describe 'FlashManager', ->
  beforeEach ->
    @flashManager = new FlashManager()

  describe '#showAlert', ->
    beforeEach ->
      affix('.flashes')

    it "shows a flash alert with the given message", ->
      expect($('.flashes .alert').length).toEqual(0)
      @flashManager.showAlert('Test error message')
      expect($('.flashes .alert').length).toEqual(1)
      expect($('.flashes .alert').html()).toContain('Test error message')

  describe '#flashCloser', ->
    beforeEach ->
      affix('.flashes .notice span.close')

    it 'closes the flash message when the close button is clicked', ->
      expect($('.flashes .notice')).toBeVisible()
      $('.flashes .notice span.close').trigger('click')
      expect($('.flashes .notice')).not.toBeVisible()

