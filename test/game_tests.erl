-module(game_tests).
-include_lib("eunit/include/eunit.hrl").

-include("src/game.hrl").

initial_game_test() ->
  #game{
     board          = [empty, empty, empty,
                       empty, empty, empty,
                       empty, empty, empty],
     possible_moves = [0, 1, 2, 3, 4, 5, 6, 7, 8],
     current_player = x,
     is_finished    = false,
     winner         = none
  } = game:watch([]).

game_after_first_move_test() ->
  #game{
     board          = [x,     empty, empty,
                       empty, empty, empty,
                       empty, empty, empty],
     possible_moves = [1, 2, 3, 4, 5, 6, 7, 8],
     current_player = o,
     is_finished    = false,
     winner         = none
  } = game:watch([0]).

game_full_test() ->
  #game{
     board          = [x, o, x,
                       x, o, x,
                       o, x, o],
     possible_moves = [],
     current_player = o,
     is_finished    = true,
     winner         = none
  } = game:watch([0, 1, 2, 4, 3, 6, 5, 8, 7]).

game_winner_test() ->
  #game{
     board          = [x,     x,     x,
                       o,     o,     empty,
                       empty, empty, empty],
     possible_moves = [5, 6, 7, 8],
     current_player = o,
     is_finished    = true,
     winner         = x
  } = game:watch([0, 3, 1, 4, 2]).
