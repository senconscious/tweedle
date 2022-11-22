defmodule TweedleWeb.TweedControllerTest do
  use TweedleWeb.ConnCase

  alias Tweedle.{AccountsFixtures, Tweeds, TweedsFixtures}

  @moduletag :tweed_controller

  describe "GET /tweeds" do
    setup :index_tweeds_path
    setup :create_tweeds

    test "200 OK no data", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

    @tag :create_tweeds
    test "200 OK", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert Enum.count(data) == 2

      Enum.each(data, fn element ->
        assert %{
                 "likes" => 0,
                 "author_id" => _,
                 "message" => _,
                 "inserted_at" => _,
                 "updated_at" => _
               } = element
      end)
    end

    test "200 OK one tweed with 1 like", %{conn: conn, path: path} do
      %{id: author_id} = AccountsFixtures.user_fixture!()
      TweedsFixtures.like_standalone_fixture(%{author_id: author_id})

      conn = get(conn, path)

      assert %{"data" => [data | []]} = json_response(conn, 200)

      assert %{"likes" => 1} = data
    end
  end

  describe "GET /tweed/:id" do
    setup :create_tweed
    setup :create_like
    setup :show_tweed_path

    test "200 OK tweed with no likes", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"likes" => 0} = data
    end

    @tag :create_like
    test "200 OK tweed with 1 like", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"likes" => 1} = data
    end
  end

  defp index_tweeds_path(%{conn: conn}) do
    path_fixture(conn, :index)
  end

  defp show_tweed_path(%{conn: conn, tweed_id: tweed_id}) do
    path_fixture(conn, :show, tweed_id)
  end

  defp path_fixture(conn, action) do
    {:ok, path: Routes.tweed_path(conn, action)}
  end

  defp path_fixture(conn, action, tweed_id) do
    {:ok, path: Routes.tweed_path(conn, action, tweed_id)}
  end

  defp create_tweeds(%{create_tweeds: true}) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    tweeds = for _n <- 1..2, do: TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweeds: tweeds}
  end

  defp create_tweeds(_), do: :ok

  defp create_tweed(_) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})
    {:ok, tweed_id: tweed_id, user_id: author_id}
  end

  defp create_like(%{create_like: true, tweed_id: tweed_id, user_id: user_id}) do
    Tweeds.create_like!(tweed_id, user_id)
    :ok
  end

  defp create_like(_), do: :ok
end
