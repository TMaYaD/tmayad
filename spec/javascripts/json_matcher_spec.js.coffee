describe "JSONMatcher", ->
  it "should match simple value", ->
    expect(1).toMatchJson 1

  it "should match array", ->
    expect(['a', 'b']).toMatchJson ['a', 'b']

  it "should match array without order", ->
    expect(['a', 'b']).toMatchJson ['b', 'a'].ignore_order()

  it "should match array without order on complex objects", ->
    expect([{'b': 2}, {'b': 1}]).toMatchJson [{'b': 1}, {'b': 2}].ignore_order()

  it "should reject array without order", ->
    expect(['a', 'b']).not.toMatchJson ['b', 'a'].reject_order()

  it "should match an object", ->
    expect(a: 1).toMatchJson a: 1
    expect(a: 1, b: 0).toMatchJson a: 1
    expect(a: 1).not.toMatchJson a: 0
    expect(a: 1).not.toMatchJson b: 1

  it "should callback given function with actual value", ->
    expected =
      a: ->
    spyOn expected, 'a'
    expect(a: 1).toMatchJson expected
    expect(expected.a.mostRecentCall.args[0]).toEqual(1)
