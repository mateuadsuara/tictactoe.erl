-module(cli_tests).
-include_lib("eunit/include/eunit.hrl").

-import(cli, [update/1]).

contains(String, SubString) ->
  string:str(String, SubString) > 0.


displays_an_empty_board_test() ->
  Game = game:new(),
  [empty, empty, empty,
   empty, empty, empty,
   empty, empty, empty] = game:board(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output,
                  " 1 | 2 | 3 \n"
                  "---+---+---\n"
                  " 4 | 5 | 6 \n"
                  "---+---+---\n"
                  " 7 | 8 | 9 \n").

displays_a_board_with_some_marks_test() ->
  Game = game:new([1, 3, 2, 5, 8]),
  [x,     x, o,
   empty, o, empty,
   empty, x, empty] = game:board(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output,
                  " x | x | o \n"
                  "---+---+---\n"
                  " 4 | o | 6 \n"
                  "---+---+---\n"
                  " 7 | x | 9 \n").


displays_x_as_the_active_player_test() ->
  Game = game:new(),
  {ongoing, x} = game:status(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "x is playing now...\n").

displays_o_as_the_active_player_test() ->
  Game = game:new([1]),
  {ongoing, o} = game:status(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "o is playing now...\n").


displays_x_as_the_winner_test() ->
  Game = game:new([1, 4, 2, 5, 3]),
  {finished, x} = game:status(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "x has won!\n").

displays_o_as_the_winner_test() ->
  Game = game:new([1, 4, 2, 5, 9, 6]),
  {finished, o} = game:status(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "o has won!\n").


displays_a_draw_test() ->
  Game = game:new([1, 2, 3, 5, 4, 7, 6, 9, 8]),
  {finished, draw} = game:status(Game),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "It is a draw.\n").


displays_the_first_move_test() ->
  Game = game:new([1]),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "Moved to 1.\n").

displays_the_second_move_test() ->
  Game = game:new([1, 9]),
  {ok, Output} = test_io:redirect("", fun() -> update(Game) end),
  true = contains(Output, "Moved to 9.\n").
