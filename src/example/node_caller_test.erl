-module(node_caller_test).

-export([test/0]).

test()->
	node_caller:start_link(["aaa"]).