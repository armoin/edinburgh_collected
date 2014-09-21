featureSwitcher = ->
  $('body').on 'click', '.not-implemented', (e) ->
    e.preventDefault()
    alert "Sorry, this feature has not been developed yet. We'll let you know when it's ready."

# on a page refresh ...
$(document).ready featureSwitcher

# on a turbolinks load ...
$(document).on 'page:load', featureSwitcher
