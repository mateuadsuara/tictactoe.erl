-module(board_tests).
-include_lib("eunit/include/eunit.hrl").

-import(board, [new/0, as_list/1, empty_spaces/1, lines/1, with_moves/2]).


a_new_board_as_list_test() ->
  [empty, empty, empty,
   empty, empty, empty,
   empty, empty, empty] = as_list(new()).

a_board_with_one_move_as_list_test() ->
  BoardWithOneMove = with_moves([{1, x}], new()),
  [x,     empty, empty,
   empty, empty, empty,
   empty, empty, empty] = as_list(BoardWithOneMove).

a_board_with_a_line_as_list_test() ->
  BoardWithOneLine = with_moves([{1, x}, {2, o}, {3, x}], new()),
  [x,     o,     x,
   empty, empty, empty,
   empty, empty, empty] = as_list(BoardWithOneLine).


a_new_board_has_all_the_empty_spaces_test() ->
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = empty_spaces(new()).

removes_the_move_from_the_empty_spaces_test() ->
  BoardWithOneMove = with_moves([{1, x}], new()),
  [2, 3, 4, 5, 6, 7, 8, 9] = empty_spaces(BoardWithOneMove).


a_new_board_has_no_lines_test() ->
  [] = lines(new()).

an_incomplete_line_is_not_a_line_test() ->
  BoardWithIncompleteLine = with_moves([{1, x}, {2, o}], new()),
  [] = lines(BoardWithIncompleteLine).

a_line_test() ->
  BoardWithOneLine = with_moves([{1, x}, {2, o}, {3, x}], new()),
  [[x, o, x]] = lines(BoardWithOneLine).

all_lines_test() ->
  BoardWithOneLine = with_moves([{1, x}, {2, o}, {3, x},
                                 {4, x}, {5, x}, {6, x},
                                 {7, o}, {8, x}, {9, o}], new()),
  [[x, o, x],
   [x, x, x],
   [o, x, o],
   [x, x, o],
   [o, x, x],
   [x, x, o],
   [x, x, o],
   [x, x, o]] = lines(BoardWithOneLine).
