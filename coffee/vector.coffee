operator = (fn) -> (vec) -> new Vector(fn(@x, vec.x), fn(@y, vec.y))

class @Vector
  constructor: (@x=0, @y=0) ->
  plus: operator (a, b) -> a + b
  minus: operator (a, b) -> a - b
  times: operator (a, b) -> a * b
  divide: operator (a, b) -> a / b
  scale: (s) => new Vector(@x * s, @y * s)
  over: (s) => new Vector(@x / s, @y / s)
  equals: (vec) => @x == vec.x and @y == vec.y
  toString: => "[" + @x + " ; " + @y + "]"
  copy: => new Vector(@x, @y)
  dot: (vec) => (@x * vec.x) + (@y * vec.y)
  magSquared: => (@x * @x) + (@y * @y)
  magnitude: => Math.sqrt(@magSquared())
  distSquared: (vec) => @minus(vec).magSquared()
  distance: (vec) => Math.sqrt(@distance(vec))
