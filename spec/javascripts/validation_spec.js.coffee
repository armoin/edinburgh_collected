describe "Validator", ->
  beforeEach ->
    loadFixtures 'validation'
    @validator = new Validator($('form'))

  describe "checking that the form is valid", ->
    it "returns false if a required text field is null", ->
      $('.form-group[aria-required="true"] input[type="text"]').val(null)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required date field is null", ->
      $('.form-group[aria-required="true"] input[type="date"]').val(null)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required text field is empty", ->
      $('.form-group[aria-required="true"] input[type="text"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required date field is empty", ->
      $('.form-group[aria-required="true"] input[type="date"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required select field has a blank option selected", ->
      $('.form-group[aria-required="true"] select option:first').attr('selected', true)
      expect(@validator.form_valid()).toBe(false)

    it "returns false if a required textarea is blank", ->
      $('.form-group[aria-required="true"] textarea').text('')
      expect(@validator.form_valid()).toBe(false)

    it "returns false if no required checkboxes are checked", ->
      $('.form-group[aria-required="true"] input[type="checkbox"]:checked').attr('checked', false)
      expect(@validator.form_valid()).toBe(false)

    it "returns true if one required checkbox is checked", ->
      expect($('.form-group[aria-required="true"] input[type="checkbox"]:checked').length).toEqual(1)
      expect(@validator.form_valid()).toBe(true)

    it "returns true if two required checkboxes are checked", ->
      $('.form-group[aria-required="true"] input[type="checkbox"]').not(':checked').attr('checked', true)
      expect($('.form-group[aria-required="true"] input[type="checkbox"]:checked').length).toEqual(2)
      expect(@validator.form_valid()).toBe(true)

    it "returns false when two required fields are incomplete", ->
      $('.form-group[aria-required="true"] input[type="text"]').val('')
      $('.form-group[aria-required="true"] input[type="date"]').val('')
      expect(@validator.form_valid()).toBe(false)

    it "returns true when all required fields are complete", ->
      expect(@validator.form_valid()).toBe(true)

  describe "toggling the submit button", ->
    describe "the submit button", ->
      it "should be disabled at the start if invalid", ->
        $('.form-group[aria-required="true"] input[type="text"]').val('')
        @validator = new Validator($('form'))
        submit_button = $('input[type="submit"]')
        expect(submit_button).toBeDisabled()

      it "should be enabled at the start if valid", ->
        submit_button = $('input[type="submit"]')
        expect(submit_button).not.toBeDisabled()

      describe "once a required text field has been typed in", ->
        it "should be enabled if the field is valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="text"]').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the field is not valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="text"]').val('').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required date field has been changed", ->
        it "should be enabled if the field is valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="date"]').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the field is not valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="date"]').val('').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required select field has been changed", ->
        it "should be enabled if the option is valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] select').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the option is not valid", ->
          @validator.validate()
          $('.form-group[aria-required="true"] select option:first').attr('selected', true)
          $('.form-group[aria-required="true"] select').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once a required textarea has been typed in", ->
        it "should be enabled if the textarea has any text in it", ->
          @validator.validate()
          $('.form-group[aria-required="true"] textarea').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the textarea does not have any text in it", ->
          @validator.validate()
          $('.form-group[aria-required="true"] textarea').val('').trigger('keyup')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

      describe "once at least one required checkbox has been checked", ->
        it "should be enabled if the checkbox was checked", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="checkbox"]').trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).not.toBeDisabled()

        it "should be disabled if the checkbox has not been checked", ->
          @validator.validate()
          $('.form-group[aria-required="true"] input[type="checkbox"]').attr('checked', false).trigger('change')
          submit_button = $('input[type="submit"]')
          expect(submit_button).toBeDisabled()

