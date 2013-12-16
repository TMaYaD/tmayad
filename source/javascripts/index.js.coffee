#= require quintus/lib/quintus
#= require quintus/lib/quintus_sprites
#= require quintus/lib/quintus_scenes
#= require quintus/lib/quintus_input
#
#= require quintus/lib/quintus_2d
#= require quintus_kinematics

POLYGON_POINTS = 6
RADIUS = 10
PADDLE_FORCE = 600
PADDLE_MAX_VELOCITY = 300
BRICK_HEIGHT = 20
BRICK_WIDTH = 50

$ ->
  width = $('section.stretch').innerWidth()
  height = $('section.stretch').innerHeight()
  $('canvas').attr
    width: width
    height: height

  Q = Quintus().include('Sprites, Scenes, 2D, Input, Kinematics')
    .setup('paranoid')

  Q.input.keyboardControls()

  Q.input.touchControls
    controls: [
      ["left", "<"]
      []
      []
      []
      ["right", ">"]
    ]

  Q.Sprite.extend 'Ball',
    init: (p)->
      @_super p,
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
        @p.x = Math.random() * width
        @p.y = Math.random() * height / 4 + height/2
        @p.vx = Math.random() * 300 - 150
        @p.vy = Math.random() * 75 + 75

  Q.Sprite.extend 'Wall',
    draw: (ctx)->
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

  Q.Sprite.extend 'Paddle',
    init: (p)->
      @_super p,
        x: width/2
        y: height - 20
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
      @p.fx = -PADDLE_FORCE

    keyUp: ->
      @p.fx = 0

    right: ->
      @p.fx = PADDLE_FORCE

    step: (dt)->
      friction = if @p.vx > 0
          @p.ax = -.6 * PADDLE_FORCE
        else if @p.vx < 0
          @p.ax = .6 * PADDLE_FORCE
        else
          @p.ax = 0
      @p.ax = @p.fx + friction
      @p.vx = Math.max(-PADDLE_MAX_VELOCITY, Math.min(PADDLE_MAX_VELOCITY, @p.vx))

    hit: (col)->
      if col.obj.isA 'Ball'
        ball = col.obj.p
        ball.vx = (ball.vx + 0.3 * @p.vx)/1.3

      @p.y = height - 20

  Q.Sprite.extend 'Brick',
    init: (p)->
      @_super p,
        health: 1
        w: BRICK_WIDTH - 2
        h: BRICK_HEIGHT - 2
      @on 'hit', @, 'break'

    draw: (ctx)->
      color = @p.health/5 + 0.2
      ctx.fillStyle = "rgba(0, 0, 0, #{color})"
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    break: (col)->
      @p.health -= 1

      if Q('Brick').length == 1
        Q.stageScene 'level1'
      else
        @stage.remove @ if @p.health <= 0

  Q.Sprite.extend 'Tab',
    init: (p)->
      @_super p,
        w: 5 * BRICK_WIDTH - 2
        h: 3 * BRICK_HEIGHT - 2
      @on 'hit'

    draw: (ctx)->
      ctx.fillStyle = "rgba(128, 192, 64, 0.8)"
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    hit: (col)->
      console.log col

  Q.scene 'level1', (stage)->
    # Left Wall
    stage.insert new Q.Wall
      x: -22
      y: height/2
      w: 50
      h: height
    # Top Wall
    stage.insert new Q.Wall
      x: width/2
      y: -22
      w: width
      h: 50
    # Right Wall
    stage.insert new Q.Wall
      x: width+22
      y: height/2
      w: 50
      h: height
    # Floor
    stage.insert new Q.Wall
      x: width/2
      y: height+22
      w: width
      h: 50

    paddle = stage.insert new Q.Paddle

    stage.insert new Q.Ball
      x: Math.random() * width
      y: Math.random() * height / 4 + height/2
      vx: Math.random() * 300 - 150
      vy: Math.random() * 75 + 75

    stage.insert new Q.Tab
      x: width/2
      y: height * 5/16

    number_of_bricks = 0.3 * (width * height) * (9 / 32) / (BRICK_HEIGHT * BRICK_WIDTH)

    for i in [1..number_of_bricks]
      xScale = width * 3 / 4
      xOffset = width * 1 / 2
      yScale = height * 3 / 8
      yOffset = height * 5 / 16

      x = (Math.random() - 0.5) * xScale
      y = (Math.random() - 0.5) * yScale

      while obj = Q.stage().locate(x + xOffset, y + yOffset)
        x = 2 * x - obj.p.x
        y = 2 * y - obj.p.y

        if x < -xScale/2 || x > xScale/2
          x = Math.random() * xScale - xScale/2
        if y < -yScale/2 || y > yScale/2
          y = Math.random() * yScale - yScale/2

      x = (Math.round(x / BRICK_WIDTH) * BRICK_WIDTH)
      y = (Math.round(y / BRICK_HEIGHT) * BRICK_HEIGHT)

      stage.insert new Q.Brick
        x: x + xOffset
        y: y + yOffset
        health: Math.floor(Math.random() * 4)

  Q.stageScene 'level1'
