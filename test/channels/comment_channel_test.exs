defmodule PxblogWeb.CommentChannelTest do
  use PxblogWeb.ChannelCase

  alias PxblogWeb.UserSocket
  alias PxblogWeb.CommentChannel
  import Pxblog.Factory

  setup do
    user    = insert(:user)
    post    = insert(:post, user: user)
    comment = insert(:comment, post: post, user: user)

    {:ok, _, socket} =
      socket(UserSocket, "user_id", %{user: user.id})
      |> subscribe_and_join(CommentChannel, "comments:#{post.id}")

    {:ok, socket: socket, post: post, comment: comment}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "CREATED_COMMENT broadcasts to comments:*", %{socket: socket, post: post} do
    push socket,
         "CREATED_COMMENT",
         %{"body" => "Test Post", "author" => "Test Author", "postId" => post.id}
    expected = %{"body" => "Test Post", "author" => "Test Author"}
    assert_broadcast "CREATED_COMMENT", expected
  end

  test "DELETED_COMMENT broadcasts to comments:*",
       %{socket: socket, post: post, comment: comment} do
    payload = %{"commentId" => comment.id, "postId" => post.id}
    push socket, "DELETED_COMMENT", payload
    assert_broadcast "DELETED_COMMENT", payload
  end
end
