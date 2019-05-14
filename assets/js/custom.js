import * as SimpleMDE from 'simplemde'

$(function() {
  const textarea = $('.md-editor');
  if (textarea.length > 0) {
    const simplemde = new SimpleMDE({ element: $('.md-editor')[0] });
  }
});
