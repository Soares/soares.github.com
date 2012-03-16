FPS = 40
# Resolution of the measurement of sine to time
RESOLUTION = 15
# Behavior of the halo's radius
BASE_H = 7
DELTA_H = 3
# Behavior of the halo's width
BASE_W = 3
DELTA_W = 1.5
# Behavior of the dot
BASE_D = 4.3
DELTA_D = 1.2

class Vector
  constructor: (@x=0, @y=0) ->
  add: (vec) =>
    @x += vec.x
    @y += vec.y
    this
  subtract: (vec) =>
    @x -= vec.x
    @y -= vec.y
    this
  plus: (vec) => new Vector(@x+vec.x, @y+vec.y)
  minus: (vec) => new Vector(@x-vec.x, @y-vec.y)
  scale: (s) =>
    @x *= s
    @y *= s
    this
  magSquared: =>
    (@x * @x) + (@y * @y)

# Variables to keep track of movement
$halo = undefined
$dot = undefined
pos = new Vector
cur = new Vector
time = 0

closer = ->
  time++
  theta = Math.sin(time / RESOLUTION)
  $halo.attr('r', BASE_H + DELTA_H * theta)
  $dot.attr('r', BASE_D + -1 * DELTA_D * theta)
  $halo.attr('stroke-width', BASE_W + DELTA_W * theta)
  delta = pos.minus(cur)
  return if delta.magSquared < 3
  cur.add(delta.scale(.25))
  $dot.attr('cx', cur.x)
  $dot.attr('cy', cur.y)
  $halo.attr('cx', cur.x)
  $halo.attr('cy', cur.y)

$ ->
  $dot = $('#dot')
  $halo = $('#halo')
  cur.x = parseFloat($dot.attr('cx'))
  cur.y = parseFloat($dot.attr('cy'))
  $(window).mousemove (e) ->
    $dot.css('visibility', 'visible')
    $halo.css('visibility', 'visible')
    pos.x = e.pageX - document.body.scrollLeft
    pos.y = e.pageY - document.body.scrollTop
  tick = setInterval(closer, if FPS == 0 then 0 else 1000/FPS)
