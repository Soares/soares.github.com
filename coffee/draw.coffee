TAU = Math.PI * 2
RESOLUTION = 15

class @Oscilator
  constructor: (@phase=0, @amplitude=1, @frequency=1, @offset=0) ->
  value: (t) ->
    @offset + @amplitude * Math.sin((@frequency * TAU * t) + (@phase * TAU))

class @ColorWheel
  constructor: (@h, @s=1, @l=.5, @t=0) ->
  make: -> new ColorWheel(@h, @s, @l)
  step: ->
    @t++
    this
  value: ->
    time = @t / RESOLUTION;
    h = if _.isNumber @h then @h else @h.value(time)
    s = if _.isNumber @s then @s else @s.value(time)
    l = if _.isNumber @l then @l else @l.value(time)
    Color.hsl(h, s, l).toString()

class @Turtle
  constructor: (@pen, @x, @y, @theta) ->
    @counter = 0
  save: =>
    {@x, @y, @theta}
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
  jump: (@x, @y) =>
    this
  move: (x, y) =>
    @x += x
    @y += y
    this
  look: (@theta) =>
    this
  forward: (size=1) =>
    @pen.beginPath()
    @pen.moveTo(@x, @y)
    @step(size)
    @pen.lineTo(@x, @y)
    @pen.closePath()
    @pen.stroke()
    return this
