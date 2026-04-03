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

  it("uses 0-based face indices", {
    mesh <- get_cerebellar_flatmap()
    expect_true(min(mesh$faces$i) >= 0)
    expect_true(min(mesh$faces$j) >= 0)
    expect_true(min(mesh$faces$k) >= 0)
    expect_equal(attr(mesh, "face_index_base"), 0L)
  })

  it("returns numeric data.frames", {
    mesh <- get_cerebellar_flatmap()
    expect_true(all(vapply(mesh$vertices, is.numeric, logical(1))))
    expect_true(all(vapply(mesh$faces, is.numeric, logical(1))))
  })
})

describe("available_cerebellar_surfaces()", {
  it("returns suit_flat", {
    expect_equal(available_cerebellar_surfaces(), "suit_flat")
  })
})
