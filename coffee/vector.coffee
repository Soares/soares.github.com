class @Vector
  constructor: (@x, @y) ->
  plus: (vec) => new Vector(@x+vec.x, @y+vec.y)
  times: (vec) => new Vector(@x*vec.x, @y*vec.y)
  minus: (vec) => new Vector(@x-vec.x, @y-vec.y)
  over: (vec) => new Vector(@x/vec.x, @y/vec.y)
  equals: (vec) => @x == vec.x and @y == vec.y
  toString: => "[" + @x + " ; " + @y + "]"

@zero = new Vector(0, 0)

l = new Vector(0, -1)
t = new Vector(-1, 0)
r = new Vector(0, 1)
b = new Vector(1, 0)

tl = t.plus(l)
tr = t.plus(r)
bl = b.plus(l)
br = b.plus(r)

@around = (vec) -> beside(vec).concat(nearby(vec));
@beside = (vec) -> [vec.plus(l), vec.plus(t), vec.plus(r), vec.plus(b)]
@nearby = (vec) -> [vec.plus(tl), vec.plus(tr), vec.plus(br), vec.plus(bl)]
