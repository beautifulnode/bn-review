$(document).ready(function(){ 
  $('#memehelp').modal({show: false}); 
  $('a[data-delete]').on('click', function(e) {
    if (confirm('Are your sure?') == true) { 
      $($(this).data('delete')).submit();
    }
  });
});