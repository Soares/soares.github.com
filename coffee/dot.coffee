$dot = undefined
pos = new Vector
cur = new Vector

closer = ->


$ ->
  $dot = $('#dot')
  $(window).mousemove (e) ->
    pos.x = e.pageX - document.body.scrollLeft
    pos.y = e.pageY - document.body.scrollTop

  closer = ->
    cur.x = parseFloat($dot.attr('cx'))
    cur.y = parseFloat($dot.attr('cy'))
    delta = pos.minus(cur)
    if delta.magSquared < 3 then return
    $dot.attr('cx', cur.x+(delta.x/4))
    $dot.attr('cy', cur.y+(delta.y/4))

  $dot.css('visibility', 'visible')
  tick = setInterval(closer, 25)
