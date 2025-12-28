defmodule Alike.Models.NLITest do
  use ExUnit.Case, async: true

  alias Alike.Models.NLI

  describe "serving_name/0" do
    test "returns the expected serving name" do
      assert NLI.serving_name() == Alike.Models.NLIServing
    end
  end
end
