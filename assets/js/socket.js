// Import the socket library
import {Socket} from 'phoenix'

// Grab the user's token and id from the meta tags
const userToken = $('meta[name="channel_token"]').attr('content')
// And make sure we're connecting with the user's token to persist the user id to the session
const socket = new Socket('/socket', {params: {token: userToken}})
// And connect out
socket.connect()

// Our actions to listen for
const CREATED_COMMENT  = 'CREATED_COMMENT'
const DELETED_COMMENT  = 'DELETED_COMMENT'

// Grab the current post's id from a hidden input on the page
const postId = $('#post-id').val()
const channel = socket.channel(`comments:${postId}`, {})
channel.join()
  .receive('ok', resp => { console.log('Joined successfully', resp) })
  .receive('error', resp => { console.log('Unable to join', resp) })

// Provide the comment's body from the form
const getCommentBody     = () => $('#comment_body').val()
// Based on something being clicked, find the parent comment id
const getTargetCommentId = (target) => $(target).parents('.comment').data('comment-id')
// Reset the input fields to blank
const resetFields = () => {
  $('#comment_body').val('')
}

// Push the CREATED_COMMENT event to the socket with the appropriate author/body
$('.create-comment').on('click', (event) => {
  event.preventDefault()
  channel.push(CREATED_COMMENT, { body: getCommentBody(), postId })
  resetFields()
})

// Push the DELETED_COMMENT event to the socket but only pass the comment id (that's all we need)
$('.comments').on('click', '.delete', (event) => {
  event.preventDefault()

  if (confirm('Are you sure?')) {
    const commentId = getTargetCommentId(event.currentTarget)
    channel.push(DELETED_COMMENT, { commentId, postId })
  }
})

// Handle receiving the CREATED_COMMENT event
channel.on(CREATED_COMMENT, (payload) => {
  $('.comments h3').after(payload.html)
})

// Handle receiving the DELETED_COMMENT event
channel.on(DELETED_COMMENT, (payload) => {
  // Just delete the comment from the DOM
  $(`#comment-${payload.commentId}`).remove()
})

export default socket
