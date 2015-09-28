-module(list).
-export([with_indexes/1]).

with_indexes(List) ->
  Indexes = lists:seq(0, length(List)-1),
  lists:zip(Indexes, List).

