-module(computer_player_tests).
-include_lib("eunit/include/eunit.hrl").

-import(computer_player, [play/1, best_move/1]).

blocks_when_can_lose_test() ->
  Game                  = game:new([1, 2, 3, 4, 6, 5, 8]),
  [x,     o,     x,
   o,     o,     x,
   empty, x,     empty] = game:board(Game),
  9                     = best_move(Game),
  [x,     o,     x,
   o,     o,     x,
   empty, x,     o]     = game:board(play(Game)).

chooses_to_win_when_has_the_opportunity_test() ->
  Game                  = game:new([1, 2, 3, 4, 5, 9]),
  [x,     o,     x,
   o,     x,     empty,
   empty, empty, o]     = game:board(Game),
  7                     = best_move(Game),
  [x,     o,     x,
   o,     x,     empty,
   x,     empty, o]     = game:board(play(Game)).

creates_a_fork_when_possible_test() ->
  Game                  = game:new([4, 1, 7, 8]),
  [o,     empty, empty,
   x,     empty, empty,
   x,     o,     empty] = game:board(Game),
  5                     = best_move(Game),
  [o,     empty, empty,
   x,     x,     empty,
   x,     o,     empty] = game:board(play(Game)).

foresees_enough_to_avoid_losing_test() ->
  Game                  = game:new([1]),
  [x,     empty, empty,
   empty, empty, empty,
   empty, empty, empty] = game:board(Game),
  5                     = best_move(Game),
  [x,     empty, empty,
   empty, o,     empty,
   empty, empty, empty] = game:board(play(Game)).

chooses_an_immediate_win_over_a_fork_test() ->
  Game                  = game:new([1, 4, 2, 7]),
  [x,     x,     empty,
   o,     empty, empty,
   o,     empty, empty] = game:board(Game),
  3                     = best_move(Game),
  [x,     x,     x,
   o,     empty, empty,
   o,     empty, empty] = game:board(play(Game)).
