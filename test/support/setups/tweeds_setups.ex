defmodule Tweedle.TweedsSetups do
  @moduledoc """
    Functions for preparing tweeds, likes and replies in test blocks
  """

  alias Tweedle.{AccountsFixtures, Tweeds, TweedsFixtures}

  def create_tweed(%{skip_create_tweed: _}), do: :ok

  def create_tweed(%{user_id: author_id}) do
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweed_id: tweed_id}
  end

  def create_standalone_tweeds(%{skip_create_standalone_tweeds: _}), do: :ok

  def create_standalone_tweeds(_) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    tweeds = for _n <- 1..2, do: TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweeds: tweeds}
  end

  def create_standalone_tweed(%{skip_create_standalone_tweed: _}), do: :ok

  def create_standalone_tweed(_) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})
    {:ok, tweed_id: tweed_id, user_id: author_id}
  end

  def create_author_tweed(%{skip_create_author_tweed: _}), do: :ok

  def create_author_tweed(%{author_id: author_id}) do
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweed_id: tweed_id}
  end

  def create_like(%{skip_create_like: _}), do: :ok

  def create_like(%{tweed_id: tweed_id, user_id: user_id}) do
    Tweeds.create_like!(tweed_id, user_id)
    :ok
  end

  def create_reply(%{skip_create_reply: _}), do: :ok

  def create_reply(%{tweed_id: tweed_id, user_id: user_id}) do
    %{id: reply_id} = TweedsFixtures.reply_fixture(%{parent_id: tweed_id, author_id: user_id})
    {:ok, reply_id: reply_id}
  end
end
