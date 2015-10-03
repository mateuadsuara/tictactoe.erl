-module(human_player_tests).
-include_lib("eunit/include/eunit.hrl").

-import(human_player, [play/1]).

contains(String, SubString) ->
  string:str(String, SubString) > 0.


asks_the_user_for_a_possible_move_test() ->
  {_, "Where would you like to move? Available: [1,5,6,7,8,9]\n"} =
    test_io:redirect("1", fun() -> play(game:new([2, 3, 4])) end).

displays_the_moves_properly_when_they_are_printable_ascii_characters_test() ->
  {_, Output} =
    test_io:redirect("8", fun() -> play(game:new([1, 5, 2, 3, 7, 4, 6])) end),
  true = contains(Output, "[8,9]\n").


returns_a_game_with_the_selected_move_test() ->
  {GameWithMove, _} =
    test_io:redirect("1", fun() -> play(game:new()) end),
  [2, 3, 4, 5, 6, 7, 8, 9] = game:possible_moves(GameWithMove).


informs_when_the_move_is_not_possible_test() ->
  {_, Output} =
    test_io:redirect("1\n2\n", fun() -> play(game:new([1])) end),
  true = contains(Output, "It is not possible to move there.\n").

uses_the_possible_move_after_an_impossible_move_test() ->
  {GameWithMove, _} =
    test_io:redirect("1\n2\n", fun() -> play(game:new([1])) end),
  [3, 4, 5, 6, 7, 8, 9] = game:possible_moves(GameWithMove).


informs_when_the_input_is_not_an_integer_test() ->
  {_, Output} =
    test_io:redirect("foo\n1\n", fun() -> play(game:new()) end),
  true = contains(Output, "It is not possible to move there.\n").

uses_the_possible_move_after_an_input_that_is_not_an_integer_test() ->
  {GameWithMove, _} =
    test_io:redirect("foo\n1\n", fun() -> play(game:new()) end),
  [2, 3, 4, 5, 6, 7, 8, 9] = game:possible_moves(GameWithMove).
