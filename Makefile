APP_NAME = hello_lashup

all: build run

build:
	./rebar3 compile

run: 
	erl -env ERL_LIBS _build/default/lib -eval "application:ensure_all_started(${APP_NAME})." -noshell
