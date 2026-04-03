.cortical_surfaces <- c(
  "pial", "white", "midthickness", "semi-inflated",
  "sphere", "smoothwm", "orig"
)

#' Get cortical brain surface mesh
#'
#' Retrieves a cortical brain surface mesh for the specified hemisphere and
#' surface type. All surfaces are fsaverage5 resolution (10,242 vertices,
#' 20,480 faces per hemisphere).
#'
#' @param hemisphere `"lh"` or `"rh"`
#' @param surface Surface type: `"pial"`, `"white"`, `"midthickness"`,
#'   `"semi-inflated"`, `"sphere"`, `"smoothwm"`, or `"orig"`
#'
#' @return A list with `vertices` (data.frame with x, y, z) and `faces`
#'   (data.frame with i, j, k, 1-based indices).
#'   Has attribute `face_index_base = 1L`.
#' @export
#' @examples
#' mesh <- get_cortical_mesh("lh", "pial")
#' nrow(mesh$vertices)
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

  mesh <- mesh_data[[hemisphere]]
  attr(mesh, "face_index_base") <- 1L
  mesh
}


#' List available cortical surfaces
#'
#' @return Character vector of available surface names.
#' @export
#' @examples
#' available_cortical_surfaces()
available_cortical_surfaces <- function() {
  .cortical_surfaces
}
