-module(function_double_tests).
-include_lib("eunit/include/eunit.hrl").

-import(function_double, [new/2]).

returns_the_specified_return_values_test() ->
  {Fun, _} = new(1, [ok1, ok2, ok3]),
  ok1 = Fun(arg1),
  ok2 = Fun(arg2),
  ok3 = Fun(arg3).

remembers_the_arguments_that_have_been_passed_test() ->
  {Fun, GetArguments} = new(1, [ok1, ok2, ok3]),
  Fun(arg1),
  Fun(arg2),
  Fun(arg3),
  [[arg1], [arg2], [arg3]] = GetArguments().

can_receive_zero_arguments_test() ->
  {Fun, GetArguments} = new(0, [ok1, ok2]),
  Fun(),
  Fun(),
  [[], []] = GetArguments().
