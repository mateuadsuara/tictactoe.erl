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


call(State, Arguments) ->
  State ! {call, self(), Arguments},
  receive
    ReturnValue -> ReturnValue
  end.

arguments(State) ->
  State ! {get, self()},
  receive
    Arguments -> Arguments
  end.

state(ReturnValues, ArgumentsReceived) ->
  receive
    {call, From, Arguments} ->
      [ReturnValue|Rest] = ReturnValues,
      From ! ReturnValue,
      state(Rest, ArgumentsReceived ++ [Arguments]);
    {get, From} ->
      From ! ArgumentsReceived
  end.
