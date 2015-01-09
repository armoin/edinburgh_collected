maxChars = 10

presenceValidator  = JSON.stringify([{"kind": "presence", "options": {}, "messages": {"blank": "test presence message"}}])
maxLengthValidator = JSON.stringify([{"kind": "length", "options": {"maximum": maxChars}, "messages": {"too_long": "text max length message"}}])

describe "FormValidator", ->
  beforeEach ->
    @form = affix('form#validatorTest')
    @formGroup = @form.affix('.form-group')

  describe "validating fields", ->
    describe "resets the form before validating", ->
      beforeEach ->
        $(@formGroup).addClass('field_with_errors')
        $("<span class='help-block'>This is some help text that should disappear</span>").appendTo(@formGroup)

      it "removes the error class from the field", ->
        expect( $(@formGroup) ).toHaveClass('field_with_errors')
        new FormValidator().validateForm(@form)
        expect( $(@formGroup) ).not.toHaveClass('field_with_errors')

      it "removes the error messages", ->
        expect( $(@formGroup) ).toContain('span.help-block')
        new FormValidator().validateForm(@form)
        expect( $(@formGroup) ).not.toContain('span.help-block')


    describe "text field", ->
      describe "no validation", ->
        beforeEach ->
          $("<input type='text' />").appendTo(@formGroup)

        describe "when blank", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when filled in", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('test')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "required", ->
        beforeEach ->
          $("<input type='text' data-validate='#{presenceValidator}' />").appendTo(@formGroup)

        describe "when blank", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('')
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')

        describe "when filled in", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('test')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "maximum length", ->
        beforeEach ->
          $("<input type='text' data-validate='#{maxLengthValidator}' />").appendTo(@formGroup)

        describe "when less than max chars", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('less chars')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when matches max chars", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('=max chars')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when over max chars", ->
          beforeEach ->
            $('form#validatorTest input[type="text"]').val('Longer than max chars')
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')


    describe "text area", ->
      describe "no validation", ->
        beforeEach ->
          $("<textarea></textarea>").appendTo(@formGroup)

        describe "when blank", ->
          beforeEach ->
            $('form#validatorTest textarea').text('')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when filled in", ->
          beforeEach ->
            $('form#validatorTest textarea').text('test')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "required", ->
        beforeEach ->
          $("<textarea data-validate='#{presenceValidator}'></textarea>").appendTo(@formGroup)

        describe "when blank", ->
          beforeEach ->
            $('form#validatorTest textarea').text('')
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')

        describe "when filled in", ->
          beforeEach ->
            $('form#validatorTest textarea').text('test')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "maximum length", ->
        beforeEach ->
          $("<textarea data-validate='#{maxLengthValidator}'></textarea>").appendTo(@formGroup)

        describe "when less than max chars", ->
          beforeEach ->
            $('form#validatorTest textarea').val('less chars')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when matches max chars", ->
          beforeEach ->
            $('form#validatorTest textarea').val('=max chars')
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when over max chars", ->
          beforeEach ->
            $('form#validatorTest textarea').val('Longer than max chars')
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')


    describe "select", ->
      describe "no validation", ->
        beforeEach ->
          $("<select><option value=''></option><option value='Photo'>Photo</option></select>").appendTo(@formGroup)

        describe "when no option selected", ->
          beforeEach ->
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when an option with no value is selected", ->
          beforeEach ->
            $('form#validatorTest select').find('option').first().prop('selected', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when an option with a value is selected", ->
          beforeEach ->
            $('form#validatorTest select').find('option').last().prop('selected', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "required", ->
        beforeEach ->
          $("<select data-validate='#{presenceValidator}'><option value=''></option><option value='Photo'>Photo</option></select>").appendTo(@formGroup)

        describe "when no option selected", ->
          beforeEach ->
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')

        describe "when an option with no value is selected", ->
          beforeEach ->
            $('form#validatorTest select').find('option').first().prop('selected', true)
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')

        describe "when an option with a value is selected", ->
          beforeEach ->
            $('form#validatorTest select').find('option').last().prop('selected', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')


    describe "checkboxes", ->
      describe "no validation", ->
        beforeEach ->
          $("<input type='checkbox' value='1'><input type='checkbox' value='2'>").appendTo(@formGroup)

        describe "when no box checked", ->
          beforeEach ->
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when one box checked", ->
          beforeEach ->
            $(@formGroup).find('input[type="checkbox"]').first().prop('checked', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when two boxes checked", ->
          beforeEach ->
            $(@formGroup).find('input[type="checkbox"]').prop('checked', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

      describe "required", ->
        beforeEach ->
          $(@formGroup).attr('aria-required', true)
          $("<input type='checkbox' value='1'><input type='checkbox' value='2'>").appendTo(@formGroup)

        describe "when no box checked", ->
          beforeEach ->
            new FormValidator().validateForm(@form)

          it "is highlighted", ->
            expect($(@formGroup)).toHaveClass('field_with_errors')

          it "has an error message", ->
            expect($(@formGroup)).toContain('span.help-block')

        describe "when one box checked", ->
          beforeEach ->
            $(@formGroup).find('input[type="checkbox"]').first().prop('checked', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

        describe "when two boxes checked", ->
          beforeEach ->
            $(@formGroup).find('input[type="checkbox"]').prop('checked', true)
            new FormValidator().validateForm(@form)

          it "is not highlighted", ->
            expect($(@formGroup)).not.toHaveClass('field_with_errors')

          it "does not have an error message", ->
            expect($(@formGroup)).not.toContain('span.help-block')

