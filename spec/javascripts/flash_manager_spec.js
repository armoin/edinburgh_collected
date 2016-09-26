//= require jquery
//= require chai-jquery

//= require flash_manager

describe('flash_manager', function () {
  var noticeText = '<span class="close">This is a notice.</span>'

  beforeEach(function () {
    $('body').html('<div class="flashes"></div>')

    $('.flashes').append('<div class="notice first">' + noticeText + '</div>')
    $('.flashes').append('<div class="notice second">' + noticeText + '</div>')

    $('.close').on('click', function (e) { e.preventDefault; FlashManager.close(e.currentTarget) })

    expect($('.notice.first')).to.be.visible
    expect($('.notice.second')).to.be.visible
  })

  afterEach(function () {
    $('body').html('')
  })

  describe('when the close button is clicked', function () {
    beforeEach(function () {
      $('.first .close').trigger('click')
    })

    it('closes the associated flash message', function () {
      expect($('.notice.first')).to.be.hidden
    })

    it('does not close other flash messages', function () {
      expect($('.notice.second')).to.be.visible
    })
  })
})
