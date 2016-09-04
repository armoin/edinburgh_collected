var FlashManager = (function () {
  var flash_manager = {};

  flash_manager.close = function (flash_message) {
    $(flash_message).parent().hide()
  };

  return flash_manager;
})()
