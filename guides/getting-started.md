# Getting Started

This guide walks you through setting up Alike and writing your first semantic similarity tests.

## Installation

Add Alike to your test dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alike, "~> 0.1.0", only: :test}
  ]
end
```

Run `mix deps.get` to fetch the dependency.

## Your First Test

Create a test file and import the wave operator:

```elixir
defmodule MyAppTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "greeting response is appropriate" do
    response = "Hello! How can I help you today?"

    # These assertions pass - the sentences mean the same thing
    assert response <~> "Hi there! What can I do for you?"
    assert response <~> "Greetings! How may I assist you?"

    # This assertion fails - completely unrelated
    refute response <~> "The weather is nice today"
  end
end
```

The `<~>` wave operator compares two sentences for semantic similarity, returning `true` if they convey the same meaning.

## How It Works

On first run, Alike downloads two ML models (~460MB total):

1. **Embedding model** - Converts sentences to vectors for similarity comparison
2. **NLI model** - Detects logical contradictions

Models are cached in `~/.cache/bumblebee/` and only downloaded once.

## What Gets Detected

### Similar Sentences (pass with `assert`)

```elixir
# Paraphrases
assert "The cat is sleeping" <~> "A feline is taking a nap"

# Synonyms
assert "The book is interesting" <~> "The novel is fascinating"

# Different wording, same meaning
assert "It's raining outside" <~> "Water is falling from the clouds"
```

### Different Topics (fail with `refute`)

```elixir
# Unrelated subjects
refute "I love pizza" <~> "Mathematics is difficult"

# Different domains
refute "Quantum physics explores subatomic particles"
       <~> "Renaissance art featured perspective and realism"
```

### Contradictions (fail with `refute`)

```elixir
# Opposite statements
refute "The sky is blue" <~> "The sky is red"

# Conflicting sentiments
refute "I love pizza" <~> "I hate pizza"

# Logical contradictions
refute "It is raining" <~> "The weather is dry"
```

## Next Steps

- Learn about [Configuration](configuration.html) to tune thresholds
- Explore [Advanced Usage](advanced-usage.html) for raw scores and NLI classification
- See [Testing Patterns](testing-patterns.html) for real-world examples
