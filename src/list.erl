-module(list).
-export([with_indexes/1]).

with_indexes(List) ->
  Indexes = lists:seq(1, length(List)),
  lists:zip(Indexes, List).

