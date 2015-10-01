-module(list).
-export([with_indexes/1, group_each/2]).

with_indexes(List) ->
  Indexes = lists:seq(1, length(List)),
  lists:zip(Indexes, List).

group_each(Amount, List) ->
  AmountOfGroups = round(length(List) / Amount),
  Indexes = [(GroupIndex * Amount) + 1 ||
             GroupIndex <- lists:seq(0, AmountOfGroups - 1)],
  GroupAt = fun(Index) -> lists:sublist(List, Index, Amount) end,
  lists:map(GroupAt, Indexes).
