.cortical_surfaces <- c(
  "pial",
  "white",
  "midthickness",
  "semi-inflated",
  "sphere",
  "smoothwm",
  "orig"
)

#' Get cortical brain surface mesh
#'
#' Retrieves a cortical brain surface mesh for the specified hemisphere and
#' surface type. All surfaces are fsaverage5 resolution (10,242 vertices,
#' 20,480 faces per hemisphere).
#'
#' Coordinates are FreeSurfer's own: `x` is left-right (negative left), `y` is
#' anterior-posterior (positive anterior) and `z` is superior-inferior
#' (positive superior). Plotting `y` against `z` gives a lateral view with
#' anterior to the right; `x` against `z` gives a coronal view.
#'
#' Each mesh carries a [ggseg.formats::mesh_space()], read with
#' `ggseg.formats::get_mesh_space()`, recording its vertex space, hemisphere,
#' whether the coordinates are anatomical, and the mapping to MNI305. Reading
#' that is how a consumer places a point without knowing where the mesh came
#' from. `pial`, `white`, `smoothwm`, `orig` and `midthickness` are anatomical
#' and map to MNI305 by the identity, fsaverage being an MNI305 average;
#' `semi-inflated` and `sphere` have had every vertex moved and so record no
#' mapping at all.
#'
#' @section Coordinates changed in 0.0.1.9002:
#' Before that version the stored coordinates were rotated 90 degrees from
#' FreeSurfer's native axes -- stored `x` was anterior-posterior and stored
#' `y` was left-right -- and `ggseg3d` rotated them back, so the pair was a
#' round trip to identity for the only consumer there was. Code that read
#' these meshes directly and relied on the rotated convention needs its axes
#' swapped: old `x` is now `y`, and old `y` is now `-x`.
#'
#' @param hemisphere `"lh"` or `"rh"`
#' @param surface Surface type: `"pial"`, `"white"`, `"midthickness"`,
#'   `"semi-inflated"`, `"sphere"`, `"smoothwm"`, or `"orig"`
#'
#' @return A list with `vertices` (data.frame with x, y, z, in FreeSurfer's
#'   native axes) and `faces` (data.frame with i, j, k, 1-based indices). Has
#'   attributes `face_index_base = 1L` and `mesh_space`.
#' @family cortical meshes
#' @seealso `ggseg.formats::get_brain_mesh()` for the inflated cortical mesh
#'   bundled with the core packages, whose faces are 0-based, and
#'   `ggseg3d::resolve_brain_mesh()`, which resolves these surfaces for 3D
#'   rendering.
#' @export
#' @examples
#' mesh <- get_cortical_mesh("lh", "pial")
#' str(mesh, max.level = 2)
#' head(mesh$faces)
#' attr(mesh, "face_index_base")
get_cortical_mesh <- function(
  hemisphere = c("lh", "rh"),
  surface = .cortical_surfaces
) {
  hemisphere <- match.arg(hemisphere)
  surface <- match.arg(surface)

  mesh_data <- switch(
    surface,
    "pial" = brain_mesh_pial,
    "white" = brain_mesh_white,
    "midthickness" = brain_mesh_midthickness,
    "semi-inflated" = brain_mesh_semi_inflated,
    "sphere" = brain_mesh_sphere,
    "smoothwm" = brain_mesh_smoothwm,
    "orig" = brain_mesh_orig,
    cli::cli_abort("Unknown surface: {.val {surface}}")
  )

  with_face_index_base(
    mesh_data[[hemisphere]],
    1L,
    paste(hemisphere, surface, sep = "_")
  )
}


#' List available cortical surfaces
#'
#' @return Character vector of available surface names.
#' @family cortical meshes
#' @export
#' @examples
#' available_cortical_surfaces()
available_cortical_surfaces <- function() {
  .cortical_surfaces
}
