defmodule Contractor.Auth.Guardian do
  use Guardian, otp_app: :contractor

  # get accounts context to get or create user
  alias Contractor.{Accounts, Accounts.Person}

  # get a field that can Identify a user
  def subject_for_token(person = %Person{}, _claims) do
    {:ok, "User:#{user.id}"}
  end

  # we can't Identify that resource
  def subject_for_token(_, _) do
   {:error, :unknown_resource_type}
  end

  # determine which subject we are Identifying
  def resource_from_claims(%{"sub" => sub}), do: resource_from_subject(sub)
  def resource_from_claims(_), do: {:error, :missing_subject}

  # pic a resource from the provided subject
  defp resource_from_subject("Person:" <> id), do: {:ok, Accounts.get_person(id)}
  defp resource_from_subject(_), do: {:error, :unknown_resource_type}
end
