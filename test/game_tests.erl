-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

-include("src/game.hrl").

initial_game_test() ->
  #game{
     board    = [empty, empty, empty,
                 empty, empty, empty,
                 empty, empty, empty],
     player   = x,
     finished = false,
     winner   = none
  } = game:watch([]).

game_after_first_move_test() ->
  #game{
     board    = [x,     empty, empty,
                 empty, empty, empty,
                 empty, empty, empty],
     player   = o,
     finished = false,
     winner   = none
  } = game:watch([0]).
