class @AddToScrapbookController
  constructor: ->
    @createScrapbookController = new CreateScrapbookController(@scrapbookCreateSuccess)

  init: =>
    $('#create-scrapbook-button').on 'click', (e) ->
      e.preventDefault()
      $('#add-to-scrapbook-modal').modal('hide')

    $('#cancel-create-scrapbook').on 'click', (e) =>
      e.preventDefault()
      $('#add-to-scrapbook-modal').modal('show');

    $('.scrapbook_selector').on 'click', '.scrapbook', (e) =>
      @selectScrapbook(e.currentTarget)

    $('#add-to-scrapbook-modal').on 'show.bs.modal', (e) ->
      id = $(e.relatedTarget).data('memory-id')
      if id
        $('#scrapbook_memory_memory_id').val(id)

      title = $(e.relatedTarget).data('memory-title')
      if title
        $('#add-to-scrapbook-modal .modal-title').text("Add \"#{title}\" to a scrapbook")

    $('#add-to-scrapbook-modal').on 'shown.bs.modal', ->
      $('.scrapbook_selector').scrollTop(0)

    $('#add-to-scrapbook-modal').on 'hide.bs.modal', (e) ->
      $('#add-to-scrapbook-modal #errors .error-message').remove()

    $("form#add-to-scrapbook .save")
      .on("click", @validateAddToScrapbook)

    $("form#add-to-scrapbook")
      .on("ajax:success", @addToScrapbookSuccess)

  scrapbookCreateSuccess: (e, data, status, xhr) =>
    @addNewScrapbookToSelect(data)
    $('#add-to-scrapbook-modal').modal('show')

  addNewScrapbookToSelect: (data) =>
    html =  '<div class="scrapbook">'
    html += '  <div class="picture"><p>&nbsp</p></div>'
    html += '  <div class="details">'
    html += '    <div class="title"></div>'
    html += '    <div class="count">0</div>'
    html += '    <div class="updates"></div>'
    html += '  </div>'
    html += '</div>'
    scrapbook = $.parseHTML(html)
    $(scrapbook).attr('data-id', data.id)
    $(scrapbook).find('.title').text(data.title)
    $(scrapbook).find('.updates').text('Updated ' + data.updated_at)
    $('.scrapbook_selector').prepend(scrapbook)
    @selectScrapbook(scrapbook)

  selectScrapbook: (scrapbook) ->
    wasSelected = $(scrapbook).hasClass('selected')
    scrapbookId = ''

    $('.scrapbook').removeClass('selected')

    unless wasSelected
      $(scrapbook).addClass('selected')
      scrapbookId = $(scrapbook).data('id')

    $('form#add-to-scrapbook #scrapbook_memory_scrapbook_id').val(scrapbookId)

  validateAddToScrapbook: (e) =>
    if $('.scrapbook.selected').length == 0
      e.preventDefault()
      selector = $('#add-to-scrapbook-modal #errors')
      message = 'Please select a scrapbook to add this memory to.'
      @displayErrorMessage(selector, message)

  addToScrapbookSuccess: (e, data, status, xhr) =>
    $('#add-to-scrapbook-modal').modal('hide');
    @displaySuccessMessage(data)

  displaySuccessMessage: (data) ->
    scope = $('#after-add-to-scrapbook-modal')
    scope.find('.scrapbook-name').text(data.title)
    scope.find('.view-scrapbook').attr('href', "/scrapbooks/#{data.id}")
    scope.modal('show');

  displayErrorMessage: (selector, message) ->
    html = "<div class=\"error-message\">#{message}</div>"
    selector.html(html)

