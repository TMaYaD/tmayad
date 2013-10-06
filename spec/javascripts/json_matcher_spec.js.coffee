describe "JSONMatcher", ->
  it "should match json expression", ->
    expect(test: 'json').toMatchJson test: 'json'

