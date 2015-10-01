-module(test_io).
-export([output_when/1]).

output_when(Function) ->
  Messages = messages_to_group_leader_during(Function),
  Strings = lists:map(fun to_string/1, Messages),
  string:join(Strings, "").

messages_to_group_leader_during(Function) ->
  Original = erlang:group_leader(),
  Spy = fun Self(ReceivedMessagesState) ->
    receive
      {get_spied_messages, Pid} ->
        Pid ! {messages, ReceivedMessagesState};
      Message ->
        Original ! Message,
        Self(lists:append(ReceivedMessagesState, [Message]))
    end
  end,
  Surrogate = spawn(fun() -> Spy([]) end),
  erlang:group_leader(Surrogate, self()),
  Function(),
  erlang:group_leader(Original, self()),
  Surrogate ! {get_spied_messages, self()},
  receive {messages, M} -> M end.

to_string(Message) ->
  case Message of
    {io_request, _, _,
     {put_chars, Encoding, Module, Func, Args}} ->
      unicode:characters_to_list(
        apply(Module, Func, Args),
        Encoding)
  end.
