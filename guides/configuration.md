# Configuration

Alike comes with sensible defaults, but you can tune the behavior for your use case.

## Thresholds

Configure thresholds in your `config/config.exs`:

```elixir
config :alike,
  # Minimum similarity score to consider sentences "alike" (0.0 to 1.0)
  # Lower = more permissive, Higher = stricter matching
  similarity_threshold: 0.45,

  # Minimum confidence to flag a contradiction (0.0 to 1.0)
  # Lower = more sensitive to contradictions, Higher = only obvious contradictions
  contradiction_threshold: 0.8
```

### Similarity Threshold

The default `0.45` works well for most cases. Adjust based on your needs:

| Threshold | Use Case |
|-----------|----------|
| 0.3 - 0.4 | Very permissive - matches loosely related sentences |
| 0.45 - 0.55 | Balanced (default) - good for paraphrase detection |
| 0.6 - 0.7 | Strict - requires close semantic match |
| 0.8+ | Very strict - nearly identical meaning required |

### Contradiction Threshold

The default `0.8` only flags high-confidence contradictions:

| Threshold | Behavior |
|-----------|----------|
| 0.5 - 0.7 | Sensitive - may flag some false positives |
| 0.8 - 0.9 | Balanced (default) - reliable contradiction detection |
| 0.95+ | Conservative - only obvious contradictions |

## Per-Call Options

Override settings for individual calls:

```elixir
# Custom similarity threshold
Alike.alike?("Hello", "Hi", threshold: 0.6)

# Disable contradiction checking (faster)
Alike.alike?("Some text", "Other text", check_contradiction: false)

# Custom timeout (milliseconds)
Alike.alike?("Text 1", "Text 2", timeout: 60_000)
```

## Test Environment

For faster CI runs, you may want different settings:

```elixir
# config/test.exs
config :alike,
  similarity_threshold: 0.45,
  contradiction_threshold: 0.8
```

## Caching Models

Models are cached in `~/.cache/bumblebee/`. For CI, cache this directory:

```yaml
# GitHub Actions
- name: Cache Bumblebee models
  uses: actions/cache@v3
  with:
    path: ~/.cache/bumblebee
    key: ${{ runner.os }}-bumblebee-${{ hashFiles('mix.lock') }}
```

This avoids re-downloading ~460MB on every CI run.
