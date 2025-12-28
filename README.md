# Alike 〰️

[![Run in Livebook](https://livebook.dev/badge/v1/blue.svg)](https://livebook.dev/run?url=https%3A%2F%2Fgithub.com%2Fgeorgeguimaraes%2Falike%2Fblob%2Fmain%2Flivebook%2Falike_tutorial.livemd)

Semantic similarity testing for Elixir.

Alike lets you test if two sentences convey the same meaning using the expressive **wave operator** `<~>`. Perfect for testing LLM outputs, chatbots, NLP pipelines, or any application that generates natural language.

```elixir
assert "The cat is sleeping" <~> "A feline is taking a nap"
```

## Features

- **Wave operator (`<~>`)** - Beautiful, expressive test assertions
- **Semantic understanding** - Detects meaning, not just string matches
- **Contradiction detection** - Catches logical contradictions like "The sky is blue" vs "The sky is red"
- **Local models** - Runs entirely on your machine, no API keys needed
- **Configurable** - Tune thresholds for your use case

## Installation

Add `alike` to your test dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:alike, "~> 0.1.0", only: :test}
  ]
end
```

Then run:

```bash
mix deps.get
```

> **Note:** On first use, Alike downloads the required models (~460MB total). This only happens once and models are cached in `~/.cache/bumblebee/`.

### Setup test_helper.exs

For faster inference, configure Nx to use the EXLA backend in your `test/test_helper.exs`:

```elixir
Nx.global_default_backend(EXLA.Backend)

ExUnit.start()
```

## Quick Start

```elixir
defmodule MyAppTest do
  use ExUnit.Case
  import Alike.WaveOperator

  test "chatbot responds appropriately" do
    response = MyChatbot.greet("Hello!")

    assert response <~> "Hi there! How can I help you today?"
  end

  test "summary captures key points" do
    long_article = """
    Climate change is affecting farming worldwide. Rising temperatures and
    changing precipitation patterns are impacting crop yields and growing seasons...
    """

    summary = MySummarizer.summarize(long_article)

    assert summary <~> "The article discusses climate change impacts on agriculture"
  end
end
```

## Usage

### The Wave Operator

The `<~>` operator is the recommended way to test semantic similarity:

```elixir
import Alike.WaveOperator

# Similar sentences pass
assert "The quick brown fox jumps over the lazy dog"
       <~> "A fast auburn fox leaps over a sleeping canine"

# Different meanings fail
refute "The weather is nice today" <~> "I enjoy reading books"

# Contradictions are detected
refute "The sky is blue" <~> "The sky is red"
```

### Direct Function Calls

For more control, use `Alike.alike?/3` directly:

```elixir
# Basic usage
Alike.alike?("The cat is sleeping", "A feline is taking a nap")
# => true

# Custom similarity threshold
Alike.alike?("Hello world", "Hi there", threshold: 0.6)
# => true or false depending on threshold

# Disable contradiction checking for speed
Alike.alike?("Some text", "Other text", check_contradiction: false)
```

### Raw Similarity Scores

Get the underlying similarity score (0.0 to 1.0):

```elixir
{:ok, score} = Alike.similarity("Hello world", "Hi there")
# => {:ok, 0.623}
```

### NLI Classification

Classify the relationship between sentences:

```elixir
{:ok, result} = Alike.classify("The sky is blue", "The sky is red")
# => {:ok, %{label: "contradiction", score: 0.998}}

{:ok, result} = Alike.classify("The cat is sleeping", "An animal is resting")
# => {:ok, %{label: "entailment", score: 0.892}}
```

**NLI Labels:**
- `"entailment"` - The second sentence logically follows from the first (e.g., "A cat is sleeping" entails "An animal is resting")
- `"contradiction"` - The sentences cannot both be true (e.g., "The sky is blue" contradicts "The sky is red")
- `"neutral"` - The sentences are related but neither entails nor contradicts the other

## Configuration

Customize thresholds in your `config/config.exs`:

```elixir
config :alike,
  # Minimum similarity score to consider sentences "alike" (0.0 to 1.0)
  similarity_threshold: 0.45,

  # Minimum confidence to flag a contradiction (0.0 to 1.0)
  contradiction_threshold: 0.8
```

### Model Configuration

Alike defaults to `all-MiniLM-L6-v2` for a good balance of speed and quality. For maximum accuracy, use L12:

```elixir
config :alike,
  embedding_model: "sentence-transformers/all-MiniLM-L12-v2"
```

| Model | Size | Speed | Quality |
|-------|------|-------|---------|
| `all-MiniLM-L6-v2` (default) | ~90MB | Fast | Good |
| `all-MiniLM-L12-v2` | ~120MB | Slower | Best |

You can also set the model via environment variable (useful for CI):

```bash
ALIKE_EMBEDDING_MODEL=sentence-transformers/all-MiniLM-L12-v2 mix test
```

Any [sentence-transformers](https://huggingface.co/sentence-transformers) model compatible with Bumblebee should work.

## How It Works

Alike uses two models that run locally on your machine, powered by [Bumblebee](https://github.com/elixir-nx/bumblebee) and [Nx](https://github.com/elixir-nx/nx):

1. **Sentence Embeddings** ([all-MiniLM-L6-v2](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) by default) - Converts sentences into 384-dimensional vectors and computes cosine similarity

2. **NLI Model** ([nli-distilroberta-base](https://huggingface.co/cross-encoder/nli-distilroberta-base)) - Detects contradictions that embeddings alone might miss

The combination catches both semantic similarity AND logical contradictions.

## Interactive Tutorial

Click the "Run in Livebook" badge above to try the interactive tutorial, or check the [`livebook`](livebook/) directory.

## Examples

### Testing LLM Outputs

```elixir
test "LLM generates appropriate response" do
  prompt = "Explain photosynthesis in simple terms"
  response = MyLLM.generate(prompt)

  assert response <~> "Plants convert sunlight into energy through a process called photosynthesis"
end
```

### Testing Translations

```elixir
test "translation preserves meaning" do
  original = "The weather is beautiful today"
  translated = MyTranslator.translate(original, to: :spanish) |> MyTranslator.translate(to: :english)

  assert original <~> translated
end
```

### Testing Summarization

```elixir
test "summary captures main idea" do
  article = "Long article about renewable energy..."
  summary = MySummarizer.summarize(article)

  assert summary <~> "The article discusses the benefits and challenges of renewable energy adoption"
end
```

## Speeding Up CI

Cache the Bumblebee models directory to avoid re-downloading on every CI run:

```yaml
# GitHub Actions example
- name: Cache Bumblebee models
  uses: actions/cache@v3
  with:
    path: ~/.cache/bumblebee
    key: ${{ runner.os }}-bumblebee-${{ hashFiles('mix.lock') }}
```

## Requirements

- Elixir 1.18+
- ~460MB disk space for models (downloaded on first use)
- Models are cached in `~/.cache/bumblebee/`

## License

Copyright (c) 2025 George Guimarães

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for details.

