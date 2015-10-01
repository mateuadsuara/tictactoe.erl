-module(computer_player).
-export([play/1]).

play(Game) ->
  AddScore = fun(Move) ->
                 {score(game:make_move(Move, Game)), Move}
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


score(Game) -> score(6, Game).
score(Depth, Game) ->
  case {Depth, game:is_finished(Game), game:winner(Game)} of
    {_, true,  none} -> 0;
    {_, true,  _}    -> 1 * Depth;
    {0, false, _}    -> 0;
    _ ->
      ScoreMove = fun(Move) ->
                      score(Depth -1, game:make_move(Move, Game))
                  end,
      Scores = lists:map(ScoreMove, game:possible_moves(Game)),
      - lists:max(Scores)
  end.
