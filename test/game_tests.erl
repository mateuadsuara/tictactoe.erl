-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

-import(game, [new/0, new/1, make_move/2, board/1, moves/1, possible_moves/1, status/1]).


can_be_iterated_making_moves_test() ->
  Game1 = new(),
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game1),
  {ok, Game2} = make_move(1, Game1),
  [1] = moves(Game2),
  [2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game2),
  {ok, Game3} = make_move(2, Game2),
  [1, 2] = moves(Game3),
  [3, 4, 5, 6, 7, 8, 9] = possible_moves(Game3).

making_an_impossible_move_returns_error_test() ->
  Game = new([2, 3]),
  [1, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  {error, impossible_move} = make_move(0, Game),
  {error, impossible_move} = make_move(10, Game),
  {error, impossible_move} = make_move(2, Game),
  {error, impossible_move} = make_move(3, Game),
  {error, impossible_move} = make_move("a", Game),
  {error, impossible_move} = make_move(not_a_move, Game).

initial_game_test() ->
  Game = new([]),
  [empty, empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [] = moves(Game),
  [1, 2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  {ongoing, x} = status(Game).

game_with_first_move_test() ->
  Game = new([1]),
  [x,     empty, empty,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [1] = moves(Game),
  [2, 3, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  {ongoing, o} = status(Game).

game_with_two_moves_test() ->
  Game = new([1, 3]),
  [x,     empty, o,
   empty, empty, empty,
   empty, empty, empty] = board(Game),
  [1, 3] = moves(Game),
  [2, 4, 5, 6, 7, 8, 9] = possible_moves(Game),
  {ongoing, x} = status(Game).

game_with_three_moves_test() ->
  Game = new([1, 3, 5]),
  [x,     empty, o,
   empty, x,     empty,
   empty, empty, empty] = board(Game),
  [1, 3, 5] = moves(Game),
  [2, 4, 6, 7, 8, 9] = possible_moves(Game),
  {ongoing, o} = status(Game).

game_ended_in_draw_test() ->
  Game = new([1, 2, 3, 5, 4, 7, 6, 9, 8]),
  [x, o, x,
   x, o, x,
   o, x, o] = board(Game),
  [1, 2, 3, 5, 4, 7, 6, 9, 8] = moves(Game),
  []   = possible_moves(Game),
  {finished, draw} = status(Game).

x_won_in_first_line_test() ->
  Game = new([1, 4, 2, 5, 3]),
  [x,     x,     x,
   o,     o,     empty,
   empty, empty, empty] = board(Game),
  [1, 4, 2, 5, 3] = moves(Game),
  [6, 7, 8, 9] = possible_moves(Game),
  {finished, x} = status(Game).

o_won_in_first_line_test() ->
  Game = new([6, 1, 7, 2, 8, 3]),
  [o,     o,     o,
   empty, empty, x,
   x,     x,     empty] = board(Game),
  [6, 1, 7, 2, 8, 3] = moves(Game),
  [4, 5, 9] = possible_moves(Game),
  {finished, o} = status(Game).
