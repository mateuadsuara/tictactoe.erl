-module(test_io).
-export([spy/1, redirect/2]).

spy(Function) ->
  Original = erlang:group_leader(),
  Surrogate = spawn(fun() -> spy_actor(Original, []) end),
  erlang:group_leader(Surrogate, self()),
  Function(),
  erlang:group_leader(Original, self()),
  Surrogate ! {get_spied_messages, self()},
  receive
    {messages, Messages} ->
      Messages
  end.

redirect(InputString, Function) ->
  Original = erlang:group_leader(),
  Surrogate = spawn(fun() ->
                        surrogate(
                          Original,
                          [],
                          InputString)
                    end),
  erlang:group_leader(Surrogate, self()),
  Result = Function(),
  erlang:group_leader(Original, self()),
  Surrogate ! {get_output, self()},
  Output = receive {output, O} -> O end,
  {Result, Output}.


spy_actor(GroupLeader, Messages) ->
  receive
    {get_spied_messages, Requester} ->
      Requester ! {messages, Messages};
    {record_message, Message} ->
      spy_actor(
        GroupLeader,
        lists:append(Messages, [Message]));
    {io_request, From, Ref, Op} ->
      Request = {io_request, From, Ref, Op},
      Self = self(),
      Self ! {record_message, Request},
      ResponseSpy = spawn(fun RSpy() ->
            receive
              Response ->
                Self ! {record_message, Response},
                From ! Response,
                RSpy()
            end
      end),
      RedirectedRequest = {io_request, ResponseSpy, Ref, Op},
      GroupLeader ! RedirectedRequest,
      spy_actor(GroupLeader, Messages);
    UnknownMessage ->
      error_logger:info_msg("Unhandled message: ~p", [UnknownMessage]),
      spy_actor(GroupLeader, Messages)
    end.

surrogate(GroupLeader, OutputString, InputString) ->
  receive
    {get_output, Requester} ->
      Requester ! {output, OutputString};
    {io_request, From, Ref,
     {get_until, unicode, [], io_lib, fread, [Format]}} ->
      case io_lib:fread(Format, InputString) of
        {ok, Result, RemainingInputString} ->
          From ! {io_reply, Ref, {ok, Result}},
          surrogate(GroupLeader, OutputString, RemainingInputString);
        {error, What} ->
          From ! {io_reply, Ref, {error, What}},
          surrogate(GroupLeader, OutputString, remove_line(InputString));
        {more, _, _, _} ->
          From ! {io_reply, Ref, eof},
          surrogate(GroupLeader, OutputString, "")
      end;
    {io_request, From, Ref,
     {put_chars, Encoding, Module, Func, Args}} ->
      Request = {io_request, From, Ref,
                 {put_chars, Encoding, Module, Func, Args}},
      GroupLeader ! Request,
      Output = unicode:characters_to_list(
        apply(Module, Func, Args),
        Encoding),
      ExtendedOutput = OutputString ++ Output,
      surrogate(GroupLeader, ExtendedOutput, InputString);
    Message ->
      GroupLeader ! Message,
      surrogate(GroupLeader, OutputString, InputString)
  end.

remove_line(String) ->
  case string:str(String, "\n") of
    0 -> "";
    1 -> remove_line(string:substr(String, 2));
    NextLineIndex ->
      string:substr(
        String,
        NextLineIndex + string:len("\n"))
  end.
