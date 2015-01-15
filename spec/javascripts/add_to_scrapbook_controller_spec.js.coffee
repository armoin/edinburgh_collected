describe "AddToScrapbooksController", ->
  beforeEach ->
    loadFixtures('add_to_scrapbook.html', 'after_add_to_scrapbook.html', 'create_scrapbook.html')

    # show the Add To Scrapbook modal
    $('#add-to-scrapbook-button').trigger('click')
    expect($('#add-to-scrapbook-modal')).toBeVisible()

    # mock event for callbacks
    @mockEvent = { preventDefault: -> true }

    @addToScrapbookController = new AddToScrapbookController()
    @addToScrapbookController.init()

  afterEach ->
    $('body').removeClass('modal-open').find('.modal-backdrop').remove()


  describe "showing the Create Scrapbook modal", ->
    it "hides the Add To Scrapbook modal", ->
      $('#create-scrapbook-button').trigger('click')
      expect($('#create-scrapbook-modal')).toBeVisible()
      expect($('#add-to-scrapbook-modal')).toBeHidden()

  describe "closing the Create Scrapbook modal", ->
    beforeEach ->
      # show the Create Scrapbook modal
      $('#create-scrapbook-button').trigger('click')
      @addToScrapbookController.createModalClose()

    xit "hides the Create Scrapbook modal", ->
      expect( $('.modal#create-scrapbook-modal') ).toBeHidden()

    xit "shows the Add To Scrapbook modal", ->
      expect( $('.modal#add-to-scrapbook-modal') ).toBeVisible()

  describe "successful creation", ->
    describe "adding a newly created scrapbook to the select list", ->
      beforeEach ->
        @date = "#{Date.now()}"
        data = {
          id: 123,
          title: 'New scrapbook',
          updated_at: @date
        }
        @addToScrapbookController.addNewScrapbookToSelect(data)
        @scrapbook_list = $('.modal#add-to-scrapbook-modal .scrapbook_selector .scrapbook')

      it "adds a new scrapbook to the list", ->
        expect( @scrapbook_list.length ).toEqual(3)

      describe "the new scrapbook", ->
        beforeEach ->
          @scrapbook = @scrapbook_list.first()

        it "has the expected title", ->
          expect( @scrapbook.find('.title').text() ).toEqual("New scrapbook")

        it "has the expected count", ->
          expect( @scrapbook.find('.count').text() ).toContain(0)

        it "has the expected updated at", ->
          expect( @scrapbook.find('.updates').text() ).toContain(@date)

        it "is selected", ->
          expect( @scrapbook ).toHaveClass('selected')

  describe "error on create", ->
    beforeEach ->
      data = { responseJSON: {"title" : ["can't be blank", "foo is not bar"]} }
      @addToScrapbookController.markErrors(data)
      @error_field = $('form#create-scrapbook #scrapbook_title')

    xit "highlights any errors", ->
      $form_group = @error_field.closest('.form-group')
      expect($form_group).toHaveClass('has-error')

    xit "shows the appropriate error messages", ->
      $error_message = @error_field.siblings('.help-block').first()
      expect($error_message.text()).toEqual("can't be blank, foo is not bar")

  describe "selecting a scrapbook", ->
    beforeEach ->
      @selected = $('.scrapbook_selector .scrapbook.selected')
      @toSelect = $('.scrapbook_selector .scrapbook[data-id="1"]')

    describe "when selected scrapbook is not currently selected", ->
      it "unselects any other selected scrapbooks", ->
        expect($(@selected)).toHaveClass('selected')
        @addToScrapbookController.selectScrapbook(@toSelect)
        expect($(@selected)).not.toHaveClass('selected')

      it "marks the selected scrapbook as selected", ->
        expect($(@toSelect)).not.toHaveClass('selected')
        @addToScrapbookController.selectScrapbook(@toSelect)
        expect($(@toSelect)).toHaveClass('selected')

      it "adds the selected scrapbook's id to a hidden field", ->
        expect($('#scrapbook_memory_scrapbook_id').val()).toEqual("#{@selected.data('id')}")
        @addToScrapbookController.selectScrapbook(@toSelect)
        expect($('#scrapbook_memory_scrapbook_id').val()).toEqual('1')

    describe "when selected scrapbook is already selected", ->
      beforeEach ->
        expect($(@selected)).toHaveClass('selected')
        @addToScrapbookController.selectScrapbook(@selected)

      it "unselects the selected scrapbook", ->
        expect($(@selected)).not.toHaveClass('selected')

      it "does not mark any other scrapbooks as selected", ->
        expect($('.scrapbook.selected').length).toEqual(0)

      it "clears the scrapbook id hidden field", ->
        expect($('#scrapbook_memory_scrapbook_id').val()).toEqual('')

  describe "validating scrapbook selection", ->
    it "shows an error if no scrapbook is selected", ->
      $('.scrapbook.selected').removeClass('selected')
      @addToScrapbookController.validateAddToScrapbook(@mockEvent)
      expect( $('.error-message').text() ).toEqual('Please select a scrapbook to add this memory to.')

    it "does not show an error if a scrapbook is selected", ->
      @addToScrapbookController.validateAddToScrapbook()
      expect( $('.error-message').length ).toEqual(0)

  describe "successfully adding a memory to a scrapbook", ->
    beforeEach ->
      @data = {
        id: 123,
        title: 'My test scrapbook'
      }

    it "closes the Add To Scrapbook modal", ->
      expect( $('#add-to-scrapbook-modal') ).toBeVisible()
      @addToScrapbookController.addToScrapbookSuccess(@mockEvent, @data)
      expect( $('#add-to-scrapbook-modal') ).toBeHidden()

    it "opens the After Add To Scrapbook modal", ->
      runs ->
        expect( $('#after-add-to-scrapbook-modal') ).toBeHidden()
        @addToScrapbookController.addToScrapbookSuccess(@mockEvent, @data)

      waitsFor `function () {
        return $('#after-add-to-scrapbook-modal').is(':visible')
      }`, "After add to scrapbook modal did not appear", 750

      runs ->
        expect( $('#after-add-to-scrapbook-modal') ).toBeVisible()

    it "adds the scrapbook title to the message", ->
      runs ->
        @addToScrapbookController.addToScrapbookSuccess(@mockEvent, @data)

      waitsFor `function () {
        return $('#after-add-to-scrapbook-modal').is(':visible')
      }`, "After add to scrapbook modal did not appear", 750

      runs ->
        expect( $('#after-add-to-scrapbook-modal .modal-body .scrapbook-name').text() ).toEqual(@data.title)

    it "View scrapbook button is a link to the scrapbook", ->
      runs ->
        @addToScrapbookController.addToScrapbookSuccess(@mockEvent, @data)

      waitsFor `function () {
        return $('#after-add-to-scrapbook-modal').is(':visible')
      }`, "After add to scrapbook modal did not appear", 750

      runs ->
        expect( $('#after-add-to-scrapbook-modal .modal-footer .view-scrapbook').attr('href') ).toEqual("/scrapbooks/#{@data.id}")

  describe "error when adding a memory to a scrapbook", ->
    # TODO: add tests for this and stop error message from appearing multiple times
