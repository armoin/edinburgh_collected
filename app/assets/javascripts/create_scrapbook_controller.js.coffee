class @CreateScrapbookController
  constructor: () ->
    $('#create-scrapbook-modal').on 'show.bs.modal', ->
      $('form#create-scrapbook').trigger('reset')

    $('#cancel-create-scrapbook').on 'click', (e) =>
      e.preventDefault()
      $('#create-scrapbook-modal').modal('hide')