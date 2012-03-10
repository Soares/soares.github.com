upLeft = Vector(-1, -1)
upRight = Vector(-1, 1)

evolve = (field, pos, val) ->
  x = field.value(pos.plus(upLeft))
  y = field.value(pos.plus(upRight))
  val.set(x, y)
  return [x, y]

class PascalValue
  constructor: ->
    @jiggling = 0
    @calculated = false
  hover: => ...
  value: => ...
  evolve: (field, pos) =>
    touched = []
    if @jiggling == -1
      touched = around(pos)
      field.value(vec)?.poke() for vec in beside(pos)
      field.value(vec)?.touch() for vec in near(pos)




    x = field.value(pos.plus(upLeft))
    y = field.value(pos.plus(upRight))
    val.set(x, y)
    return [x, y]

even = (num) -> num % 2 is 0
rowOfZeroes = (num) ->
  row = []
  if num <= 0 then return row
  while (num--) row[i] = 0
  return row
resizeArray = (arr, size, make) ->
  diff = size - arr.length
  if diff > 0
    while (diff--) arr.pop()
  else
    while (diff++) arr.push(make())


class Field
  constructor: (width, height) ->
    @_matrix = rowOfZeroes(width) for _ in [0..height]

  width: => if @_matrix.length is 0 then 0 else @_matrix[0].length

  height: => @_matrix.length

  resize: (width, height) =>
    @_matrix = resizeArray(@_matrix, height, () -> rowOfZeroes(width))
    resizeArray(row, width, () -> 0) for row in @_matrix

  flow: (row, col, spread) =>
    if spread == 1
      @increment(row, col)
    else
      @update(row, col+i) for i in [0..spread]
    if row < @height()
      @flow(row+1, if even(row) then col-1 else col, spread+1)

  update: (row, col) =>
    [a, b] = if even(row) then [-1, 0] else [0, 1]
    x = @_matrix[row-1]?[col+a]
    y = @_matrix[row-1]?[col+b]
    @_matrix[row][col] = (x ? 0) + (y ? 0)


  reflow: =>
    update(row, col) for col in [0..@width()] for row in [0..@height()]

  increment: (row, col) =>
    @_matrix[row]?[col] += 1

  toString: => @_matrix.join("\n")
