Nx.global_default_backend(EXLA.Backend)

# Optional: Pre-load models once at startup for faster tests
Alike.start()

# Exclude L12-only tests by default (run with: mix test --include l12_only)
ExUnit.configure(exclude: [:l12_only])

ExUnit.start()
