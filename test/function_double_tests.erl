-module(function_double_tests).
-include_lib("eunit/include/eunit.hrl").

-import(function_double, [new/1, arity1/1, arity2/1, arity3/1, destroy_and_get_arguments/1]).


returns_the_specified_return_values_test() ->
  FunctionDouble = new([ok1, ok2, ok3]),
  Fn = arity1(FunctionDouble),
  ok1 = Fn(arg1),
  ok2 = Fn(arg2),
  ok3 = Fn(arg3),
  destroy_and_get_arguments(FunctionDouble).

remembers_the_arguments_that_have_been_passed_test() ->
  FunctionDouble = new([ok1, ok2, ok3]),
  Fn = arity1(FunctionDouble),
  Fn(arg1),
  Fn(arg2),
  Fn(arg3),
  [[arg1], [arg2], [arg3]] =
    destroy_and_get_arguments(FunctionDouble).

can_pass_different_amount_of_arguments_test() ->
  FunctionDouble = new([ok1, ok2, ok3]),
  Fn1 = arity1(FunctionDouble),
  ok1 = Fn1(arg_1_a),
  Fn2 = arity2(FunctionDouble),
  ok2 = Fn2(arg_2_a, arg_2_b),
  Fn3 = arity3(FunctionDouble),
  ok3 = Fn3(arg_3_a, arg_3_b, arg_3_c),
  [[arg_1_a],
   [arg_2_a, arg_2_b],
   [arg_3_a, arg_3_b, arg_3_c]] =
    destroy_and_get_arguments(FunctionDouble).
