defmodule Tweedle.TweedsFixtures do
  alias Tweedle.Tweeds

  def valid_tweed_attrs do
    %{
      message: "Some tweed"
    }
  end

  def valid_reply_attrs do
    %{
      message: "Some reply"
    }
  end

  def tweed_fixture(attrs \\ %{}) do
    valid_tweed_attrs()
    |> Map.merge(attrs)
    |> Tweeds.create_tweed!()
  end

  def reply_fixture(attrs \\ %{}) do
    valid_reply_attrs()
    |> Map.merge(attrs)
    |> Tweeds.create_reply!()
  end

  def tweed_payload(attrs \\ %{}) do
    valid_tweed_attrs()
    |> Map.merge(attrs)
    |> then(fn attrs -> %{tweed: attrs} end)
  end

  def reply_payload(attrs \\ %{}) do
    valid_reply_attrs()
    |> Map.merge(attrs)
    |> then(fn attrs -> %{reply: attrs} end)
  end

  def like_standalone_fixture(attrs \\ %{}) do
    attrs
    |> tweed_fixture()
    |> then(fn %{id: tweed_id, author_id: user_id} ->
      Tweeds.create_like!(tweed_id, user_id)
    end)
  end
end
