defmodule Contractor.Auth.BearerAuth do
  use Guardian.Plug.Pipeline,
  otp_app: :spender,
  error_handler: Contractor.Auth.ErrorHandler,
  module: Contractor.Auth.Guardian

  # If there is a session token, validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, validate it
  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  # Load the user if either of the verifications worked allow_blank so that Guardian doesnt throw an error when no user
  plug Guardian.Plug.LoadResource, allow_blank: true
end
