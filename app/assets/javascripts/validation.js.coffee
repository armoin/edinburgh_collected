class @Validator
  validate: ->
    $("form .required").on 'keyup', @toggle_submit
    $("form .required").on 'change', @toggle_submit

  form_valid: ->
    result = true
    $('.required').find('input, textarea, select').each (i, field) ->
      value = $(field).val()
      result = false if value == null || value == ''
    result

# $ ->
#   $("form .required").on 'keyup', toggle_submit
#   $("form .required").on 'change', toggle_submit
#
  toggle_submit: (e) =>
    form = $(e.currentTarget).closest('form')
    submit = form.find 'input[type="submit"]'
    submit.attr 'disabled', !@form_valid()
#
# form_valid = ->
#   result = true
#   $('.required input').each (i, field) ->
#     value = $(field).val()
#     result = false if value == null || value == ''
#   result
