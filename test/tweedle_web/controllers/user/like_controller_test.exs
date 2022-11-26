defmodule TweedleWeb.User.LikeControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.TweedsSetups, only: [create_tweed: 1, create_like: 1]

  alias Tweedle.TweedsFixtures

  @moduletag :user_like_controller

  setup :authorize_conn
  setup :create_tweed

  describe "POST /likes" do
    setup :create_path
    setup :create_like

    @tag :skip_create_like
    test "200 OK", %{conn: conn, path: path} do
      conn = post(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"user_id" => _, "tweed_id" => _, "inserted_at" => _} = data
    end

    test "200 OK like on second tweed", %{conn: conn, user_id: user_id} do
      %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: user_id})

      path = path_fixture(conn, :create, tweed_id)

      conn = post(conn, path)

      assert %{"data" => _} = json_response(conn, 200)
    end

    test "422 ERROR tweed already liked", %{conn: conn, path: path} do
      assert_error_sent(422, fn ->
        post(conn, path)
      end)
    end
  end

  describe "DELETE /likes" do
    setup :delete_path
    setup :create_like

    test "200 OK", %{conn: conn, path: path} do
      conn = delete(conn, path)

      assert %{"data" => _} = json_response(conn, 200)
    end

    @tag :skip_create_like
    test "404 ERROR when no like", %{conn: conn, path: path} do
      assert_error_sent(404, fn ->
        delete(conn, path)
      end)
    end
  end

  defp create_path(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: path_fixture(conn, :create, tweed_id)}
  end

  defp delete_path(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: path_fixture(conn, :delete, tweed_id)}
  end

  defp path_fixture(conn, action, tweed_id) do
    Routes.user_tweed_like_path(conn, action, tweed_id)
  end
end
