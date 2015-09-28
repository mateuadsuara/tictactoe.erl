-module(board).
-export([get_next_mark/1, get_board_with_moves/1]).

get_board_with_moves(Moves) ->
  InitialMarks = #{0=>empty, 1=>empty, 2=>empty,
                   3=>empty, 4=>empty, 5=>empty,
                   6=>empty, 7=>empty, 8=>empty},
  MarksWithMoves = lists:foldl(
    fun({Move, Mark}, ResultingMarks) ->
      maps:put(Move, Mark, ResultingMarks)
    end,
    InitialMarks,
    add_marks_to(Moves)
  ),
  maps:values(MarksWithMoves).

add_marks_to(Moves) ->
  map_with_index(
    fun({Move, TurnIndex}) ->
        {Move, get_mark_for_turn(TurnIndex)}
    end,
    Moves
  ).

get_mark_for_turn(Turn) ->
  Even = Turn rem 2 == 0,
  case Even of
    true -> x;
    false -> o
  end.

get_next_mark(Moves) ->
  get_mark_for_turn(length(Moves)).

map_with_index(Fn, List) ->
  Indexes = lists:seq(0, length(List)-1),
  lists:map(Fn, lists:zip(List, Indexes)).
