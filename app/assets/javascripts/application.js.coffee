# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
# vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require popper
#= require turbolinks
#= require bootstrap
#= require jquery.turbolinks
#= require bootstrap-sprockets
#= require jquery_ujs
#= require moment
#= require fullcalendar
#= require_tree .

document.addEventListener 'turbolinks:load', ->
  # a click on a component-column links to its show
  $('tbody.with-show').on 'click', 'tr', (e) ->
    unless ($(e.target).hasClass('admin-actions__link__icon') || $(e.target).hasClass('btn-square'))
      id = $(this).attr('data-id') # the first td must containt the id
      component = $(this).attr('data-component') 
      unless component == 'user'
        url = "/#{component}s/#{id}"
        window.location.href = url
  $('#join-tournament-button').on 'click', (e) ->
    $('.navbar-account').dropdown('toggle')
  $('.scroll-top').on 'click', (e) ->
    $('html, body').animate({
      scrollTop: 0
    }, 500);

  $('.toast').toast({delay: 10000}).toast('show')
