%%%-------------------------------------------------------------------
%%% @author sdhillon
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Mar 2016 8:06 AM
%%%-------------------------------------------------------------------
-module(hello_lashup_SUITE).

-compile({parse_transform, lager_transform}).
-compile(export_all).

-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).


init_per_suite(Config) ->
  %% this might help, might not...
  os:cmd(os:find_executable("epmd") ++ " -daemon"),
  {ok, Hostname} = inet:gethostname(),
  case net_kernel:start([list_to_atom("runner@" ++ Hostname), shortnames]) of
    {ok, _} -> ok;
    {error, {already_started, _}} -> ok
  end,
  application:ensure_all_started(hello_lashup),
  Config.

end_per_suite(Config) ->
  application:stop(hello_lashup),
  net_kernel:stop(),
  Config.

all() ->
  [hello_world].

hello_world(_Config) ->
    ct:pal("start"),
    hello_lashup_run:setv("hello", "world"),
    ct:pal(hello_lashup_run:getv("hello")).
