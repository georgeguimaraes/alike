# Simple script to start the chat interface
# Run with: mix run lib/chat_script.exs

# Start the application if not already started
unless Application.started_applications()
       |> Enum.map(fn {app, _, _} -> app end)
       |> Enum.member?(:alike) do
  Application.ensure_all_started(:alike)
end

# Start the chat interface
ChatInterface.start()
