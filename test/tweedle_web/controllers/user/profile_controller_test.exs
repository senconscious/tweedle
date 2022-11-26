defmodule TweedleWeb.User.ProfileControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.AccountsSetups, only: [create_author: 1, create_follow: 1]

  setup :authorize_conn

  describe "GET /followed_profiles" do
    setup :index_followed_path
    setup :create_author
    setup :create_follow

    @tag :skip_create_author
    @tag :skip_create_follow
    test "200 OK no followed users", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

    test "200 OK follow one user", %{conn: conn, path: path, author_id: author_id} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      refute data == []
      assert [%{"id" => ^author_id, "username" => _} | []] = data
    end
  end

  defp index_followed_path(%{conn: conn}) do
    {:ok, path: Routes.user_profile_path(conn, :index_followed)}
  end
end
