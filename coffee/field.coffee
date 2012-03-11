# Display variables (tweak these for different effects)
gradient = [' ', '·','~','¢','c','»','¤','X','M','¶']
CURSOR_RADIUS_SQUARED = 16
CURSOR_INTENSITY = 9
DECAY_RATE = .95
decay = (val) -> if val < .5 then 0 else val * DECAY_RATE


# Helper functions
arrayOf = (len) -> 0 for i in [0..len-1]
resize = (arr, len, empty) ->
  delta = len - arr.length
  if delta > 0 then arr.push(empty()) for i in [0..delta-1]
  if delta < 0 then arr.pop() for i in [delta+1..0]


# Base field class
class @Field
  constructor: -> @values = []

  resize: (cols, rows) =>
    # If we're adding rows, we want to resize existing columns first
    # and then add a bunch of already-correctly-sized columns
    if rows >= @values.length
      _.map(@values, (row, y) -> resize(row, cols, () -> 0))
      resize(@values, rows, () -> arrayOf(cols))
    # If we're dropping rows, we want to drop them before wasting time
    # resizing the columns
    else
      resize(@values, rows, () -> arrayOf(cols))
      _.map(@values, (row, y) -> resize(row, cols, () -> 0))
    return this

  value: () =>
    pos = Vector.from(arguments)
    @values[pos.y]?[pos.x]

  toString: => (row.join("") for row in @values).join("\n")

distSquared = ([x3, y3], [x1, y1, x2, y2]) ->
  if x1 == x2 and y1 == y2
    return Math.pow(x3-x1, 2) + Math.pow(y3-y1, 2)
  mag = Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2)
  u = ((x3 - x1) * (x2 - x1) + (y3 - y1) * (y2 - y1)) / mag
  x = x1 + u * (x2-x1)
  y = y1 + u * (y2-y1)
  Math.pow(x-x3, 2) + Math.pow(y-y3, 2)

# Cursor-specific field
class @CursorField extends Field
  step: =>
    return this unless @source?
    [x1, y1] = @store ? @source
    [x2, y2] = @source
    for i in [0...@values.length]
      row = @values[i]
      for j in [0...row.length]
        val = row[j]
        sqdist = distSquared([j, i], [x1, y1, x2, y2])
        if sqdist > CURSOR_RADIUS_SQUARED
          ratio = 0
        else
          ratio = 1 - (sqdist / CURSOR_RADIUS_SQUARED)
        intensity = ratio * CURSOR_INTENSITY
        @values[i][j] = Math.max(intensity, decay(val))
    @store = @source
    return this
  toString: =>
    show = (val) -> gradient[Math.min(9, Math.round(val))]
    ((show val for val in row).join("") for row in @values).join("\n")
