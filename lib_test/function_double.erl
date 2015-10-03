-module(function_double).

-export([new/2]).

new(Arity, ReturnValues) ->
  State = spawn(fun() -> state(ReturnValues, []) end),
  Spy = case Arity of
          0 -> fun() -> call(State, []) end;
          1 -> fun(Arg) -> call(State, [Arg]) end
        end,
  GetArguments = fun() -> arguments(State) end,
  {Spy, GetArguments}.


state(ReturnValues, ArgumentsReceived) ->
  receive
    {call, From, Arguments} ->
      [ReturnValue|Rest] = ReturnValues,
      From ! ReturnValue,
      state(Rest, ArgumentsReceived ++ [Arguments]);
    {arguments, From} ->
      From ! ArgumentsReceived
  end.

call(State, Arguments) ->
  State ! {call, self(), Arguments},
  receive
    ReturnValue -> ReturnValue
  end.

arguments(State) ->
  State ! {arguments, self()},
  receive
    Arguments -> Arguments
  end.
