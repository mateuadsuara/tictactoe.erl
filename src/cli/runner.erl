-module(runner).
-export([run/3]).

run(Game, {X, O}, Display) ->
  PlayerFor = fun(x) -> X;
                 (o) -> O
              end,
  runner(Game, PlayerFor, Display).


runner(Game, PlayerFor, Display) ->
  Display(Game),
  case game:status(Game) of
    {ongoing, CurrentMark} ->
      Play = PlayerFor(CurrentMark),
      runner(Play(Game), PlayerFor, Display);
    {finished, _} ->
      Game
  end.
