-module(list_tests).
-include_lib("eunit/include/eunit.hrl").

-import(list, [with_indexes/1, group_each/2, max_key/2]).

empty_list_has_no_indexes_test() ->
  [] = with_indexes([]).

adds_indexes_to_each_element_test() ->
  [{1, a}, {2, b}, {3, c}] = with_indexes([a, b, c]).

group_each_2_elements_test() ->
  [[1, 2], [3, 4], [5, 6]]
    = group_each(2, [1, 2, 3, 4, 5, 6]).

group_each_3_elements_test() ->
  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    = group_each(3, [1, 2, 3, 4, 5, 6, 7, 8, 9]).

group_each_2_with_incomplete_groups_test() ->
  [[1, 2], [3, 4], [5]] = group_each(2, [1, 2, 3, 4, 5]).

gets_the_tuple_with_max_key_test() ->
  {b, 3} = max_key(2, [{a, 1}, {b, 3}, {c, 2}]).
