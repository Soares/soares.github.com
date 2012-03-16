live = {}
cells = []
index = 0
gliders = [
  [[0, 1, 0], [2, 0, 0], [3, 4, 5]]
  [[1, 0, 5], [2, 3, 0], [0, 4, 0]]
  [[1, 0, 0], [2, 0, 5], [3, 4, 0]]
  [[0, 0, 1], [2, 3, 0], [0, 4, 5]]]

@glide = ($glider) ->
  for y in [0...glider[0].length]
    $row = $('tr', $glider).eq(y)
    cells[y] = []
    for x in [0...glider[0][y].length]
      $cell = $('td', $row).eq(x)
      live[glider[0][y][x]] = $('a', $cell) if glider[0][y][x] > 0
      cells[y][x] = $cell

  iterate = ->
    index = (index + 1) % gliders.length
    glider = gliders[index]
    link.detach() for i, link of live
    for y in [0...cells.length]
      for x in [0...cells[y].length]
        cells[y][x].append(live[glider[y][x]]) if glider[y][x] != 0

  $('#iterate').click (e) ->
    e.stopPropagation()
    iterate()
