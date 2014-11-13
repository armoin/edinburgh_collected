class @Moderator
  constructor: ->
    $('a.approve, a.reject, a.unmoderate').on('click', @moderate)

  moderate: (e) =>
    e.preventDefault()
    $.ajax({
      contentType: 'application/json',
      dataType: 'json',
      method: 'PUT',
      url: $(e.target).attr('href'),
      data: @buildData(e.target)
    })
      .done(@moderationSuccess)
      .fail(@moderationError)

  moderationSuccess: (data) =>
    $('.memory[data-id="' + data.id + '"]').remove()

  moderationError: (xhr, textStatus, error) =>
    fm = new FlashManager()
    fm.showAlert("Error: #{xhr.responseText}")

  buildData: (link) ->
    reason = $(link).data('reason')
    JSON.stringify({ reason: reason })

