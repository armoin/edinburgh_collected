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

    $('.scrapbooks').on 'click', '.scrapbook', (e) =>
      @selectScrapbook(e.currentTarget)

    $('#add-to-scrapbook-modal').on 'shown.bs.modal', ->
      $('.scrapbooks').scrollTop(0)

    $("form#add-to-scrapbook .save")
      .on("click", @validateAddToScrapbook)

    $("form#add-to-scrapbook")
      .on("ajax:success", @addToScrapbookSuccess)
      .on("ajax:error", @addToScrapbookError)

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
    $('.scrapbooks').prepend(scrapbook)
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
      selector = $('#add-to-scrapbook-modal .modal-body')
      message = 'Please select a scrapbook to add this memory to.'
      @displayErrorMessage(selector, message)

  addToScrapbookSuccess: (e, data, status, xhr) =>
    $('#add-to-scrapbook-modal').modal('hide');
    @displaySuccessMessage(data)
    @updateScrapbookIndicator()

  updateScrapbookIndicator: ->
    currentCount = parseInt($('span#scrapbook-count').text(), 10)
    $('span#scrapbook-count').text(currentCount + 1)
    scrapbookText = if currentCount == 0 then 'scrapbook' else 'scrapbooks'
    $('span#scrapbook-text').text(scrapbookText)

  addToScrapbookError: (e, data, status, xhr) =>
    selector = $('#add-to-scrapbook-modal .modal-body')
    message = "Could not add to the selected scrapbook. Please try again later."
    @displayErrorMessage(selector, message)

  displaySuccessMessage: (data) ->
    html =  '<div class="notice">'
    html += '  This photo was added to your scrapbook "' + data.title + '"'
    html += '  <a class="btn btn-default" href="/my/scrapbooks/' + data.id + '">'
    html += '    View your scrapbook'
    html += '  </a>'
    html += '</div>'
    $('.flashes').html(html).show();

  displayErrorMessage: (selector, message) ->
    html = "<div class=\"error-message\">#{message}</div>"
    selector.prepend(html)

