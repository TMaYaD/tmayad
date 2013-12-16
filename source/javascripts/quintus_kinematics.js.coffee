#= require quintus/lib/quintus

Quintus['Kinematics'] = (Q)->
  Q.component 'aiVerticalBounce',
    added: ->
      @entity.on 'bump.top', @, 'goDown'
      @entity.on 'bump.bottom', @, 'goUp'

    goDown: (col)->
      @entity.p.vy = col.impact
      if @entity.p.defaultDirection == 'up'
        @entity.p.flip = 'y'
      else
        @entity.p.flip = false

    goUp: (col)->
      @entity.p.vy = -col.impact
      if @entity.p.defaultDirection == 'down'
        @entity.p.flip = 'y'
      else
        @entity.p.flip = false



