defmodule Chatzilla.User do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(user, socket) do
    Agent.update(__MODULE__, fn(map) ->
      case Map.get(map, user) do
        nil -> Map.put(map, user, MapSet.new([socket]))
        set -> Map.put(map, user, MapSet.put(set, socket))
      end
    end)
  end

  def remove(user, socket) do
    Agent.get_and_update(__MODULE__, fn(map) ->
      case Map.get(map, user) do
        nil -> {nil, map}
        set ->
          if MapSet.size(set) > 1 do
            {
              {MapSet.member?(set, socket), MapSet.size(set)},
              Map.put(map, user, MapSet.delete(set, socket))
            }
          else
            {
              {MapSet.member?(set, socket), MapSet.size(set)},
              Map.delete(map, user)
            }
          end
      end
    end)
  end

  def all do
    Agent.get(__MODULE__, fn(map) ->
      for {k, set} <- map, into: %{}, do: {k, MapSet.to_list(set)}
    end)
  end

  def all_names do
    Agent.get(__MODULE__, &(Enum.sort(Map.keys(&1))))
  end
end
