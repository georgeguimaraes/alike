defmodule Alike.ChatInterface do
  @moduledoc """
  A simple interactive interface for testing semantic similarity.
  """

  alias Alike.Models.Embedding

  @doc """
  Starts an interactive session for testing semantic similarity.
  """
  def start do
    IO.puts("=== Semantic Similarity Tester ===")
    IO.puts("Enter two sentences separated by | to compare them.")
    IO.puts("Example: The cat is sleeping | A feline is taking a nap")
    IO.puts("Type 'exit' to quit.")
    IO.puts("==================================\n")

    ensure_model_started()
    chat_loop()
  end

  defp chat_loop do
    input =
      IO.gets("> ")
      |> String.trim()

    case input do
      "exit" ->
        IO.puts("Goodbye!")

      _ ->
        process_input(input)
        chat_loop()
    end
  end

  defp process_input(input) do
    case String.split(input, "|", parts: 2) do
      [sentence1, sentence2] ->
        compare_sentences(String.trim(sentence1), String.trim(sentence2))

      _ ->
        IO.puts("\nPlease enter two sentences separated by |\n")
    end
  end

  defp compare_sentences(s1, s2) do
    case Alike.Similarity.similarity(s1, s2) do
      {:ok, score} ->
        alike = score >= 0.5
        IO.puts("\nSimilarity score: #{Float.round(score, 3)}")
        IO.puts("Are they alike? #{alike}\n")

      {:error, reason} ->
        IO.puts("\nError: #{inspect(reason)}\n")
    end
  end

  defp ensure_model_started do
    model_name = Embedding.serving_name()

    unless Process.whereis(model_name) do
      IO.puts("Loading embedding model...")
      spec = Embedding.child_spec()
      {:ok, _pid} = Supervisor.start_child(Alike.Supervisor, spec)
      IO.puts("Model ready!\n")
    end
  end
end
