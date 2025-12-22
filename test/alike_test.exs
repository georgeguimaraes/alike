defmodule AlikeTest do
  use ExUnit.Case, async: false
  doctest Alike
  import Alike.WaveOperator

  @moduletag timeout: 180_000

  describe "semantic similarity - assertions (should be true)" do
    test "wave operator for similar sentences" do
      assert "The quick brown fox jumps over the lazy dog"
             <~> "A fast auburn fox leaps over a sleeping canine"
    end

    test "direct alike? call with similar sentences" do
      assert Alike.alike?("The cat is sleeping", "A feline is taking a nap")
    end

    test "paraphrased expressions" do
      assert Alike.alike?("It's raining outside", "Water is falling from the clouds")
    end

    test "synonymous descriptions" do
      assert Alike.alike?("The book is interesting", "The novel is fascinating")
    end
  end

  describe "semantic similarity - rejections (should be false)" do
    test "wave operator with unrelated sentences" do
      refute "The weather is nice today" <~> "I enjoy reading books"
    end

    test "direct alike? call with unrelated sentences" do
      refute Alike.alike?("I love pizza", "Mathematics is difficult")
    end

    test "completely different topics" do
      refute Alike.alike?(
               "Quantum physics explores subatomic particles",
               "Renaissance art featured perspective and realism"
             )
    end

    test "same words different meaning (homonyms)" do
      refute Alike.alike?(
               "The bank of the river was muddy",
               "I need to visit the bank to deposit money"
             )
    end
  end

  describe "contradiction detection" do
    test "contradictory color statements" do
      refute Alike.alike?("The sky is blue", "The sky is red")
    end

    test "opposite sentiments" do
      refute Alike.alike?("I love pizza", "I hate pizza")
    end

    test "weather contradictions" do
      refute Alike.alike?("It is raining", "The weather is dry")
    end

    test "entailment is still recognized as alike" do
      assert Alike.alike?("The cat is sleeping", "A feline is taking a nap")
    end
  end
end
