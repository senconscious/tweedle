defmodule Tweedle.AccountsTest do
  use Tweedle.DataCase

  alias Tweedle.Accounts
  alias Ecto.{InvalidChangesetError, NoResultsError}

  @moduletag :accounts

  @valid_attrs %{
    email: "test@mail.com",
    name: "Sample Name",
    password: "password1234",
    username: "sample_username"
  }

  describe "create_user!/1" do
    test "OK when valid attrs" do
      assert Accounts.create_user!(@valid_attrs)
    end

    test "raise when missing password" do
      assert_raise(InvalidChangesetError, fn ->
        user_fixture!(%{password: nil})
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

  describe "update_user!/1" do
    setup :create_user

    test "OK when valid attrs", %{user: user} do
      assert %{username: "updated_username"} =
               Accounts.update_user!(user, %{username: "updated_username"})
    end

    test "raise when duplicate email", %{user: %{email: email}} do
      user = user_fixture!(%{email: "second@mail.com", username: "second_username"})

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
      user = user_fixture!()

      assert [^user] = Accounts.list_users()
    end
  end

  defp user_fixture!(attrs \\ %{}) do
    @valid_attrs
    |> Map.merge(attrs)
    |> Accounts.create_user!()
  end

  defp create_user(_) do
    {:ok, user: user_fixture!()}
  end
end
