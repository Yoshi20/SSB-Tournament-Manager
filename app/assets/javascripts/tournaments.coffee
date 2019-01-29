# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  # show the correct subform in tournament#new or tournament#edit
  showOrHideSubform()
  $('input[type="radio"]').click ->
    showOrHideSubform()

  # hide the paid fee submit button in tournament#show
  $('.paid-fee-button').hide()

  # a click on a paid fee checkbox sends an AJAX request in tournament#show
  $('.paid-fee-checkbox').bind('change', ->
    $t = $(this)
    $form = $t.closest('form')[0]
    data =
      'registration':
        paid_fee: if $t[0].checked then $t[0].value else 0
    $.ajax
      method: 'patch'
      url: $form.action
      data: data
      dataType: 'json'
      error: ->
        console.log("error: update paid_fee ajax request")
      success: (response) ->
        # console.log(response)
  )

showOrHideSubform = ->
  selected_index = -1
  $('.tournament-subtype').find('input[type="radio"]').each (i) ->
    if $(this).is(':checked')
      selected_index = i
  $('.tournament-subform').each (i) ->
    if i == selected_index
      $(this).show() #blup: should be an ajax request?
    else
      $(this).hide() #blup: should be .detach()
