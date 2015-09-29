-module(rules).
-export([is_board_finished/1, get_board_winner/1]).

is_board_finished(Board) ->
  is_board_full(Board) orelse (get_board_winner(Board) /= none).

get_board_winner(Board) ->
  case get_winner_lines(Board) of
    [] -> none;
    [[Winner|_]] -> Winner
  end.

is_board_full(BoardMap) ->
  BoardSpaces = maps:values(BoardMap),
  NotEmpty = fun(Space) ->
                 Space /= empty
             end,
  lists:all(NotEmpty, BoardSpaces).

get_winner_lines(BoardMap) ->
  ContainsSameMark = fun(Line) ->
                         [FirstMark|Rest] = Line,
                         IsSameAsFirstMark = fun(Mark) ->
                                                 (Mark /= empty) and
                                                 (Mark == FirstMark)
                                             end,
                         lists:all(IsSameAsFirstMark, Rest)
                     end,
  lists:filter(ContainsSameMark, board:get_lines_with_marks(BoardMap)).
