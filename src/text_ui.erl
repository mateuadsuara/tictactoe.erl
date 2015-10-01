-module(text_ui).
-export([format/1]).

format(Board) ->
  Cells = format_cells(Board),
  Rows = format_rows(square_rows(Cells)),
  add_separators(Rows).


add_separators(Rows) ->
  CellsPerRow = length(Rows),
  Separator = string:join(
                lists:duplicate(CellsPerRow, "---"),
                "+"),
  string:join(Rows, Separator ++ "\n").

format_rows(Rows) ->
  lists:map(fun format_row/1, Rows).

format_row(Row) ->
  string:join(Row, "|") ++ "\n".

square_rows(Cells) ->
  SideSize = round(math:sqrt(length(Cells))),
  list:group_each(SideSize, Cells).

format_cells(Board) ->
  BoardTuples = list:with_indexes(Board),
  lists:map(fun to_cell/1, BoardTuples).

to_cell(BoardTuple) ->
  " " ++ to_string(BoardTuple) ++ " ".

to_string({Space, empty}) -> integer_to_list(Space);
to_string({_, Mark}) -> atom_to_list(Mark).
