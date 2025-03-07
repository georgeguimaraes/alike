defmodule ChatInterface do
  @moduledoc """
  A simple interface for sending messages to the language model and viewing responses.
  """

  @doc """
  Starts an interactive chat session with the language model.
  """
  def start do
    IO.puts("=== Language Model Chat Interface ===")
    IO.puts("Type your message and press Enter to send.")
    IO.puts("Type 'exit' to quit.")
    IO.puts("Type 'alike:sentence1|sentence2' to test semantic similarity.")
    IO.puts("=======================================\n")

    ensure_model_started()
    chat_loop()
  end

  defp chat_loop do
    prompt =
      IO.gets("> ")
      |> String.trim()

    case prompt do
      "exit" ->
        IO.puts("Goodbye!")

      "alike:" <> sentences ->
        # Handle alike command - format is alike:sentence1|sentence2
        case String.split(sentences, "|", parts: 2) do
          [sentence1, sentence2] ->
            result = Alike.alike?(String.trim(sentence1), String.trim(sentence2))
            IO.puts("\nAre the sentences alike? #{result}\n")
            
          _ ->
            IO.puts("\nInvalid format. Use 'alike:sentence1|sentence2'\n")
        end
        chat_loop()

      _ ->
        # Standard message to the model
        case send_to_model(prompt) do
          {:ok, response} ->
            IO.puts("\nModel: #{response}\n")
          {:error, reason} ->
            IO.puts("\nError: #{inspect(reason)}\n")
        end
        chat_loop()
    end
  end

  defp send_to_model(prompt) do
    # Apply system wrapper for Chat interface consistency
    wrapped_prompt = LanguageModel.Prompts.system_wrapper(prompt)
    
    # Directly use LanguageModel.Model.generate for raw access
    LanguageModel.Model.generate(wrapped_prompt)
  end

  defp ensure_model_started do
    model_name = LanguageModel.Model.serving_name()

    unless Process.whereis(model_name) do
      IO.puts("Starting language model...")
      spec = LanguageModel.Model.child_spec()
      {:ok, _pid} = Supervisor.start_child(Alike.Supervisor, spec)
      IO.puts("Model started!")
    end
  end
end