-module(strings).

-export([contains/2, remove_colors/1]).

contains(String, SubString) ->
  string:str(String, SubString) > 0.

remove_colors(String) ->
  re:replace(String, "(\e\\[[0-1];3[0-9]m|\e\\[0m)", "", [global, {return, list}]).
