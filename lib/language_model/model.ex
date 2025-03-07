defmodule LanguageModel.Model do
  @moduledoc """
  Loads and manages the SmolLM2 model for text generation.
  """

  @model "HuggingFaceTB/SmolLM2-360M-Instruct"
  @default_opts [
    max_new_tokens: 100,
    timeout: 1_000,
    compile: true
  ]

  def serving do
    IO.puts("Loading model #{@model}...")

    {:ok, model_info} = Bumblebee.load_model({:hf, @model})
    IO.puts("Model loaded successfully.")

    IO.puts("Loading tokenizer...")
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, @model})
    IO.puts("Tokenizer loaded successfully.")

    IO.puts("Loading generation config...")
    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, @model})
    IO.puts("Generation config loaded successfully.")

    # Configure generation parameters specifically for SmolLM2 models
    # Using parameters shown in the SmolLM2 documentation that are supported in Bumblebee
    generation_config = Bumblebee.configure(
      generation_config,
      max_new_tokens: 100,
      temperature: 0.2,    # Lower temperature for more deterministic responses
      do_sample: true,     # Enable sampling (with low temperature for more consistency)
      pad_token_id: tokenizer.pad_token_id,
      num_beams: 1         # Use greedy decoding if we can't use sampling well
    )

    # Set compilation options - use precompilation for better performance
    compile = Keyword.get(@default_opts, :compile, false)
    compile_opts = if compile, do: [batch_size: 1, sequence_length: 100], else: false

    # Set up text generation using parameters from SmolLM2 documentation
    # The model documentation shows these parameters work for SmolLM2:
    # temperature: 0.2, top_p: 0.9, do_sample: true
    # But we're limited by what Bumblebee 0.6.0 supports
    Bumblebee.Text.generation(
      model_info,
      tokenizer,
      generation_config,
      compile: compile_opts,
      defn_options: [compiler: EXLA],
      stream: false
    )
  end

  @doc """
  Returns the name of the Nx.Serving registered process.
  """
  def serving_name, do: __MODULE__

  def child_spec(opts \\ []) do
    opts = Keyword.merge(@default_opts, opts)
    name = Keyword.get(opts, :name, __MODULE__)

    Nx.Serving.child_spec(
      serving: serving(),
      name: name,
      batch_size: 1,
      batch_timeout: Keyword.get(opts, :timeout, 1_000)
    )
  end

  def generate(prompt, opts \\ []) do
    name = Keyword.get(opts, :name, __MODULE__)

    case Nx.Serving.batched_run(name, prompt) do
      %{results: [%{text: text}]} ->
        {:ok, text}

      error ->
        {:error, error}
    end
  end
end
