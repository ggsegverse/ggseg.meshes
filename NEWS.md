# ggseg.meshes (development version)

- The `ggseg.formats` floor is no longer pinned in `Suggests`. No code in `R/`
  calls `ggseg.formats`, so the floor only ever served the tests -- but an
  unsatisfiable `Suggests` version makes `R CMD check` stop at "checking
  package dependencies" before a single test runs, which is exactly what it
  did on CRAN. The three tests that need the version carry it themselves.

## Breaking changes

- Cortical coordinates are FreeSurfer's native axes: `x` left-right, `y`
  anterior-posterior, `z` superior-inferior. They were stored rotated 90
  degrees, and `ggseg3d` rotated them back, so the pair was a round trip to
  identity for the only consumer there was. Code reading these meshes directly
  and relying on the rotated convention needs its axes swapped: old `x` is now
  `y`, old `y` is now `-x`. Faces are unchanged, so atlas vertex indices still
  address the same vertices.

## New features

- Every mesh carries a `ggseg.formats::mesh_space()` recording its vertex
  space, hemisphere, whether the coordinates are anatomical and the mapping to
  MNI305, so a consumer places a point from what the mesh says rather than from
  which package it came from. `pial`, `white`, `smoothwm`, `orig` and
  `midthickness` map to MNI305 by the identity; `semi-inflated` and `sphere`
  record no mapping, every vertex having been moved.

- Surfaces are read through `ggseg.extra::read_surface_mesh()`, so the
  ecosystem decides in one place how to read a surface and what its faces count
  from. `save_sysdata()` now refuses a mesh that records no frame, or an
  anatomical one with no mapping.

- Vignette figures and the package logo are written as 8-bit palette PNGs, and
  the logo is additionally resized to its display size, cutting the source
  tarball from 5.3 MB to under 2.5 MB and back below the CRAN 5 MB limit. The
  figures are unchanged in size and content.
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

## Bug fixes

- The `mesh_space` tests now require `ggseg.formats (>= 0.0.4.9032)` to skip
  on, instead of erroring against a release that has no `get_mesh_space()`.
- Dropped the `ggseg.formats::mesh_space()` cross-reference anchor from
  `get_cortical_mesh()`; it was a missing link until that version is released.
- Removed the unreachable `switch()` fallbacks in `get_cortical_mesh()` and
  `get_cerebellar_flatmap()`; `match.arg()` has already rejected the input.

# ggseg.meshes 0.0.1

## New features

- Cortical fsaverage5 surfaces: pial, white, midthickness, semi-inflated, sphere, smoothwm, orig
- SUIT cerebellar flatmap surface
- `get_cortical_mesh()` for accessing cortical surfaces by hemisphere and type
- `get_cerebellar_flatmap()` for the SUIT flatmap mesh
- `available_cortical_surfaces()` and `available_cerebellar_surfaces()` for discovery
