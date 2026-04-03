.cerebellar_surfaces <- c("suit_flat")

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
#' @param surface Surface type. Currently only `"suit_flat"`.
#'
#' @return A list with `vertices` (data.frame with x, y, z) and `faces`
#'   (data.frame with i, j, k, 0-based indices matching `ggseg.formats`
#'   convention for cerebellar meshes).
#'   Has attribute `face_index_base = 0L`.
#' @export
#' @examples
#' mesh <- get_cerebellar_flatmap()
#' nrow(mesh$vertices)
get_cerebellar_flatmap <- function(surface = .cerebellar_surfaces) {
  surface <- match.arg(surface)

  mesh <- switch(
    surface,
    "suit_flat" = cerebellar_mesh_suit_flat,
    cli::cli_abort("Unknown surface: {.val {surface}}")
  )

  attr(mesh, "face_index_base") <- 0L
  mesh
}


#' List available cerebellar surfaces
#'
#' @return Character vector of available surface names.
#' @export
#' @examples
#' available_cerebellar_surfaces()
available_cerebellar_surfaces <- function() {
  .cerebellar_surfaces
}
