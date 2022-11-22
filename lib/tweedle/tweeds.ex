defmodule Tweedle.Tweeds do
  @moduledoc """
    Tweeds context
  """

  import Ecto.Query

  alias EctoJuno.Query.Sorting
  alias Tweedle.Repo
  alias Tweedle.Tweeds.{Like, Tweed}

  def create_tweed!(author_id, params) do
    params
    |> Map.put("author_id", author_id)
    |> create_tweed!()
  end

  def create_tweed!(params) do
    %Tweed{}
    |> Tweed.changeset(params)
    |> Repo.insert!()
  end

  def list_tweeds do
    query = subquery(tweed_likes_query())

    Tweed
    |> join(:inner, [t], tl in subquery(query), on: t.id == tl.tweed_id)
    |> Sorting.sort_query(Tweed, %{sort_direction: "desc"})
    |> select([t, tl], %{t | likes: tl.like_count})
    |> Repo.all()
  end

  def get_tweed!(id) do
    query = subquery(tweed_likes_query())

    Tweed
    |> where([t], t.id == ^id)
    |> join(:inner, [t], tl in subquery(query), on: t.id == tl.tweed_id)
    |> select([t, tl], %{t | likes: tl.like_count})
    |> Repo.one!()
  end

  def update_tweed!(%Tweed{} = tweed, params) do
    tweed
    |> Tweed.update_changeset(params)
    |> Repo.update!()
  end

  def update_tweed!(id, params) do
    id
    |> get_tweed!()
    |> update_tweed!(params)
  end

  def delete_tweed!(%Tweed{} = tweed), do: Repo.delete!(tweed)

  def delete_tweed!(id) do
    id
    |> get_tweed!()
    |> delete_tweed!()
  end

  defp tweed_likes_query do
    Tweed
    |> join(:left, [t], l in assoc(t, :likes))
    |> group_by([t], t.id)
    |> select([t, l], %{tweed_id: t.id, like_count: count(l.inserted_at)})
  end

  def list_likes(user_id) do
    Like
    |> where([l], l.user_id == ^user_id)
    |> preload([:tweed])
    |> Sorting.sort_query(Like, %{sort_direction: "desc"})
    |> Repo.all()
  end

  def get_like!(tweed_id, user_id), do: Repo.get_by!(Like, tweed_id: tweed_id, user_id: user_id)

  def create_like!(tweed_id, user_id) do
    %Like{}
    |> Like.changeset(%{tweed_id: tweed_id, user_id: user_id})
    |> Repo.insert!()
  end

  def delete_like!(tweed_id, user_id) do
    tweed_id
    |> get_like!(user_id)
    |> Repo.delete!()
  end
end
