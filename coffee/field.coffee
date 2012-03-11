resize = (arr, len, make) ->
  delta = len - arr.length
  if delta > 0 then arr.push(make(i)) for i in [0..delta-1]
  if delta < 0 then arr.pop() for i in [delta+1..0] # TODO: Does this work?

arrayOf = (len, make) -> make(i) for i in [0..len-1]

class @Field
  constructor: -> @values = []

  resize: (cols, rows) =>
    # Mark new cells as dirty
    for y in [0..rows]
      if y >= @values.length
        for x in [0..cols]
          @mark(new Vector(x, y))
      else
        for x in [@values[y].length..cols]
          @mark(new Vector(x, y))

    vec = (y) => (x) => new Vector(x, y)
    # If we're adding rows, we want to resize existing columns first
    # and then add a bunch of already-correctly-sized columns
    if rows >= @values.length
      _.map(@values, (row, y) -> resize(row, cols, vec(y)))
      resize(@values, rows, (y) -> arrayOf(cols, vec(y)))
    # If we're dropping rows, we want to drop them before wasting time
    # resizing the columns
    else
      resize(@values, rows, (y) -> arrayOf(cols, vec(y)))
      _.map(@values, (row, y) -> resize(row, cols, vec(y)))
    return this

  value: () =>
    pos = Vector.from(arguments)
    @values[pos.y]?[pos.x]

  toString: => (row.join("") for row in @values).join("\n")

CURSOR_RADIUS = 5
CURSOR_INTENSITY = 7
intensity = (pos, src) ->
  delta = pos.minus(src).magSquared()
  ratio = 1 - (delta / (CURSOR_RADIUS * CURSOR_RADIUS))
  return ratio * CURSOR_ITENSITY


class @CursorField extends Field
  constructor: ->
  step: (source) ->






  neighbors: (v, options) =>
    vec = Vector.from(v)
    # Options look as follows:
    # limit: "adjacent" | "diagonal" (default both)
    # missing: function | value (default prune)
    neighbors = []
    unlimited = not options?.limit?
    get = (x, y) => @value(vec.plus(x, y), options?.missing)
    if unlimited or options.limit == "adjacent"
      neighbors.push(get(0, 1))
      neighbors.push(get(0, -1))
      neighbors.push(get(-1, 0))
      neighbors.push(get(1, 0))
    if unlimited or options.limit == "diagonal"
      neighbors.push(get(1, 1))
      neighbors.push(get(-1, 1))
      neighbors.push(get(1, -1))
      neighbors.push(get(-1, -1))
    _.filter(neighbors, (x) -> x != undefined)

  evolve: (pos, val) =>
    if val > 0
      val *= .9
    if val < .05
      val = 0
