-module(game).
-export([watch/1]).

-include("src/game.hrl").

watch(MovesDone) ->
  Board = board:get_board_with_moves(MovesDone),
  #game{
     board          = board:display_board(Board),
     possible_moves = board:get_remaining_moves(MovesDone),
     current_player = board:get_next_mark(MovesDone),
     is_finished    = rules:is_board_finished(Board),
     winner         = rules:get_board_winner(Board)
  }.
