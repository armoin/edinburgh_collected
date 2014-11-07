describe "Moderator", ->
  beforeEach ->
    @moderator = new Moderator()

  describe "building the data for the AJAX request", ->
    it "extracts the reason if one is given", ->
      link = "<a href='#' data-reason='Test reason'>Test</a>"
      expected = JSON.stringify({reason: 'Test reason'})
      expect(@moderator.buildData(link)).toEqual(expected)

    it "has an undefined reason if none is given", ->
      link = "<a href='#'>Test</a>"
      expected = JSON.stringify({reason: undefined})
      expect(@moderator.buildData(link)).toEqual(expected)

  describe "successful moderation", ->
    beforeEach ->
      affix('.memory[data-id="123"]')

    it "removes the item that was moderated", ->
      expect($('.memory[data-id="123"]').length).toEqual(1)
      @moderator.moderationSuccess({id: 123})
      expect($('.memory[data-id="123"]').length).toEqual(0)

  describe "unsuccessful moderation", ->
    beforeEach ->
      affix('.flashes')

    it "shows a flash alert with the error", ->
      expect($('.flashes .alert').length).toEqual(0)
      @moderator.moderationError({responseText: 'Test error message'})
      expect($('.flashes .alert').length).toEqual(1)
      expect($('.flashes .alert').html()).toContain('Test error message')
