defmodule Contractor.AuthenticationTestHelpers do
  use Phoenix.ConnTest
  import Contractor.Factory

  #when given a connection to authenticate create a user call auth witht user and conn
  def authenticate(conn) do
    user = insert(:person)
    conn
    |> authenticate(user)
  end

  def authenticate(conn, user) do
    # get the token for the user
    {:ok, token, _} = user |> Contractor.Auth.Guardian.encode_and_sign()

    # add the users token to the request header
    conn
    |> put_req_header("authorization", "Bearer #{token}")
  end
end
