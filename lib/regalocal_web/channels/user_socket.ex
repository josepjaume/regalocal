defmodule RegalocalWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", RegalocalWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a business. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :business_id, verified_business_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given business:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.business_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given business:
  #
  #     RegalocalWeb.Endpoint.broadcast("user_socket:#{business.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
