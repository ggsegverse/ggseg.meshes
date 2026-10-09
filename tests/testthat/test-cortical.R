# Per-surface vertex signatures. These pin the switch() in get_cortical_mesh()
# to the right stored object: swapping two surfaces changes the numbers next to
# the name, which no structural test would catch.
lh_signatures <- list(
  pial = c(-21.851, 29.551, 17.274, 38.313, 18.484, 28.040),
  white = c(-21.896, 29.425, 17.179, 37.813, 17.397, 27.200),
  midthickness = c(-21.874, 29.488, 17.226, 38.059, 17.928, 27.611),
  `semi-inflated` = c(-10.374, 10.894, 6.528, 47.471, 21.712, 34.131),
  sphere = c(0, 0, 0, 57.738, 57.738, 57.738),
  smoothwm = c(-21.896, 29.425, 17.179, 37.627, 17.146, 27.016),
  orig = c(-21.902, 29.402, 17.193, 37.759, 17.322, 27.141)
)

vertex_signature <- function(mesh) {
  unname(c(
    vapply(mesh$vertices, mean, numeric(1)),
    vapply(mesh$vertices, stats::sd, numeric(1))
  ))
}

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
        expect_identical(nrow(mesh$vertices), 10242L)
        expect_identical(nrow(mesh$faces), 20480L)
      }
    }
  })

  it("has face indices spanning the whole vertex range from its base", {
    for (hemi in c("lh", "rh")) {
      for (surf in available_cortical_surfaces()) {
        mesh <- get_cortical_mesh(hemi, surf)
        base <- attr(mesh, "face_index_base")
        idx <- unlist(mesh$faces, use.names = FALSE)
        expect_identical(base, 1L)
        expect_identical(min(idx), base)
        expect_identical(max(idx), nrow(mesh$vertices) - 1L + base)
      }
    }
  })

  it("returns double vertices and integer faces with no missing values", {
    for (hemi in c("lh", "rh")) {
      for (surf in available_cortical_surfaces()) {
        mesh <- get_cortical_mesh(hemi, surf)
        expect_true(all(vapply(mesh$vertices, is.double, logical(1))))
        expect_true(all(vapply(mesh$faces, is.integer, logical(1))))
        expect_false(anyNA(mesh$vertices))
        expect_false(anyNA(mesh$faces))
      }
    }
  })

  it("shares one face topology across every surface and hemisphere", {
    reference <- get_cortical_mesh("lh", "pial")$faces
    for (hemi in c("lh", "rh")) {
      for (surf in available_cortical_surfaces()) {
        expect_identical(get_cortical_mesh(hemi, surf)$faces, reference)
      }
    }
  })

  it("maps each surface name to its own stored geometry", {
    for (hemi in c("lh", "rh")) {
      signatures <- lapply(
        available_cortical_surfaces(),
        function(surf) vertex_signature(get_cortical_mesh(hemi, surf))
      )
      expect_length(unique(signatures), length(available_cortical_surfaces()))
    }

    for (surf in names(lh_signatures)) {
      expect_equal(
        vertex_signature(get_cortical_mesh("lh", surf)),
        lh_signatures[[surf]],
        tolerance = 1e-3,
        info = surf
      )
    }
  })

  it("derives midthickness as the midpoint of pial and white", {
    for (hemi in c("lh", "rh")) {
      pial <- get_cortical_mesh(hemi, "pial")$vertices
      white <- get_cortical_mesh(hemi, "white")$vertices
      mid <- get_cortical_mesh(hemi, "midthickness")$vertices
      expect_equal(mid, (pial + white) / 2, tolerance = 1e-6)
    }
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
      "pial",
      "white",
      "midthickness",
      "semi-inflated",
      "sphere",
      "smoothwm",
      "orig"
    )
    expect_identical(surfs, expected)
  })
})
