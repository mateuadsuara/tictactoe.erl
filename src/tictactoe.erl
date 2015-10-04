-module('tictactoe').

-export([main/1]).

main(_) ->
  io:format("It is tictactoe time!~n~n"),
  Players = menu:choose_players(
              fun human_player:play/1,
              fun computer_player:play/1),
  Display = fun display:update/1,
  Game = game:new(),
  runner:run(Game, Players, Display).
