-module(cli).

-export([update/1]).

update(Game) ->
  display_last_move(game:moves(Game)),
  display_board(game:board(Game)),
  display_status(game:status(Game)).


display_last_move([]) -> ok;
display_last_move(Moves) ->
  io:format("Moved to ~w.~n", [lists:last(Moves)]).

display_board(Board) ->
  io:format("~n~s~n", [text_ui:format(Board)]).

display_status({ongoing, ActivePlayer}) ->
  io:format("~p is playing now...~n", [ActivePlayer]);
display_status({finished, draw}) ->
  io:format("It is a draw.~n");
display_status({finished, Winner}) ->
  io:format("~p has won!~n", [Winner]).
