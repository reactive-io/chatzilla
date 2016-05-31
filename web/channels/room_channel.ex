defmodule Chatzilla.RoomChannel do
  use Phoenix.Channel

  intercept ["message:new"]

  def join("rooms:lobby", _message, socket) do
    send self, {:user, :join, socket.assigns.user_id}

    {:ok, socket}
  end
  def join("rooms:" <> _room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:user, :join, user_id}, socket) do
    Chatzilla.User.add(user_id, socket)

    broadcast socket, "user:join", %{user: user_id, user_list: Chatzilla.User.all_names}

    {:noreply, socket}
  end

  def handle_in("message:submit", payload, socket) do
    user_id = socket.assigns.user_id
    message = Map.put(payload, "name", user_id)

    broadcast socket, "message:new", message

    {:reply, {:ok, message}, socket}
  end

  def handle_out(event = "message:new", payload, socket) do
    push socket, event, payload

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    user_id = socket.assigns.user_id

    Chatzilla.User.remove(user_id, socket)

    broadcast socket, "user:leave", %{user: user_id, user_list: Chatzilla.User.all_names}
    :ok
  end
end
