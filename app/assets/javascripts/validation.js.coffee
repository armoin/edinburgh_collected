class @Validator
  constructor: (@form) ->
    @toggle_submit()

  validate: ->
    $("form .form-control").on 'keyup', @toggle_submit
    $("form .form-control").on 'change', @toggle_submit

  form_valid: ->
    result = true
    $('.required').find('input, textarea, select').each (i, field) ->
      value = $(field).val()
      result = false if value == null || value == ''
    result

  toggle_submit: =>
    submit = @form.find 'input[type="submit"]'
    submit.attr 'disabled', !@form_valid()

