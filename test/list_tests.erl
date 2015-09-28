-module(list_tests).
-include_lib("eunit/include/eunit.hrl").

empty_list_has_no_indexes_test() ->
  [] = list:with_indexes([]).

adds_indexes_to_each_element_test() ->
  [{0, a}, {1, b}, {2, c}] = list:with_indexes([a, b, c]).
