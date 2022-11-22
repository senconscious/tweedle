defmodule TweedleWeb.User.LikeControllerTest do
  use TweedleWeb.ConnCase

  alias Tweedle.{Tweeds, TweedsFixtures}

  @moduletag :user_like_controller
  @moduletag :create_tweed

  setup :authorize_conn
  setup :create_tweed

  describe "POST /likes" do
    setup :create_path_fixture
    setup :create_like

    test "200 OK", %{conn: conn, path: path} do
      conn = post(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert %{"user_id" => _, "tweed_id" => _, "inserted_at" => _} = data
    end

    @tag :create_like
    test "200 OK like on second tweed", %{conn: conn, user_id: user_id} do
      %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: user_id})

      path = path_fixture(conn, :create, tweed_id)

      conn = post(conn, path)

      assert %{"data" => _} = json_response(conn, 200)
    end

    @tag :create_like
    test "422 ERROR tweed already liked", %{conn: conn, path: path} do
      assert_error_sent(422, fn ->
        post(conn, path)
      end)
    end
  end

  describe "DELETE /likes" do
    setup :delete_path_fixture
    setup :create_like

    @tag :create_like
    test "200 OK", %{conn: conn, path: path} do
      conn = delete(conn, path)

      assert %{"data" => _} = json_response(conn, 200)
    end

    test "404 ERROR when no like", %{conn: conn, path: path} do
      assert_error_sent(404, fn ->
        delete(conn, path)
      end)
    end
  end

  describe "GET /likes" do
    setup :index_path_fixture
    setup :create_like

    test "200 OK no liked tweeds", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

    @tag :create_like
    test "200 OK two liked tweeds", %{conn: conn, path: path, user_id: user_id} do
      TweedsFixtures.like_standalone_fixture(%{author_id: user_id})

      conn = get(conn, path)

      assert %{"data" => data} = json_response(conn, 200)
      assert Enum.count(data) == 2

      Enum.each(data, fn element ->
        assert %{"inserted_at" => _, "tweed" => _} = element
      end)
    end
  end

  defp create_path_fixture(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: path_fixture(conn, :create, tweed_id)}
  end

  defp delete_path_fixture(%{conn: conn, tweed_id: tweed_id}) do
    {:ok, path: path_fixture(conn, :delete, tweed_id)}
  end

  defp index_path_fixture(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :index)}
  end

  defp path_fixture(conn, action, tweed_id) do
    Routes.user_tweed_like_path(conn, action, tweed_id)
  end

  defp path_fixture(conn, action) do
    Routes.user_like_path(conn, action)
  end

  defp create_tweed(%{create_tweed: true, user_id: author_id}) do
    %{id: tweed_id} = TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweed_id: tweed_id}
  end

  defp create_tweed(_), do: :ok

  defp create_like(%{create_like: true, tweed_id: tweed_id, user_id: user_id}) do
    Tweeds.create_like!(tweed_id, user_id)
    :ok
  end

  defp create_like(_), do: :ok
end
