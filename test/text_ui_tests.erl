-module(text_ui_tests).
-include_lib("eunit/include/eunit.hrl").

-import(text_ui, [format/1]).

formats_an_empty_board_test() ->
  " 1 | 2 | 3 \n"
  "---+---+---\n"
  " 4 | 5 | 6 \n"
  "---+---+---\n"
  " 7 | 8 | 9 \n" = format([empty, empty, empty,
                            empty, empty, empty,
                            empty, empty, empty]).

formats_a_board_with_some_marks_test() ->
  " x | x | o \n"
  "---+---+---\n"
  " 4 | o | 6 \n"
  "---+---+---\n"
  " 7 | x | 9 \n" = format([x,     x, o,
                            empty, o, empty,
                            empty, x, empty]).

formats_a_2by2_board_with_some_marks_test() ->
  " 1 | x \n"
  "---+---\n"
  " 3 | o \n" = format([empty, x,
                        empty, o]).
