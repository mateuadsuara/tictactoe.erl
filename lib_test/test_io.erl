-module(test_io).
-export([spy/1, redirect/2]).

spy(DuringFunction) ->
  {_, Messages} = replace_group_leader_for(
    fun(GroupLeader) -> spy_messages(GroupLeader, []) end,
    DuringFunction),
  Messages.

redirect(InputString, DuringFunction) ->
  {FunctionResult, CapturedOutput} = replace_group_leader_for(
    fun(GroupLeader) -> redirect_io(GroupLeader, [], InputString) end,
    DuringFunction).


replace_group_leader_for(SurrogateFn, DuringFunction) ->
  Original = erlang:group_leader(),
  Surrogate = spawn(fun() -> SurrogateFn(Original) end),
  erlang:group_leader(Surrogate, self()),
  FunctionResult = DuringFunction(),
  erlang:group_leader(Original, self()),
  receive after 10 -> enough_to_flush_surrogate end,
  Surrogate ! {get_result, self()},
  SurrogateResult = receive R -> R end,
  {FunctionResult, SurrogateResult}.

spy_messages(GroupLeader, Messages) ->
  Self = self(),
  receive
    {get_result, From} -> From ! Messages;
    {record_message, Message} ->
      spy_messages(
        GroupLeader,
        lists:append(Messages, [Message]));
    {io_request, From, Ref, Op} ->
      Request = {io_request, From, Ref, Op},
      Self ! {record_message, Request},
      ResponseSpyPid = spawn(fun ResponseSpy() ->
            receive Response ->
                Self ! {record_message, Response},
                From ! Response,
                ResponseSpy()
            end
      end),
      RedirectedRequest = {io_request, ResponseSpyPid, Ref, Op},
      GroupLeader ! RedirectedRequest,
      spy_messages(GroupLeader, Messages);
    Message ->
      Self ! {record_message, Message},
      GroupLeader ! Message,
      spy_messages(GroupLeader, Messages)
    end.

redirect_io(GroupLeader, OutputString, InputString) ->
  receive
    {get_result, From} -> From ! OutputString;
    {io_request, From, Ref,
     {get_until, unicode, [], io_lib, fread, [Format]}} ->
      case io_lib:fread(Format, InputString) of
        {ok, Result, RemainingInputString} ->
          From ! {io_reply, Ref, {ok, Result}},
          redirect_io(GroupLeader, OutputString, RemainingInputString);
        {error, What} ->
          From ! {io_reply, Ref, {error, What}},
          redirect_io(GroupLeader, OutputString, remove_line(InputString));
        {more, _, _, _} ->
          From ! {io_reply, Ref, eof},
          redirect_io(GroupLeader, OutputString, "")
      end;
    {io_request, From, Ref,
     {put_chars, Encoding, Module, Func, Args}} ->
      Message = {io_request, From, Ref,
                 {put_chars, Encoding, Module, Func, Args}},
      GroupLeader ! Message,
      Output = unicode:characters_to_list(
        apply(Module, Func, Args),
        Encoding),
      ExtendedOutput = OutputString ++ Output,
      redirect_io(GroupLeader, ExtendedOutput, InputString);
    UnknownMessage ->
      GroupLeader ! UnknownMessage,
      redirect_io(GroupLeader, OutputString, InputString)
  end.

remove_line(String) ->
  case string:str(String, "\n") of
    0             -> "";
    1             -> remove_line(string:substr(String, 2));
    NextLineIndex -> string:substr(String, NextLineIndex)
  end.
