defmodule Alike.Models.EmbeddingTest do
  use ExUnit.Case, async: true

  alias Alike.Models.Embedding

  describe "model_name/0" do
    test "returns default model when no config set" do
      # Clear any existing config
      Application.delete_env(:alike, :embedding_model)
      System.delete_env("ALIKE_EMBEDDING_MODEL")

      assert Embedding.model_name() == "sentence-transformers/all-MiniLM-L6-v2"
    end

    test "returns model from application config" do
      System.delete_env("ALIKE_EMBEDDING_MODEL")
      Application.put_env(:alike, :embedding_model, "sentence-transformers/all-MiniLM-L12-v2")

      assert Embedding.model_name() == "sentence-transformers/all-MiniLM-L12-v2"

      Application.delete_env(:alike, :embedding_model)
    end

    test "env var overrides application config" do
      Application.put_env(:alike, :embedding_model, "sentence-transformers/all-MiniLM-L12-v2")
      System.put_env("ALIKE_EMBEDDING_MODEL", "sentence-transformers/paraphrase-MiniLM-L3-v2")

      assert Embedding.model_name() == "sentence-transformers/paraphrase-MiniLM-L3-v2"

      System.delete_env("ALIKE_EMBEDDING_MODEL")
      Application.delete_env(:alike, :embedding_model)
    end
  end
end
