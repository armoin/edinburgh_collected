class @Validator
  constructor: (@form) ->
    @toggle_submit()

  validate: ->
    $("form").find('input, textarea').on 'keyup', @toggle_submit
    $("form").find('input, select').on 'change', @toggle_submit

  atLeastOneChecked: (form_group) ->
    $(form_group).find('input[type="checkbox"]:checked').length > 0

  form_valid: =>
    result = true
    $('.form-group[aria-required="true"]').each (i, form_group) =>
      if $(form_group).hasClass('check_boxes')
        result = @atLeastOneChecked(form_group)
      else
        field = $(form_group).find('input, textarea, select')
        value = $(field).val()
        result = false if value == null || value == ''
    result

  toggle_submit: =>
    submit = @form.find 'input[type="submit"]'
    submit.attr 'disabled', !@form_valid()
