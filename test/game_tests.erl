-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

-import(game, [new/0, new/1, make_move/2, board/1, possible_moves/1, next_player/1, is_finished/1, winner/1]).


can_be_iterated_making_moves_test() ->
  Game1 = new(),
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game1),
  Game2 = make_move(1, Game1),
  [2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game2),
  Game3 = make_move(2, Game2),
  [3, 4, 5, 6, 7, 8, 9] = possible_moves(Game3).

initial_game_test() ->
  Game = new([]),
  [empty, empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  x     = next_player(Game),
  false = is_finished(Game),
  none  = winner(Game).

game_with_first_move_test() ->
  Game = new([1]),
  [x,     empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  o     = next_player(Game),
  false = is_finished(Game),
  none  = winner(Game).

game_with_two_moves_test() ->
  Game = new([1, 3]),
  [x,     empty, o,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [2, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  x     = next_player(Game),
  false = is_finished(Game),
  none  = winner(Game).

game_with_three_moves_test() ->
  Game = new([1, 3, 5]),
  [x,     empty, o,
   empty, x,     empty,
   empty, empty, empty] = board(Game),
  [2, 4, 6, 7, 8, 9] = possible_moves(Game),
  o     = next_player(Game),
  false = is_finished(Game),
  none  = winner(Game).

game_ended_in_draw_test() ->
  Game = new([1, 2, 3, 5, 4, 7, 6, 9, 8]),
  [x, o, x,
   x, o, x,
   o, x, o] = board(Game),
  []   = possible_moves(Game),
  o    = next_player(Game),
  true = is_finished(Game),
  none = winner(Game).

x_won_in_first_line_test() ->
  Game = new([1, 4, 2, 5, 3]),
  [x,     x,     x,
   o,     o,     empty,
   empty, empty, empty] = board(Game),
  [6, 7, 8, 9] = possible_moves(Game),
  o    = next_player(Game),
  true = is_finished(Game),
  x    = winner(Game).

o_won_in_first_line_test() ->
  Game = new([6, 1, 7, 2, 8, 3]),
  [o,     o,     o,
   empty, empty, x,
   x,     x,     empty] = board(Game),
  [4, 5, 9] = possible_moves(Game),
  x    = next_player(Game),
  true = is_finished(Game),
  o    = winner(Game).
