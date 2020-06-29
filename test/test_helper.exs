ExUnit.start()

defmodule TestCase do
  Code.require_file("test/exvcr_utils.exs")
  use ExUnit.CaseTemplate
end
