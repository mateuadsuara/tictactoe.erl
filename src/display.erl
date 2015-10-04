-module(display).

-export([update/1]).

update(Game) ->
  display_last_move(game:previous_moves(Game)),
  display_board(game:board(Game)),
  display_status(game:status(Game)).


display_last_move([]) -> ok;
display_last_move(Moves) ->
  io:format("Moved to ~w.~n", [lists:last(Moves)]).

display_board(Board) ->
  io:format("~n~s~n", [format(Board)]).

display_status({ongoing, ActivePlayer}) ->
  io:format("~p is playing now...~n", [ActivePlayer]);
display_status({finished, draw}) ->
  io:format("It is a draw.~n");
display_status({finished, Winner}) ->
  io:format("~p wins!~n", [Winner]).

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

to_string({Space, empty}) -> grey(integer_to_list(Space));
to_string({_, Mark}) -> atom_to_list(Mark).

grey(String) -> "\033[1;30m" ++ String ++ "\033[0m".
