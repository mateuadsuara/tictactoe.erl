-module(rules_tests).
-include_lib("eunit/include/eunit.hrl").

no_winner_test() ->
  none = winner([x, o, x,
                 x, o, o,
                 o, x, x]).

x_won_in_first_line_test() ->
  x = winner([x,     x,     x,
              o,     o,     empty,
              empty, empty, empty]).

o_won_in_first_line_test() ->
  o = winner([o,     o,     o,
              x,     x,     empty,
              empty, empty, x]).

not_finished_test() ->
  false = is_finished([x,     o,     empty,
                       empty, empty, empty,
                       empty, empty, empty]).

finished_when_board_is_full_test() ->
  true = is_finished([x, o, x,
                      x, o, o,
                      o, x, x]).

finished_when_someone_won_test() ->
  true = is_finished([empty, empty, empty,
                      x,     x,     x,
                      empty, o,     o]).

is_finished(BoardList) ->
  rules:is_board_finished(board_map(BoardList)).

winner(BoardList) ->
  rules:get_board_winner(board_map(BoardList)).

board_map(BoardList) ->
  maps:from_list(list:with_indexes(BoardList)).
