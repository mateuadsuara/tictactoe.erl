-module(computer_player).
-export([play/1, best_move/1]).

play(Game) ->
  make_move(best_move(Game), Game).


best_move(Game) ->
  case game:previous_moves(Game) of
    [] -> 1;
    _  ->
      {BestMove, _} = list:max_key(2, possibilities(Game)),
      BestMove
  end.

possibilities(Game) ->
  AddScore = fun(Move) -> {Move, score_move(Move, Game)} end,
  lists:map(AddScore, game:possible_moves(Game)).

score_move(Move, Game) ->
  negamax_score(6, make_move(Move, Game)).

negamax_score(Depth, Game) ->
  case {Depth, game:status(Game)} of
    {_, {finished, draw}} -> 0;
    {_, {finished, _}}    -> 1 * Depth;
    {0, {ongoing, _}}     -> 0;
    _ ->
      ScoreMove = fun(Move) ->
                      negamax_score(Depth -1, make_move(Move, Game))
                  end,
      Scores = lists:map(ScoreMove, game:possible_moves(Game)),
      - lists:max(Scores)
  end.

make_move(Move, Game) ->
  {ok, GameWithMove} = game:make_move(Move, Game),
  GameWithMove.
