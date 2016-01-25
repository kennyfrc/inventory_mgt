$(document).ready(function() {
  $('#product_description_product_category_id').change(function(){
    if($(this).val() == 'pop_out_form') {
      $('#pop_out_form input[type=text]').val('');
      $('#pop_out_form').show();
    } else {
      $('#pop_out_form').hide();
      $('#pop_out_form input[type=text]').val('');
    }
  });
});