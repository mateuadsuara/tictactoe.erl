-module(board_tests).
-include_lib("eunit/include/eunit.hrl").

board_with_no_moves_test() ->
  #{1:=empty, 2:=empty, 3:=empty,
    4:=empty, 5:=empty, 6:=empty,
    7:=empty, 8:=empty, 9:=empty} = board:get_board_with_moves([]).

board_with_first_mark_in_first_space_test() ->
  #{1:=x,     2:=empty, 3:=empty,
    4:=empty, 5:=empty, 6:=empty,
    7:=empty, 8:=empty, 9:=empty} = board:get_board_with_moves([1]).

board_with_second_mark_in_second_space_test() ->
  #{1:=x,     2:=o,     3:=empty,
    4:=empty, 5:=empty, 6:=empty,
    7:=empty, 8:=empty, 9:=empty} = board:get_board_with_moves([1, 2]).

board_with_third_mark_in_third_space_test() ->
  #{1:=x,     2:=o,     3:=x,
    4:=empty, 5:=empty, 6:=empty,
    7:=empty, 8:=empty, 9:=empty} = board:get_board_with_moves([1, 2, 3]).

display_board_test() ->
  Board = #{1=>x,     2=>o,     3=>x,
            4=>empty, 5=>empty, 6=>empty,
            7=>empty, 8=>empty, 9=>empty},
  [x,     o,     x,
   empty, empty, empty,
   empty, empty, empty] = board:display_board(Board).

all_remaining_moves_test() ->
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = board:get_remaining_moves([]).

some_remaining_moves_test() ->
  [6, 7, 8, 9] = board:get_remaining_moves([1, 2, 3, 4, 5]).

no_remaining_moves_test() ->
  [] = board:get_remaining_moves([1, 2, 3, 4, 5, 6, 7, 8, 9]).

mark_for_first_turn_test() ->
  x = board:get_next_mark([]).

mark_for_second_turn_test() ->
  o = board:get_next_mark([2]).

mark_for_third_turn_test() ->
  x = board:get_next_mark([2, 3]).
