-module(human_player).
-export([play/1]).

play(Game) ->
  prompt(Game),
  make_move(Game).


prompt(Game) ->
  io:fwrite(
    "Where would you like to move? Available: ~w~n",
    [game:possible_moves(Game)]).

make_move(Game) ->
  case game:make_move(read_move(), Game) of
    {error, impossible_move} ->
      inform_impossible_move(),
      make_move(Game);
    {ok, GameWithMove} ->
      GameWithMove
  end.

read_move() ->
  case io:fread("", "~d") of
    {error, {fread, integer}} ->
      inform_impossible_move(),
      read_move();
    {ok, [Move]} ->
      Move
  end.

inform_impossible_move() ->
  io:format("It is not possible to move there.~n").
