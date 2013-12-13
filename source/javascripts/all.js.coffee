#= require jquery
#= require jquery.mousewheel
#
#= require foundation/foundation
#= require foundation/foundation.offcanvas
#
#= require_tree .

$ ->
  $body = $('#body')
  column_width = $('.content', $body).width()

  _lock = false
  $body.mousewheel (event, delta)->
    event.preventDefault()
    return if _lock
    d = event.deltaY || -event.deltaX
    factor = column_width * event.deltaFactor / 50
    prop =
      scrollLeft: $body.scrollLeft() - d * column_width
    $body.animate prop,
      duration: 400
      easing: 'linear'
      start: ->
        _lock = true
      complete: ->
        _lock = false


  $body.scroll ->
    scroll_left = $body.scrollLeft()
    $('.leader').css('background-position', "#{scroll_left/2}px")

  $(".top-bar [href='#{window.location.pathname}']").parent('li').addClass('active')
