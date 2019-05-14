import * as EasyMDE from 'easymde'

$(function() {
  const textarea = $('.md-editor');
  if (textarea.length > 0) {
    const easyMDE = new EasyMDE({ element: $('.md-editor')[0] });
  }
});
