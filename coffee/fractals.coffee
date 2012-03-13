TAU = Math.PI * 2

class Turtle
  constructor: (@pen, @x, @y, @theta) -> @counter = 0
  save: => {@x, @y, @theta}
  restore: (state) =>
    this[attr] = val for attr, val of state
    return this
  turn: (angle) =>
    @theta = (@theta + angle) % 1
    return this
  step: (size=1) =>
    @x += size * Math.cos(@theta * TAU)
    @y += size * Math.sin(@theta * TAU)
    return this
  go: (size=1) =>
    @step(size)
    @pen.moveTo(@x, @y)
    return this
  jump: (@x, @y) => this
  look: (@theta) => this
  forward: (size=1) =>
    @pen.beginPath()
    @pen.moveTo(@x, @y)
    @step(size)
    @pen.lineTo(@x, @y)
    @pen.closePath()
    @pen.stroke()
    return this

class LSystem
  axiom: ''
  rules: {}
  theta: 0
  scale: 1
  angle: 1/4
  position: 0

  constructor: (@pen, @x, @y, heading, size) ->
    size *= @scale
    turtle = new Turtle(pen, @x, @y, heading + @theta, size)
    @states = []
    @progress = 0
    @axiom = (@axiom+'0').split('')
    @actions =
      'F': => turtle.forward(size)
      'G': => turtle.go(size)
      '+': => turtle.turn(@angle)
      '-': => turtle.turn(-@angle)
      '[': => @states.push(turtle.save())
      ']': => turtle.restore(@states.pop())
      '0': => @iterate(turtle, size)
    @history = []

  iterate: (turtle, size) =>
    reset = @reset ? => turtle.jump(@x, @y).look(@theta)
    reset(turtle, size)
    @progress--
    return this

  step: (skip) =>
    symbol = @axiom.shift()
    @history.push(symbol)
    @axiom = @axiom.concat((@rules?[symbol] ? symbol).split(''))
    unless skip
      @actions[symbol]?()
      @progress++
    # console.log(@history.join(''), @progress, skip)
    return this

class Fractal extends LSystem
  hue: 0
  sat: 1
  lum: 1/2
  spectrum: [0, 1]
  depth: 32

  constructor: (@pen, x, y, heading, size) ->
    @_color = Color.hsl(@hue, @sat, @lum).toString()
    [min, max] = @spectrum
    space = if max == min then 1 else max - min
    @_step = space / @depth
    @_direction = if max == min then 0 else 1
    super

  next: =>
    hue = @hue + (@_step * @_direction)
    if @_direction == 0
      hue = hue % 1
    else if @_direction > 0 and hue >= @spectrum[1]
      hue = @spectrum[1]
      @_direction = -1
    else if @_direction < 0 and hue <= @spectrum[0]
      hue = @spectrum[0]
      @_direction = 1
    @hue = hue

  reset: =>
    @next()
    @_color = Color.hsl(@hue, @sat, @lum).toString()
    return this

  step: (s=1, l=.5) =>
    @pen.strokeStyle = @_color
    super

class Dragon extends Fractal
  axiom: 'FX'
  rules:
    'X': 'X+YF'
    'Y': 'FX-Y'
  angle: 1/4
  scale: 2
  hue: 1/7
  spectrum: [-1/24, 1/6]
  depth: 16
  reset: =>
    @step(true) for i in [0...@progress]
    super

class Snowflake extends Fractal
  axiom: 'F++F++F'
  rules:
    'F': 'F-F++F-F'
  angle: 1/6
  hue: .5
  spectrum: [.47, .69]

class Plant extends Fractal
  axiom: 'FX'
  rules:
    'X': 'F-[[X]+X]+F[+FX]-X'
    'F': 'FF'
  theta: 1/4
  angle: -25/360
  scale: 3
  depth: 8
  hue: .15
  spectrum: [.15, .4]
  reset: (turtle, size) =>
    turtle.jump(turtle.x + size * .5 * Math.pow(@progress, .5), @y).look(@angle)
    super

class Serpinsky extends Fractal
  axiom: 'FX'
  rules:
    'X': 'Y-FX-FY'
    'Y': 'X+FY+FX'
  depth: 16
  angle: -1/6
  hue: 1/3
  reset: (turtle) =>
    turtle.turn(@angle)
    super

class Eight extends Fractal
  axiom: 'FX'
  rules:
    'X': 'F[-FFX]+FX'
  angle: 1/12
  depth: 8
  scale: 6
  theta: -1/2
  reset: (turtle) =>
    turtle.jump(@x,@y).look(@theta)
    super

Fractals = [Dragon, Serpinsky, Eight, Snowflake, Plant]
current = 0

HEADING = 0
SIZE = 1
FPS = 0
speed = if FPS == 0 then 0 else 1000/FPS
fractals = []
main = undefined
$controls = undefined

update = ->
  fractal.step() for fractal in fractals

go = ->
  main = main or setInterval(update, speed)

stop = ->
  fractals = []
  $controls?.removeClass('going').removeClass('paused')
  main = clearInterval(main)

$ ->
  surface = document.getElementById('canvas').getContext('2d')
  $controls = $('#controls')
  $('.control', $controls).click (e) ->
    e.stopPropagation()
    if $controls.is('.going')
      $controls.removeClass('going').addClass('paused')
      main = clearInterval(main)
    else
      $controls.removeClass('paused').addClass('going')
      go()
  $('.clear', $controls).click (e) ->
    surface.clearRect(0, 0, surface.canvas.width, surface.canvas.height)
    e.stopPropagation()
    stop()
  $window = $(window)
  $window.resize((e) ->
    surface.canvas.width = window.innerWidth
    surface.canvas.height = window.innerHeight
    stop()
  ).trigger('resize')

  $window.click (e) ->
    $controls.addClass('going')
    [x, y] = [e.pageX, e.pageY]
    x -= document.body.scrollLeft
    y -= document.body.scrollTop
    fractals.push(new Fractals[current](surface, x, y, HEADING, SIZE))
    current = (current + 1) % Fractals.length
    go()
