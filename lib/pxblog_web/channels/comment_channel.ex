defmodule PxblogWeb.CommentChannel do
  use Pxblog.Web, :channel
  alias PxblogWeb.CommentHelper
  alias Pxblog.Repo
  alias Pxblog.User
  alias Pxblog.Comment

  def join("comments:" <> _comment_id, _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comments:lobby).
  def handle_in("CREATED_COMMENT", payload, socket) do
    case CommentHelper.create(payload, socket) do
      {:ok, comment} ->
        broadcast(socket, "CREATED_COMMENT", comment)
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_in("DELETED_COMMENT", payload, socket) do
    case CommentHelper.delete(payload, socket) do
      {:ok, _} ->
        broadcast socket, "DELETED_COMMENT", payload
        {:noreply, socket}
      {:error, _} ->
        {:noreply, socket}
    end
  end

  # Intercept CREATED_COMMENT and check delete permission for every receiver
  intercept ["CREATED_COMMENT"]
  def handle_out("CREATED_COMMENT", payload, socket) do
    comment = Repo.get!(Comment, payload.comment_id) |> Repo.preload(:user)
    user_id = if is_nil(socket.assigns[:user]), do: 0, else: socket.assigns[:user]
    user = Repo.one from u in User, where: u.id == ^user_id, preload: [:role]
    html = Phoenix.View.render_to_string(PxblogWeb.CommentView, "comment.html", comment: comment, user: user)

    push socket, "CREATED_COMMENT", %{ html: html }
    {:noreply, socket}
  end
end
