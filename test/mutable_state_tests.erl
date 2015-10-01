-module(mutable_state_tests).
-include_lib("eunit/include/eunit.hrl").

-import(mutable_state, [new/1, extract/1, swap/2, destroy/1]).


extract_initial_state_test() ->
  State = new(initial_state),
  Extracted = extract(State),
  destroy(State),
  initial_state = Extracted.

change_state_test() ->
  State = new(5),
  Previous = swap(fun(N) -> N * 3 end, State),
  Extracted = extract(State),
  destroy(State),
  5 = Previous,
  15 = Extracted.

destroy_extracts_state_test() ->
  State = new(state),
  state = destroy(State).

it_is_local_and_isolated_test() ->
  StateA = new(state_a),
  StateB = new(state_b),
  state_a = destroy(StateA),
  state_b = destroy(StateB).
