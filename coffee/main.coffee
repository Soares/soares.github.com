# Configuration
HEADING = 0
SIZE = 1
FPS = 0

# Globals
speed = if FPS == 0 then 0 else 1000/FPS
fractals = {}
ticker = 0
id = 0
clear = (f) -> delete fractals[f]

$ ->
  go = ->
    ticker = ticker or setInterval(update, speed)

  stop = ->
    fractals = {}
    $controls.removeClass('going').removeClass('paused')
    ticker = clearInterval(ticker)

  update = ->
    fractal.step() for id, fractal of fractals

  context = document.getElementById('canvas').getContext('2d')
  $controls = $('#controls')
  $fractals = $('#fractals')
  $body = $('body')
  $window = $(window).resize((e) ->
    context.canvas.width = window.innerWidth
    context.canvas.height = window.innerHeight
    stop()
  ).trigger('resize')

  $('#svg, #canvas, #dot, #halo').mouseup (e) ->
    e.stopPropagation()
    if $controls.is('.paused') then fractals = {}
    $controls.removeClass('paused').addClass('going')
    x = e.pageX - document.body.scrollLeft
    y = e.pageY - document.body.scrollTop
    id++
    die = ((i) -> () -> delete fractals[i]) id
    fractals[id] = new Current(context, x, y, HEADING, SIZE, die)
    go()

  Current = Fractals[$body.attr('class')]

  $('button', $fractals).click ->
    frac = $(this).button('toggle').data('fractal')
    Current = Fractals[frac]
    $body.removeClass().addClass(frac)

  $('.control', $controls).click (e) ->
    if $controls.is('.going')
      $controls.removeClass('going').addClass('paused')
      ticker = clearInterval(ticker)
    else
      $controls.removeClass('paused').addClass('going')
      go()

  $('.clear', $controls).click (e) ->
    context.clearRect(0, 0, context.canvas.width, context.canvas.height)
    stop()
