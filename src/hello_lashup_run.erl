-module(hello_lashup_run).
-behaviour(gen_server).

-define(SERVER, ?MODULE).
-define(FIELDNAME, {lashup_key, riak_dt_lwwreg}).

-record(state, {
    lashup_gm_monitor = erlang:error() :: reference()
}).

%% API
-export([start_link/0,
    getv/1,
    setv/2]).

%% gen_server callbacks
-export([init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3]).

%-type state() :: #state{}.

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
    lager:info("init"),
    Ref = monitor(process, lashup_gm),
    State = #state{lashup_gm_monitor = Ref},
    {ok, State}.

handle_call(Request, _From, State) ->
    lager:info("call"),
    Reply =
    case Request of
        {get, Key} ->
            handle_getv(Key);
        {set, Key, Value} ->
            handle_setv(Key, Value)
    end,
    {reply, Reply, State}.

handle_getv(Key) ->
    Data = lashup_kv:value(Key),
    Dict = orddict:from_list(Data),
    orddict:fetch(?FIELDNAME, Dict).

handle_setv(Key, Value) ->
    Op = {assign, Value},
    Update = {update, ?FIELDNAME, Op},
    MapOp = {update, [Update]},
    {ok, _} = lashup_kv:request_op(Key, MapOp),
    ok.

handle_cast(_Request, State) ->
    lager:info("cast"),
    {noreply, State}.

handle_info(_Info, State) ->
    lager:info("info"),
    {noreply, State}.

terminate(_Reason, _State) ->
    lager:info("terminate"),
    ok.

code_change(_OldVsn, State, _Extra) ->
    lager:info("code_change"),
    {ok, State}.

getv(Key) ->
    gen_server:call(?SERVER, {get, Key}).

setv(Key, Value) ->
    ok = gen_server:call(?SERVER, {set, Key, Value}),
    ok.
