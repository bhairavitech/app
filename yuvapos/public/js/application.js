
function handle_action(action) {
  
  $(action[1]).html(action[2]);

  /*
  switch(action[0]) {
  case 'set_value':
    $(action[1]).val(action[2])
    break;
  case 'replace_html':
    $(action[1]).html(action[2])
    break;
  case 'insert_html':
    $(action[1]).after(action[2])
    break;
  case 'focus':
    $(action[1]).focus()
    break;
  case 'autocompleter':
    set_entity_autocompleter()
    break;
  case 'resort':
    ts_resortTable()
    break;
  default:
    alert('Unhandled action type: ' + action[0]);
  }
  */
}


function setup_register_form() {
  $('#register_form').submit(function() {
    $.ajax({
      type: 'POST',
      url: '/update/add_entry',
      dataType: 'json',
      data: $(this).serialize() + '&' + $('#register_form :submit').attr('name') + '=1',
      success: function(data){
        handle_actions(data);
      }
    });
    return false;
  })

  $(document).on('click', 'a.modify', function() {
    $.getJSON($(this).attr('href'),
    {selected_entry_id: $('#selected_entry_id').val()},
    function(data){
      handle_actions(data);
    });

    return false;
  })

  set_entity_autocompleter() 
  handle_actions([])
}