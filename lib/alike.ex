defmodule Alike do
  @moduledoc """
  Provides functions to assert that two sentences are semantically alike
  by directly prompting a language model.
  """

  @doc """
  Compares two sentences by prompting a language model to determine if they convey the same meaning.

  Returns a boolean indicating if the sentences are semantically alike.

  ## Options
    * `:timeout` - Time in milliseconds to wait for a response (default: 5000)

  ## Examples

      iex> Alike.alike?("The cat is sleeping", "A feline is taking a nap")
      true
  """
  def alike?(expected, actual, opts \\ []) do
    LanguageModel.alike?(expected, actual, opts)
  end
end
