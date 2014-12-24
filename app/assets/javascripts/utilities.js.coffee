class @Utilities
  @redirectEvent: (event, source, destination) ->
    $(source).on event, (e) ->
      e.preventDefault()
      $(destination).trigger event

