Quintus.Tab = (Q)->
  Q.Sprite.extend 'Tab',
    init: (p)->
      @_super p,
        w: 3 * Quintus.Brick.WIDTH - 2
        h: 2 * Quintus.Brick.HEIGHT - 2
        name: ''
      @on 'hit', @, 'navigate'
      @on 'touch', @, 'navigate'

    draw: (ctx)->
      ctx.fillStyle = "rgba(128, 192, 64, 0.8)"
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h
      ctx.fillStyle = '#FFFFFF'
      ctx.textAlign = 'center'
      ctx.textBaseline = 'middle'
      ctx.font = "#{@p.h/2}px Roboto"
      ctx.fillText @p.name, 0, 0

    navigate: ->
      location.pathname = @p.location if @p.location
