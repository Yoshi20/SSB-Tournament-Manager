# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  # radio button deselection
  wasChecked = false
  $('.main_char input:radio').on 'mousedown', (e) ->
    this.focus();
    if this.checked
      wasChecked = true
    else
      wasChecked = false
  $('.main_char input:radio').on 'click', (e) ->
    if wasChecked
      setTimeout(uncheck(this), 50)
  uncheck = (t) ->
    t.checked = false

  # request and show character_skins
  $('.main_char input:radio').on 'click', (e) ->
    $t = $(this)
    character = $t.val()
    skin_nr = $t.attr('name')[9]
    $main_char_skin_class = $(".main_char_skin#{skin_nr}")
    current_character_skin_nr = $main_char_skin_class.data('value')
    host_and_stuff = window.location.href.replace(window.location.pathname, '')
    url = host_and_stuff+'/character_skins.js?character='+character+'&skin_nr='+skin_nr+'&current_character_skin_nr='+current_character_skin_nr
    if this.checked
      $.ajax
        method: 'get'
        url: url
        dataType: 'text'
        error: ->
          console.log("error: get character_skins ajax request")
          $main_char_skin_class.find('.row').remove()
        success: (response) ->
          $main_char_skin_class.find('.row').remove()
          $main_char_skin_class.append(response);
    else
      $main_char_skin_class.find('.row').remove()
