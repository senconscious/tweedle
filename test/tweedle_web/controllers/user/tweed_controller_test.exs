defmodule TweedleWeb.User.TweedControllerTest do
  use TweedleWeb.ConnCase

  import Tweedle.TweedsSetups, only: [create_tweed: 1]

  alias Tweedle.TweedsFixtures

  @moduletag :user_tweed_controller

  setup :authorize_conn

  describe "POST /tweeds" do
    setup :create_path

    test "200 OK valid attrs", %{conn: conn, path: path} do
      attrs = TweedsFixtures.tweed_payload()

      conn = post(conn, path, attrs)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"author_id" => _, "message" => _, "inserted_at" => _, "updated_at" => _} = data
    end

    test "422 ERROR no message in attrs", %{conn: conn, path: path} do
      attrs = %{tweed: %{}}

      assert_error_sent(422, fn ->
        post(conn, path, attrs)
      end)
    end

    test "422 ERROR message is too long", %{conn: conn, path: path} do
      attrs = TweedsFixtures.tweed_payload(%{message: generate_string(257)})

      assert_error_sent(422, fn ->
        post(conn, path, attrs)
      end)
    end
  end

  describe "PATCH /tweeds/:id" do
    setup :create_tweed
    setup :update_path

    test "200 OK", %{conn: conn, path: path} do
      message = "UPDATED MESSAGE"
      attrs = TweedsFixtures.tweed_payload(%{message: message})

      conn = patch(conn, path, attrs)
      assert %{"data" => %{"message" => ^message}} = json_response(conn, 200)
    end

    test "404 ERROR tweed not exists", %{conn: conn, tweed_id: tweed_id} do
      message = "UPDATED MESSAGE"
      attrs = TweedsFixtures.tweed_payload(%{message: message})
      path = path_fixture(conn, :update, tweed_id + 1)

      assert_error_sent(404, fn ->
        patch(conn, path, attrs)
      end)
    end
  end

  describe "DELETE /tweeds/:id" do
    setup :create_tweed
    setup :delete_path

    test "200 OK", %{conn: conn, path: path, tweed_id: tweed_id} do
      conn = delete(conn, path)
      assert %{"data" => %{"id" => ^tweed_id}} = json_response(conn, 200)
    end

    test "404 ERROR tweed not exists", %{conn: conn, tweed_id: tweed_id} do
      path = path_fixture(conn, :delete, tweed_id + 1)

      assert_error_sent(404, fn ->
        delete(conn, path)
      end)
    end
  end

  defp create_path(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :create)}
  end

  defp update_path(%{conn: conn, tweed_id: id}) do
    {:ok, path: path_fixture(conn, :update, id)}
  end

  defp delete_path(%{conn: conn, tweed_id: id}) do
    {:ok, path: path_fixture(conn, :delete, id)}
  end

  defp path_fixture(conn, action) do
    Routes.user_tweed_path(conn, action)
  end

  defp path_fixture(conn, action, id) do
    Routes.user_tweed_path(conn, action, id)
  end

  defp generate_string(length) do
    for _n <- 1..length, reduce: "" do
      acc ->
        "#{acc}a"
    end
  end
end
