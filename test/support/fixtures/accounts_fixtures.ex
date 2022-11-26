defmodule Tweedle.AccountsFixtures do
  alias Tweedle.Accounts

  def valid_user_attrs do
    random_key = System.unique_integer([:positive, :monotonic])

    %{
      email: "test_user#{random_key}@mail.com",
      name: "Sample Name #{random_key}",
      password: "passworD1234",
      username: "sample_username_#{random_key}"
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
