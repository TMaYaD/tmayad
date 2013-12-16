#= require quintus/lib/quintus
#= require quintus/lib/quintus_sprites
#= require quintus/lib/quintus_scenes
#= require quintus/lib/quintus_input
#
#= require quintus/lib/quintus_2d
#= require quintus_kinematics

POLYGON_POINTS = 6
RADIUS = 10
PADDLE_FORCE = 400

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

    hit: (col)->
      if col.obj.isA 'Ball'
        ball = col.obj.p
        ball.vx += 0.4 * @p.vx

  Q.Sprite.extend 'Brick',
    init: (p)->
      @_super p,
        health: 1
        w: 48
        h: 18
      @on 'hit', @, 'break'

    draw: (ctx)->
      ctx.fillStyle = "rgba(0, 0, 0, #{@p.health/5 + 0.2})"
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    break: (col)->
      @p.health -= 1

      if Q('Brick').length == 1
        Q.stageScene 'level1'
      else
        @stage.remove @ if @p.health == 0

  Q.scene 'level1', (stage)->
    stage.insert new Q.Wall
      x: 0
      y: height/2
      w: 5
      h: height
    stage.insert new Q.Wall
      x: width/2
      y: 0
      w: width
      h: 5
    stage.insert new Q.Wall
      x: width
      y: height/2
      w: 5
      h: height

    stage.insert new Q.Wall
      x: width/2
      y: height
      w: width
      h: 5

    paddle = stage.insert new Q.Paddle

    stage.insert new Q.Ball
      x: Math.random() * width
      y: Math.random() * height / 4 + height/2
      vx: Math.random() * 300 - 150
      vy: Math.random() * 75 + 75

    for i in [1..30]
      stage.insert new Q.Brick
        x: Math.round(Math.random() * width * 3 / 200) * 50 + width / 8
        y: Math.round(Math.random() * height * 3/ 160) * 20 + height / 8

    for i in [1..20]
      stage.insert new Q.Brick
        x: Math.round(Math.random() * width * 3 / 200) * 50 + width / 8
        y: Math.round(Math.random() * height * 3/ 160) * 20 + height / 8
        health: 2

    for i in [1..10]
      stage.insert new Q.Brick
        x: Math.round(Math.random() * width * 3 / 200) * 50 + width / 8
        y: Math.round(Math.random() * height * 3/ 160) * 20 + height / 8
        health: 3

  Q.stageScene 'level1'
