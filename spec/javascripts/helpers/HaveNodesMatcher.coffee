#= require ./JsonMatcher

jasmine.Matchers::toHaveNodes = (expected) ->
  expected_matcher = new @env.JsonMatcher expected.map (name)->
    { name: name }

  result = expected_matcher.matches @actual

  @message = expected_matcher.message unless result
  result
