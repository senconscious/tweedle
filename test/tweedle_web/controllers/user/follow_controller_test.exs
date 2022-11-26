defmodule TweedleWeb.User.FollowControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.AccountsSetups, only: [create_author: 1, create_follow: 1]

  alias Tweedle.AccountsFixtures

  @moduletag :user_follow_controller

  setup :authorize_conn
  setup :create_author

  describe "POST /follows" do
    setup :create_path
    setup :create_follow

    @tag :skip_create_follow
    test "200 OK", %{conn: conn, path: path} do
      conn = post(conn, path)
      assert %{"data" => data} = json_response(conn, 200)
      assert %{"author_id" => _, "follower_id" => _} = data
    end

    test "200 OK follow second person", %{conn: conn} do
      %{id: author_id} = AccountsFixtures.user_fixture!()
      path = path_fixture(conn, :create, author_id)

      conn = post(conn, path)
      assert %{"data" => _} = json_response(conn, 200)
    end

    @tag :skip_create_follow
    test "422 ERROR can't follow myself", %{conn: conn, user_id: author_id} do
      path = path_fixture(conn, :create, author_id)

      assert_error_sent(422, fn ->
        post(conn, path)
      end)
    end

    test "422 ERROR follow twice same person", %{conn: conn, path: path} do
      assert_error_sent(422, fn ->
        post(conn, path)
      end)
    end
  end

  describe "DELETE /follows" do
    setup :delete_path
    setup :create_follow

    test "200 OK", %{conn: conn, path: path} do
      conn = delete(conn, path)
      assert %{"data" => %{"author_id" => _, "follower_id" => _}} = json_response(conn, 200)
    end

    @tag :skip_create_follow
    test "404 ERROR not followed author", %{conn: conn, path: path} do
      assert_error_sent(404, fn ->
        delete(conn, path)
      end)
    end
  end

  defp create_path(%{conn: conn, author_id: author_id}) do
    {:ok, path: path_fixture(conn, :create, author_id)}
  end

  defp delete_path(%{conn: conn, author_id: author_id}) do
    {:ok, path: path_fixture(conn, :delete, author_id)}
  end

  defp path_fixture(conn, action, profile_id) do
    Routes.user_follow_path(conn, action, profile_id)
  end
end
