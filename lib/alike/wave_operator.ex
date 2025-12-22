defmodule Alike.WaveOperator do
  @moduledoc """
  Defines the `<~>` wave operator for semantic similarity assertions.

  The wave operator provides an expressive way to test if two sentences
  convey the same meaning in your ExUnit tests.

  ## Usage

      defmodule MyTest do
        use ExUnit.Case
        import Alike.WaveOperator

        test "similar sentences" do
          assert "The cat is sleeping" <~> "A feline is taking a nap"
        end

        test "contradictions are detected" do
          refute "The sky is blue" <~> "The sky is red"
        end

        test "unrelated sentences" do
          refute "I love pizza" <~> "Mathematics is difficult"
        end
      end

  ## Why "Wave"?

  The `<~>` operator visually resembles a wave, suggesting the fluid nature
  of semantic similarity - two sentences can express the same meaning
  even when using completely different words.
  """

  @doc """
  Compares two sentences for semantic similarity.

  Returns `true` if the sentences are semantically alike, `false` otherwise.

  ## Examples

      iex> import Alike.WaveOperator
      iex> "The cat is sleeping" <~> "A feline is taking a nap"
      true

      iex> import Alike.WaveOperator
      iex> "The weather is nice" <~> "I enjoy reading books"
      false

  """
  defmacro left <~> right do
    quote do
      Alike.alike?(unquote(left), unquote(right))
    end
  end
end

# Backward compatibility alias
defmodule WaveOperator do
  @moduledoc """
  Alias for `Alike.WaveOperator`.

  Prefer using `import Alike.WaveOperator` in new code.
  """

  defmacro left <~> right do
    quote do
      Alike.alike?(unquote(left), unquote(right))
    end
  end
end
