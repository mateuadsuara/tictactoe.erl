-module(menu).

-export([choose_players/2]).

choose_players(Human, Computer) ->
  io:format("Who will play x and o?~n"
            "1: x as human, o as human.~n"
            "2: x as human, o as computer.~n"
            "3: x as computer, o as human.~n"
            "4: x as computer, o as computer.~n"),
  Option = ask_for_one_of(["1", "2", "3", "4"]),
  case Option of
    "1" -> {Human, Human};
    "2" -> {Human, Computer};
    "3" -> {Computer, Human};
    "4" -> {Computer, Computer}
  end.


ask_for_one_of(Options) ->
  {ok, [Option]} = io:fread("", "~s"),
  case lists:member(Option, Options) of
    true -> Option;
    _ ->
      io:format("That is not an option.~n"),
      ask_for_one_of(Options)
  end.
