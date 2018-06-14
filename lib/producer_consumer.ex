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

  @doc """
  This function reads this file lazily
  here instead of loading the whole file into memory then processing them
  we instead consume the file line by line
  - less memory
  - more computationaly expensive
  """
  def consume(:lazy, path) do
    # lets return the file only when we need the file
    # and when we do let take it in line by line
    map =
     File.stream!(path)
      |> Stream.flat_map(&String.split/1) # for each line here we break it into words
      |> Enum.reduce(%{}, fn word, map ->
        Map.update(map, word, 1, & &1 + 1 )
      end)

  end
end
