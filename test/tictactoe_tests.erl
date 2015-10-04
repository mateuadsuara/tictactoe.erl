-module(tictactoe_tests).
-include_lib("eunit/include/eunit.hrl").

-import(tictactoe, [main/1]).
-import(strings, [contains/2]).
-import(test_io, [redirect_io/2]).

a_full_game_between_two_humans_works_test() ->
  {_, Output} = redirect_io("1\n1\n4\n2\n5\n3", fun() -> main([]) end),
  true        = contains(Output, "x wins").

a_full_game_between_two_computers_works_test() ->
  {_, Output} = redirect_io("4", fun() -> main([]) end),
  true        = contains(Output, "draw").
