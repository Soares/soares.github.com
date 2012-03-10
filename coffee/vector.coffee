class Vector
  constructor: (@x, @y) ->
  plus: (vec) -> Vector(@x+vec.x, @y+vec.y)
  times: (vec) -> Vector(@x*vec.x, @y*vec.y)
  minus: (vec) -> Vector(@x-vec.x, @y-vec.y)
  over: (vec) -> Vector(@x/vec.x, @y/vec.y)
  equals: (vec) -> @x == vec.x and @y == vec.y

l = Vector(0, -1)
t = Vector(-1, 0)
r = Vector(0, 1)
b = Vector(1, 0)

tl = t.plus(l)
tr = t.plus(r)
bl = b.plus(l)
br = b.plus(r)


around = (vec) -> # TODO: beside ++ nearby
beside = (vec) -> [vec.plus(l), vec.plus(t), vec.plus(r), vec.plus(b)]
nearby = (vec) -> [vec.plus(tl), vec.plus(tr), vec.plus(br), vec.plus(bl)]
