#= require ./JsonMatcher

jasmine.Matchers::toHaveNodes = (expected) ->
  expected_nodes = expected.map (name)->
    { name: name }
  expected_nodes.unordered = expected.unordered

  expected_matcher = new @env.JsonMatcher expected_nodes
  result = expected_matcher.matches @actual

  @message = expected_matcher.message unless result
  result
