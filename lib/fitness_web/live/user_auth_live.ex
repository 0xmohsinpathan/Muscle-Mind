defmodule FitnessWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Fitness.Accounts

  def on_mount(:user, _params, %{"user_token" => user_token} = _session, socket) do

    socket =
      socket
      |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
    if Accounts.is_admin?(socket.assigns.current_user) do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/")}
    end
  end
end
