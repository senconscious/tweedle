defmodule TweedleWeb.ProfileControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.AccountsSetups, only: [create_user: 1]

  @moduletag :profile_controller

  describe "GET /profiles" do
    setup :create_user
    setup :index_path

    @tag :skip_create_user
    test "200 OK no users", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

    test "200 OK", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      refute data == []
      assert [%{"id" => _, "username" => _, "name" => _, "inserted_at" => _} | []] = data
    end
  end

  describe "GET /profiles/:id" do
    setup :create_user
    setup :show_path

    test "200 OK", %{conn: conn, path: path} do
      conn = get(conn, path)
      assert %{"data" => data} = json_response(conn, 200)
      assert %{"id" => _, "username" => _, "name" => _, "inserted_at" => _} = data
    end

    test "404 ERROR user not exist", %{conn: conn, user_id: user_id} do
      path = path_fixture(conn, :show, user_id + 1)

      assert_error_sent(404, fn ->
        get(conn, path)
      end)
    end
  end

  def index_path(%{conn: conn}) do
    {:ok, path: Routes.profile_path(conn, :index)}
  end

  def show_path(%{conn: conn, user_id: user_id}) do
    {:ok, path: path_fixture(conn, :show, user_id)}
  end

  defp path_fixture(conn, action, id) do
    Routes.profile_path(conn, action, id)
  end
end
