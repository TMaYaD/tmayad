POLYGON_POINTS = 6
RADIUS = 10

Quintus.Ball = (Q)->
  Q.Sprite.extend 'Ball',
    init: (p)->
      @_super p,
        x: Math.random() * Q.width
        y: Math.random() * Q.height / 4 + Q.height/2
        vx: Math.random() * Quintus.Paddle.MAX_VELOCITY - Quintus.Paddle.MAX_VELOCITY / 2
        vy: Math.random() * Quintus.Paddle.MAX_VELOCITY / 2 + Quintus.Paddle.MAX_VELOCITY /2
        w: RADIUS * 2
        h: RADIUS * 2
        gravity: 0
        points: [RADIUS*Math.cos(2*Math.PI*i/POLYGON_POINTS), RADIUS*Math.sin(2*Math.PI*i/POLYGON_POINTS)] for i in [1..POLYGON_POINTS]
      @add '2d, aiBounce, aiVerticalBounce'
      @on 'bump.bottom', @, 'restart'

    draw: (ctx)->
      ctx.beginPath()
      ctx.fillStyle = '#0099CC'
      ctx.arc(0, 0, @p.cx, 0, 2*Math.PI)
      ctx.fill()

    restart: (col)->
      if col.obj.isA 'Wall'
        @p.x = Math.random() * Q.width
        @p.y = Math.random() * Q.height / 4 + Q.height/2
        @p.vx = Math.random() * 300 - 150
        @p.vy = Math.random() * 75 + 75

