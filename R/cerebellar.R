.cerebellar_surfaces <- "suit_flat"

#' Get SUIT cerebellar flatmap mesh
#'
#' Retrieves the SUIT cerebellar flatmap surface mesh. This is a 2D flattened
#' representation of the cerebellar cortex, useful for visualising cerebellar
#' parcellations without 3D rendering.
#'
#' The projection is exactly flat: `z` is `0` for every one of the 28,935
#' vertices.
#'
#' The flatmap's vertices are the first 28,935 of the 30,013 in the SUIT 3D
#' pial surface in `ggseg.formats`, in the same order. The remaining 1,078 are
#' the peduncular cap, which has no flatmap counterpart. A cerebellar atlas
#' vertex index below 28,935 therefore applies to this mesh unchanged; indices
#' from 28,935 upwards cannot be drawn on the flatmap. 101 of the 28,935
#' vertices appear in no face, so values on them are carried but never
#' rendered.
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

  with_face_index_base(mesh, 0L, paste0("cerebellar_mesh_", surface))
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
