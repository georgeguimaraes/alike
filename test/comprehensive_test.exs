defmodule ComprehensiveTest do
  use ExUnit.Case, async: false

  @moduletag timeout: 600_000

  # Load test sentences
  Code.require_file("support/test_sentences.ex", __DIR__)

  describe "similar pairs (should be alike):" do
    for {s1, s2} <- Alike.TestSentences.similar_pairs() do
      @s1 s1
      @s2 s2
      test "#{s1} <~> #{s2}" do
        assert Alike.alike?(@s1, @s2)
      end
    end
  end

  describe "contradiction pairs (should NOT be alike):" do
    for {s1, s2} <- Alike.TestSentences.contradiction_pairs() do
      @s1 s1
      @s2 s2
      test "#{s1} <!> #{s2}" do
        refute Alike.alike?(@s1, @s2)
      end
    end
  end

  describe "unrelated pairs (should NOT be alike):" do
    for {s1, s2} <- Alike.TestSentences.unrelated_pairs() do
      @s1 s1
      @s2 s2
      test "#{s1} <!> #{s2}" do
        refute Alike.alike?(@s1, @s2)
      end
    end
  end
end
