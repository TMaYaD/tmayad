describe "Tree", ->
  tree = undefined

  beforeEach ->
    tree = new Tree('sitemap.json')
    tree.parse target: 'LoonyFlow'

  it "should parse sitemap for ancestors", ->
    expect(tree.ancestors).toHaveNodes [ 'TMaYaD', 'Projects' ]

