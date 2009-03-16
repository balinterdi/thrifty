$(document).ready(function() {
  $('#user-link').click(function() {
    $(this).replaceWith('<a href="/logout">logout</a>');
  });
});
