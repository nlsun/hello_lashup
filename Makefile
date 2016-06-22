all: run

# Compile and Run
run:
	./rebar3 ct --readable=false

compile:
	./rebar3 compile

clean:
	./rebar3 clean
