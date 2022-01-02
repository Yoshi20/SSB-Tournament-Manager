# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  run = () ->
    # add icons to calendar events
    $('.calendar-has-icon-class').each ->
      $currentElement = $(this)
      $fc_content = $currentElement.find('.fc-content')
      if $fc_content.find('img').length == 0
        classes = $currentElement[0].classList
        icon = classes.item(classes.length-1)
        img = document.createElement("img");
        img.src = $("##{icon}").attr('src');
        img.width = 20;
        img.height = 20;
        if $fc_content.find('.fc-time').length == 0
          img.style = 'margin-right: -2px; margin-left: -2px;';
        else
          img.style = 'margin-right: 2px; margin-left: -2px;';
        $fc_content.prepend(img);
  setInterval(run, 1000)
