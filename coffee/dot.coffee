$halo = undefined
$dot = undefined
pos = new Vector
cur = new Vector
time = 0
RESOLUTION = 15
BASE_H = 7
DELTA_H = 3
BASE_D = 4.3
DELTA_D = 1.2

BASE_W = 3
DELTA_W = 1.5

closer = ->

closer = ->
  time++
  delta = pos.minus(cur)
  theta = Math.sin(time / RESOLUTION)
  $halo.attr('r', BASE_H + DELTA_H * theta)
  $dot.attr('r', BASE_D + -1 * DELTA_D * theta)
  $halo.attr('stroke-width', BASE_W + DELTA_W * theta)
  if delta.magSquared < 3 then return
  cur.x += delta.x/4
  cur.y += delta.y/4
  $dot.attr('cx', cur.x)
  $dot.attr('cy', cur.y)
  $halo.attr('cx', cur.x)
  $halo.attr('cy', cur.y)

$ ->
  $dot = $('#dot')
  $halo = $('#halo')
  $(window).mousemove (e) ->
    pos.x = e.pageX - document.body.scrollLeft
    pos.y = e.pageY - document.body.scrollTop

  cur.x = parseFloat($dot.attr('cx'))
  cur.y = parseFloat($dot.attr('cy'))
  $dot.css('visibility', 'visible')
  $halo.css('visibility', 'visible')
  tick = setInterval(closer, 25)
