# Advanced Usage

Beyond the wave operator, Alike provides lower-level APIs for custom use cases.

## Raw Similarity Scores

Get the underlying cosine similarity score:

```elixir
{:ok, score} = Alike.similarity("The cat is sleeping", "A feline is napping")
# => {:ok, 0.847}

{:ok, score} = Alike.similarity("Hello world", "Goodbye moon")
# => {:ok, 0.312}
```

The score ranges from 0.0 (completely different) to 1.0 (identical meaning).

### Use Cases

- **Custom thresholds**: Apply different thresholds for different test types
- **Debugging**: Understand why a test passed or failed
- **Analytics**: Track similarity scores over time

```elixir
test "response quality is high" do
  {:ok, score} = Alike.similarity(expected, actual)

  # Require at least 70% similarity for this specific test
  assert score >= 0.7, "Response too different: #{score}"
end
```

## NLI Classification

Classify the logical relationship between sentences:

```elixir
{:ok, result} = Alike.classify("A dog is running", "An animal is moving")
# => {:ok, %{label: "entailment", score: 0.94}}

{:ok, result} = Alike.classify("The sky is blue", "The sky is red")
# => {:ok, %{label: "contradiction", score: 0.99}}

{:ok, result} = Alike.classify("I like coffee", "It's raining outside")
# => {:ok, %{label: "neutral", score: 0.87}}
```

### NLI Labels

| Label | Meaning | Example |
|-------|---------|---------|
| `entailment` | Second sentence follows from first | "A cat sleeps" -> "An animal rests" |
| `contradiction` | Sentences cannot both be true | "Sky is blue" vs "Sky is red" |
| `neutral` | No logical relationship | "I like coffee" vs "It's raining" |

### Use Cases

- **Fact checking**: Verify statements don't contradict known facts
- **Consistency**: Ensure generated content is internally consistent
- **Inference**: Check if conclusions follow from premises

```elixir
test "response doesn't contradict the prompt" do
  prompt = "The user is a premium subscriber"
  response = generate_response(prompt)

  {:ok, %{label: label}} = Alike.classify(prompt, response)
  refute label == "contradiction", "Response contradicts the prompt!"
end
```

## Combining Approaches

Use both similarity and classification for robust testing:

```elixir
test "response is relevant and consistent" do
  expected = "Thank you for your purchase"
  actual = get_response()

  # Check semantic similarity
  {:ok, score} = Alike.similarity(expected, actual)
  assert score >= 0.5, "Response not similar enough"

  # Check for contradictions
  {:ok, %{label: label}} = Alike.classify(expected, actual)
  refute label == "contradiction", "Response contradicts expected"
end
```

## Direct Model Access

For advanced use cases, access the models directly:

```elixir
# Generate embeddings
{:ok, [%{embedding: tensor}]} = Alike.Models.Embedding.embed(["Hello world"])

# Compute similarity manually
{:ok, [%{embedding: e1}, %{embedding: e2}]} =
  Alike.Models.Embedding.embed(["Hello", "Hi"])
score = Alike.Models.Embedding.cosine_similarity(e1, e2)
```

## Performance Tips

1. **Batch similar tests**: Models stay loaded between tests
2. **Disable contradiction checking**: Use `check_contradiction: false` when not needed
3. **Cache in CI**: Cache `~/.cache/bumblebee/` to avoid downloads
4. **Increase timeout**: For slow machines, increase the timeout option
