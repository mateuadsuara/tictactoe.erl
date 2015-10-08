-module(test_io).
-export([redirect_io/2]).

redirect_io(InputString, DuringFunction) ->
  replace_group_leader_for(
    fun(GroupLeader) -> redirect_io(GroupLeader, [], InputString) end,
    DuringFunction).


replace_group_leader_for(SurrogateFn, DuringFunction) ->
  Original = erlang:group_leader(),
  Surrogate = spawn(fun() -> SurrogateFn(Original) end),
  erlang:group_leader(Surrogate, self()),
  FunctionResult = DuringFunction(),
  erlang:group_leader(Original, self()),
  Surrogate ! {get_result, self()},
  SurrogateResult = receive R -> R end,
  {FunctionResult, SurrogateResult}.

redirect_io(GroupLeader, OutputString, InputString) ->
  receive
    {get_result, From} -> From ! OutputString;
    {io_request, From, Ref,
     {get_until, unicode, [], io_lib, fread, [Format]}} ->
      {Response, RemainingInputString} = read(InputString, Format),
      From ! {io_reply, Ref, Response},
      redirect_io(GroupLeader, OutputString, RemainingInputString);
    {io_request, From, Ref,
     {put_chars, Encoding, Module, Func, Args}} ->
      Message = {io_request, From, Ref,
                 {put_chars, Encoding, Module, Func, Args}},
      GroupLeader ! Message,
      ExtendedOutput = write(OutputString, Encoding, Module, Func, Args),
      redirect_io(GroupLeader, ExtendedOutput, InputString);
    UnknownMessage ->
      GroupLeader ! UnknownMessage,
      redirect_io(GroupLeader, OutputString, InputString)
  end.

read(InputString, Format) ->
  case io_lib:fread(Format, InputString) of
    {ok, Result, RemainingInputString} ->
      {{ok, Result}, RemainingInputString};
    {error, What} ->
      {{error, What}, remove_line(InputString)};
    {more, _, _, _} ->
      {eof, ""}
  end.

remove_line(String) ->
  case string:str(String, "\n") of
    0             -> "";
    1             -> remove_line(string:substr(String, 2));
    NextLineIndex -> string:substr(String, NextLineIndex)
  end.

write(OutputString, Encoding, Module, Func, Args) ->
  Output = unicode:characters_to_list(
             apply(Module, Func, Args),
             Encoding),
  OutputString ++ Output.
