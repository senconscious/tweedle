defmodule TweedleWeb.TweedControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.TweedsSetups

  alias Tweedle.{AccountsFixtures, TweedsFixtures}

  @moduletag :tweed_controller

  describe "GET /tweeds" do
    setup :index_path
    setup :create_standalone_tweeds

    @tag :skip_create_standalone_tweeds
    test "200 OK no data", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

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

    @tag :skip_create_standalone_tweeds
    test "200 OK one tweed with 1 like", %{conn: conn, path: path} do
      %{id: author_id} = AccountsFixtures.user_fixture!()
      TweedsFixtures.like_standalone_fixture(%{author_id: author_id})

      conn = get(conn, path)

      assert %{"data" => [data | []]} = json_response(conn, 200)

      assert %{"likes" => 1} = data
    end
  end

  describe "GET /tweeds/:id (likes)" do
    setup :create_standalone_tweed
    setup :create_like
    setup :show_path

    @tag :skip_create_like
    test "200 OK tweed with no likes", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => %{"likes" => 0}} = json_response(conn, 200)
    end

    test "200 OK tweed with 1 like", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => %{"likes" => 1}} = json_response(conn, 200)
    end
  end

  describe "GET /tweeds/:id (replies)" do
    setup :create_standalone_tweed
    setup :create_reply
    setup :show_path

    @tag :skip_create_reply
    test "200 OK tweed with no replies", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => %{"replies" => []}} = json_response(conn, 200)
    end

    test "200 OK tweed with 1 reply", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => %{"replies" => replies}} = json_response(conn, 200)
      refute replies == []
    end
  end

  defp index_path(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :index)}
  end

  defp show_path(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: path_fixture(conn, :show, tweed_id)}
  end

  defp path_fixture(conn, action) do
    Routes.tweed_path(conn, action)
  end

  defp path_fixture(conn, action, tweed_id) do
    Routes.tweed_path(conn, action, tweed_id)
  end
end
