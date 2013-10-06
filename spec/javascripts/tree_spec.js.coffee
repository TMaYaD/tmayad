xdescribe "Tree", ->
  tree = undefined

  beforeEach ->
    tree = new Tree('sitemap.json')
    tree.parse target: 'LoonyFlow'

  xit "should parse sitemap for ancestors", ->
    expect(tree.ancestors).toHaveElements [ 'TMaYaD', 'Projects' ]

  it "should match json expression", ->
    expect(test: 'json').toMatchJson test: 'json'

