class @FormValidator
  labelLengthConstraints: (form) ->
    validatedFields(form)
      .filter (i, field) -> hasLengthValidation(field)
      .each   (i, field) ->
        currentLabelText = $(field).siblings('label').text()
        maxLength = lengthValidationFor(field).options.maximum
        minLength = lengthValidationFor(field).options.minimum
        if maxLength
          maxLengthText = '(max ' + maxLength + ' characters)'
          unless currentLabelText.match(".*#{maxLengthText}")
            $(field).siblings('label').text(currentLabelText + ' ' + maxLengthText)
        else if minLength
          minLengthText = '(min ' + minLength + ' characters)'
          unless currentLabelText.match(".*#{minLengthText}")
            $(field).siblings('label').text(currentLabelText + ' ' + minLengthText)

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

  hasLengthValidation = (field) ->
    $(field).data('validate').filter( (validation) ->
      validation.kind == 'length'
    ).length > 0

  validatedFields = (parent) ->
    $(parent).find('[data-validate]')

  lengthValidationFor = (field) ->
    $(field).data('validate').filter( (validation) ->
      validation.kind == 'length'
    )[0]

  dataValidated = (formGroup) ->
    return validatedFields(formGroup).length > 0

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

    if hasMaxSize(formGroup) && maxFileSizeExceeded(formGroup)
      markInvalid(formGroup, ['File must be less than or equal to 2MB'])

  hasFileAttached = (formGroup) ->
    file = $(formGroup).find('input#memory_source').val()
    file && file != ''

  hasFileCached = (formGroup) ->
    cache = $(formGroup).find('input#memory_source_cache').val()
    cache && cache != ''

  hasMaxSize = (formGroup) ->
    $(formGroup).find('input[type="file"]').data('max-size')

  maxFileSizeExceeded = (formGroup) ->
    fileInputEl = $(formGroup).find('input[type="file"]')[0]
    maxSize = parseInt $(fileInputEl).data('max-size'), 10
    size = 0
    if fileInputEl.files && fileInputEl.files[0]
      size = fileInputEl.files[0].size
    size >= maxSize

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

