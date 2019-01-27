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
#= require jquery.turbolinks
#= require bootstrap-sprockets
#= require jquery_ujs
#= require turbolinks
#= require moment
#= require fullcalendar
#= require_tree .

document.addEventListener 'turbolinks:load', ->
  # a click on a component-column links to its show
  $('tbody.with-show').on 'click', 'td', (e) ->
     unless ($(this).hasClass('actions'))
      id = +$(this).closest("tr").find("td").html()
      str = this.closest("tbody").className
      str = str.substring(10) # filter the "with-show"
      component = str.substring(0, str.indexOf('-'))
      unless component == 'user'
        window.location.href = "/#{component}s/#{id}"

  # change mouse icon
  $('tbody.with-show').css('cursor', 'pointer')

# # function to get the current url params as hash
# getParamsAsHash = ->
#   paramsHash = {}
#   currentParamsArray = window.location.search.substring(1).split('&')
#   for param in currentParamsArray
#     currentParamArray = param.split('=')
#     paramsHash[currentParamArray[0]] = currentParamArray[1]
#   return paramsHash

# console.log("blup = #{blup}")
# console.log($(blup))
