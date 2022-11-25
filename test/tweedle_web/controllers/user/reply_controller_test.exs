defmodule TweedleWeb.User.ReplyControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.TweedsSetups, only: [create_tweed: 1, create_reply: 1]

  alias Tweedle.TweedsFixtures

  @moduletag :user_tweed_controller

  setup :authorize_conn
  setup :create_tweed

  describe "POST /replies" do
    setup :create_path

    test "200 OK", %{conn: conn, path: path, tweed_id: tweed_id, user_id: author_id} do
      attrs = TweedsFixtures.reply_payload()

      conn = post(conn, path, attrs)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"parent_id" => ^tweed_id, "message" => _, "author_id" => ^author_id} = data
    end
  end

  describe "PATCH /replies/:id" do
    setup :create_reply
    setup :update_path

    test "200 OK", %{conn: conn, path: path} do
      message = "UPDATED_REPLY"
      attrs = TweedsFixtures.reply_payload(%{message: message})

      conn = patch(conn, path, attrs)

      assert %{"data" => %{"message" => ^message}} = json_response(conn, 200)
    end
  end

  describe "DELETE /replies/:id" do
    setup :create_reply
    setup :delete_path

    test "200 OK", %{conn: conn, path: path} do
      conn = delete(conn, path)

      assert %{"data" => %{"id" => _, "parent_id" => _}} = json_response(conn, 200)
    end
  end

  defp create_path(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: Routes.user_tweed_reply_path(conn, :create, tweed_id)}
  end

  defp update_path(%{conn: conn, reply_id: reply_id}) do
    {:ok, path: path_fixture(conn, :update, reply_id)}
  end

  defp delete_path(%{conn: conn, reply_id: reply_id}) do
    {:ok, path: path_fixture(conn, :delete, reply_id)}
  end

  defp path_fixture(conn, action, id) do
    Routes.user_reply_path(conn, action, id)
  end
end
