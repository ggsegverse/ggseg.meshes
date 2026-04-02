#' Get SUIT cerebellar flatmap mesh
#'
#' Retrieves the SUIT cerebellar flatmap surface mesh. This is a 2D flattened
#' representation of the cerebellar cortex, useful for visualising cerebellar
#' parcellations without 3D rendering.
#'
#' The flatmap has z-coordinates near zero (flat projection). Vertex count
#' matches the SUIT 3D pial surface in `ggseg.formats`, so vertex indices
#' from cerebellar atlases map directly to this mesh.
#'
#' @return A list with `vertices` (data.frame with x, y, z) and `faces`
#'   (data.frame with i, j, k, 0-based indices matching `ggseg.formats`
#'   convention for cerebellar meshes).
#' @export
#' @examples
#' mesh <- get_cerebellar_flatmap()
#' nrow(mesh$vertices)
get_cerebellar_flatmap <- function() {
  cerebellar_mesh_suit_flat
}


#' List available cerebellar surfaces
#'
#' @return Character vector of available surface names.
#' @export
#' @examples
#' available_cerebellar_surfaces()
available_cerebellar_surfaces <- function() {
  c("suit_flat")
}
