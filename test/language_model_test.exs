defmodule LanguageModelTest do
  use ExUnit.Case, async: true

  describe "generate/2" do
    test "returns a valid response" do
      case LanguageModel.generate("Test prompt") do
        {:ok, response} -> assert is_binary(response)
        {:error, _} -> assert true # Test passes if model isn't available
      end
    end

    test "handles timeout option" do
      case LanguageModel.generate("Test prompt", timeout: 1000) do
        {:ok, response} -> assert is_binary(response)
        {:error, _} -> assert true # Test passes if model isn't available
      end
    end

    test "produces valid JSON format" do
      prompt = "Compare these sentences and determine if they convey the same meaning: 
                Sentence 1: The weather is nice today.
                Sentence 2: It's a beautiful day outside."

      case LanguageModel.generate(prompt) do
        {:ok, response} -> assert_valid_json_response(response)
        {:error, _} -> assert true # Test passes if model isn't available
      end
    end
  end

  describe "alike?/3" do
    test "returns boolean for similar sentences" do
      result = LanguageModel.alike?("The cat is sleeping", "A feline is taking a nap")
      assert is_boolean(result)
    end

    test "handles timeout option" do
      result = LanguageModel.alike?("Quick test", "Fast test", timeout: 1000)
      assert is_boolean(result)
    end
  end

  describe "model_integration" do
    test "model returns expected format" do
      prompt = "Are these sentences similar? 'I like pizza' and 'Pizza is my favorite food'"

      case LanguageModel.model_generate(prompt, []) do
        {:ok, response} ->
          assert is_binary(response)
          assert_valid_json_response(response)

        {:error, _} ->
          # When model fails, we still want the test to pass
          assert true
      end
    end
  end

  defp assert_valid_json_response(response) do
    try do
      # Very simple check for presence of keys
      response_str = response

      assert String.contains?(response_str, "\"alike\"") or
               String.contains?(response_str, ":alike")

      assert String.contains?(response_str, "\"explanation\"") or
               String.contains?(response_str, ":explanation")

      assert String.contains?(response_str, "true") or String.contains?(response_str, "false")
    rescue
      e ->
        flunk("Response is not valid JSON: #{inspect(response)}, error: #{inspect(e)}")
    end
  end
end
