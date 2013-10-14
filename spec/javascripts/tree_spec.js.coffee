describe "Tree", ->

  json =
    name: 'root',
    children: [
      {
        name: 'a 1'
        children: [
          {
            name: 'b 1'
            children: [
              {
                name: 'c 1'
              }, {
                name: 'c 2'
              }
            ]
          }, {
            name: 'b 2'
            children: [
              {
                name: 'c 3'
              }, {
                name: 'c 4'
              }
            ]
          }, {
            name: 'b 3'
            children: [
              {
                name: 'c 5'
              }, {
                name: 'c 6'
              }
            ]
          }
        ]
      }, {
        name: 'a 2'
        children: [
          {
            name: 'b 4'
            children: [
              {
                name: 'c 7'
              }, {
                name: 'c 8'
              }
            ]
          }, {
            name: 'b 5'
            children: [
              {
                name: 'c 9'
              }
            ]
          }
        ]
      }
    ]

  tree = new Tree json

  it "should parse sitemap for ancestors", ->
    tree.parse target: 'b 2'
    expect(tree.ancestors).toHaveNodes [ 'root', 'a 1' ]

  it "should parse sitemap for siblings", ->
    tree.parse target: 'b2'
    expect(tree.siblings).toHaveNodes [ 'b 1', 'b 3' ]
