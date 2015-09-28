-module(game).
-export([watch/1]).

-include("src/game.hrl").

watch(Moves) ->
  #game{
     board    = board:get_board_with_moves(Moves),
     player   = board:get_next_mark(Moves),
     finished = false,
     winner   = none
  }.
