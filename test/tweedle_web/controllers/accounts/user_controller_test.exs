defmodule TweedleWeb.Accounts.UserControllerTest do
  use TweedleWeb.ConnCase

  @moduletag :accounts_user_controller

  setup :authorize_conn

  describe "GET /profile" do
    setup :show_path

    test "200 OK", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"id" => _, "email" => _, "username" => _, "name" => _} = data
    end
  end

  defp show_path(%{conn: conn}) do
    {:ok, path: Routes.accounts_user_path(conn, :show)}
  end
end
