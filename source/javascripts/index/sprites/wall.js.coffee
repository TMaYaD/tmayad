Quintus.Wall = (Q)->
  Q.Sprite.extend 'Wall',
    draw: (ctx)->
      ctx.fillRect -@p.cx, -@p.cy, @p.w, @p.h

