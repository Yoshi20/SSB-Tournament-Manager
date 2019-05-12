# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener 'turbolinks:load', ->

  $('.player-stats-column').css("display", "table-cell !important");
  # $('.player-comment-column').each (i, e) ->
  #   console.log(e)
  #   $(e).css("display", "table-cell !important");

  # a click on the show-player-comments-btn toggles the view to either show the comments or hide them
  $('#show-player-comments-btn').on 'click', (e) ->
    e.preventDefault()
    $t = $(this)
    class_list_to_show = 'd-none d-md-table-cell d-lg-none d-xl-table-cell'
    class_list_to_hide = 'd-md-table-cell d-lg-none d-xl-table-cell'
    if $('.player-comment-column').hasClass(class_list_to_show)
      # comment is visible -> hide comment and show stats
      $('.player-comment-column').removeClass(class_list_to_hide)
      $('.player-stats-column').addClass(class_list_to_show)
      $t.html('Show player comments')
    else
      # comment is not visible -> hide stats and show comment
      $('.player-stats-column').removeClass(class_list_to_hide)
      $('.player-comment-column').addClass(class_list_to_show)
      $t.html('Show player stats')
