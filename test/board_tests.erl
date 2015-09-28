-module(board_tests).
-include_lib("eunit/include/eunit.hrl").

-include("src/game.hrl").

board_with_no_moves_test() ->
  [empty, empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board:get_board_with_moves([]).

board_with_first_mark_in_first_space_test() ->
  [x,     empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board:get_board_with_moves([0]).

board_with_second_mark_in_second_space_test() ->
  [x,     o,     empty,
   empty, empty, empty,
   empty, empty, empty] = board:get_board_with_moves([0, 1]).

mark_for_first_turn_test() ->
  x = board:get_next_mark([]).

mark_for_second_turn_test() ->
  o = board:get_next_mark([1]).

mark_for_third_turn_test() ->
  x = board:get_next_mark([1, 2]).
