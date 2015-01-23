class @CreateScrapbookController
  constructor: () ->
    $('#create-scrapbook-modal').on 'show.bs.modal', ->
      $('form#create-scrapbook').trigger('reset')

    $('#cancel-create-scrapbook').on 'click', (e) =>
      e.preventDefault()
      $('#create-scrapbook-modal').modal('hide')

  # scrapbookCreateError: (e, data, status, xhr) =>
  #   @markErrors(data)
  #
  # markErrors: (data) ->
  #   $.each data.responseJSON, (key, value) ->
  #     $('form#create-scrapbook').find("#scrapbook_#{key}")
  #       .after('<span class="help-block">' + value.join(", ") + '</span>')
  #       .closest('.form-group').addClass('has-error')
  #
