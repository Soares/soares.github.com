# Display variables (tweak these for different effects)
# gradient = [' ','·','·','·','·','·','·','o','0','0']
gradient = [' ', '·','~','¢','c','»','¤','X','M','¶']
gradient = [' ','.',':',';','c','<','«','¤','#','8']
CURSOR_RADIUS = 10
CURSOR_ZONE = CURSOR_RADIUS * CURSOR_RADIUS
CURSOR_INTENSITY = gradient.length
DECAY_RATE = .25
decay = (val) -> if val < .5 then 0 else val * (1-DECAY_RATE)


# Helper functions
arrayOf = (len, empty) -> empty(i) for i in [0..len-1]
resize = (arr, len, empty) ->
  delta = len - arr.length
  if delta > 0
    args = [arr.length, 0].concat(empty(i) for i in [0...delta])
    Array.prototype.splice.apply(arr, args)
  else arr.splice(len, delta)
distSquared = (v, w, p) ->
  if v.equals(w) then return p.distSquared(v)
  t = p.minus(v).dot(w.minus(v)) / w.distSquared(v)
  if t < 0 then return p.distSquared(v)
  else if t > 1 then return p.distSquared(w)
  q = v.plus(w.minus(v).scale(t))
  return p.distSquared(q)
distToPath = (v, w, p) ->
  if v.equals(w) then return CURSOR_ZONE + 1
  # Uncomment to keep the dot around:
  if v.equals(w) then return p.distSquared(v)
  t = p.minus(v).dot(w.minus(v)) / w.distSquared(v)
  q = v.plus(w.minus(v).scale(t))
  return p.distSquared(q)



# Base field class
class @Field
  constructor: -> @values = []
  empty: (x, y) -> 0

  move: (@source) =>
  click: (@hit) =>
  resize: (cols, rows) =>
    # If we're adding rows, we want to resize existing columns first
    # and then add a bunch of already-correctly-sized columns
    make = @empty
    if rows >= @values.length
      _.map(@values, (row, y) -> resize(row, cols, (x) -> make(x, y)))
      resize(@values, rows, (y) -> arrayOf(cols, (x) -> make(x, y)))
    # If we're dropping rows, we want to drop them before wasting time
    # resizing the columns
    else
      resize(@values, rows, (y) -> arrayOf(cols, (x) -> make(x, y)))
      _.map(@values, (row, y) -> resize(row, cols, (x) -> make(x, y)))
    return this

  value: (x, y) => @values[y]?[x]

  step: -> this

  show: (val) -> val
  toString: =>
    ((@show val for val in row).join("") for row in @values).join("\n")

# Cursor-specific field
class @CursorField extends Field
  step: =>
    return this unless @source?
    v = @store ? @source
    w = @source
    for i in [0...@values.length]
      for j in [0...@values[i].length]
        sqdist = distToPath(v, w, new Vector(j, i))
        ratio = if sqdist >= CURSOR_ZONE then 0 else 1 - (sqdist / CURSOR_ZONE)
        intensity = ratio * CURSOR_INTENSITY
        @values[i][j] = Math.max(intensity, decay(@values[i][j]))
    @store = @source
    return this
  show: (val) -> gradient[Math.min(CURSOR_INTENSITY-1, Math.round(val))]

# Pascall's triangle field
class @TriangleField extends Field
  empty: (x, y) => if x % 2 == y % 2 then 0 else -1
  show: (val) -> if val >= 0 then val % 10 else " "
  click: (pos) =>
    x = Math.round(pos.x)
    y = Math.round(pos.y)
    if x % 2 != y % 2
      neighbors = _.map([
        new Vector(x-1, y)
        new Vector(x+1, y)
        new Vector(x, y-1)
        new Vector(x, y+1)
      ], (v) -> [v.distSquared(pos), v]).sort()
      x = neighbors[0][1].x
      y = neighbors[0][1].y
    @values[y]?[x] += 1
  step: =>
    for i in [@values.length-1..0]
      for j in [0...@values[i].length]
        continue unless i % 2 == j % 2
        a = @value(j-1, i-1) ? 0
        b = @value(j+1, i-1) ? 0
        @values[i][j] = Math.max(@values[i][j], a + b)
    return this

# Both fields!
class @Both extends Field
  constructor: (@cursor, @triangle) -> super
  empty: (x, y) => [0, -1]
  resize: =>
    @cursor.resize.apply(this, arguments)
    @triangle.resize.apply(this, arguments)
    super
  move: =>
    @cursor.move.apply(this, arguments)
    @triangle.move.apply(this, arguments)
  click: =>
    @cursor.click.apply(this, arguments)
    @triangle.click.apply(this, arguments)
  step: =>
    @triangle.step()
    @cursor.step()
    for i in [0...@values.length]
      for j in [0...@values[i].length]
        @values[i][j] = [@cursor.values[i]?[j], @triangle.values[i]?[j]]
    return this
  show: ([c, t]) ->
    if t > 0 then return @triangle.show(t)
    if c > 0 and t == 0 then return @cursor.show(c)
    if c > 0 and t < 0 then return "·"
    return " "
