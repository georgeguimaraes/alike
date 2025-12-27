defmodule Alike.Similarity do
  @moduledoc """
  Core semantic similarity detection using sentence embeddings and NLI.

  This module provides the main logic for determining if two sentences
  are semantically alike, combining embedding-based similarity with
  NLI-based contradiction detection.

  ## Configuration

      config :alike,
        similarity_threshold: 0.45,
        contradiction_threshold: 0.8

  ## Usage

  Most users should use `Alike.alike?/3` or the wave operator instead
  of calling this module directly.

  For advanced use cases:

      # Get raw similarity score
      {:ok, score} = Alike.Similarity.similarity("Hello", "Hi there")

      # Classify relationship with NLI
      {:ok, %{label: "entailment"}} = Alike.Similarity.classify("A cat", "An animal")

  """

  alias Alike.Models.{Embedding, NLI}

  defp similarity_threshold do
    Application.get_env(:alike, :similarity_threshold, 0.45)
  end

  defp contradiction_threshold do
    Application.get_env(:alike, :contradiction_threshold, 0.8)
  end

  @doc """
  Determines if two sentences are semantically alike.

  ## Options

    * `:threshold` - Similarity threshold (0.0 to 1.0). Default from config or 0.45
    * `:check_contradiction` - Use NLI to check for contradictions. Default: true
    * `:timeout` - Time in milliseconds to wait (default: 30000)

  ## Returns

    * `true` - The sentences are semantically alike
    * `false` - The sentences are not alike or contradict each other

  """
  def alike?(sentence1, sentence2, opts \\ []) do
    threshold = Keyword.get(opts, :threshold, similarity_threshold())
    check_contradiction = Keyword.get(opts, :check_contradiction, true)
    timeout = Keyword.get(opts, :timeout, 30_000)

    ensure_embedding_started()

    task =
      Task.async(fn ->
        do_alike?(sentence1, sentence2, threshold, check_contradiction)
      end)

    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, result} -> result
      nil -> false
    end
  end

  defp do_alike?(sentence1, sentence2, threshold, check_contradiction) do
    case compute_similarity(sentence1, sentence2) do
      {:ok, similarity} when similarity >= threshold ->
        maybe_check_contradiction(sentence1, sentence2, similarity, check_contradiction)

      {:ok, _similarity} ->
        false

      {:error, _reason} ->
        false
    end
  end

  defp maybe_check_contradiction(sentence1, sentence2, similarity, true) do
    ensure_nli_started()
    check_for_contradiction(sentence1, sentence2, similarity)
  end

  defp maybe_check_contradiction(_sentence1, _sentence2, _similarity, false), do: true

  defp check_for_contradiction(sentence1, sentence2, similarity) do
    case NLI.classify(sentence1, sentence2) do
      {:ok, %{label: "contradiction", score: score}} ->
        if score > contradiction_threshold() do
          false
        else
          true
        end

      {:ok, _} ->
        true

      {:error, _} ->
        similarity >= similarity_threshold()
    end
  end

  @doc """
  Returns the similarity score between two sentences.

  Returns `{:ok, float}` where float is between 0.0 and 1.0,
  or `{:error, reason}` on failure.
  """
  def similarity(sentence1, sentence2, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 30_000)

    ensure_embedding_started()

    task = Task.async(fn -> compute_similarity(sentence1, sentence2) end)

    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, result} -> result
      nil -> {:error, :timeout}
    end
  end

  @doc """
  Classifies the relationship between two sentences using NLI.

  Returns `{:ok, %{label: label, score: float}}` where label is one of:
  - `"entailment"` - sentence2 follows from sentence1
  - `"contradiction"` - the sentences contradict each other
  - `"neutral"` - no clear relationship
  """
  def classify(sentence1, sentence2, opts \\ []) do
    timeout = Keyword.get(opts, :timeout, 60_000)

    ensure_nli_started()

    task = Task.async(fn -> NLI.classify(sentence1, sentence2) end)

    case Task.yield(task, timeout) || Task.shutdown(task) do
      {:ok, result} -> result
      nil -> {:error, :timeout}
    end
  end

  defp compute_similarity(sentence1, sentence2) do
    case Embedding.embed([sentence1, sentence2]) do
      {:ok, [%{embedding: e1}, %{embedding: e2}]} ->
        similarity = Embedding.cosine_similarity(e1, e2)
        {:ok, similarity}

      {:ok, %{embedding: embeddings}} ->
        e1 = Nx.slice(embeddings, [0, 0], [1, 384])
        e2 = Nx.slice(embeddings, [1, 0], [1, 384])
        similarity = Embedding.cosine_similarity(e1, e2)
        {:ok, similarity}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Generate embeddings for a text.
  """
  def embed(text, opts \\ []) do
    ensure_embedding_started()
    Embedding.embed([text], opts)
  end

  defp ensure_embedding_started do
    case Supervisor.start_child(Alike.Supervisor, Embedding.child_spec()) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _}} -> :ok
    end
  end

  defp ensure_nli_started do
    case Supervisor.start_child(Alike.Supervisor, NLI.child_spec()) do
      {:ok, _pid} -> :ok
      {:error, {:already_started, _}} -> :ok
    end
  end
end
