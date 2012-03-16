(function() {
  var $dot, $halo, BASE_D, BASE_H, BASE_W, DELTA_D, DELTA_H, DELTA_W, FPS, RESOLUTION, Vector, closer, cur, pos, time,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  FPS = 40;

  RESOLUTION = 15;

  BASE_H = 7;

  DELTA_H = 3;

  BASE_W = 3;

  DELTA_W = 1.5;

  BASE_D = 4.3;

  DELTA_D = 1.2;

  Vector = (function() {

    function Vector(x, y) {
      this.x = x != null ? x : 0;
      this.y = y != null ? y : 0;
      this.magSquared = __bind(this.magSquared, this);
      this.scale = __bind(this.scale, this);
      this.minus = __bind(this.minus, this);
      this.plus = __bind(this.plus, this);
      this.subtract = __bind(this.subtract, this);
      this.add = __bind(this.add, this);
    }

    Vector.prototype.add = function(vec) {
      this.x += vec.x;
      this.y += vec.y;
      return this;
    };

    Vector.prototype.subtract = function(vec) {
      this.x -= vec.x;
      this.y -= vec.y;
      return this;
    };

    Vector.prototype.plus = function(vec) {
      return new Vector(this.x + vec.x, this.y + vec.y);
    };

    Vector.prototype.minus = function(vec) {
      return new Vector(this.x - vec.x, this.y - vec.y);
    };

    Vector.prototype.scale = function(s) {
      this.x *= s;
      this.y *= s;
      return this;
    };

    Vector.prototype.magSquared = function() {
      return (this.x * this.x) + (this.y * this.y);
    };

    return Vector;

  })();

  $halo = void 0;

  $dot = void 0;

  pos = new Vector;

  cur = new Vector;

  time = 0;

  closer = function() {
    var delta, theta;
    time++;
    theta = Math.sin(time / RESOLUTION);
    $halo.attr('r', BASE_H + DELTA_H * theta);
    $dot.attr('r', BASE_D + -1 * DELTA_D * theta);
    $halo.attr('stroke-width', BASE_W + DELTA_W * theta);
    delta = pos.minus(cur);
    if (delta.magSquared < 3) return;
    cur.add(delta.scale(.25));
    $dot.attr('cx', cur.x);
    $dot.attr('cy', cur.y);
    $halo.attr('cx', cur.x);
    return $halo.attr('cy', cur.y);
  };

  $(function() {
    var tick;
    $dot = $('#dot');
    $halo = $('#halo');
    cur.x = parseFloat($dot.attr('cx'));
    cur.y = parseFloat($dot.attr('cy'));
    $(window).mousemove(function(e) {
      $dot.css('visibility', 'visible');
      $halo.css('visibility', 'visible');
      pos.x = e.pageX - document.body.scrollLeft;
      return pos.y = e.pageY - document.body.scrollTop;
    });
    return tick = setInterval(closer, FPS === 0 ? 0 : 1000 / FPS);
  });

}).call(this);
(function() {
  var RESOLUTION, TAU,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  TAU = Math.PI * 2;

  RESOLUTION = 15;

  this.Oscilator = (function() {

    function Oscilator(phase, amplitude, frequency, offset) {
      this.phase = phase != null ? phase : 0;
      this.amplitude = amplitude != null ? amplitude : 1;
      this.frequency = frequency != null ? frequency : 1;
      this.offset = offset != null ? offset : 0;
    }

    Oscilator.prototype.value = function(t) {
      return this.offset + this.amplitude * Math.sin((this.frequency * TAU * t) + (this.phase * TAU));
    };

    return Oscilator;

  })();

  this.ColorWheel = (function() {

    function ColorWheel(h, s, l, t) {
      this.h = h;
      this.s = s != null ? s : 1;
      this.l = l != null ? l : .5;
      this.t = t != null ? t : 0;
    }

    ColorWheel.prototype.make = function() {
      return new ColorWheel(this.h, this.s, this.l);
    };

    ColorWheel.prototype.step = function() {
      this.t++;
      return this;
    };

    ColorWheel.prototype.value = function() {
      var h, l, s, time;
      time = this.t / RESOLUTION;
      h = _.isNumber(this.h) ? this.h : this.h.value(time);
      s = _.isNumber(this.s) ? this.s : this.s.value(time);
      l = _.isNumber(this.l) ? this.l : this.l.value(time);
      return Color.hsl(h, s, l).toString();
    };

    return ColorWheel;

  })();

  this.Turtle = (function() {

    function Turtle(pen, x, y, theta) {
      this.pen = pen;
      this.x = x;
      this.y = y;
      this.theta = theta;
      this.forward = __bind(this.forward, this);
      this.look = __bind(this.look, this);
      this.move = __bind(this.move, this);
      this.jump = __bind(this.jump, this);
      this.go = __bind(this.go, this);
      this.step = __bind(this.step, this);
      this.turn = __bind(this.turn, this);
      this.restore = __bind(this.restore, this);
      this.save = __bind(this.save, this);
      this.counter = 0;
    }

    Turtle.prototype.save = function() {
      return {
        x: this.x,
        y: this.y,
        theta: this.theta
      };
    };

    Turtle.prototype.restore = function(state) {
      var attr, val;
      for (attr in state) {
        val = state[attr];
        this[attr] = val;
      }
      return this;
    };

    Turtle.prototype.turn = function(angle) {
      this.theta = (this.theta + angle) % 1;
      return this;
    };

    Turtle.prototype.step = function(size) {
      if (size == null) size = 1;
      this.x += size * Math.cos(this.theta * TAU);
      this.y += size * Math.sin(this.theta * TAU);
      return this;
    };

    Turtle.prototype.go = function(size) {
      if (size == null) size = 1;
      this.step(size);
      this.pen.moveTo(this.x, this.y);
      return this;
    };

    Turtle.prototype.jump = function(x, y) {
      this.x = x;
      this.y = y;
      return this;
    };

    Turtle.prototype.move = function(x, y) {
      this.x += x;
      this.y += y;
      return this;
    };

    Turtle.prototype.look = function(theta) {
      this.theta = theta;
      return this;
    };

    Turtle.prototype.forward = function(size) {
      if (size == null) size = 1;
      this.pen.beginPath();
      this.pen.moveTo(this.x, this.y);
      this.step(size);
      this.pen.lineTo(this.x, this.y);
      this.pen.closePath();
      this.pen.stroke();
      return this;
    };

    return Turtle;

  })();

}).call(this);
(function() {
  var Dragon, Fractal, Plant, Serpinsky, Snowflake, Tree, thits,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Fractal = (function() {

    Fractal.prototype.axiom = '';

    Fractal.prototype.rules = {};

    Fractal.prototype.angle = 1 / 4;

    Fractal.prototype.position = 0;

    function Fractal(pen, x, y, heading, size) {
      var turtle,
        _this = this;
      this.pen = pen;
      this.x = x;
      this.y = y;
      this.step = __bind(this.step, this);
      this.iterate = __bind(this.iterate, this);
      turtle = new Turtle(pen, this.x, this.y, heading, size);
      this.states = [];
      this.colors = this.colors.make();
      this.color = this.colors.value();
      this.progress = 0;
      this.axiom = (this.axiom + '0').split('');
      this.actions = {
        'F': function() {
          return turtle.forward(size);
        },
        'G': function() {
          return turtle.go(size);
        },
        '+': function() {
          return turtle.turn(_this.angle);
        },
        '-': function() {
          return turtle.turn(-_this.angle);
        },
        '[': function() {
          return _this.states.push(turtle.save());
        },
        ']': function() {
          return turtle.restore(_this.states.pop());
        },
        '0': function() {
          return _this.iterate(turtle, size, heading);
        }
      };
    }

    Fractal.prototype.iterate = function(turtle, size, heading) {
      this.color = this.colors.step().value();
      if (typeof this.reset === "function") this.reset(turtle, size, heading);
      this.progress--;
      return this;
    };

    Fractal.prototype.step = function(skip) {
      var symbol, _base, _ref, _ref2;
      this.pen.strokeStyle = this.color;
      symbol = this.axiom.shift();
      this.axiom = this.axiom.concat(((_ref = (_ref2 = this.rules) != null ? _ref2[symbol] : void 0) != null ? _ref : symbol).split(''));
      if (skip) return this;
      if (typeof (_base = this.actions)[symbol] === "function") _base[symbol]();
      this.progress++;
      if (symbol === 'F') {
        return this;
      } else {
        return this.step();
      }
    };

    return Fractal;

  })();

  Dragon = (function(_super) {

    __extends(Dragon, _super);

    Dragon.prototype.axiom = 'FX';

    Dragon.prototype.rules = {
      'X': 'X+YF',
      'Y': 'FX-Y'
    };

    Dragon.prototype.angle = 1 / 4;

    Dragon.prototype.colors = new ColorWheel(new Oscilator(.25, .075, .5, .075));

    function Dragon(pen, x, y, heading, size) {
      this.step = __bind(this.step, this);
      this.reset = __bind(this.reset, this);      this.batching = 0;
      Dragon.__super__.constructor.call(this, pen, x, y, heading, size * 3);
    }

    Dragon.prototype.reset = function() {
      return this.batching = this.progress;
    };

    Dragon.prototype.step = function(skip) {
      var cap, i;
      if (!skip && this.batching > 0) {
        cap = Math.min(100, this.batching);
        for (i = 0; 0 <= cap ? i < cap : i > cap; 0 <= cap ? i++ : i--) {
          this.step(true);
        }
        this.batching -= cap;
        return;
      }
      return Dragon.__super__.step.apply(this, arguments);
    };

    return Dragon;

  })(Fractal);

  Snowflake = (function(_super) {

    __extends(Snowflake, _super);

    function Snowflake() {
      Snowflake.__super__.constructor.apply(this, arguments);
    }

    Snowflake.prototype.axiom = 'F++F++F';

    Snowflake.prototype.rules = {
      'F': 'F-F++F-F'
    };

    Snowflake.prototype.angle = 1 / 6;

    Snowflake.prototype.colors = new ColorWheel(new Oscilator(.125, .08, 1, .54), 1, new Oscilator(.25, .125, .5, .625));

    return Snowflake;

  })(Fractal);

  Plant = (function(_super) {

    __extends(Plant, _super);

    Plant.prototype.axiom = 'FX';

    Plant.prototype.rules = {
      'X': 'F-[[X]+X]+F[+FX]-X',
      'F': 'FF'
    };

    Plant.prototype.angle = -25 / 360;

    Plant.prototype.colors = new ColorWheel(new Oscilator(0, .105, 1, .275));

    function Plant(pen, x, y, heading, size) {
      this.reset = __bind(this.reset, this);      Plant.__super__.constructor.call(this, pen, x, y, heading + 1 / 4, size * 3);
    }

    Plant.prototype.reset = function(turtle, size) {
      turtle.jump(turtle.x + size * .5 * Math.pow(this.progress, .5), this.y).look(this.angle);
      return Plant.__super__.reset.apply(this, arguments);
    };

    return Plant;

  })(Fractal);

  thits = 0;

  Serpinsky = (function(_super) {

    __extends(Serpinsky, _super);

    Serpinsky.prototype.axiom = 'FX';

    Serpinsky.prototype.rules = {
      'X': 'Y-FX-FY',
      'Y': 'X+FY+FX'
    };

    Serpinsky.prototype.angle = -1 / 6;

    Serpinsky.prototype.reset = function() {};

    function Serpinsky(pen, x, y, heading, size) {
      this.reset = __bind(this.reset, this);
      var hue, theta;
      theta = (thits % 6) / 6;
      hue = (thits * .29) % 1;
      this.colors = new ColorWheel(new Oscilator(hue, .5, .265, .76));
      Serpinsky.__super__.constructor.call(this, pen, x, y, heading + theta, size);
      thits++;
    }

    return Serpinsky;

  })(Fractal);

  Tree = (function(_super) {

    __extends(Tree, _super);

    Tree.prototype.axiom = 'FX';

    Tree.prototype.rules = {
      'X': 'F[-FFX]+FX'
    };

    Tree.prototype.angle = 1 / 16;

    Tree.prototype.colors = new ColorWheel(new Oscilator(0, .105, .8, .265));

    function Tree(pen, x, y, heading, size) {
      this.reset = __bind(this.reset, this);      Tree.__super__.constructor.call(this, pen, x, y, heading - 1 / 4, size * 6);
    }

    Tree.prototype.reset = function(turtle, size, heading) {
      return turtle.jump(this.x, this.y).look(heading);
    };

    return Tree;

  })(Fractal);

  this.Fractals = {
    fire: Dragon,
    earth: Tree,
    snow: Snowflake,
    tri: Serpinsky,
    hidden: Plant
  };

}).call(this);
(function() {
  var cells, gliders, index, live;

  live = {};

  cells = [];

  index = 0;

  gliders = [[[0, 1, 0], [2, 0, 0], [3, 4, 5]], [[1, 0, 5], [2, 3, 0], [0, 4, 0]], [[1, 0, 0], [2, 0, 5], [3, 4, 0]], [[0, 0, 1], [2, 3, 0], [0, 4, 5]]];

  this.glide = function($glider) {
    var $cell, $row, iterate, x, y, _ref, _ref2;
    for (y = 0, _ref = gliders[0].length; 0 <= _ref ? y < _ref : y > _ref; 0 <= _ref ? y++ : y--) {
      $row = $('tr', $glider).eq(y);
      cells[y] = [];
      for (x = 0, _ref2 = gliders[0][y].length; 0 <= _ref2 ? x < _ref2 : x > _ref2; 0 <= _ref2 ? x++ : x--) {
        $cell = $('td', $row).eq(x);
        if (gliders[0][y][x] > 0) live[gliders[0][y][x]] = $('a', $cell);
        cells[y][x] = $cell;
      }
    }
    iterate = function() {
      var glider, i, link, x, y, _ref3, _results;
      index = (index + 1) % gliders.length;
      glider = gliders[index];
      for (i in live) {
        link = live[i];
        link.detach();
      }
      _results = [];
      for (y = 0, _ref3 = cells.length; 0 <= _ref3 ? y < _ref3 : y > _ref3; 0 <= _ref3 ? y++ : y--) {
        _results.push((function() {
          var _ref4, _results2;
          _results2 = [];
          for (x = 0, _ref4 = cells[y].length; 0 <= _ref4 ? x < _ref4 : x > _ref4; 0 <= _ref4 ? x++ : x--) {
            if (glider[y][x] !== 0) {
              _results2.push(cells[y][x].append(live[glider[y][x]]));
            } else {
              _results2.push(void 0);
            }
          }
          return _results2;
        })());
      }
      return _results;
    };
    return $('#iterate').click(function(e) {
      e.stopPropagation();
      return iterate();
    });
  };

}).call(this);
(function() {
  var FPS, HEADING, SIZE, fractals, speed, ticker;

  HEADING = 0;

  SIZE = 1;

  FPS = 0;

  speed = FPS === 0 ? 0 : 1000 / FPS;

  fractals = [];

  ticker = 0;

  $(function() {
    var $body, $controls, $fractals, $window, Current, context, go, stop, update;
    go = function() {
      return ticker = ticker || setInterval(update, speed);
    };
    stop = function() {
      fractals = [];
      $controls.removeClass('going').removeClass('paused');
      return ticker = clearInterval(ticker);
    };
    update = function() {
      var fractal, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = fractals.length; _i < _len; _i++) {
        fractal = fractals[_i];
        _results.push(fractal.step());
      }
      return _results;
    };
    context = document.getElementById('canvas').getContext('2d');
    $controls = $('#controls');
    $fractals = $('#fractals');
    $body = $('body');
    $window = $(window).resize(function(e) {
      context.canvas.width = window.innerWidth;
      context.canvas.height = window.innerHeight;
      return stop();
    }).trigger('resize').click(function(e) {
      var x, y;
      if ($controls.is('.paused')) fractals = [];
      $controls.removeClass('paused').addClass('going');
      x = e.pageX - document.body.scrollLeft;
      y = e.pageY - document.body.scrollTop;
      fractals.push(new Current(context, x, y, HEADING, SIZE));
      return go();
    });
    Current = Fractals[$body.attr('class')];
    $('button', $controls.add($fractals)).click(function(e) {
      return e.stopPropagation();
    });
    $('button', $fractals).click(function() {
      var frac;
      frac = $(this).button('toggle').data('fractal');
      Current = Fractals[frac];
      return $body.removeClass().addClass(frac);
    });
    $('.control', $controls).click(function(e) {
      if ($controls.is('.going')) {
        $controls.removeClass('going').addClass('paused');
        return ticker = clearInterval(ticker);
      } else {
        $controls.removeClass('paused').addClass('going');
        return go();
      }
    });
    return $('.clear', $controls).click(function(e) {
      context.clearRect(0, 0, context.canvas.width, context.canvas.height);
      return stop();
    });
  });

}).call(this);
(function() {

  $(function() {
    $('.btn-group').button();
    return $('#fractals').css('display', 'block');
  });

}).call(this);
