defmodule TweedleWeb.TweedControllerTest do
  use TweedleWeb.ConnCase

  alias Tweedle.{AccountsFixtures, TweedsFixtures}

  @moduletag :tweed_controller

  describe "GET /tweeds" do
    setup :index_tweeds_path
    setup :create_tweeds

    test "200 OK no data", %{conn: conn, path: path} do
      conn = get(conn, path)

      assert %{"data" => []} = json_response(conn, 200)
    end

    @tag :create_tweeds
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

    test "200 OK one tweed with 1 like", %{conn: conn, path: path} do
      %{id: author_id} = AccountsFixtures.user_fixture!()
      TweedsFixtures.like_standalone_fixture(%{author_id: author_id})

      conn = get(conn, path)

      assert %{"data" => [data | []]} = json_response(conn, 200)

      assert %{"likes" => 1} = data
    end
  end

  defp index_tweeds_path(%{conn: conn}) do
    path_fixture(conn, :index)
  end

  defp path_fixture(conn, action) do
    {:ok, path: Routes.tweed_path(conn, action)}
  end

  defp create_tweeds(%{create_tweeds: true}) do
    %{id: author_id} = AccountsFixtures.user_fixture!()
    tweeds = for _n <- 1..2, do: TweedsFixtures.tweed_fixture(%{author_id: author_id})

    {:ok, tweeds: tweeds}
  end

  defp create_tweeds(_), do: :ok
end
