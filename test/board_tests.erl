-module(board_tests).
-include_lib("eunit/include/eunit.hrl").

board_with_no_moves_test() ->
  #{0:=empty, 1:=empty, 2:=empty,
    3:=empty, 4:=empty, 5:=empty,
    6:=empty, 7:=empty, 8:=empty} = board:get_board_with_moves([]).

board_with_first_mark_in_first_space_test() ->
  #{0:=x,     1:=empty, 2:=empty,
    3:=empty, 4:=empty, 5:=empty,
    6:=empty, 7:=empty, 8:=empty} = board:get_board_with_moves([0]).

board_with_second_mark_in_second_space_test() ->
  #{0:=x,     1:=o,     2:=empty,
    3:=empty, 4:=empty, 5:=empty,
    6:=empty, 7:=empty, 8:=empty} = board:get_board_with_moves([0, 1]).

board_with_third_mark_in_third_space_test() ->
  #{0:=x,     1:=o,     2:=x,
    3:=empty, 4:=empty, 5:=empty,
    6:=empty, 7:=empty, 8:=empty} = board:get_board_with_moves([0, 1, 2]).

display_board_test() ->
  Board = #{0=>x,     1=>o,     2=>x,
            3=>empty, 4=>empty, 5=>empty,
            6=>empty, 7=>empty, 8=>empty},
  [x,     o,     x,
   empty, empty, empty,
   empty, empty, empty] = board:display_board(Board).

all_remaining_moves_test() ->
  [0, 1, 2, 3, 4, 5, 6, 7, 8] = board:get_remaining_moves([]).

some_remaining_moves_test() ->
  [5, 6, 7, 8] = board:get_remaining_moves([0, 1, 2, 3, 4]).

no_remaining_moves_test() ->
  [] = board:get_remaining_moves([0, 1, 2, 3, 4, 5, 6, 7, 8]).

mark_for_first_turn_test() ->
  x = board:get_next_mark([]).

mark_for_second_turn_test() ->
  o = board:get_next_mark([1]).

mark_for_third_turn_test() ->
  x = board:get_next_mark([1, 2]).
