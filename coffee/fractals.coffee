class Fractal
  axiom: ''
  rules: {}
  angle: 1/4
  position: 0
  cap: 0

  constructor: (@pen, @x, @y, heading, size, @die) ->
    turtle = new Turtle(pen, @x, @y, heading, size)
    @states = []
    @colors = @colors.make()
    @color = @colors.value()
    @progress = 0
    @axiom = (@axiom+'0').split('')
    @iterations = 0
    @actions =
      'F': => turtle.forward(size)
      'G': => turtle.go(size)
      '+': => turtle.turn(@angle)
      '-': => turtle.turn(-@angle)
      '[': => @states.push(turtle.save())
      ']': => turtle.restore(@states.pop())
      '0': => @iterate(turtle, size, heading)

  iterate: (turtle, size, heading) =>
    @iterations++
    if @cap > 0 and @iterations >= @cap
      delete @axiom
      @die()
    @color = @colors.step().value()
    @reset?(turtle, size, heading)
    @progress--
    return this

  step: (skip) =>
    @pen.strokeStyle = @color
    symbol = @axiom.shift()
    if @cap - @iterations > 1
      @axiom = @axiom.concat((@rules?[symbol] ? symbol).split(''))
    if skip then return this
    @actions[symbol]?()
    @progress++
    return if symbol == 'F' then this else @step()

class Dragon extends Fractal
  axiom: 'FX'
  rules:
    'X': 'X+YF'
    'Y': 'FX-Y'
  angle: 1/4
  colors: new ColorWheel(new Oscilator(.25, .075, .5, .075))
  cap: 15

  constructor: (pen, x, y, heading, size, die) ->
    @batching = 0
    super(pen, x, y, heading, size * 3, die)

  reset: =>
    @batching = @progress

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
  cap: 9
  colors: new ColorWheel(
    new Oscilator(.125, .08, 1, .54),
    1,
    new Oscilator(.25, .125, .5, .625))

class Plant extends Fractal
  axiom: 'FX'
  rules:
    'X': 'F-[[X]+X]+F[+FX]-X'
    'F': 'FF'
  angle: -25/360
  colors: new ColorWheel(new Oscilator(.67, .09, -.4, .23))
  cap: 8

  constructor: (pen, x, y, heading, size, die) ->
    super(pen, x, y, heading + 1/4, size * 3, die)

  reset: (turtle, size) =>
    turtle.jump(turtle.x + size * .5 * Math.pow(@progress, .5), @y).look(@angle)
    super

thits = 0
class Serpinsky extends Fractal
  axiom: 'FX'
  rules:
    'X': 'Y-FX-FY'
    'Y': 'X+FY+FX'
  angle: -1/6
  cap: 9

  reset: =>

  constructor: (pen, x, y, heading, size, die) ->
    theta = (thits % 6) / 6
    hue = (thits * .29) % 1
    @colors = new ColorWheel(new Oscilator(hue, .5, .265, .76))
    super(pen, x, y, heading + theta, size, die)
    thits++

class Tree extends Fractal
  axiom: 'FX'
  rules:
    'X': 'F[-FFX]+FX'
  angle: 1/16
  colors: new ColorWheel(new Oscilator(.80, .1, .6, .155))
  cap: 11

  constructor: (pen, x, y, heading, size, die) ->
    super(pen, x, y, heading - 1/4, size * 6, die)

  reset: (turtle, size, heading) =>
    turtle.jump(@x, @y).look(heading)

@Fractals =
  fire: Dragon
  earth: Tree
  snow: Snowflake
  tri: Serpinsky
  hidden: Plant
