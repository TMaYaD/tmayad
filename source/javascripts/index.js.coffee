#= require quintus/lib/quintus
#= require quintus/lib/quintus_sprites
#= require quintus/lib/quintus_scenes
#= require quintus/lib/quintus_input
#
#= require quintus/lib/quintus_2d
#= require quintus_kinematics

POLYGON_POINTS = 6
RADIUS = 10

$ ->
  width = $('section.stretch').innerWidth()
  height = $('section.stretch').innerHeight()
  $('canvas').attr
    width: width
    height: height
  Q = Quintus().include('Sprites, Scenes, 2D, Input, Kinematics')
    .setup('paranoid')
    .controls()

  Q.Sprite.extend 'Ball',
    init: (p)->
      @_super p,
        w: RADIUS * 2
        h: RADIUS * 2
        color: '#000000'
        gravity: 0
        points: [RADIUS*Math.cos(2*Math.PI*i/POLYGON_POINTS), RADIUS*Math.sin(2*Math.PI*i/POLYGON_POINTS)] for i in [1..POLYGON_POINTS]
      @add '2d, aiBounce, aiVerticalBounce'
      @on 'bump.bottom', @, 'restart'

    draw: (ctx)->
      ctx.beginPath()
      ctx.fillStyle = @p.color
      ctx.arc(0, 0, @p.cx, 0, 2*Math.PI)
      ctx.fill()

    step: (dt)->
      #@p.x += @p.dx * dt
      #@p.y += @p.dy * dt

    restart: (col)->
      Q.stageScene 'level1' if col.obj.isA 'Wall'

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
        v: 0
      Q.input.on 'left', @, 'left'
      Q.input.on 'right', @, 'right'

    draw: (ctx)->
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    step: (ctx)->
      @p.x += @p.v
      @p.v = @p.v / 2
      @p.x = Math.min(width - 100, Math.max(100, @p.x))

    left: ->
      @p.v = Math.max(@p.v-10, -200)

    right: ->
      @p.v = Math.min(@p.v+10, 200)

  Q.Sprite.extend 'Brick',
    init: (p)->
      @_super p,
        health: 1
        w: 48
        h: 18
      @on 'hit', @, 'break'

    draw: (ctx)->
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

    break: (col)->
      @p.health -= 1

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
      vx: Math.random() * 200 - 100
      vy: Math.random() * 50 + 50

    for i in [1..30]
      stage.insert new Q.Brick
        x: Math.round(Math.random() * width * 3 / 200) * 50 + width / 8
        y: Math.round(Math.random() * height / 40) * 20

  Q.stageScene 'level1'
