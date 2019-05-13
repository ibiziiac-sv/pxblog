defmodule PxblogWeb.Helpers.AuthorizationHelpers do
  import Plug.Conn

  def handle_unauthorized(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "You are not authorized to access this resource!")
    |> Phoenix.Controller.redirect(to: "/")
    |> halt
  end

  def handle_not_found(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Resource not found!")
    |> Phoenix.Controller.redirect(to: "/")
    |> halt
  end
end
