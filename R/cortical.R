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
#' The stored coordinates are rotated 90 degrees from FreeSurfer's native axes,
#' so they do not mean what the names x, y, z usually mean on a
#' FreeSurfer-derived surface. `x` is the anterior-posterior axis (positive
#' anterior), `y` is the left-right axis (positive left, so the left hemisphere
#' sits at positive `y`), and `z` is the superior-inferior axis (positive
#' superior, unrotated). Plotting `x` against `z` therefore gives a lateral
#' view with anterior to the right and superior at the top; plotting `y`
#' against `z` gives a coronal view.
#'
#' @param hemisphere `"lh"` or `"rh"`
#' @param surface Surface type: `"pial"`, `"white"`, `"midthickness"`,
#'   `"semi-inflated"`, `"sphere"`, `"smoothwm"`, or `"orig"`
#'
#' @return A list with `vertices` (data.frame with x, y, z, in the rotated
#'   convention described above) and `faces` (data.frame with i, j, k, 1-based
#'   indices). Has attribute `face_index_base = 1L`.
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
