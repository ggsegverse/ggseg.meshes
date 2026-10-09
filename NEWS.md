# ggseg.meshes (development version)

- Vignette figures and the package logo are written as 8-bit palette PNGs, and
  the logo is additionally resized to its display size, cutting the source
  tarball from 5.3 MB to under 2.5 MB and back below the CRAN 5 MB limit. The
  figures are unchanged in size and content.
- `get_cortical_mesh()` now documents its coordinate convention: the meshes are
  rotated 90 degrees from FreeSurfer's native axes, so `x` is
  anterior-posterior and `y` is left-right.
- Documented that the cortical face table matches the ggseg.formats inflated
  mesh in connectivity but not in index base: it is 1-based, that one 0-based.
- Corrected `get_cerebellar_flatmap()`'s documentation: the flatmap is the
  first 28,935 vertices of the 30,013-vertex SUIT 3D pial surface, not a
  vertex-for-vertex match, and its `z` is exactly zero.
- `face_index_base` is now verified against the stored faces instead of being
  stamped on as a literal; an inconsistent mesh errors rather than shipping a
  wrong attribute.
- The `data-raw/` scripts now share `data-raw/save_sysdata.R`, so re-running
  either one can no longer drop the other's meshes from `R/sysdata.rda`.
- Recorded the remaining `data-raw/` dependencies in `Config/Needs/data-raw`.
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
