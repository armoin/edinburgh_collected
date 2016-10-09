$(document).ready(function () {
  var $form = $('[data-delete-account-form]');

  if ($form.length) {
    $form.on('submit', function (e) {
      var $account_will_be_deleted = $('input[type="checkbox"]#user_account_will_be_deleted')
      if($account_will_be_deleted.not(':checked').length) {
        e.preventDefault();
        var label = $account_will_be_deleted.closest('label');
        label.css({
          "background-color": 'red',
          "color": 'white'
        });
      }
    })
  }
})

