#= require quintus/lib/quintus
#= require quintus/lib/quintus_sprites
#= require quintus/lib/quintus_scenes
#= require quintus/lib/quintus_input
#
#= require quintus/lib/quintus_2d
#= require quintus_kinematics

$ ->
  width = $('section.stretch').innerWidth()
  height = $('section.stretch').innerHeight()
  $('canvas').attr
    width: width
    height: height
  radius = 10
  Q = Quintus().include('Sprites, Scenes, 2D, Input, Kinematics')
    .setup('paranoid')
    .controls()

  Q.Sprite.extend 'Ball',
    init: (p)->
      @_super p,
        x: width/2
        y: height/2
        w: radius * 2
        h: radius * 2
        cx: radius
        cy: radius
        vx: 100
        vy: 100
        color: '#000000'
        gravity: 0
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
      y: Math.random() * height / 2
      vx: Math.random() * 200 - 100
      vy: Math.random() * 50 + 50

  Q.stageScene 'level1'
