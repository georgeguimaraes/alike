defmodule AlikeTest do
  use ExUnit.Case, async: true
  doctest Alike
  import WaveOperator

  describe "semantic similarity tests" do
    test "direct alike? function call with similar sentences" do
      assert Alike.alike?("The cat is sleeping", "A feline is taking a nap")
    end

    test "wave operator for semantic similarity" do
      assert "The quick brown fox jumps over the lazy dog"
             <~> "A fast auburn fox leaps over a sleeping canine"
    end

    test "famous quotes and their paraphrases are recognized as alike" do
      alike_pairs = [
        # Famous movie quotes with similar meanings
        {"Here's looking at you, kid.", "I'll always remember you fondly."},
        {"May the Force be with you.", "I hope luck and strength guide your journey."},
        {"I'll be back.", "I will return soon."},

        # Literary quotes with similar meanings
        {"It was the best of times, it was the worst of times.",
         "It was an age of extremes, both wonderful and terrible."},
        {"All that glitters is not gold.", "Appearances can be deceiving."},
        {"To be or not to be, that is the question.",
         "Existence versus non-existence is the fundamental dilemma."},

        # Common expressions with similar meanings
        {"The early bird catches the worm.", "Those who start early gain advantages."},
        {"Don't count your chickens before they hatch.",
         "Avoid assuming future success prematurely."},
        {"A penny saved is a penny earned.", "Being frugal is as beneficial as making money."}
      ]

      for {sentence1, sentence2} <- alike_pairs do
        assert Alike.alike?(sentence1, sentence2)
      end
    end

    test "technical concepts described differently are recognized as alike" do
      alike_pairs = [
        # Technical concepts explained differently
        {"The algorithm sorts elements by repeatedly comparing adjacent pairs.",
         "The sorting method works by sequentially examining neighboring items and arranging them in order."},
        {"Asynchronous operations allow the program to continue execution without waiting.",
         "Non-blocking functions let the software proceed without pausing for completion."},

        # Scientific principles explained differently
        {"Matter cannot be created or destroyed, only transformed.",
         "The total amount of mass stays constant, though it may change forms."},
        {"Evolution occurs through natural selection of beneficial traits.",
         "Advantageous characteristics tend to persist over generations through evolutionary processes."}
      ]

      for {sentence1, sentence2} <- alike_pairs do
        assert Alike.alike?(sentence1, sentence2)
      end
    end

    test "wave operator with completely different sentences" do
      refute "The weather is nice today" <~> "I enjoy reading books"
    end

    test "semantically different sentences are recognized as not alike" do
      unlike_pairs = [
        # Contradictory statements
        {"The sky is blue.", "The sky is red."},
        {"I love spicy food.", "I hate spicy food."},
        {"This movie is a masterpiece.", "This movie is terrible."},

        # Different topics entirely
        {"Quantum physics explores subatomic particles.",
         "Renaissance art featured perspective and realism."},
        {"The hiking trail was steep and rocky.", "Economic policy affects inflation rates."},
        {"Baseball season starts in spring.", "The periodic table organizes chemical elements."},

        # Similar words, different meanings
        {"The bank of the river was muddy.", "I need to visit the bank to deposit money."},
        {"The bat flew through the night sky.", "The baseball player swung the bat."}
      ]

      for {sentence1, sentence2} <- unlike_pairs do
        refute Alike.alike?(sentence1, sentence2)
      end
    end
  end

  describe "error handling" do
    test "alike? handles errors gracefully" do
      assert Alike.alike?("Error test", "Error test")
    end

    test "alike? with timeout option" do
      assert Alike.alike?("Quick test", "Fast test", timeout: 1000)
    end
  end
end
