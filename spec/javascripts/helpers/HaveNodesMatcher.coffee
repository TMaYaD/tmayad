beforeEach ->
  @addMatchers toHaveNodes: (expected) ->
    expected_nodes = expected.map (name)->
      { name: name }

    expect(@actual).toMatchJson expected_nodes
