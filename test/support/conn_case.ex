defmodule ContractorWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  use Phoenix.ConnTest
  import Contractor.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      alias Contractor.Repo
      use Phoenix.ConnTest
      import ContractorWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint ContractorWeb.Endpoint
      import Contractor.Factory
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Contractor.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Contractor.Repo, {:shared, self()})
    end

    {conn, current_user} = cond do
      tags[:authenticated] ->
        build_conn()
        |> add_authentication_headers(tags[:authenticated])
      true ->
        conn = build_conn()
        {conn, nil}
    end

    {:ok, conn: conn, current_user: current_user}
  end

  defp add_authentication_headers(conn, true) do
    user = insert(:person)

    conn = conn |> Contractor.AuthenticationTestHelpers.authenticate(user)
    {conn, user}
  end

end
