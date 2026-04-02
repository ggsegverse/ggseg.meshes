describe("get_cortical_mesh()", {
  it("returns sphere mesh with correct structure", {
    mesh <- get_cortical_mesh("lh", "sphere")
    expect_type(mesh, "list")
    expect_named(mesh, c("vertices", "faces"))
    expect_named(mesh$vertices, c("x", "y", "z"))
    expect_named(mesh$faces, c("i", "j", "k"))
  })

  it("has 10242 vertices per hemisphere (fsaverage5)", {
    for (hemi in c("lh", "rh")) {
      for (surf in available_cortical_surfaces()) {
        mesh <- get_cortical_mesh(hemi, surf)
        expect_equal(nrow(mesh$vertices), 10242)
        expect_equal(nrow(mesh$faces), 20480)
      }
    }
  })

  it("uses 1-based face indices", {
    mesh <- get_cortical_mesh("lh", "orig")
    expect_true(min(mesh$faces$i) >= 1)
  })

  it("errors on invalid hemisphere", {
    expect_error(get_cortical_mesh("xx", "sphere"))
  })

  it("errors on invalid surface", {
    expect_error(get_cortical_mesh("lh", "fake"))
  })
})

describe("available_cortical_surfaces()", {
  it("returns all surface names", {
    surfs <- available_cortical_surfaces()
    expected <- c(
      "pial", "white", "semi-inflated",
      "sphere", "smoothwm", "orig"
    )
    expect_equal(surfs, expected)
  })
})
