defmodule Alike.Models.NLI do
  @moduledoc """
  Natural Language Inference model for contradiction detection.

  Uses [nli-distilroberta-base](https://huggingface.co/cross-encoder/nli-distilroberta-base)
  to classify the relationship between two sentences as:
  - `"entailment"` - the second sentence follows from the first
  - `"contradiction"` - the sentences contradict each other
  - `"neutral"` - no clear relationship
  """

  @model "cross-encoder/nli-distilroberta-base"

  @doc """
  Returns the Nx.Serving for the NLI model.
  """
  def serving do
    IO.puts("Loading NLI model #{@model}...")
    {:ok, model_info} = Bumblebee.load_model({:hf, @model})
    IO.puts("NLI model loaded successfully.")

    IO.puts("Loading NLI tokenizer...")
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, @model})
    IO.puts("NLI tokenizer loaded successfully.")

    # Cross-encoder NLI uses text classification
    # Input format: sentence1 [SEP] sentence2
    # Output labels: contradiction (0), entailment (1), neutral (2)
    Bumblebee.Text.text_classification(
      model_info,
      tokenizer,
      compile: [batch_size: 1, sequence_length: 256],
      defn_options: [compiler: EXLA]
    )
  end

  @doc """
  Returns the registered name for the NLI serving process.
  """
  def serving_name, do: Alike.Models.NLIServing

  @doc """
  Returns a child spec for starting the NLI model under a supervisor.
  """
  def child_spec(opts \\ []) do
    name = Keyword.get(opts, :name, serving_name())

    Nx.Serving.child_spec(
      serving: serving(),
      name: name,
      batch_size: 1,
      batch_timeout: 100
    )
  end

  @doc """
  Classifies the relationship between two sentences.

  Returns `{:ok, %{label: label, score: float}}` where label is one of:
  - `"entailment"` - sentence2 follows from sentence1
  - `"contradiction"` - the sentences contradict each other
  - `"neutral"` - no clear relationship

  ## Examples

      iex> Alike.Models.NLI.classify("The sky is blue", "The sky is red")
      {:ok, %{label: "contradiction", score: 0.998}}

  """
  def classify(sentence1, sentence2, opts \\ []) do
    name = Keyword.get(opts, :name, serving_name())

    # Cross-encoder expects both sentences - Bumblebee handles the SEP token
    result = Nx.Serving.batched_run(name, {sentence1, sentence2})

    case result do
      %{predictions: predictions} ->
        # Get the top prediction
        top = Enum.max_by(predictions, & &1.score)
        {:ok, %{label: top.label, score: top.score}}

      error ->
        {:error, error}
    end
  end
end
