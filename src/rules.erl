-module(rules).
-export([is_board_finished/1, get_board_winner/1]).

is_board_finished(Board) ->
  is_board_full(Board) orelse (get_board_winner(Board) /= none).

is_board_full(BoardMap) ->
  BoardSpaces = maps:values(BoardMap),
  NotEmpty = fun(Space) ->
                 Space /= empty
             end,
  lists:all(NotEmpty, BoardSpaces).

get_board_winner(Board) ->
  case get_winner_lines(Board) of
    [] -> none;
    [[Winner|_]] -> Winner
  end.

get_winner_lines(BoardMap) ->
  ContainsSameMark = fun(Line) ->
                         [FirstMark|Rest] = Line,
                         IsSameAsFirstMark = fun(Mark) ->
                                                 (Mark /= empty) and
                                                 (Mark == FirstMark)
                                             end,
                         lists:all(IsSameAsFirstMark, Rest)
                     end,
  lists:filter(ContainsSameMark, get_lines_with_marks(BoardMap)).

get_lines_with_marks(BoardMap) ->
  MarkAtSpace = fun(Space) -> maps:get(Space, BoardMap) end,
  MarksAtLine = fun(Line) -> lists:map(MarkAtSpace, Line) end,
  MarksAtLines = fun(Lines) -> lists:map(MarksAtLine, Lines) end,
  MarksAtLines(get_possible_lines()).

get_possible_lines() ->
  [[0, 1, 2], [3, 4, 5], [6, 7, 8],
   [0, 3, 6], [1, 4, 7], [2, 5, 8],
   [0, 4, 8], [2, 4, 6]].
