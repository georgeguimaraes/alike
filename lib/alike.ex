defmodule Alike do
  @moduledoc """
  Semantic similarity testing for Elixir.

  Alike uses sentence embeddings and NLI (Natural Language Inference) to determine
  if two sentences convey the same meaning, making it perfect for testing natural
  language outputs in your applications.

  ## Quick Start

      import Alike.WaveOperator

      # In your tests
      assert "The cat is sleeping" <~> "A feline is taking a nap"
      refute "The sky is blue" <~> "The sky is red"

  ## Features

  - **Wave operator (`<~>`)** - Expressive test assertions for semantic similarity
  - **Contradiction detection** - Catches logical contradictions using NLI
  - **Configurable thresholds** - Tune similarity and contradiction sensitivity

  ## Configuration

      # config/config.exs
      config :alike,
        similarity_threshold: 0.45,
        contradiction_threshold: 0.8

  See `Alike.Similarity` for advanced usage and raw similarity scores.
  """

  @doc """
  Determines if two sentences are semantically alike.

  Uses sentence embeddings (all-MiniLM-L12-v2) for similarity detection and
  NLI (nli-distilroberta-base) for contradiction detection.

  ## Options

    * `:threshold` - Similarity threshold (0.0 to 1.0). Default from config or 0.45
    * `:check_contradiction` - Use NLI to check for contradictions. Default: true
    * `:timeout` - Time in milliseconds to wait (default: 30000)

  ## Examples

      iex> Alike.alike?("The cat is sleeping", "A feline is taking a nap")
      true

      iex> Alike.alike?("The sky is blue", "The sky is red")
      false

      iex> Alike.alike?("I love pizza", "Mathematics is difficult")
      false

  """
  def alike?(sentence1, sentence2, opts \\ []) do
    Alike.Similarity.alike?(sentence1, sentence2, opts)
  end

  @doc """
  Returns the similarity score between two sentences.

  Delegates to `Alike.Similarity.similarity/3`.
  """
  defdelegate similarity(sentence1, sentence2, opts \\ []), to: Alike.Similarity

  @doc """
  Classifies the relationship between two sentences using NLI.

  Delegates to `Alike.Similarity.classify/3`.
  """
  defdelegate classify(sentence1, sentence2, opts \\ []), to: Alike.Similarity
end
