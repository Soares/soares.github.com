$ -> doc = $.get 'more.html', (page) -> initialize $('#more', page)
initialize = ($more) ->
  $card = $('#card')
  $card.after($more)
  @glide($('#glider'))

  $forward = $('#to-more')
  $back = $('#to-card')

  $forward.click (e) ->
    e.stopPropagation()
    $card.slideToggle 'fast', ->
      $more.slideToggle('fast')
    false

  $back.click (e) ->
    e.stopPropagation()
    $more.slideToggle 'fast', ->
      $card.slideToggle('fast')
    false
