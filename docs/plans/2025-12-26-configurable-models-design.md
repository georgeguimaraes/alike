# Configurable Embedding Models

## Overview

Allow users to configure which embedding model Alike uses via application config.

## Configuration

```elixir
# config/config.exs
config :alike,
  embedding_model: "sentence-transformers/all-MiniLM-L6-v2"
```

Default: `all-MiniLM-L6-v2` (faster, ~90MB)
Alternative: `all-MiniLM-L12-v2` (best quality, ~120MB)

## Implementation

`Alike.Models.Embedding` reads config with env var override for CI:

```elixir
@default_model "sentence-transformers/all-MiniLM-L6-v2"

def model_name do
  System.get_env("ALIKE_EMBEDDING_MODEL") ||
    Application.get_env(:alike, :embedding_model, @default_model)
end
```

## Testing

Tag edge cases requiring L12:

```elixir
@tag :l12_only
test "edge case requiring deeper semantics" do
  # ...
end
```

CI matrix runs both models:
- L6: `mix test --exclude l12_only`
- L12: `mix test` (all tests)

## Affected Files

- `lib/alike/models/embedding.ex` - add `model_name/0`, use dynamic model
- `test/full_test.exs` - tag 2 edge cases with `@tag :l12_only`
- `.github/workflows/test.yml` - add model matrix
- `README.md` - document model configuration
