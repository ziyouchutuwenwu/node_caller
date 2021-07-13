-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules().

interprete_modules() ->
  int:ni(node_caller_test),
  int:ni(node_caller),
  int:ni(node_name_helper),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").