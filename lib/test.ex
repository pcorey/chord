# defmodule Memo do
#   defmacro memo(full_ast = {:def, _, [def_ast = {func, _, _}, [do: do_ast]]}) do
#     module = __CALLER__.module

#     quote do
#       def unquote(def_ast) do
#         IO.puts("In #{inspect(module)}.#{inspect(func)}")
#         unquote(do_ast)
#       end
#     end
#   end
# end
