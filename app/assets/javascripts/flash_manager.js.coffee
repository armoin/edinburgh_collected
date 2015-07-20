class @FlashManager
  constructor: ->
    # on a turbolinks load ...
    $(document).on 'page:load', @flashCloser
    @flashCloser()

  showAlert: (message) ->
    _showFlash('alert', message)

  flashCloser: ->
    $(document).on 'click touchstart', '.flashes .close', (e) ->
      $(this).parent().hide()

  _showFlash = (type, message) ->
    $('.flashes').html("<div class=\"#{type}\">#{message}<span class=\"close\">&times;</span></div>")
