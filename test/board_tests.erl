-module(board_tests).

-include_lib("eunit/include/eunit.hrl").

-include("src/board.hrl").
-import(board, [watch/1]).

initial_board_test() ->
  NoMoves = [],
  #board{
     marks = [empty, empty, empty,
              empty, empty, empty,
              empty, empty, empty],
     player = x,
     finished = false,
     winner = none
  } = watch(NoMoves).
