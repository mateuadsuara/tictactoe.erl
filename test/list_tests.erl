-module(list_tests).
-include_lib("eunit/include/eunit.hrl").

-import(list, [with_indexes/1]).


empty_list_has_no_indexes_test() ->
  [] = with_indexes([]).

adds_indexes_to_each_element_test() ->
  [{1, a}, {2, b}, {3, c}] = with_indexes([a, b, c]).
