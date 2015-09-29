-module(board).
-export([get_board_with_moves/1, display_board/1, get_remaining_moves/1, get_next_mark/1, get_lines_with_marks/1]).

get_board_with_moves(Moves) ->
  lists:foldl(
    fun({SpaceToMove, Mark}, ResultingBoard) ->
        put_in_board(SpaceToMove, Mark, ResultingBoard)
    end,
    get_initial_board(),
    add_marks_to(Moves)
  ).

add_marks_to(Moves) ->
  lists:map(
    fun({TurnIndex, Move}) ->
        {Move, get_mark_for_turn(TurnIndex)}
    end,
    list:with_indexes(Moves)
  ).

get_mark_for_turn(OddTurn) when OddTurn rem 2 /= 0 -> x;
get_mark_for_turn(_) -> o.

get_next_mark(Moves) ->
  get_mark_for_turn(length(Moves) + 1).

get_remaining_moves(MovesDone) ->
  lists:subtract(get_all_spaces(), MovesDone).


get_initial_board() ->
  get_initial_board(empty).

get_initial_board(EmptyMark) ->
  #{1=>EmptyMark, 2=>EmptyMark, 3=>EmptyMark,
    4=>EmptyMark, 5=>EmptyMark, 6=>EmptyMark,
    7=>EmptyMark, 8=>EmptyMark, 9=>EmptyMark}.

put_in_board(Space, Mark, Board) ->
  maps:put(Space, Mark, Board).

get_all_spaces() ->
  [1, 2, 3, 4, 5, 6, 7, 8, 9].

display_board(Board) ->
  maps:values(Board).

get_lines_with_marks(Board) ->
  MarkAtSpace = fun(Space) -> maps:get(Space, Board) end,
  MarksAtLine = fun(Line) -> lists:map(MarkAtSpace, Line) end,
  MarksAtLines = fun(Lines) -> lists:map(MarksAtLine, Lines) end,
  MarksAtLines(get_possible_lines_()).

get_possible_lines_() ->
  [[1, 2, 3], [4, 5, 6], [7, 8, 9],
   [1, 4, 7], [2, 5, 8], [3, 6, 9],
   [1, 5, 9], [3, 5, 7]].
