defmodule Contractor.Stage do
@moduledoc """
Module that contains the stages of the application
At the moment the plan is to leverage 3 stages an input, a processing
stage and an output stage
"""



 @doc """
 This function reads this file in an eager way
 iex> Contractor.Stage.consume(:eager, "path")
 %{word => count}
 """
 @spec consume(atom(), String.t) :: map()
  def consume(:eager, path) do
    {:ok, file} = File.read(path) #load file into memory

    #split the file into lines
    map =
      file
      |> String.split("\n") # split file into lines
      |> Enum.flat_map(&String.split/1) # for each item in this list of lines to words
      |> Enum.reduce(%{}, fn word, map ->
         Map.update(map, word, 1, & &1 + 1)
       end)
  end

end
