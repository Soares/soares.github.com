arrayOf = (len, empty) -> empty(i) for i in [0..len-1]

resize = (arr, len, empty) ->
  delta = len - arr.length
  if delta > 0
    args = [arr.length, 0].concat(empty(i) for i in [0...delta])
    Array.prototype.splice.apply(arr, args)
  else arr.splice(len, delta)


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
  show: (x, y, val) -> val
  toString: =>
    one = (y, row) => (@show(x, y, row[x]) for x in [0...row.length]).join('')
    (one(y, @values[y]) for y in [0...@values.length]).join('\n')
