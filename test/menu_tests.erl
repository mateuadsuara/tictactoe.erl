-module(menu_tests).
-include_lib("eunit/include/eunit.hrl").

-import(menu, [choose_players/2]).
-import(strings, [contains/2]).

displays_the_options_test() ->
  {_, Output} =
    test_io:redirect_io("1", fun() -> choose_players() end),
  "Who will play x and o?\n"
  "1: x as human, o as human.\n"
  "2: x as human, o as computer.\n"
  "3: x as computer, o as human.\n"
  "4: x as computer, o as computer.\n" = Output.

chooses_x_human_o_human_test() ->
  {{X, O}, _} =
    test_io:redirect_io("1", fun() -> choose_players() end),
  human_player = X,
  human_player = O.

chooses_x_human_o_computer_test() ->
  {{X, O}, _} =
    test_io:redirect_io("2", fun() -> choose_players() end),
  human_player = X,
  computer_player = O.

chooses_x_computer_o_human_test() ->
  {{X, O}, _} =
    test_io:redirect_io("3", fun() -> choose_players() end),
  computer_player = X,
  human_player = O.

chooses_x_computer_o_computer_test() ->
  {{X, O}, _} =
    test_io:redirect_io("4", fun() -> choose_players() end),
  computer_player = X,
  computer_player = O.

informs_of_an_option_out_of_range_test() ->
  {_, Output} =
    test_io:redirect_io("5\n1", fun() -> choose_players() end),
  true = contains(Output, "That is not an option.").

informs_of_an_invalid_option_test() ->
  {_, Output} =
    test_io:redirect_io("foo\n1", fun() -> choose_players() end),
  true = contains(Output, "That is not an option.").

chooses_the_valid_option_after_an_invalid_one_test() ->
  {{X, O}, _} =
    test_io:redirect_io("5\n1", fun() -> choose_players() end),
  human_player = X,
  human_player = O.


choose_players() ->
  choose_players(human_player, computer_player).
