beforeEach ->
  @addMatchers toMatchJson: (expected) ->
    expected = new JsonMatcher expected unless expected.name == 'JsonMatcher'

    expected.matches @actual

class JsonMatcher
  constructor: (expected) ->
    @name = 'JsonMatcher'
    @expected = expected

  matches: (actual)->
    @expected =~ actual

