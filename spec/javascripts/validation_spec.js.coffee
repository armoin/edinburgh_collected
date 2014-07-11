describe "Validator", ->
  beforeEach ->
    loadFixtures 'validation'
    @validator = new Validator()

  describe "checking that the form is valid", ->
    it "returns false if a required text field is null", ->
      $('.required input[type="text"]').val(null)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required date field is null", ->
      $('.required input[type="date"]').val(null)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required text field is empty", ->
      $('.required input[type="text"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required date field is empty", ->
      $('.required input[type="date"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required select field has a blank option selected", ->
      $('.required select option:first').attr('selected', true)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required textarea is blank", ->
      $('.required textarea').text('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false when two required fields are incomplete", ->
      $('.required input[type="text"]').val('')
      $('.required input[type="date"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns true when all required fields are complete", ->
      expect(@validator.form_valid()).toBe(true)

  describe "toggling the submit button", ->
    describe "the submit button", ->
      it "should be disabled at the start", ->
        submit_button = $('input[type="submit"]')
        expect(submit_button).toBeDisabled()

      describe "once a required text field has been typed in", ->
        it "should be enabled if the field is valid", ->
          @validator.validate()
          $('.required input[type="text"]').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the field is not valid", ->
          @validator.validate()
          $('.required input[type="text"]').val('').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required date field has been changed", ->
        it "should be enabled if the field is valid", ->
          @validator.validate()
          $('.required input[type="date"]').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the field is not valid", ->
          @validator.validate()
          $('.required input[type="date"]').val('').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required select field has been changed", ->
        it "should be enabled if the option is valid", ->
          @validator.validate()
          $('.required select').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the option is not valid", ->
          @validator.validate()
          $('.required select option:first').attr('selected', true)
          $('.required select').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required textarea has been typed in", ->
        it "should be enabled if the textarea has any text in it", ->
          @validator.validate()
          $('.required textarea').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the textarea does not have any text in it", ->
          @validator.validate()
          $('.required textarea').val('').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

