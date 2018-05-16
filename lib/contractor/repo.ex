defmodule Contractor.Repo do
  @moduledoc """
  Module used to handle out application's Repo
  """
  use Ecto.Repo, otp_app: :contractor

  @doc """
  Initialize our database with the options passed in
  """
  def init(_, opts) do
    {:ok, opts}
  end
end
