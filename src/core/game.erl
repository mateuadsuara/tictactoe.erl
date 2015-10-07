-module(game).
-export([new/0, new/1, make_move/2, board/1, previous_moves/1, possible_moves/1, status/1]).

-record(game, {spaces_to_move, board}).

new() ->
  new([]).

new(Moves) ->
  #game{
     spaces_to_move = Moves,
     board = board_with_moves(Moves)
  }.

make_move(Move, Game) ->
  case is_possible_move(Move, Game) of
    false ->
      {error, impossible_move};
    _ ->
      Moves = lists:append(Game#game.spaces_to_move, [Move]),
      {ok, new(Moves)}
  end.

board(Game) ->
  board:as_list(Game#game.board).

previous_moves(Game) ->
  Game#game.spaces_to_move.

possible_moves(Game) ->
  board:empty_spaces(Game#game.board).

status(Game) ->
 case {is_finished(Game), next_player(Game), winner(Game)} of
   {true, _, none}        -> {finished, draw};
   {true, _, Winner}      -> {finished, Winner};
   {false, NextPlayer, _} -> {ongoing, NextPlayer}
 end.


next_player(Game) ->
  LastTurn = length(Game#game.spaces_to_move),
  NextTurn = LastTurn + 1,
  mark_for(NextTurn).

is_finished(Game) ->
  has_no_moves_left(Game) orelse has_a_winner(Game).

winner(Game) ->
  case winner_lines(Game#game.board) of
    []             -> none;
    [[Winner|_]|_] -> Winner
  end.

board_with_moves(SpacesToMove) ->
  board:with_moves(add_marks_to(SpacesToMove), board:new()).

add_marks_to(SpacesToMove) ->
  lists:map(fun mark_at_turn/1, add_turns_to(SpacesToMove)).

mark_at_turn({Turn, Space}) ->
  {Space, mark_for(Turn)}.

add_turns_to(SpacesToMove) ->
  list:with_indexes(SpacesToMove).

mark_for(Turn) when Turn rem 2 /= 0 -> x;
mark_for(_) -> o.

is_possible_move(Move, Game) ->
  lists:member(Move, board:empty_spaces(Game#game.board)).

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
