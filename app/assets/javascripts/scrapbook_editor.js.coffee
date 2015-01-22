class @ScrapbookEditor
  constructor: () ->
    $('#editScrapbook .memories').waitForImages ->
      $container = $(@)
      $spinner   = $(".masonry-loading-spinner")
      gutter     = parseInt $('.masonry').css('marginBottom')

      $spinner.hide()
      $container.parent().show()
      $packCont = $container.packery({
        itemSelector: '.masonry',
        columnWidth:  '.masonry',
        rowHeight:  40,
        gutter: gutter,
        fitWidth: true,
      })
      $memories = $packCont.find('.memory')
      $memories.draggable()
      $packCont.packery 'bindUIDraggableEvents', $memories
      $packCont.packery 'on', 'dragItemPositioned', recordOrdering
      $packCont.packery 'on', 'removeComplete', recordDeletions

    $('.remove-memory').on 'click', (e) =>
      memory = $(e.currentTarget).closest('.memory')
      $('.memories').packery('remove', memory)
      $('.memories').packery()

  recordDeletions = (pckryInstance, deleted) =>
    current = $('input#scrapbook_deleted').val().split(',')
    deletedIds = $.map(deleted, (el) -> $(el.element).data('id'))
    unless current.length == 1 && current[0] == ''
      deletedIds = current.concat(deletedIds)
    $('input#scrapbook_deleted').val(deletedIds.join())
    recordOrdering(pckryInstance)

  recordOrdering = (pckryInstance) ->
    ordering = $.map(pckryInstance.getItemElements(), (el) -> $(el).data('id'))
    $('input#scrapbook_ordering').val(ordering)
