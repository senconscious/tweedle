defmodule TweedleWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use TweedleWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import TweedleWeb.ConnCase

      alias TweedleWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TweedleWeb.Endpoint

      def sign_in(%{authorized: true, conn: conn, email: email, password: password}) do
        {:ok, token, _claims} = Tweedle.Accounts.sign_in!(email, password)

        {:ok, conn: put_req_header(conn, "authorization", "Bearer #{token}")}
      end

      def sign_in(_), do: :ok

      def sign_out(%{conn: conn}) do
        {:ok, conn: Routes.accounts_token_path(conn, :sign_out)}
      end

      def authorize_conn(%{conn: conn}) do
        %{email: email, password: password} = attrs = Tweedle.AccountsFixtures.valid_user_attrs()

        %{id: user_id} = Tweedle.Accounts.create_user!(attrs)
        {:ok, token, _claims} = Tweedle.Accounts.sign_in!(email, password)

        {:ok, conn: put_req_header(conn, "authorization", "Bearer #{token}"), user_id: user_id}
      end
    end
  end

  setup tags do
    Tweedle.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
