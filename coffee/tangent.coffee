GRADIENT = [' ','.',':',';','c','<','«','¤','#','8']
CURSOR_RADIUS = 12
DECAY_RATE = .25

zone = CURSOR_RADIUS * CURSOR_RADIUS

distToPath = (v, w, p) ->
  if v.equals(w) then return zone + 1
  # Alternatively, we could keep a constant halo around the cursor
  # by uncommenting this line:
  # if v.equals(w) then return p.distSquared(v)
  t = p.minus(v).dot(w.minus(v)) / w.distSquared(v)
  # Make it simply follow the cursor by uncommenting these lines:
  if t < 0 then return p.distSquared(v)
  if t > 1 then return p.distSquared(w)
  q = v.plus(w.minus(v).scale(t))
  return p.distSquared(q)

decay = (val) -> if val < .5 then 0 else val * (1-DECAY_RATE)

messages = [
  ["Hey there!", .8, .3],
  ["Follow me on twitter: So8res", .2, .9],
  ["You can't stop the signal", .9, .95],
  ["Secrets, secrets", 0, 0],
]

class @TangentField extends Field
  width: => @values[0]?.length ? 0
  height: => @values.length
  drawingRules: ([m, w, h]) =>
    width = @width()
    height = @height()
    half = m.length / 2
    maxw = width - m.length
    w = Math.round(Math.max(0, Math.min(maxw, w * width - half)))
    h = Math.round(Math.max(0, Math.min(height-1, h * height)))
    return [m, h, w, w + m.length]

  step: =>
    return this unless @source?
    v = @store ? @source
    w = @source
    for i in [0...@values.length]
      for j in [0...@values[i].length]
        sqdist = distToPath(v, w, new Vector(j, i))
        ratio = if sqdist >= zone then 0 else 1 - (sqdist / zone)
        intensity = ratio * GRADIENT.length
        @values[i][j] = Math.max(intensity, decay(@values[i][j]))
    @store = @source
    return this
  show: (x, y, val) ->
    if Math.round(val) == 0 then return GRADIENT[0]
    if val >= GRADIENT.length-3
      for message in messages
        [m, h, w, e] = @drawingRules(message)
        if y == h and x >= w and x < e then return m[x - w]
    GRADIENT[Math.min(GRADIENT.length-1, Math.round(val))]
