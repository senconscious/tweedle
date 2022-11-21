defmodule TweedleWeb.User.TweedControllerTest do
  use TweedleWeb.ConnCase

  alias Tweedle.TweedsFixtures

  @moduletag :user_tweed_controller

  setup :authorize_conn

  describe "POST /tweeds" do
    setup :create_tweed_path

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
    setup :update_tweed_path

    test "200 OK", %{conn: conn, path: path} do
      message = "UPDATED MESSAGE"
      attrs = TweedsFixtures.tweed_payload(%{message: message})

      conn = patch(conn, path, attrs)
      assert %{"data" => %{"message" => ^message}} = json_response(conn, 200)
    end

    test "404 ERROR tweed not exists", %{conn: conn, tweed_id: tweed_id} do
      message = "UPDATED MESSAGE"
      attrs = TweedsFixtures.tweed_payload(%{message: message})
      {:ok, path: path} = path_fixture(conn, :update, tweed_id + 1)

      assert_error_sent(404, fn ->
        patch(conn, path, attrs)
      end)
    end
  end

  describe "DELETE /tweeds/:id" do
    setup :create_tweed
    setup :delete_tweed_path

    test "200 OK", %{conn: conn, path: path, tweed_id: tweed_id} do
      conn = delete(conn, path)
      assert %{"data" => %{"id" => ^tweed_id}} = json_response(conn, 200)
    end

    test "404 ERROR tweed not exists", %{conn: conn, tweed_id: tweed_id} do
      {:ok, path: path} = path_fixture(conn, :delete, tweed_id + 1)

      assert_error_sent(404, fn ->
        delete(conn, path)
      end)
    end
  end

  defp create_tweed_path(%{conn: conn}) do
    path_fixture(conn, :create)
  end

  defp update_tweed_path(%{conn: conn, tweed_id: id}) do
    path_fixture(conn, :update, id)
  end

  defp delete_tweed_path(%{conn: conn, tweed_id: id}) do
    path_fixture(conn, :delete, id)
  end

  defp path_fixture(conn, action) do
    {:ok, path: Routes.user_tweed_path(conn, action)}
  end

  defp path_fixture(conn, action, id) do
    {:ok, path: Routes.user_tweed_path(conn, action, id)}
  end

  defp generate_string(length) do
    for _n <- 1..length, reduce: "" do
      acc ->
        "#{acc}a"
    end
  end

  defp create_tweed(%{user_id: author_id}) do
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweed_id: tweed_id}
  end
end
