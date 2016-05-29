-module(node_caller).
-behaviour(gen_server).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state_record, {node_prefix}).

start_link([NodePrefix]) ->
	gen_server:start_link(?MODULE, [NodePrefix], []).

init([NodePrefix]) ->
	process_flag(trap_exit, true),

	io:format("node prefix ~p~n", [NodePrefix]),
	{ok, #state_record{node_prefix = NodePrefix}}.

handle_call({node_call, Module, Function, Args}, _From, #state_record{node_prefix = NodePrefix} = State) ->
	Nodes = node_name_helper:get_nodes_with_prefix(nodes(), NodePrefix),
	Result = (
		if
			length(Nodes) > 0 ->
				RadomIndex = random:uniform(9) rem length(Nodes) + 1,
				Node = lists:nth(RadomIndex, Nodes),
%%                 apply模式调用，需要在参数上加[]
				RpcResult = rpc:call(Node, Module, Function, [Args]),
				RpcResult;
			true ->
				RpcResult = "no node to call",
				RpcResult
		end
	),
	{reply, Result, State};

handle_call(_Request, _From, State) ->
	{reply, _Reply = ok, State}.

handle_cast(stop, State) ->
	{stop, normal, State};

handle_cast(_Msg, State) ->
	{noreply, State}.

handle_info(Info, State) ->
	io:format("Info ~p,~p~n", [Info, State]),
	{noreply, State}.

terminate(_Reason, _State) ->
	io:format("terminate ~p,~p,~p~n", [_Reason, _State, self()]),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.