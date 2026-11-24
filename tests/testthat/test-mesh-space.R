anatomical_surfaces <- c("pial", "white", "smoothwm", "orig", "midthickness")

describe("every shipped cortical mesh describes itself", {
  # Pinned because the alternative is inference. These coordinates were stored
  # rotated until 0.0.1.9002 and a consumer had to know which package a mesh
  # came from to read them -- and a mesh read wrongly still renders a
  # convincing brain.
  it("records vertex space, hemisphere and surface", {
    skip_if_not_installed("ggseg.formats", "0.0.4.9032")
    expected_hemi <- c(lh = "left", rh = "right")

    for (surface in available_cortical_surfaces()) {
      for (hemi in names(expected_hemi)) {
        space <- ggseg.formats::get_mesh_space(get_cortical_mesh(hemi, surface))
        expect_s3_class(space, "mesh_space")
        expect_identical(space$vertex_space, "fsaverage5", info = surface)
        expect_identical(space$hemi, expected_hemi[[hemi]], info = surface)
        expect_identical(space$surface, surface, info = surface)
        expect_identical(space$units, "mm", info = surface)
      }
    }
  })

  it("maps the anatomical surfaces to MNI305 and the others not at all", {
    skip_if_not_installed("ggseg.formats", "0.0.4.9032")

    for (surface in available_cortical_surfaces()) {
      space <- ggseg.formats::get_mesh_space(get_cortical_mesh("lh", surface))
      if (surface %in% anatomical_surfaces) {
        expect_true(space$anatomical, info = surface)
        expect_identical(dim(space$to_mni305), c(4L, 4L), info = surface)
      } else {
        expect_false(space$anatomical, info = surface)
        expect_null(space$to_mni305, info = surface)
      }
    }
  })
})

describe("cortical coordinates are FreeSurfer's native axes", {
  # The check that would have caught a mirrored rebuild: x is left-right, so
  # the left hemisphere sits at negative x and the right at positive. Under
  # the pre-0.0.1.9002 rotation x was anterior-posterior and this was false
  # for both.
  it("puts each anatomical hemisphere on its own side of the midline", {
    for (surface in intersect(
      available_cortical_surfaces(),
      anatomical_surfaces
    )) {
      lh <- get_cortical_mesh("lh", surface)$vertices
      rh <- get_cortical_mesh("rh", surface)$vertices
      expect_lt(mean(lh$x), 0)
      expect_gt(mean(rh$x), 0)
    }
  })

  it("spans a human brain on each axis", {
    # Catches an axis permutation that happens to keep the hemispheres
    # separated: a brain is wider front-to-back than side-to-side.
    v <- get_cortical_mesh("lh", "pial")$vertices
    expect_gt(diff(range(v$y)), diff(range(v$x)))
    expect_gt(diff(range(v$y)), 140)
    expect_lt(diff(range(v$x)), 100)
  })
})

describe("the cerebellar flatmap records that it is flat", {
  it("is not anatomical and maps nowhere", {
    skip_if_not_installed("ggseg.formats", "0.0.4.9032")
    space <- ggseg.formats::get_mesh_space(get_cerebellar_flatmap())
    expect_false(space$anatomical)
    expect_null(space$to_mni305)
    expect_identical(space$vertex_space, "suit")
  })
})
