class @Scrapbooks
  init: ->
    $('#create-scrapbook').on 'click', (e) ->
      e.preventDefault()
      $('#add-to-scrapbook-modal').modal('hide')

  scrapbookCreated: (data) ->
    @addNewScrapbookToSelect(data)
    @createModalClose()

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
