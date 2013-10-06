Array::ignore_order = ->
  @unordered = true
  @

Array::reject_order = ->
  @unordered = false
  @

beforeEach ->
  @addMatchers toMatchJson: (expected) ->
    expected = new JsonMatcher expected unless expected.name == 'JsonMatcher'

    expected.matches @actual

class JsonMatcher
  primitives: [
    'string',
    'number',
    'boolean'
  ]

  constructor: (expected) ->
    @name = 'JsonMatcher'
    @expected = expected

  matches: (actual)->
    @match @expected, actual

  match: (expected, actual) ->
    switch
      when typeof expected in @primitives
        expected == actual
      when expected instanceof Array
        @match_array expected, actual
      when typeof expected == 'function'
        expected(actual)
        true
      else
        @match_hash expected, actual

  match_array: (expected, actual) ->
    return false unless expected.length == actual.length
    if expected.unordered
      expected = expected.slice(0).sort()
      actual = actual.slice(0).sort()

    expected.reduce (return_value, item, i)=>
      return_value && @match item, actual[i]

  match_hash: (expected, actual) ->
    return_value = true

    match_prop = (prop)=>
      return false unless expected.hasOwnProperty(prop)
      return false unless actual.hasOwnProperty(prop)

      @match expected[prop], actual[prop]

    for prop of expected
      return_value = return_value && match_prop(prop)

    return_value
