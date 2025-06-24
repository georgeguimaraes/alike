defmodule LanguageModel.Model do
  @moduledoc """
  Loads and manages the SmolLM2 model for text generation.
  """

  @model "HuggingFaceTB/SmolLM2-1.7B-Instruct"
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
    # Using parameters from the HuggingFace docs that are supported in Bumblebee 0.6.0
    # HuggingFace example uses: max_new_tokens=50, temperature=0.2, top_p=0.9, do_sample=True
    # But we can only use what Bumblebee supports
    generation_config =
      Bumblebee.configure(
        generation_config,
        max_new_tokens: 100,
        temperature: 0.2,  # Lower temperature for more focused responses
        # Add sampling strategy to match HuggingFace example (similar to do_sample=True, top_p=0.9)
        strategy: %{type: :multinomial_sampling, top_p: 0.9}
      )

    # Set compilation options - use precompilation for better performance
    compile = Keyword.get(@default_opts, :compile, false)
    compile_opts = if compile, do: [batch_size: 1, sequence_length: 100], else: false

    # Set up text generation using parameters from SmolLM2 documentation
    # The model documentation shows these parameters work for SmolLM2:
    # temperature: 0.2, max_new_tokens: 50
    # We've simplified the config to only use parameters Bumblebee 0.6.0 supports
    Bumblebee.Text.generation(
      model_info,
      tokenizer,
      generation_config,
      compile: compile_opts,
      defn_options: [compiler: EXLA]
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
        # Extract just the assistant's response from the formatted text
        # Normally this would be handled by tokenizer.decode(tokens, skip_special_tokens=True)
        # in the HuggingFace Python API
        clean_text = extract_assistant_response(text)
        {:ok, clean_text}

      error ->
        {:error, error}
    end
  end

  # Extract only the assistant's response from the formatted text
  defp extract_assistant_response(text) do
    # First clean any redundant system/user tags that might be in the output
    text = 
      text
      |> String.replace(~r/<\|im_start\|>system.*?<\|im_end\|>/s, "")
      |> String.replace(~r/<\|im_start\|>user.*?<\|im_end\|>/s, "")
      |> String.trim()
    
    # Extract just the assistant's response
    text = 
      cond do
        # If it contains the assistant tag, extract the content after it
        String.contains?(text, "<|im_start|>assistant") ->
          text
          |> String.split("<|im_start|>assistant", parts: 2)
          |> List.last()
          |> String.split("<|im_end|>", parts: 2)
          |> List.first()
          |> String.trim()
          
        # Otherwise just use the text as is
        true -> text
      end
    
    # After extraction, look for true/false answers
    text_lower = String.downcase(text)
    
    cond do
      # Simple exact matches
      text_lower == "true" -> "true"
      text_lower == "false" -> "false"
      
      # If the answer starts with true/false
      String.starts_with?(text_lower, "true") -> "true"
      String.starts_with?(text_lower, "false") -> "false"
      
      # Look for clear indicators in the text
      String.contains?(text_lower, " true ") || 
      String.contains?(text_lower, " true.") || 
      String.contains?(text_lower, " true,") ||
      String.contains?(text_lower, " yes") ||
      String.contains?(text_lower, "similar") ||
      String.contains?(text_lower, "same meaning") -> "true"
      
      String.contains?(text_lower, " false ") || 
      String.contains?(text_lower, " false.") || 
      String.contains?(text_lower, " false,") ||
      String.contains?(text_lower, " no ") ||
      String.contains?(text_lower, " not ") ||
      String.contains?(text_lower, "different") -> "false"
      
      # If we can't clearly determine, return the original text
      true -> text
    end
  end
end
