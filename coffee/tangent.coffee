GRADIENT = [' ','.',':',';','c','<','«','¤','#','8']
CURSOR_RADIUS = 10
DECAY_RATE = .25


zone = CURSOR_RADIUS * CURSOR_RADIUS

distToPath = (v, w, p) ->
  if v.equals(w) then return zone + 1
  # Alternatively, we could keep a constant halo around the cursor
  # by uncommenting this line:
  # if v.equals(w) then return p.distSquared(v)
  t = p.minus(v).dot(w.minus(v)) / w.distSquared(v)
  q = v.plus(w.minus(v).scale(t))
  return p.distSquared(q)

decay = (val) -> if val < .5 then 0 else val * (1-DECAY_RATE)

class @TangentField extends Field
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
  show: (val) -> GRADIENT[Math.min(GRADIENT.length-1, Math.round(val))]
