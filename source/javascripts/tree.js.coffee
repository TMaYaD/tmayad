class window.Tree
  ancestors: []
  siblings: []

  nodes: []
  links: []

  constructor: (json, opts={})->
    @root = json

  parse: (opts)->
    @target = opts['target']
    @recur_for_ancestors @root

  recur_for_ancestors: (node)->
    if node.name == @target
      @parse_target node
      @parse_siblings node
    else
      @ancestors.push node
      if node.children
        node.children.forEach (child)=>
          child.parent = node
          @recur_for_ancestors child

  parse_target: (node)->

  parse_siblings: (node)->
