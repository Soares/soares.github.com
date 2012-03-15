$ ->
  $card = $('#card')
  $more = $('#more')
  $forward = $('#to-more')
  $back = $('#to-card')

  $forward.append(' »')
  $back.prepend('« ')

  $forward.click (e) ->
    $card.slideToggle 'fast', ->
      $more.slideToggle('fast')
    e.stopPropagation()
    false

  $back.click (e) ->
    $more.slideToggle 'fast', ->
      $card.slideToggle('fast')
    e.stopPropagation()
    false
