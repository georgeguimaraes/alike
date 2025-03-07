# Alike

**Semantic Similarity Testing for Elixir with Language Models**

Alike is an Elixir library that lets you test if two sentences have the same meaning. Instead of using embeddings and cosine similarity, we leverage a local language model to determine semantic similarity by prompting it directly.

## Key Features

- **Direct LLM Comparison**  
  Prompts a language model to compare two sentences and determine if they are semantically similar.

- **Wave Operator (`<~>`)**  
  Write expressive tests with `assert sentence1 <~> sentence2`.

- **Simple Integration with ExUnit**  
  Works seamlessly with your existing test suites.

## Installation

```elixir
def deps do
  [
    {:alike, "~> 0.1.0"}
  ]
end
```

## Usage

Add Alike to your test dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:alike, "~> 0.1.0", only: :test}
  ]
end
```

Then use it in your tests:

```elixir
defmodule YourTest do
  use ExUnit.Case, async: true
  import WaveOperator

  test "semantically similar sentences" do
    # These sentences mean the same thing
    assert "The cat is sleeping" <~> "A feline is taking a nap"
    
    # These sentences have different meanings
    refute "The dog is barking" <~> "The cat is sleeping"
  end
end
```

## How It Works

1. **Tests use `<~>`**  
   The wave operator calls `Alike.alike?/3`, which prompts the language model.
   
2. **Language Model Responds**  
   The LLM returns a JSON object with its assessment:
   ```json
   {alike: true, explanation: "Both sentences describe a sleeping cat."}
   ```
   
3. **Boolean Result**  
   The assertion succeeds or fails based on the `alike` value.

## Model Details

Alike uses [SmolLM2-360M-Instruct](https://huggingface.co/HuggingFaceTB/SmolLM2-360M-Instruct), a small but efficient language model that:

- Is fast enough to run in CI environments
- Runs locally without needing external API calls
- Can accurately determine semantic similarity
- Uses approximately 1.5GB of memory

## Configuration

You can configure the model behavior:

```elixir
# In your config.exs
config :alike,
  timeout: 10_000,         # timeout for model inference
  fallback_mode: true      # use fallback when model fails
```

## Usage in Tests

When you include Alike in your project as a test dependency:

```elixir
{:alike, "~> 0.1.0", only: :test}
```

Alike will automatically start a single instance of the language model when your tests run, making it available for all test cases that use the library. This ensures:

1. The model is ready when your tests need it
2. Only one instance is started, regardless of how many tests use it
3. Resources are efficiently managed

The model automatically starts in test environments without any additional configuration required.

For faster test runs during development, you can skip loading the model:

```bash
# Skip loading the model for faster test runs
mix test --no-start

# Run with the actual model for full integration tests
mix test
```

## How to Speed Up CI Tests

Downloading the model files (~724MB) each time CI runs can significantly slow down your test process. To speed up CI tests, you can cache the Bumblebee model files between runs.

### Caching with GitHub Actions

Here's an example of how to set up caching for Bumblebee models in GitHub Actions:

```yaml
name: Elixir CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Elixir
      uses: erlef/setup-beam@v1
      with:
        elixir-version: '1.18.0'
        otp-version: '26.0'
    
    - name: Cache Bumblebee models
      uses: actions/cache@v3
      with:
        path: ~/.cache/bumblebee
        key: ${{ runner.os }}-bumblebee-smollm2-360m-${{ hashFiles('lib/language_model/model.ex') }}
        restore-keys: |
          ${{ runner.os }}-bumblebee-smollm2-360m-
    
    - name: Install dependencies
      run: mix deps.get
    
    - name: Run tests
      run: mix test
```

The key part is caching the `~/.cache/bumblebee` directory, which is where Bumblebee stores downloaded model files by default. The cache key includes a hash of your model.ex file, so if you change the model, it will download a fresh copy.

### Environment Variables

You can also configure the cache directory location using environment variables:

```bash
# Set a custom cache directory
export BUMBLEBEE_CACHE_DIR=/path/to/cache
```

This is useful for CI environments where you want to specify a particular cache location.

## Requirements

- Elixir ~> 1.18
- EXLA for GPU acceleration (optional but recommended)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see LICENSE for details.

