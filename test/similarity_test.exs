defmodule Alike.SimilarityTest do
  use ExUnit.Case, async: false

  @moduletag timeout: 120_000

  # NOTE: Embedding-based similarity measures topical/semantic similarity,
  # NOT logical contradiction. Sentences about the same topic will score high
  # even if they contradict each other.

  describe "similarity/2" do
    test "returns similarity score between 0 and 1" do
      {:ok, score} = Alike.Similarity.similarity("hello world", "hi there")
      assert is_float(score)
      assert score >= -1.0 and score <= 1.0
    end

    test "identical sentences have high similarity" do
      {:ok, score} =
        Alike.Similarity.similarity("The cat sat on the mat", "The cat sat on the mat")

      assert score > 0.95
    end
  end

  describe "alike?/3" do
    test "returns true for semantically similar sentences" do
      assert Alike.Similarity.alike?("The cat is sleeping", "A feline is taking a nap")
    end

    test "returns true for paraphrased sentences" do
      assert Alike.Similarity.alike?("It is raining outside", "Water is falling from the clouds")
    end

    test "returns false for unrelated sentences" do
      refute Alike.Similarity.alike?("The weather is nice today", "I enjoy reading books")
    end

    test "returns false for completely different topics" do
      refute Alike.Similarity.alike?(
               "Quantum physics explores subatomic particles",
               "Renaissance art featured perspective and realism"
             )
    end
  end

  describe "embed/1" do
    test "returns embeddings for text" do
      {:ok, result} = Alike.Similarity.embed("Hello world")
      # Returns a list with one embedding map
      assert is_list(result)
      assert [%{embedding: embedding}] = result
      assert is_struct(embedding, Nx.Tensor)
    end
  end
end
