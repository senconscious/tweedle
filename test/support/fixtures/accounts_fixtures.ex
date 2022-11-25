defmodule Tweedle.AccountsFixtures do
  alias Tweedle.Accounts

  def valid_user_attrs do
    %{
      email: "test@mail.com",
      name: "Sample Name",
      password: "password1234",
      username: "sample_username"
    }
  end

  def user_fixture!(attrs \\ %{}) do
    valid_user_attrs()
    |> Map.merge(attrs)
    |> Accounts.create_user!()
  end

  def sign_in_payload(email, password) do
    %{user: %{email: email, password: password}}
  end

  def sign_up_payload(attrs \\ %{}) do
    valid_user_attrs()
    |> Map.merge(attrs)
    |> then(fn attrs ->
      %{user: attrs}
    end)
  end
end
