defmodule Alike.Models.Embedding do
  @moduledoc """
  Sentence embedding model for semantic similarity.

  Uses [all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) by default
  to convert sentences into 384-dimensional vectors for cosine similarity comparison.

  Configure via application config or environment variable:

      config :alike, embedding_model: "sentence-transformers/all-MiniLM-L12-v2"

  Or: `ALIKE_EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L12-v2`
  """

  alias Bumblebee.Text.TextEmbedding

  @default_model "sentence-transformers/all-MiniLM-L6-v2"

  @doc """
  Returns the configured embedding model name.

  Priority: ALIKE_EMBEDDING_MODEL env var > :alike :embedding_model config > default
  """
  def model_name do
    System.get_env("ALIKE_EMBEDDING_MODEL") ||
      Application.get_env(:alike, :embedding_model, @default_model)
  end

  @doc false
  def default_model, do: @default_model

  @doc """
  Returns the Nx.Serving for the embedding model.
  """
  def serving do
    model = model_name()
    IO.puts("Loading embedding model #{model}...")
    {:ok, model_info} = Bumblebee.load_model({:hf, model})
    IO.puts("Model loaded successfully.")

    IO.puts("Loading tokenizer...")
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, model})
    IO.puts("Tokenizer loaded successfully.")

    TextEmbedding.text_embedding(
      model_info,
      tokenizer,
      compile: [batch_size: 2, sequence_length: 128],
      defn_options: [compiler: EXLA],
      output_pool: :mean_pooling,
      output_attribute: :hidden_state
    )
  end

  @doc """
  Returns the registered name for the embedding serving process.
  """
  def serving_name, do: Alike.Models.EmbeddingServing

  @doc """
  Returns a child spec for starting the embedding model under a supervisor.
  """
  def child_spec(opts \\ []) do
    name = Keyword.get(opts, :name, serving_name())

    Nx.Serving.child_spec(
      serving: serving(),
      name: name,
      batch_size: 2,
      batch_timeout: 100
    )
  end

  @doc """
  Computes embeddings for one or more sentences.

  ## Examples

      iex> Alike.Models.Embedding.embed(["Hello world"])
      {:ok, [%{embedding: #Nx.Tensor<...>}]}

  """
  def embed(sentences, opts \\ []) when is_list(sentences) do
    name = Keyword.get(opts, :name, serving_name())

    result = Nx.Serving.batched_run(name, sentences)

    case result do
      [%{embedding: _} | _] = list -> {:ok, list}
      %{embedding: _} = single -> {:ok, single}
      error -> {:error, error}
    end
  end

  @doc """
  Computes cosine similarity between two embedding vectors.

  Returns a float between -1 and 1.
  """
  def cosine_similarity(embedding1, embedding2) do
    e1 = Nx.flatten(embedding1)
    e2 = Nx.flatten(embedding2)

    dot_product = Nx.dot(e1, e2)
    norm1 = Nx.LinAlg.norm(e1)
    norm2 = Nx.LinAlg.norm(e2)

    Nx.divide(dot_product, Nx.multiply(norm1, norm2))
    |> Nx.to_number()
  end
end
