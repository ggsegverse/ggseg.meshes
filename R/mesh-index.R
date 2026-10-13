#' Attach a verified face index base to a mesh
#'
#' The stored meshes inherit their face index base from the reader that built
#' them: `freesurferformats::read.fs.surface()` converts FreeSurfer's 0-based
#' on-disk faces to 1-based, while `gifti::readgii()` leaves GIFTI faces
#' 0-based. Rather than stamping that base on as a literal, derive it from the
#' data and check it against the base the documentation promises, so a change
#' of upstream convention fails loudly instead of shipping off-by-one meshes
#' with an attribute that confidently says otherwise.
#'
#' @param mesh List with `vertices` and `faces` data frames.
#' @param expected_base The documented face index base, `0L` or `1L`.
#' @param name Mesh name, used in error messages.
#'
#' @return `mesh` with attribute `face_index_base` set.
#' @noRd
with_face_index_base <- function(mesh, expected_base, name) {
  idx <- unlist(mesh$faces, use.names = FALSE)
  base <- min(idx)
  n_vertices <- nrow(mesh$vertices)

  if (!identical(base, expected_base) || max(idx) != n_vertices - 1L + base) {
    cli::cli_abort(c(
      "Stored mesh {.val {name}} has inconsistent face indices.",
      i = "Faces span {min(idx)}-{max(idx)} over {n_vertices} vertices.",
      i = "Expected {expected_base}-{n_vertices - 1L + expected_base} for a
           {expected_base}-based mesh."
    ))
  }

  attr(mesh, "face_index_base") <- base
  mesh
}
