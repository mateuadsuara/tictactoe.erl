-module(test_io_tests).
-include_lib("eunit/include/eunit.hrl").

returns_the_function_result_test() ->
  {result, _} = test_io:redirect_io("", fun() -> result end).

redirects_the_formatted_output_test() ->
  {_, "FOO\"BAR\"\n"} =
    test_io:redirect_io(
      "",
      fun() ->
          ok = io:format("FOO"),
          ok = io:format("~p~n", ["BAR"])
      end).

reads_a_string_test() ->
  test_io:redirect_io(
    "foo",
    fun() ->
        {ok, ["foo"]} = io:fread("", "~s")
    end).

reads_a_string_after_some_lines_test() ->
  test_io:redirect_io(
    "\n\n\nfoo",
    fun() ->
        {ok, ["foo"]} = io:fread("", "~s")
    end).

reads_an_integer_test() ->
  test_io:redirect_io(
    "4",
    fun() ->
        {ok, [4]} = io:fread("", "~d")
    end).

reads_an_integer_in_a_line_test() ->
  test_io:redirect_io(
    "4\n",
    fun() ->
        {ok, [4]} = io:fread("", "~d")
    end).

reads_an_integer_in_the_next_line_test() ->
  test_io:redirect_io(
    "\n4",
    fun() ->
        {ok, [4]} = io:fread("", "~d")
    end).

empty_line_when_reading_integer_errs_test() ->
  test_io:redirect_io(
    "\n",
    fun() ->
        {error, {fread, integer}} = io:fread("", "~d")
    end).

nothing_to_read_test() ->
  test_io:redirect_io(
    "",
    fun() ->
        eof = io:fread("", "~d")
    end).

reads_an_integer_after_an_invalid_one_test() ->
  test_io:redirect_io(
    "foo\n4",
    fun() ->
        {error, {fread, integer}} = io:fread("", "~d"),
        {ok, [4]} = io:fread("", "~d")
    end).

reads_an_integer_after_an_invalid_one_in_the_second_line_test() ->
  test_io:redirect_io(
    "\nfoo\n4",
    fun() ->
        {error, {fread, integer}} = io:fread("", "~d"),
        {ok, [4]} = io:fread("", "~d")
    end).

nothing_to_read_after_an_invalid_integer_test() ->
  test_io:redirect_io(
    "foo",
    fun() ->
        {error, {fread, integer}} = io:fread("", "~d"),
        eof = io:fread("", "~d")
    end).
