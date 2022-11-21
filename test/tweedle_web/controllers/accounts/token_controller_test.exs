defmodule TweedleWeb.Accounts.TokenControllerTest do
  use TweedleWeb.ConnCase

  alias Tweedle.AccountsFixtures

  @moduletag :accounts_token_controller

  describe "POST /sign_up" do
    @describetag :accounts_token_controller_sign_up

    setup :sign_up_path
    setup :setup_user

    test "200 OK valid attrs", %{conn: conn, path: path} do
      conn = post(conn, path, sign_up_payload())

      assert %{"data" => %{"token" => _}} = json_response(conn, 200)
    end

    @tag :setup_user
    test "422 ERROR email already occupied", %{conn: conn, path: path} do
      assert_error_sent(422, fn ->
        post(conn, path, sign_up_payload(%{username: "second_sample_username"}))
      end)
    end
  end

  describe "POST /sign_in" do
    @describetag :accounts_token_controller_sign_in
    @describetag :setup_user

    setup :sign_in_path
    setup :setup_user

    test "200 OK valid email and password", %{
      conn: conn,
      path: path,
      email: email,
      password: password
    } do
      conn = post(conn, path, sign_in_payload(email, password))

      assert %{"data" => %{"token" => _}} = json_response(conn, 200)
    end

    test "404 ERROR no user with email", %{conn: conn, path: path, password: password} do
      assert_error_sent(404, fn ->
        post(conn, path, sign_in_payload("invalid_email@mail.com", password))
      end)
    end

    test "400 ERROR invalid password", %{conn: conn, path: path, email: email} do
      conn = post(conn, path, sign_in_payload(email, "invalid_password1234"))
      assert %{"errors" => "invalid password"} = json_response(conn, 400)
    end
  end

  describe "POST /sign_out" do
    @describetag :accounts_token_controller_sign_out
    @describetag :setup_user

    setup :sign_out_path
    setup :setup_user
    setup :sign_in

    @tag :authorized
    test "204 OK", %{conn: conn, path: path} do
      conn = post(conn, path)

      assert response(conn, 204)
    end

    test "401 ERROR unauthorized", %{conn: conn, path: path} do
      conn = post(conn, path)

      assert %{"errors" => "unauthenticated"} = json_response(conn, 401)
    end
  end

  defp sign_up_path(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :sign_up)}
  end

  defp sign_in_path(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :sign_in)}
  end

  defp sign_out_path(%{conn: conn}) do
    {:ok, path: path_fixture(conn, :sign_out)}
  end

  defp path_fixture(conn, action) do
    Routes.accounts_token_path(conn, action)
  end

  defp setup_user(%{setup_user: true}) do
    %{email: email} = AccountsFixtures.user_fixture!(%{password: "passworD1234"})
    {:ok, email: email, password: "passworD1234"}
  end

  defp setup_user(_block), do: :ok

  defp sign_in_payload(email, password) do
    %{user: %{email: email, password: password}}
  end

  defp sign_up_payload(attrs \\ %{}) do
    AccountsFixtures.valid_user_attrs()
    |> Map.merge(attrs)
    |> then(fn attrs ->
      %{user: attrs}
    end)
  end
end
