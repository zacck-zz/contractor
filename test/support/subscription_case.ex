 defmodule ContractorWeb.SubscriptionCase do
  @moduledoc """
  Build a test case for testing Absinthe Subscriptions
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use ContractorWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest,
        schema: ContractorWeb.Schema

      import Contractor.Factory

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(ContractorWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
