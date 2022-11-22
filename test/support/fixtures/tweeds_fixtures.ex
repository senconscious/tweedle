defmodule Tweedle.TweedsFixtures do
  alias Tweedle.Tweeds

  def valid_tweed_attrs do
    %{
      message: "Some tweed"
    }
  end

  def tweed_fixture(attrs \\ %{}) do
    valid_tweed_attrs()
    |> Map.merge(attrs)
    |> Tweeds.create_tweed!()
  end

  def tweed_payload(attrs \\ %{}) do
    valid_tweed_attrs()
    |> Map.merge(attrs)
    |> then(fn attrs -> %{tweed: attrs} end)
  end

  def like_standalone_fixture(attrs \\ %{}) do
    attrs
    |> tweed_fixture()
    |> then(fn %{id: tweed_id, author_id: user_id} ->
      Tweeds.create_like!(tweed_id, user_id)
    end)
  end
end
