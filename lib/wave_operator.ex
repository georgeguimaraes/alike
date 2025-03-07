defmodule WaveOperator do
  @moduledoc """
  Defines the `<~>` operator (the Wave Operator) for asserting that two sentences are semantically alike.
  """

  @doc """
  The wave operator `<~>` compares two sentences for semantic similarity.

  This operator can be used in ExUnit tests with `assert`:

  ## Examples

      import WaveOperator
      
      test "semantically similar sentences" do
        assert "The cat is sleeping" <~> "A feline is taking a nap"
      end
  """
  defmacro left <~> right do
    quote do
      Alike.alike?(unquote(left), unquote(right))
    end
  end
end
