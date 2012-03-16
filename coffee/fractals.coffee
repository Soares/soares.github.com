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
  move: (x, y) =>
    @x += x
    @y += y
    this
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

  iterate: (turtle, size) =>
    reset = @reset ? => turtle.jump(@x, @y).look(@theta)
    reset(turtle, size)
    @progress--
    return this

  step: (skip) =>
    symbol = @axiom.shift()
    @axiom = @axiom.concat((@rules?[symbol] ? symbol).split(''))
    if skip then return this
    @actions[symbol]?()
    @progress++
    return if symbol == 'F' then this else @step()

class Fractal extends LSystem
  hue: 0
  sat: 1
  lum: 1/2
  spectrum: [0, 1]
  depth: 32

  constructor: (@pen, x, y, heading, size) ->
    @_color = Color.hsl(@hue, @sat, @lum).toString()
    [min, max] = @spectrum
    space = max - min
    @_step = space / @depth
    super

  next: =>
    hue = @hue + @_step
    big = Math.max(@spectrum[0], @spectrum[1])
    lil = Math.min(@spectrum[0], @spectrum[1])
    if @spectrum[0] != 0 or @spectrum[1] != 1
      if hue > big
        hue = lil
      else if hue < lil
        hue = big
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
  hue: .15
  spectrum: [.15, 0]
  depth: 12
  reset: =>
    @batching = @progress
    super

  step: (skip) =>
    if not skip and @batching > 0
      cap = Math.min(100, @batching)
      @step(true) for i in [0...cap]
      @batching -= cap
      return
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

hoff = 0
toff = 0
class Serpinsky extends Fractal
  constructor: ->
    @hue += hoff
    hoff += .29
    @theta *= toff
    toff = toff + 1 % 6
    super
  axiom: 'FX'
  rules:
    'X': 'Y-FX-FY'
    'Y': 'X+FY+FX'
  depth: 16
  angle: -1/6
  theta: 1/6
  hue: -.35
  # spectrum: [.15, .16]

class Tree extends Fractal
  axiom: 'FX'
  rules:
    'X': 'F[-FFX]+FX'
  angle: 1/16
  depth: 1
  scale: 6
  hue: .31
  theta: -1/4
  spectrum: [.31,.312]
  reset: (turtle) =>
    turtle.jump(@x,@y).look(@theta)
    super

@Fractals =
  fire: Dragon
  earth: Tree
  snow: Snowflake
  tri: Serpinsky
