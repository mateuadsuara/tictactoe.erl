-module(board).
-export([get_board_with_moves/1, display_board/1, get_remaining_moves/1, get_next_mark/1]).

get_board_with_moves(Moves) ->
  BoardWithMoves = lists:foldl(
    fun({SpaceToMove, Mark}, ResultingBoard) ->
        put_in_board(SpaceToMove, Mark, ResultingBoard)
    end,
    get_initial_board(),
    add_marks_to(Moves)
  ),
  BoardWithMoves.

add_marks_to(Moves) ->
  lists:map(
    fun({TurnIndex, Move}) ->
        {Move, get_mark_for_turn(TurnIndex)}
    end,
    list:with_indexes(Moves)
  ).

get_mark_for_turn(EvenTurn) when EvenTurn rem 2 == 0 -> x;
get_mark_for_turn(_) -> o.

get_next_mark(Moves) ->
  get_mark_for_turn(length(Moves)).

get_remaining_moves(MovesDone) ->
  lists:subtract(get_available_spaces(), MovesDone).

get_initial_board() ->
  #{0=>empty, 1=>empty, 2=>empty,
    3=>empty, 4=>empty, 5=>empty,
    6=>empty, 7=>empty, 8=>empty}.

put_in_board(Space, Mark, Board) ->
  maps:put(Space, Mark, Board).

get_available_spaces() ->
  maps:keys(get_initial_board()).

display_board(Board) ->
  maps:values(Board).
