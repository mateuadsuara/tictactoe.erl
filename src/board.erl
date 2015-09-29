-module(board).
-export([new/0, as_list/1, empty_spaces/1, lines/1, with_moves/2]).

new() ->
  #{1=>empty, 2=>empty, 3=>empty,
    4=>empty, 5=>empty, 6=>empty,
    7=>empty, 8=>empty, 9=>empty}.

as_list(Board) ->
  maps:values(Board).

empty_spaces(Board) ->
  lists:map(fun get_space_from_cell/1, empty_cells(Board)).

lines(Board) ->
  lists:filter(fun is_full/1, lines_with_marks(Board)).

with_moves(Moves, Board) ->
  lists:foldl(fun with_move/2, Board, Moves).


empty_cells(Board) ->
  lists:filter(fun is_cell_empty/1, cells(Board)).

is_cell_empty({_, Mark}) ->
  Mark == empty.

cells(Board) ->
  maps:to_list(Board).

get_space_from_cell({Space, _}) ->
  Space.

is_full(Line) ->
  lists:all(fun not_empty/1, Line).

not_empty(Mark) ->
  Mark /= empty.

lines_with_marks(Board) ->
  MarkAtSpace  = fun(Space) -> maps:get(Space, Board) end,
  MarksAtLine  = fun(Line)  -> lists:map(MarkAtSpace, Line) end,
  MarksAtLines = fun(Lines) -> lists:map(MarksAtLine, Lines) end,
  MarksAtLines(possible_lines()).

possible_lines() ->
  [[1, 2, 3], [4, 5, 6], [7, 8, 9],
   [1, 4, 7], [2, 5, 8], [3, 6, 9],
   [1, 5, 9], [3, 5, 7]].

with_move({Space, Mark}, Board) ->
  maps:put(Space, Mark, Board).
