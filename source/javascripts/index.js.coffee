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
