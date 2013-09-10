$(function() {
  if($('#manage')) {

    // Approvals.
    $('#manage .approve').on('ajax:success', function(data, status, xhr) {
      if (status['approved'] == true) {
        approved_row = $(status['html']);
        approved_row.hide();
        $('tbody#approved_users').append(approved_row);
        approved_row.fadeIn();
        row = $(this).parents('tr');
        row.fadeOut();
        row.remove();
      }
    });

    // Denied!
    $('#manage .deny').on('ajax:success', function(data, status, xhr) {
      if (status == true) {
        row = $(this).parents('tr');
        row.fadeOut();
        row.remove();
      }
    });

    // Role changes.
    $(document).on('click', '#manage .user_role', function(){
        console.log("Updating role.");
        form = $(this).parents('form')
        form.find('.user_role_input').val($(this).val());
        form.submit();
    });

  }

});
