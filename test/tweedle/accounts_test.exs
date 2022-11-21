defmodule Tweedle.AccountsTest do
  use Tweedle.DataCase

  alias Ecto.{InvalidChangesetError, NoResultsError}
  alias Tweedle.Accounts
  alias Tweedle.AccountsFixtures

  @moduletag :accounts

  describe "create_user!/1" do
    test "OK when valid attrs" do
      assert Accounts.create_user!(AccountsFixtures.valid_user_attrs())
    end

    test "raise when missing password" do
      assert_raise(InvalidChangesetError, fn ->
        AccountsFixtures.user_fixture!(%{password: nil})
      end)
    end
  end

  describe "get_user!/1" do
    setup :create_user

    test "ok when user exists", %{user: %{id: user_id}} do
      assert Accounts.get_user!(user_id)
    end

    test "raise when user doesn't exist", %{user: %{id: user_id}} do
      assert_raise(NoResultsError, fn ->
        Accounts.get_user!(user_id + 1)
      end)
    end
  end

  describe "get_user/1" do
    setup :create_user

    test "ok when user exists", %{user: %{id: user_id}} do
      assert Accounts.get_user(user_id)
    end

    test "raise when user doesn't exist", %{user: %{id: user_id}} do
      refute Accounts.get_user(user_id + 1)
    end
  end

  describe "update_user!/1" do
    setup :create_user

    test "OK when valid attrs", %{user: user} do
      assert %{username: "updated_username"} =
               Accounts.update_user!(user, %{username: "updated_username"})
    end

    test "raise when duplicate email", %{user: %{email: email}} do
      user =
        AccountsFixtures.user_fixture!(%{email: "second@mail.com", username: "second_username"})

      assert_raise(InvalidChangesetError, fn ->
        Accounts.update_user!(user, %{email: email})
      end)
    end
  end

  describe "delete_user!/1" do
    setup :create_user

    test "OK", %{user: %{id: user_id} = user} do
      Accounts.delete_user!(user)

      assert_raise(NoResultsError, fn -> Accounts.get_user!(user_id) end)
    end
  end

  describe "list_users/0" do
    test "OK empty data" do
      assert [] = Accounts.list_users()
    end

    test "OK one record" do
      user = AccountsFixtures.user_fixture!()

      assert [^user] = Accounts.list_users()
    end
  end

  describe "sign_up!/1" do
    test "OK valid attrs" do
      assert {:ok, _token, _claims} = Accounts.sign_up!(AccountsFixtures.valid_user_attrs())
    end

    test "raise not valid attrs" do
      assert_raise(InvalidChangesetError, fn -> Accounts.sign_up!(%{}) end)
    end
  end

  describe "sign_in!/2" do
    setup :create_user

    test "OK success", %{user: %{email: email}} do
      %{password: password} = AccountsFixtures.valid_user_attrs()
      assert {:ok, _token, _claims} = Accounts.sign_in!(email, password)
    end

    test "Error not valid password", %{user: %{email: email}} do
      assert {:error, "invalid password"} = Accounts.sign_in!(email, "not_valid_password")
    end

    test "raise user not found" do
      assert_raise(NoResultsError, fn ->
        Accounts.sign_in!("not_existing@mail.com", "some random password")
      end)
    end
  end

  describe "sign_out/1" do
    setup :create_user
    setup :sign_in_user

    test "OK", %{token: token} do
      assert {:ok, _claims} = Accounts.sign_out(token)
    end

    test "error invalid token" do
      assert {:error, :not_found} = Accounts.sign_out("some invalid token")
    end
  end

  defp create_user(_) do
    {:ok, user: AccountsFixtures.user_fixture!()}
  end

  defp sign_in_user(%{user: %{email: email}}) do
    %{password: password} = AccountsFixtures.valid_user_attrs()
    {:ok, token, _claims} = Accounts.sign_in!(email, password)
    {:ok, token: token}
  end
end
