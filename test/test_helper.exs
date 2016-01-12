ExUnit.start()

defmodule TestCase do
  use ExUnit.CaseTemplate

  setup do
    Code.require_file("test/exvcr_utils.exs")
    :ok
  end

end

