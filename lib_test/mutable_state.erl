-module(mutable_state).
-export([new/1,
         swap/2,
         extract/1,
         destroy/1]).

-behaviour(gen_server).
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         code_change/3,
         terminate/2
        ]).

%% public api

new(InitialState) ->
  {ok, Server} = gen_server:start(?MODULE, InitialState, []),
  Server.

swap(Transformation, Server) ->
  gen_server:call(Server, {swap, Transformation}).

extract(Server) ->
  gen_server:call(Server, extract).

destroy(Server) ->
  Extracted = extract(Server),
  gen_server:cast(Server, destroy),
  Extracted.

%% gen server

init(InitialState) ->
    {ok, InitialState}.

handle_call(extract, _From, State) ->
    {reply, State, State};
handle_call({swap, Transformation}, _From, State) ->
    NewState = Transformation(State),
    {reply, State, NewState}.

handle_cast(destroy, State) ->
    {stop, shutdown, State}.

handle_info(_, _) -> ignored.
code_change(_, _, _) -> ignored.
terminate(_, _) -> ignored.
