# The SUIT 3D pial surface in ggseg.formats has 30,013 vertices; the flatmap is
# its first 28,935, the 1,078 peduncular cap vertices having no counterpart.
# ggseg.formats is not a dependency of this package, so those two numbers are
# pinned here to keep the documented relationship from going stale silently.
suit_3d_vertices <- 30013L
suit_cap_vertices <- 1078L

describe("get_cerebellar_flatmap()", {
  it("returns mesh with correct structure", {
    mesh <- get_cerebellar_flatmap()
    expect_type(mesh, "list")
    expect_named(mesh, c("vertices", "faces"))
    expect_named(mesh$vertices, c("x", "y", "z"))
    expect_named(mesh$faces, c("i", "j", "k"))
  })

  it("covers the SUIT 3D vertex space minus the peduncular cap", {
    mesh <- get_cerebellar_flatmap()
    expect_identical(nrow(mesh$vertices), suit_3d_vertices - suit_cap_vertices)
    expect_identical(nrow(mesh$vertices), 28935L)
  })

  it("is exactly flat", {
    mesh <- get_cerebellar_flatmap()
    expect_true(all(mesh$vertices$z == 0))
  })

  it("has face indices spanning the whole vertex range from its base", {
    mesh <- get_cerebellar_flatmap()
    base <- attr(mesh, "face_index_base")
    idx <- unlist(mesh$faces, use.names = FALSE)
    expect_identical(base, 0L)
    expect_identical(min(idx), base)
    expect_identical(max(idx), nrow(mesh$vertices) - 1L + base)
  })

  it("has 101 vertices in no face", {
    mesh <- get_cerebellar_flatmap()
    idx <- unlist(mesh$faces, use.names = FALSE)
    expect_identical(nrow(mesh$vertices) - length(unique(idx)), 101L)
  })

  it("returns double vertices and integer faces with no missing values", {
    mesh <- get_cerebellar_flatmap()
    expect_true(all(vapply(mesh$vertices, is.double, logical(1))))
    expect_true(all(vapply(mesh$faces, is.integer, logical(1))))
    expect_false(anyNA(mesh$vertices))
    expect_false(anyNA(mesh$faces))
  })

  it("errors on invalid surface", {
    expect_error(get_cerebellar_flatmap("fake"))
  })
})

describe("available_cerebellar_surfaces()", {
  it("returns suit_flat", {
    expect_identical(available_cerebellar_surfaces(), "suit_flat")
  })
})
