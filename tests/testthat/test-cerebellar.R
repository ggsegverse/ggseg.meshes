describe("get_cerebellar_flatmap()", {
  it("returns mesh with correct structure", {
    mesh <- get_cerebellar_flatmap()
    expect_type(mesh, "list")
    expect_named(mesh, c("vertices", "faces"))
    expect_named(mesh$vertices, c("x", "y", "z"))
    expect_named(mesh$faces, c("i", "j", "k"))
  })

  it("has expected vertex count", {
    mesh <- get_cerebellar_flatmap()
    expect_equal(nrow(mesh$vertices), 28935)
  })

  it("is approximately flat (z near zero)", {
    mesh <- get_cerebellar_flatmap()
    expect_true(max(abs(mesh$vertices$z)) < 1)
  })
})

describe("available_cerebellar_surfaces()", {
  it("returns suit_flat", {
    expect_equal(available_cerebellar_surfaces(), "suit_flat")
  })
})
