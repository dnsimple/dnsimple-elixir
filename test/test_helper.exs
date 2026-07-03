ExUnit.start()

defmodule TestCase do
  Code.require_file("test/fixture_utils.exs")
  use ExUnit.CaseTemplate
end
