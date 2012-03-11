@field = new TangentField
$field = null
dims = null
hue = 0.7
COLOR_STEP = 1/256

@update = ->
  hue += COLOR_STEP
  if hue > 1 then hue = hue - 1
  color = Color.hsl(hue, 1, .5)
  $field.text(field.step().toString()).css('color', color)

getDimensions = () ->
  $dummy = $field.clone().text('0').css(visibility: 'hidden')
  $dummy.appendTo('body')
  size = [$dummy.width(), parseInt($dummy.css('line-height'), 10)]
  $dummy.remove()
  return size

position = (x, y) -> [Math.floor(x/dims[0]), Math.floor(y/dims[1])]

$ ->
  $window = $(window)
  $field = $('#field')

  $window.resize((e) ->
    dims = getDimensions()
    [w, h] = position($window.width(), $window.height())
    field.resize(w, h)
    $field.text(field.toString())
  ).trigger('resize')

  $window.mousemove (e) ->
    [x, y] = position(e.clientX, e.clientY)
    field.move(new Vector(x, y))

  $window.click (e) ->
    [x, y] = position(e.clientX, e.clientY)
    field.click(new Vector(x, y))

  tick = setInterval("update()", 100)
