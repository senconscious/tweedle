defmodule TweedleWeb.Helpers.ExceptionHelper do
  @moduledoc """
    Implementations of `Plug.Exception` for different errors.

    Needed to override status code when error is raised
  """
  defimpl Plug.Exception, for: Ecto.InvalidChangesetError do
    def status(_exception), do: 422

    def actions(_exception), do: []
  end
end
