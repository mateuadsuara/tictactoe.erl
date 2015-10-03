-module(computer_player).
-export([play/1, best_move/1]).

play(Game) ->
  make_move(best_move(Game), Game).


best_move(Game) ->
  AddScore = fun(Move) ->
                 {score_move(Move, Game), Move}
             end,
  SelectBest = fun(Option, BestSoFar) ->
                   {Score, _}     = Option,
                   {BestScore, _} = BestSoFar,
                   case Score > BestScore of
                     true -> Option;
                     _    -> BestSoFar
                   end
               end,
  Options = lists:map(AddScore, game:possible_moves(Game)),
  [First|Rest] = Options,
  {_, Move} = lists:foldl(SelectBest, First, Rest),
  Move.

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
