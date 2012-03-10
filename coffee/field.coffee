nub = (arr) -> # TODO: Remove duplicates (use vector equality)
concat = (arr) -> # TODO: Flatten

resize = (arr, len, empty) ->
  delta = len - arr.length
  if delta > 0 then arr.push(empty) for _ in [0..delta]
  if delta < 0 then arr.pop() for _ in [abs(delta)..0] # TODO: Does this work?

arrayOf = (len, empty) -> empty() for _ in [0..len]

class Field
  constructor: (@empty) ->
    @values = []
    @dirty = []

  resize: (width, height) =>
    rows = height / TEXT_HEIGHT
    cols = width / TEXT_WIDTH

    # Mark new cells as dirty
    for y in [0..rows]
      if y >= matrix.length
        for x in [0..cols]
          @dirty.push(Vector(x, y))
      else
        for x in [matrix[y].length..cols]
          @dirty.push(Vector(x, y))

    # Increase/decrease the size of existing rows
    resize(row, cols, @empty) for row in @values
    # Add/remove rows as necessary
    resize(@values, rows, () -> arrayOf(cols, @empty))

  toString: => (row.join("") for row in @values).join("")
  value: (vec) => @values[vec.y]?[vec.x]
  step: => @dirty = nub(concat(@value(vec).evolve(this, vec) for vec in @dirty))
