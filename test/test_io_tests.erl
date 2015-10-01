-module(test_io_tests).
-include_lib("eunit/include/eunit.hrl").

captures_several_outputs_test() ->
  "foobar" =
    test_io:output_when(fun() ->
                            io:format("foo"),
                            io:format("bar")
                        end).

captures_complex_formatting_test() ->
  "foo\"bar\"\n" =
    test_io:output_when(fun() ->
                            io:format("foo~p~n", ["bar"])
                        end).
