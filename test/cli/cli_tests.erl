-module(cli_tests).
-include_lib("eunit/include/eunit.hrl").

-import(cli, [execute/0]).
-import(strings, [contains/2]).
-import(test_io, [redirect_io/2]).

a_full_game_between_two_humans_works_test() ->
  {_, Output} = redirect_io("1\n1\n4\n2\n5\n3", fun() -> execute() end),
  true        = contains(Output, "x wins").

a_full_game_between_two_computers_works_test() ->
  {_, Output} = redirect_io("4", fun() -> execute() end),
  true        = contains(Output, "draw").
