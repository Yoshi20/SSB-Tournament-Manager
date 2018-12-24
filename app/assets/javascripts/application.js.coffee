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
#= require_tree .

$ ->

  # a click on a + or - button changes the signe of the number field (if necessary) and sends an AJAX request if its value is != 0 or NaN
  $(document).on 'click', '.change_stock_btn', (e) ->
    e.preventDefault()
    $t = $(this)
    $numberInput = $t.closest('td').find('input[type=number]').last()
    change_stock_value = parseInt($numberInput.val())
    if change_stock_value != 0 && !isNaN(change_stock_value)
      if ($t.hasClass('plus_btn') && change_stock_value < 0) || ($t.hasClass('minus_btn') && change_stock_value > 0)
        change_stock_value *= -1
        $numberInput.val(change_stock_value)
      $form = $t.closest('form')
      form_id = $form.attr('id')
      index_first_underscore = form_id.indexOf('_')
      index_last_underscore = form_id.lastIndexOf('_')
      component = form_id.substring(index_first_underscore+1, index_last_underscore)
      console.log("component = #{component}")
      url = $form.attr('action')
      console.log("url = #{url}")
      data =
        "#{component}":
          in_stock: change_stock_value
        paramsHash: getParamsAsHash()
      $.ajax
        method: 'patch'
        url: url
        data: data
        dataType: 'json'
        error: ->
          console.log("error: update in_stock ajax request")
        success: (response) ->
          $form.closest('tbody').find('tr').each (i, tr) ->
            if tr.id == 'highlighted'
              $(tr).removeAttr('id')
              $(tr).removeAttr('style')
          $form.closest('tr').replaceWith(response["#{component}"])


# document.addEventListener 'turbolinks:load', ->
#   # a click on a component-column links to its show
#   $('tbody').on 'click', 'td', (e) ->
#      unless ($(this).hasClass('actions'))
#       id = +$(this).closest("tr").find("td").html()
#       str = this.closest("tbody").className
#       component = str.substring(0, str.indexOf('-'))
#       unless component == 'user'
#         window.location.href = "/#{component}s/#{id}"
#
#   # change mouse icon
#   $('tbody').css('cursor', 'pointer')

# function to get the current url params as hash
getParamsAsHash = ->
  paramsHash = {}
  currentParamsArray = window.location.search.substring(1).split('&')
  for param in currentParamsArray
    currentParamArray = param.split('=')
    paramsHash[currentParamArray[0]] = currentParamArray[1]
  return paramsHash

# console.log("blup = #{blup}")
# console.log($(blup))
