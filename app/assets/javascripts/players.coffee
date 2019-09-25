# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  # radio button deselection
  wasChecked = false
  $('.main_char input:radio').on 'mousedown', (e) ->
    if this.checked
      wasChecked = true
    else
      wasChecked = false
  $('.main_char input:radio').on 'click', (e) ->
    if wasChecked
      this.checked = false
