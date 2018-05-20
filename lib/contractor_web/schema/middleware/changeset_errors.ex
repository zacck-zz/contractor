defmodule ContractorWeb.Schema.Middleware.ChangesetErrors do
  @behaviour Absinthe.Middleware

  def call(res, _) do
    %{res |
      errors: Enum.flat_map(res.errors, &transform_error/1)
    }
  end

  defp transform_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts}-> err end)
    |> Enum.map(fn({item, error}) -> "#{item}: #{error}" end)
  end

  #handle other kinds of errors
  defp transform_error(error), do: [error]
end
