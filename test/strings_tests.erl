-module(strings_tests).
-include_lib("eunit/include/eunit.hrl").

-import(strings, [contains/2, remove_colors/1]).

contains_a_substring_test() ->
  true = contains("foobar", "foo").

does_not_contain_a_substring_test() ->
  false = contains("foo", "bar").

removes_the_colors_in_a_text_test() ->
  "FOO" = remove_colors("\033[1;30mFOO\033[0m").
