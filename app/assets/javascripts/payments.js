jQuery(function($) {
  $('#new_user').submit(function(event) {
    var $form = $(this);
    $form.find('#form-submit').prop('disabled', true);
    Stripe.createToken($form, stripeResponseHandler);
    return false;
  });

  var stripeResponseHandler = function(status, response) {
    var $form = $('#new_user');

    if (response.error)
      {
        $('.payment-errors').html(response.error.message);
        $form.find('#form-submit').prop('disabled', false);
      }
    else
      {
        var token = response.id;
        $form.append($('<input type="hidden" name="stripeToken">').val(token));
        $form.get(0).submit();
      }
  };

});
