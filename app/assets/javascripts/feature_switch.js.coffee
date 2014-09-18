$ ->
  $('body').on 'click', '.not-implemented', (e) ->
    e.preventDefault()
    alert "Sorry, this feature has not been developed yet. We'll let you know when it's ready."
