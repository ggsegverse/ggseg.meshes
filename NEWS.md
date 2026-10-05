# ggseg.meshes (development version)

- Vignette figures and the package logo are written as 8-bit palette PNGs at
  their display size, cutting the source tarball from 5.3 MB to under 2.5 MB
  and back below the CRAN 5 MB limit. The figures themselves are unchanged.
- Dropped `ggseg.formats` from `Suggests`; it was referenced only in prose.
- Moved `freesurfer`, `freesurferformats` and `gifti` from `Suggests` to
  `Config/Needs/data-raw`, and recorded `magick` there too. All four are used
  only by the mesh- and figure-building scripts in `data-raw/`, which is not
  part of the built package, so checking or installing `ggseg.meshes` no
  longer asks for them.
- Documentation is regenerated with roxygen2 8.1.0, matching the rest of the
  ggsegverse packages.

# ggseg.meshes 0.0.1

## New features

- Cortical fsaverage5 surfaces: pial, white, midthickness, semi-inflated, sphere, smoothwm, orig
- SUIT cerebellar flatmap surface
- `get_cortical_mesh()` for accessing cortical surfaces by hemisphere and type
- `get_cerebellar_flatmap()` for the SUIT flatmap mesh
- `available_cortical_surfaces()` and `available_cerebellar_surfaces()` for discovery
