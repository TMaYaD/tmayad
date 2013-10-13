Array::ignore_order = ->
  @unordered = true
  @

Array::reject_order = ->
  @unordered = false
  @

beforeEach ->
  @addMatchers toMatchJson: (expected) ->
    expected = new JsonMatcher expected unless expected.name == 'JsonMatcher'

    result = expected.matches @actual
    @message = expected.message unless result
    result

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
    try
      @match @expected, actual
      return true

    catch err
      throw err unless err.type == 'failure'

      @message = err.message
      return false

  match: (expected, actual) ->
    switch
      when typeof expected in @primitives
        @fail_with "expected #{JSON.stringify actual} to equal #{JSON.stringify expected}." unless expected == actual
      when expected instanceof Array
        @match_array expected, actual
      when typeof expected == 'function'
        expected(actual, @)
      else
        @match_hash expected, actual

  fail_with: (message)->
    throw
      type: 'failure',
      message: message

  match_array: (expected, actual) ->
    @fail_with "expected #{JSON.stringify actual} to be an Array: #{JSON.stringify expected}" unless actual instanceof Array
    @fail_with "too few elements(#{actual.length}/#{expected.length}) in #{JSON.stringify actual}" if expected.length > actual.length

    if expected.unordered
      expected = expected.slice(0).sort()
      actual = actual.slice(0).sort()

    expected.forEach (item, i)=>
      @match item, actual[i]

  match_hash: (expected, actual) ->
    match_prop = (prop)=>

    for prop of expected
      @fail_with "key #{prop} not found in #{JSON.stringify expected}" unless expected.hasOwnProperty(prop)
      @fail_with "key #{prop} not found in #{JSON.stringify actual}" unless actual.hasOwnProperty(prop)

      @match expected[prop], actual[prop]
