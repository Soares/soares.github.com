onCells = {}
$glider = undefined
cell = (x, y) -> $('td', $('tr', $glider).eq(y)).eq(x).find('a')
index = 0

gliders = [
  [[0, 1, 0], [2, 0, 0], [3, 4, 5]],
  [[1, 0, 5], [2, 3, 0], [0, 4, 0]],
  [[1, 0, 0], [2, 0, 5], [3, 4, 0]],
  [[0, 0, 1], [2, 3, 0], [0, 4, 5]],
]

iterate = ->
  index = (index + 1) % gliders.length
  desc = gliders[index]
  cell.detach() for idx, cell of onCells
  $('tr', $glider).each (y, row) ->
    $('td', row).each (x, cell) ->
      if desc[y][x] != 0
        $(cell).append(onCells[desc[y][x]])

$ ->
  $card = $('#card')
  $more = $('#more')
  $forward = $('#to-more')
  $back = $('#to-card')
  $glider = $('#glider')

  for y in [0...gliders[index].length]
    for x in [0...gliders[index][y].length]
      if gliders[index][y][x] > 0
        onCells[gliders[index][y][x]] = cell(x, y)

  $forward.append(' »').click (e) ->
    e.stopPropagation()
    $card.slideToggle 'fast', ->
      $more.slideToggle('fast')
    false

  $back.prepend('« ').click (e) ->
    e.stopPropagation()
    $more.slideToggle 'fast', ->
      $card.slideToggle('fast')
    false

  $('#iterate').click (e) ->
    e.stopPropagation()
    iterate()
