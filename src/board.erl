-module(board).

-include("src/board.hrl").
-export([watch/1]).

watch(Moves) ->
  #board{
     marks = [empty, empty, empty,
              empty, empty, empty,
              empty, empty, empty],
     player = x,
     finished = false,
     winner = none
  }.
