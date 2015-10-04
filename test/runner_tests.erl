-module(runner_tests).
-include_lib("eunit/include/eunit.hrl").

-import(runner, [run/3]).

goes_through_the_players_until_x_wins_test() ->
  X               = player_choosing([1, 2, 3]),
  O               = player_choosing([4, 5]),
  FinalGame       = run(game:new(), {X, O}, no_display()),
  [1, 4, 2, 5, 3] = game:previous_moves(FinalGame),
  {finished, x}   = game:status(FinalGame).

goes_through_the_players_until_o_wins_test() ->
  X                  = player_choosing([1, 2, 9]),
  O                  = player_choosing([4, 5, 6]),
  FinalGame          = run(game:new(), {X, O}, no_display()),
  [1, 4, 2, 5, 9, 6] = game:previous_moves(FinalGame),
  {finished, o}      = game:status(FinalGame).

displays_all_the_games_test() ->
  {Display, GetDisplayedGames} = display_spy(),
  X            = player_choosing([1, 2, 3]),
  O            = player_choosing([4, 5]),
  InitialGame  = game:new(),
  FinalGame    = run(InitialGame, {X, O}, Display),
  [Game1, Game2, Game3, Game4, Game5, Game6] = GetDisplayedGames(),
  InitialGame  = Game1,
  [1]          = game:previous_moves(Game2),
  [1, 4]       = game:previous_moves(Game3),
  [1, 4, 2]    = game:previous_moves(Game4),
  [1, 4, 2, 5] = game:previous_moves(Game5),
  FinalGame    = Game6.


player_choosing(Moves) ->
  {PopMove, _} = function_double:new(0, Moves),
  fun(Game) ->
      {ok, NextGame} = game:make_move(PopMove(), Game),
      NextGame
  end.

no_display() ->
  fun(_) -> ok end.

display_spy() ->
  {Spy, GetArgumentCalls} = function_double:new(1, lists:duplicate(9, ok)),
  GetArguments =
    fun() ->
        lists:flatten(GetArgumentCalls())
    end,
  {Spy, GetArguments}.
