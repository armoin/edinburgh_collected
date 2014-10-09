describe "Scrapbooks", ->
  describe "adding a memory", ->
    beforeEach ->
      @container = affix '.container'
      @container.affix 'a#add-to-scrapbook.add-link[data-toggle="modal"][data-target="#add-to-scrapbook-modal"]'
      @add_modal = @container.affix '.modal#add-to-scrapbook-modal'

      @add_modal.affix '#create-scrapbook[data-toggle="modal"][data-target="#create-scrapbook-modal"]'
      create_modal = @container.affix '.modal#create-scrapbook-modal'

      scrapbooks = @add_modal.affix '.scrapbooks'

      scrapbook2 = scrapbooks.affix '.scrapbook'
      scrapbook2.affix '.picture p[text=" "]'
      details = scrapbook2.affix '.details'
      details.affix '.title[text="Scrapbook 2"]'
      details.affix '.count[text="0"]'
      details.affix '.updates[text="Yesterday"]'

      scrapbook1 = scrapbooks.affix '.scrapbook'
      scrapbook1.affix '.picture img[src="assets/test.jpg"]'
      details = scrapbook1.affix '.details'
      details.affix '.title[text="Scrapbook 1"]'
      details.affix '.count[text="3"]'
      details.affix '.updates[text="2 days ago"]'

      @add_modal.affix '.cancel[data-dismiss="modal"]'
      @scrapbooks = new Scrapbooks()

    afterEach ->
      $('body').removeClass('modal-open').find('.modal-backdrop').remove()

    it "starts with all modals hidden", ->
      expect( $('.modal') ).toBeHidden()

    it "shows the Add To Scrapbook modal when the Add button is clicked", ->
      $('.add-link').trigger('click')
      expect( $('.modal') ).toBeVisible()

    it "lists all scrapbooks", ->
      expect( $('.scrapbooks .scrapbook').length ).toEqual(2)

    describe "creating a new Scrapbook", ->
      beforeEach ->
        $('.add-link').trigger('click')

      it "starts with the Add To Scrapbook modal showing and the Create Scrapbook modal hidden", ->
        expect( $('.modal#add-to-scrapbook-modal') ).toBeVisible()
        expect( $('.modal#create-scrapbook-modal') ).toBeHidden()

      describe "when the Create Scrapbook button is clicked", ->
        beforeEach ->
          @scrapbooks.init()
          $('#create-scrapbook').trigger('click')

        it "shows the Create Scrapbook modal", ->
          expect( $('.modal#create-scrapbook-modal') ).toBeVisible()

        it "hides the Add To Scrapbook modal", ->
          expect( $('.modal#add-to-scrapbook-modal') ).toBeHidden()

    describe "closing the Create Scrapbook modal", ->
      beforeEach ->
        $('#add-to-scrapbook').trigger('click')
        @scrapbooks.createModalClose()

      describe "when successful", ->
        it "hides the Create Scrapbook modal", ->
          expect( $('.modal#create-scrapbook-modal') ).toBeHidden()

        it "shows the Add To Scrapbook modal", ->
          expect( $('.modal#add-to-scrapbook-modal') ).toBeVisible()


    describe "adding a newly created scrapbook to the select list", ->
      beforeEach ->
        @date = "#{Date.now()}"
        data = {
          id: 123,
          title: 'New scrapbook',
          updated_at: @date
        }
        @scrapbooks.addNewScrapbookToSelect(data)
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


    describe "choosing an existing Scrapbook", ->
