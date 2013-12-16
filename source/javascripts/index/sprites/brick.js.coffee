Quintus.Brick = (Q)->
  Q.Sprite.extend 'Brick',
    init: (p)->
      defaults = Q._defaults @get_position(),
        health: Math.floor(Math.random() * 4)
        w: Quintus.Brick.WIDTH - Quintus.Brick.GUTTER
        h: Quintus.Brick.HEIGHT - Quintus.Brick.GUTTER

      @_super p, defaults
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

    get_position: ->
      xScale = Q.width * 3 / 4
      xOffset = Q.width * 1 / 2
      yScale = Q.height * 3 / 8
      yOffset = Q.height * 5 / 16

      x = (Math.random() - 0.5) * xScale
      y = (Math.random() - 0.5) * yScale

      while obj = Q.stage().locate(x + xOffset, y + yOffset)
        x = 2 * x - obj.p.x
        y = 2 * y - obj.p.y

        if x < -xScale/2 || x > xScale/2
          x = Math.random() * xScale - xScale/2
        if y < -yScale/2 || y > yScale/2
          y = Math.random() * yScale - yScale/2

      {
        x: (Math.round(x / Quintus.Brick.WIDTH) * Quintus.Brick.WIDTH) + xOffset
        y: (Math.round(y / Quintus.Brick.HEIGHT) * Quintus.Brick.HEIGHT) + yOffset
      }



Quintus.Brick.HEIGHT = 20
Quintus.Brick.WIDTH = 50
Quintus.Brick.GUTTER = 2
