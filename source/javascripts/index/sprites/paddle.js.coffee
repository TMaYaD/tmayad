Quintus.Paddle = (Q)->
  Q.Sprite.extend 'Paddle',
    init: (p)->
      @_super p,
        x: Q.width/2
        y: Q.height - 20
        w: 200
        h: 10
        fx: 0
        gravity: 0

      @add '2d'
      Q.input.on 'left', @, 'left'
      Q.input.on 'leftUp', @, 'keyUp'
      Q.input.on 'right', @, 'right'
      Q.input.on 'rightUp', @, 'keyUp'
      @on 'hit', @, 'hit'

    draw: (ctx)->
      ctx.fillStyle = '#99cc00'
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    left: ->
      @p.fx = -Quintus.Paddle.FORCE

    keyUp: ->
      @p.fx = 0

    right: ->
      @p.fx = Quintus.Paddle.FORCE

    step: (dt)->
      friction = if @p.vx > 0
          @p.ax = -.6 * Quintus.Paddle.FORCE
        else if @p.vx < 0
          @p.ax = .6 * Quintus.Paddle.FORCE
        else
          @p.ax = 0
      @p.ax = @p.fx + friction
      @p.vx = Math.max(-Quintus.Paddle.MAX_VELOCITY, Math.min(Quintus.Paddle.MAX_VELOCITY, @p.vx))

    hit: (col)->
      if col.obj.isA 'Ball'
        ball = col.obj.p
        ball.vx = (ball.vx + 0.3 * @p.vx)/1.3

      @p.y = Q.height - 20

Quintus.Paddle.FORCE = 900
Quintus.Paddle.MAX_VELOCITY = 500

