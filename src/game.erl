-module(game).
-export([new/1, board/1, possible_moves/1, next_player/1, is_finished/1, winner/1]).

-record(game, {spaces_to_move, board}).

new(SpacesToMove) ->
  #game{
     spaces_to_move = SpacesToMove,
     board = board_with_moves(SpacesToMove)
  }.

board(Game) ->
  board:as_list(Game#game.board).

possible_moves(Game) ->
  board:empty_spaces(Game#game.board).

next_player(Game) ->
  LastTurn = length(Game#game.spaces_to_move),
  NextTurn = LastTurn + 1,
  mark_for(NextTurn).

is_finished(Game) ->
  has_no_moves_left(Game) orelse has_a_winner(Game).

winner(Game) ->
  case winner_lines(Game#game.board) of
    []           -> none;
    [[Winner|_]] -> Winner
  end.


board_with_moves(SpacesToMove) ->
  board:with_moves(add_marks_to(SpacesToMove), board:new()).

add_marks_to(SpacesToMove) ->
  lists:map(fun mark_at_turn/1, add_turns_to(SpacesToMove)).

mark_at_turn({Turn, Space}) ->
  {Space, mark_for(Turn)}.

add_turns_to(SpacesToMove) ->
  list_with_indexes(SpacesToMove).

list_with_indexes(List) ->
  Indexes = lists:seq(1, length(List)),
  lists:zip(Indexes, List).

mark_for(Turn) when Turn rem 2 /= 0 -> x;
mark_for(_) -> o.

has_no_moves_left(Game) ->
  [] == possible_moves(Game).

has_a_winner(Game) ->
  winner(Game) /= none.

winner_lines(Board) ->
  lists:filter(fun contains_same_mark/1, board:lines(Board)).

contains_same_mark(Line) ->
  [FirstMark|Rest] = Line,
  IsSameAsFirstMark = fun(Mark) -> Mark == FirstMark end,
  lists:all(IsSameAsFirstMark, Rest).
