describe "ScrapbooksController", ->
  beforeEach ->
    loadFixtures('scrapbooks.html')

    # show the Add To Scrapbook modal
    $('#add-to-scrapbook-button').trigger('click')
    expect($('#add-to-scrapbook-modal')).toBeVisible()

    @scrapbooks_controller = new ScrapbooksController()
    @scrapbooks_controller.init()

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
      @scrapbooks_controller.createModalClose()

    describe "when successful", ->
      it "hides the Create Scrapbook modal", ->
        expect( $('.modal#create-scrapbook-modal') ).toBeHidden()

      it "shows the Add To Scrapbook modal", ->
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
        @scrapbooks_controller.addNewScrapbookToSelect(data)
        @scrapbook_list = $('.modal#add-to-scrapbook-modal .scrapbooks .scrapbook')

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
      @scrapbooks_controller.markErrors(data)
      @error_field = $('form#create-scrapbook #scrapbook_title')

    it "highlights any errors", ->
      $form_group = @error_field.closest('.form-group')
      expect($form_group).toHaveClass('has-error')

    it "shows the appropriate error messages", ->
      $error_message = @error_field.siblings('.help-block').first()
      expect($error_message.text()).toEqual("can't be blank, foo is not bar")
