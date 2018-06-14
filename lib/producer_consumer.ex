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


  @doc """
  This function reads this file concurrently
  here instead of reading the file line by line and counting
  We are using different processes and hence different cores to process stages of
  our computation concurrently
  """
  def consume(:flow, path) do
    map =
      #get a stream of a file line by line
      File.stream!(path)
      |> Flow.from_enumerable() # lets make a flow from a stream :producer genStage
      |> Flow.flat_map(&String.split/1) # start a bunch of other stages to do the work
      |> Flow.partition() # this sets up a new group of workers to process data that may coflict
      |> Flow.reduce(fn -> %{} end, fn word, map ->
        Map.update(map, word, 1, & &1 + 1)
      end)
   end


   # Using GenStages
   # lets build a producer that emits counts
   defmodule InputStage do
     @moduledoc """
     This module is a Producer in our GenStage Pipeline
     """
     use GenStage
     # init our process with some state
     @spec init(integer()) :: {atom(), integer()}
     def init(counter) do
       {:producer, counter}
     end

     @doc """
     Handle demand functions are called everytime a consumer that
     is subscribed to this producer asks for an event/thing the
     name matters if you are doing event sourcing
     """
     @spec handle_demand(integer(), integer()) :: {atom(), list(), integer()}
     def handle_demand(demand, counter) when demand > 0 do
       events = Enum.to_list(counter..counter+demand-1)
       {:noreply, events, counter + demand}
     end
   end

   defmodule OutputStage do
     @moduledoc """
     This module is a Consumer for events from out producer Stage
     """
     @spec init(atom()) :: {atom(), any()}
     def init(:ok) do
       {:consumer, :the_state_doesnt_matter}
     end

     @doc """
     Invoked when producers send events
     """
     @spec handle_events(list(), pid(), integer()) :: {atom(), list(), integer()}
     def handle_events(events, _from, state) do
       Process.sleep(1000) # do work here
       IO.inspect(events)
       {:noreply, [], state}
     end
   end


end
