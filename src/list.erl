-module(list).
-export([with_indexes/1, group_each/2, max_key/2]).

with_indexes(List) ->
  Indexes = lists:seq(1, length(List)),
  lists:zip(Indexes, List).

group_each(GroupSize, List) ->
  AmountOfGroups = round(length(List) / GroupSize),
  Indexes = [(GroupIndex * GroupSize) + 1 ||
             GroupIndex <- lists:seq(0, AmountOfGroups - 1)],
  GroupAt = fun(Index) -> lists:sublist(List, Index, GroupSize) end,
  lists:map(GroupAt, Indexes).

max_key(KeyIndexInTuple, TupleList) ->
  Max = fun(Candidate, MaxSoFar) ->
            CandidateKey = erlang:element(KeyIndexInTuple, Candidate),
            MaxKey       = erlang:element(KeyIndexInTuple, MaxSoFar),
            case CandidateKey > MaxKey of
              true -> Candidate;
              _    -> MaxSoFar
            end
        end,
  [First|Rest] = TupleList,
  lists:foldl(Max, First, Rest).
