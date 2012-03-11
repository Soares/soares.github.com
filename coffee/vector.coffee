from = (args) ->
  if args.length == 0
    return args(new Vector())
  if args.length == 1
    if args[0] instanceof Vector
      return args[0].pair()
    if _.isArray args[0]
      return args[0]
    if _.isFunction args[0]
      return args(args[0]())
    if _.isNumber args[0]
      return new Vector(args[0], args[0])
  return [args[0], args[1]]

operator = (fn) -> () ->
  [x, y] = from(arguments)
  new Vector(fn(@x, x), fn(@y, y))

class @Vector
  constructor: (@x=0, @y=0) ->
  plus: operator (a, b) -> a + b
  times: operator (a, b) -> a * b
  scale: (s) => new Vector(@x * s, @y * s)
  minus: operator (a, b) -> a - b
  over: operator (a, b) -> a / b
  equals: =>
    [x, y] = from(arguments)
    @x == x and @y == y
  toString: => "[" + @x + " ; " + @y + "]"
  pair: => [@x, @y]
  copy: => new Vector(@x, @y)
  magSquared: => (@x * @x) + (@y * @y)
  magnitude: => Math.sqrt(@magSquared())
Vector.from = (v) ->
  if v instanceof Vector then return v
  [x, y] = from(arguments)
  new Vector(x, y)

@zero = new Vector(0, 0)
