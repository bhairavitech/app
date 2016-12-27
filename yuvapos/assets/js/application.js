
function handle_action(action) {
  
  $(action[1]).html(action[2]);

  
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
  
}


function setup_product_form() {
  $('#product_form').submit(function() {
    $.ajax({
      type: 'POST',
      url: '/products',
      dataType: 'json',
      data: $(this).serialize() + '&' + $('#product_form :submit').attr('name') + '=1',
      success: function(data){
        handle_actions(data);
      }
    });
    return false;
  })
}


 
function handle_actions(actions) {
  var l = actions.length;
  var i;
  for(i=0; i<l; i++) {
    handle_action(actions[i]);
  }
}

