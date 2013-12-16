#= require quintus/lib/quintus
#= require quintus/lib/quintus_sprites
#= require quintus/lib/quintus_scenes
#= require quintus/lib/quintus_input
#= require quintus/lib/quintus_touch
#= require quintus/lib/quintus_2d
#= require quintus_kinematics
#
#= require index/sprites/wall
#= require index/sprites/brick
#= require index/sprites/paddle
#= require index/sprites/ball
#= require index/sprites/tab

$ ->
  width = $('section.stretch').innerWidth()
  height = $('section.stretch').innerHeight()
  $('canvas').attr
    width: width
    height: height

  Q = Quintus().include('Sprites, Scenes, 2D, Input, Touch, Kinematics')
    .include('Wall, Brick, Paddle, Ball, Tab')
    .setup('paranoid')

  Q.touch(Q.SPRITE_ALL)

  Q.input.keyboardControls()

  Q.input.touchControls
    controls: [
      ["left", "<"]
      []
      []
      []
      ["right", ">"]
    ]

  Q.scene 'level1', (stage)->
    xInset = Quintus.Brick.WIDTH/2 - Quintus.Brick.GUTTER
    yInset = Quintus.Brick.HEIGHT/2 - Quintus.Brick.GUTTER
    # Left Wall
    stage.insert new Q.Wall
      x: -xInset
      y: Q.height/2
      w: Quintus.Brick.WIDTH
      h: Q.height
    # Top Wall
    stage.insert new Q.Wall
      x: Q.width/2
      y: -yInset
      w: Q.width
      h: Quintus.Brick.HEIGHT
    # Right Wall
    stage.insert new Q.Wall
      x: Q.width+xInset
      y: Q.height/2
      w: Quintus.Brick.WIDTH
      h: Q.height
    # Floor
    stage.insert new Q.Wall
      x: Q.width/2
      y: Q.height+yInset
      w: Q.width
      h: Quintus.Brick.HEIGHT

    paddle = stage.insert new Q.Paddle

    stage.insert new Q.Ball()

    stage.insert new Q.Tab
      x: Q.width/2 - Quintus.Brick.WIDTH * 2
      y: Q.height * 5/16 - Quintus.Brick.HEIGHT/2
      name: 'Projects'
      location: '/projects'

    stage.insert new Q.Tab
      x: Q.width/2 + Quintus.Brick.WIDTH * 2
      y: Q.height * 5/16 - Quintus.Brick.HEIGHT/2
      name: 'Clients'
      location: '/clients'

    number_of_bricks = 0.3 * (Q.width * Q.height) * (9 / 32) / (Quintus.Brick.HEIGHT * Quintus.Brick.WIDTH)
    stage.insert new Q.Brick for i in [1..number_of_bricks]

  Q.stageScene 'level1'
