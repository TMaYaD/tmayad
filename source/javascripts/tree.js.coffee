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
      @target_found = true
    else
      if node.children
        node.children.some (child)=>
          @recur_for_ancestors child
          @ancestors.unshift(node) if @target_found
          @target_found


  parse_target: (node)->

  parse_siblings: (node)->
