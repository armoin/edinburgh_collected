class @ScrapbooksController
  init: =>
    $('#create-scrapbook-button').on 'click', (e) ->
      e.preventDefault()
      $('#add-to-scrapbook-modal').modal('hide')

    $('form#create-scrapbook')
      .on('ajax:success', @scrapbookCreateSuccess)
      .on('ajax:error', @scrapbookCreateError)

    $('.scrapbooks').on 'click', '.scrapbook', (e) ->
      $('.scrapbook').removeClass('selected')
      $(e.currentTarget).addClass('selected')
      $('form#add-to-scrapbook #scrapbook_memory_scrapbook_id')
        .val($(e.currentTarget).data('id'))

  scrapbookCreateSuccess: (e, data, status, xhr) =>
    @addNewScrapbookToSelect(data)
    @createModalClose()

  scrapbookCreateError: (e, data, status, xhr) =>
    @markErrors(data)

  createModalClose: ->
    $('#create-scrapbook-modal').modal('hide');
    $('#add-to-scrapbook-modal').modal('show');

  addNewScrapbookToSelect: (data) ->
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
    $(scrapbook).trigger('click')

  markErrors: (data) ->
    $.each data.responseJSON, (key, value) ->
      $('form#create-scrapbook').find("#scrapbook_#{key}")
        .after('<span class="help-block">' + value.join(", ") + '</span>')
        .closest('.form-group').addClass('has-error')

