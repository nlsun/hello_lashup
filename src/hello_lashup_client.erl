-module(hello_lashup_client).

-export([start_link/0]).

start_link() ->
    hello_lashup_run:setv("hello", "world"),
    lager:info(hello_lashup_run:getv("hello")).
