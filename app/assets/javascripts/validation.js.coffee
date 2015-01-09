class @FormValidator
  validateForm: (form, opts) ->
    reset(form)

    $(form).find('.form-group').each (i, formGroup) ->
      if dataValidated(formGroup)
        validateField( $(formGroup).find('[data-validate]')[0] )
      else if isRequired(formGroup) && containsMulitpleCheckboxes(formGroup)
        validateCheckboxes(formGroup)
      else if isRequired(formGroup) && containsFileSelector(formGroup)
        validateFileSelector(formGroup)

    if isValid(form)
      onValid(form, opts)
    else
      onInvalid(form, opts)


  ## Helpers
  #=========

  onValid = (form, opts) ->
    opts.onValid() if opts && opts.onValid

  onInvalid = (form, opts) ->
    if opts && opts.onInvalid
      opts.onInvalid()
    else
      $('.field_with_errors')[0].scrollIntoView()

  dataValidated = (formGroup) ->
    return $(formGroup).find('[data-validate]').length > 0

  validateField = (field) ->
    judge.validate field, {
      valid: (element) -> # do nothing,
      invalid: (element, messages) ->
        markInvalid($(element).closest('.form-group'), messages)
    }

  isRequired = (formGroup) ->
    $(formGroup).is('[aria-required="true"]')

  containsMulitpleCheckboxes = (formGroup) ->
    $(formGroup).find('input[type="checkbox"]').length > 1

  validateCheckboxes = (formGroup) ->
    if noneChecked(formGroup)
      markInvalid(formGroup, ['Please select at least one'])

  noneChecked = (formGroup) ->
    $(formGroup).find('input[type="checkbox"]:checked').length == 0

  containsFileSelector = (formGroup) ->
    $(formGroup).find('input[type="file"]').length > 0

  validateFileSelector = (formGroup) ->
    if !hasFileAttached(formGroup) && !hasFileCached(formGroup)
      markInvalid(formGroup, ['Please select a file to upload'])

  hasFileAttached = (formGroup) ->
    files = $(formGroup).find('input[type="file"]')[0].files
    files && files.length > 0

  hasFileCached = (formGroup) ->
    cache = $(formGroup).find('input#memory_source_cache').val()
    cache && cache != ''

  markInvalid = (formGroup, messages) ->
    $(formGroup).addClass('field_with_errors')
    $.each messages, (i, message) ->
      $(formGroup).append('<span class="help-block">' + message + '</span>')

  isValid = (form) ->
    $('.field_with_errors').length == 0

  reset = (form) ->
    $(form)
      .find('.field_with_errors').removeClass('field_with_errors')
      .find('span.help-block').remove()

