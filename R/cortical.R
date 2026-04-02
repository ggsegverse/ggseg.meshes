#' Get cortical brain surface mesh
#'
#' Retrieves a cortical brain surface mesh for the specified hemisphere and
#' surface type. All surfaces are fsaverage5 resolution (10,242 vertices,
#' 20,480 faces per hemisphere).
#'
#' @param hemisphere `"lh"` or `"rh"`
#' @param surface Surface type: `"pial"`, `"white"`, `"semi-inflated"`,
#'   `"sphere"`, `"smoothwm"`, or `"orig"`
#'
#' @return A list with `vertices` (data.frame with x, y, z) and `faces`
#'   (data.frame with i, j, k, 1-based indices).
#' @export
#' @examples
#' mesh <- get_cortical_mesh("lh", "pial")
#' nrow(mesh$vertices)
get_cortical_mesh <- function(
  hemisphere = c("lh", "rh"),
  surface = c("pial", "white", "semi-inflated",
              "sphere", "smoothwm", "orig")
) {
  hemisphere <- match.arg(hemisphere)
  surface <- match.arg(surface)

  mesh_data <- switch(
    surface,
    "pial" = brain_mesh_pial,
    "white" = brain_mesh_white,
    "semi-inflated" = brain_mesh_semi_inflated,
    "sphere" = brain_mesh_sphere,
    "smoothwm" = brain_mesh_smoothwm,
    "orig" = brain_mesh_orig
  )

  mesh_data[[hemisphere]]
}


#' List available cortical surfaces
#'
#' @return Character vector of available surface names.
#' @export
#' @examples
#' available_cortical_surfaces()
available_cortical_surfaces <- function() {
  c("pial", "white", "semi-inflated", "sphere", "smoothwm", "orig")
}
