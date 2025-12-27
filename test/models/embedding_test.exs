defmodule Alike.Models.EmbeddingTest do
  use ExUnit.Case, async: true

  alias Alike.Models.Embedding

  describe "default_model/0" do
    test "returns L6 as default" do
      assert Embedding.default_model() == "sentence-transformers/all-MiniLM-L6-v2"
    end
  end

  describe "model_name/0" do
    test "returns a valid model name" do
      # Just verify it returns a string - actual config behavior tested via CI matrix
      assert is_binary(Embedding.model_name())
      assert String.starts_with?(Embedding.model_name(), "sentence-transformers/")
    end
  end
end
