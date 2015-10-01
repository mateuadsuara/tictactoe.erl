-module(function_double).

-export([new/1, arity1/1, arity2/1, arity3/1, destroy_and_get_arguments/1]).

new(ReturnValues) ->
  StubState = mutable_state:new(ReturnValues),
  SpyState = mutable_state:new([]),
  {StubState, SpyState}.

arity1(States) ->
  fun(Arg) ->
    pop_and_store(States, [Arg])
  end.

arity2(States) ->
  fun(Arg1, Arg2) ->
    pop_and_store(States, [Arg1, Arg2])
  end.

arity3(States) ->
  fun(Arg1, Arg2, Arg3) ->
    pop_and_store(States, [Arg1, Arg2, Arg3])
  end.

pop_and_store({StubState, SpyState}, Args) ->
  mutable_state:swap(
    fun(PassedArgs) -> PassedArgs ++ [Args] end,
    SpyState
  ),
  [Head|_] = mutable_state:swap(
               fun([_|Tail]) -> Tail end,
               StubState
             ),
  Head.

destroy_and_get_arguments({StubState, SpyState}) ->
  mutable_state:destroy(StubState),
  mutable_state:destroy(SpyState).
