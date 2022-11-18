defmodule TweedleWeb.Helpers.ExceptionHelper do
  defimpl Plug.Exception, for: Ecto.InvalidChangesetError do
    def status(_exception), do: 422

    def actions(_exception), do: []
  end
end
