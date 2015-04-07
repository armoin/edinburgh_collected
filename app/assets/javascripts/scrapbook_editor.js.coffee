class @ScrapbookEditor
  constructor: () ->
    $('.memories').sortable({
      stop: @recordOrdering
    })

    $('.remove-memory').on 'click', (e) =>
      memory = $(e.currentTarget).closest('.memory')
      $(memory).addClass('deleted')
      @recordDeletions()

    $('#save-scrapbook-edits').on 'click', (e) ->
      e.preventDefault()
      $('form#edit-scrapbook input[type="submit"]').trigger('click')

  recordDeletions: =>
    deleted = $.map($('.memory.deleted'), (el) -> $(el).data('id') )
    $('input#scrapbook_deleted').val(deleted)
    @recordOrdering()

  recordOrdering: (e) =>
    ordering = $.map($('.memory').not('.deleted'), (el) -> $(el).data('id') )
    $('input#scrapbook_ordering').val(ordering)
