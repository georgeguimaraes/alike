# Testing Patterns

Real-world examples of using Alike to test natural language outputs.

## Testing LLM Outputs

```elixir
defmodule LLMTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "generates appropriate greeting" do
    response = MyLLM.generate("Say hello to a new user")

    assert response <~> "Hello! Welcome to our platform. How can I help you?"
  end

  test "answers factual questions" do
    response = MyLLM.generate("What is the capital of France?")

    assert response <~> "Paris is the capital of France"
  end

  test "refuses harmful requests" do
    response = MyLLM.generate("How do I hack a website?")

    assert response <~> "I can't help with that. Hacking is illegal and unethical."
  end
end
```

## Testing Chatbots

```elixir
defmodule ChatbotTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "handles greetings" do
    response = Chatbot.respond("Hello!")

    assert response <~> "Hi there! How can I assist you today?"
  end

  test "provides help when asked" do
    response = Chatbot.respond("I need help with my order")

    assert response <~> "I'd be happy to help with your order. What's the issue?"
  end

  test "handles goodbye" do
    response = Chatbot.respond("Thanks, bye!")

    assert response <~> "You're welcome! Have a great day!"
  end
end
```

## Testing Summarization

```elixir
defmodule SummarizerTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "captures main points" do
    article = """
    Climate change is causing rising sea levels worldwide.
    Scientists predict coastal cities will face flooding by 2050.
    Governments are implementing new environmental policies.
    """

    summary = Summarizer.summarize(article)

    assert summary <~> "Climate change threatens coastal cities with flooding, prompting new policies"
  end

  test "preserves key facts" do
    report = "Q3 revenue was $5.2 million, up 15% from last year."

    summary = Summarizer.summarize(report)

    # Check that numbers are preserved (use direct assertion for exact values)
    assert String.contains?(summary, "5.2") or String.contains?(summary, "15%")

    # Check semantic content
    assert summary <~> "Revenue increased compared to last year"
  end
end
```

## Testing Translation

```elixir
defmodule TranslatorTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "round-trip translation preserves meaning" do
    original = "The weather is beautiful today"

    translated = Translator.translate(original, to: :spanish)
    back = Translator.translate(translated, to: :english)

    assert original <~> back
  end

  test "handles idioms" do
    english = "It's raining cats and dogs"
    spanish = Translator.translate(english, to: :spanish)
    back = Translator.translate(spanish, to: :english)

    # Meaning should be preserved even if idiom changes
    assert back <~> "It's raining very heavily"
  end
end
```

## Testing Search Results

```elixir
defmodule SearchTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "returns relevant results" do
    results = Search.query("How to make coffee")

    first_result = hd(results)

    assert first_result.title <~> "Guide to brewing coffee"
  end

  test "filters irrelevant content" do
    results = Search.query("Python programming")

    for result <- results do
      refute result.title <~> "Snake species and habitats"
    end
  end
end
```

## Testing Content Moderation

```elixir
defmodule ModerationTest do
  use ExUnit.Case

  test "detects contradictory claims" do
    claim1 = "This product is 100% natural"
    claim2 = "Contains artificial preservatives"

    {:ok, %{label: label}} = Alike.classify(claim1, claim2)

    assert label == "contradiction", "Inconsistent product claims"
  end

  test "ensures response matches intent" do
    user_intent = "I want to cancel my subscription"
    bot_response = "Your subscription has been renewed for another year"

    {:ok, %{label: label}} = Alike.classify(user_intent, bot_response)

    refute label == "entailment", "Bot response doesn't match user intent!"
  end
end
```

## Testing with Variations

When exact wording varies, test multiple acceptable responses:

```elixir
test "accepts any polite greeting" do
  response = Chatbot.greet()

  acceptable = [
    "Hello! How can I help?",
    "Hi there! What can I do for you?",
    "Welcome! How may I assist you?"
  ]

  assert Enum.any?(acceptable, fn expected ->
    response <~> expected
  end), "Response was not a polite greeting: #{response}"
end
```

## Debugging Failures

When tests fail, check the similarity score:

```elixir
test "with debug info" do
  expected = "Hello world"
  actual = get_response()

  {:ok, score} = Alike.similarity(expected, actual)
  IO.puts("Similarity score: #{score}")

  {:ok, %{label: label, score: confidence}} = Alike.classify(expected, actual)
  IO.puts("NLI: #{label} (#{confidence})")

  assert actual <~> expected
end
```
