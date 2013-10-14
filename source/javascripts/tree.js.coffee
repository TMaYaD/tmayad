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
      @target_found = true
    else
      if node.children
        node.children.some (child)=>
          @recur_for_ancestors child
          if @target_found
            @ancestors.unshift(node)
            unless @siblings_found
              @get_siblings node, child
              @siblings_found = true
          @target_found


  parse_target: (node)->

  get_siblings: (parent, target)->
    parent.children.forEach (child)=>
      @siblings.push child unless child == target
