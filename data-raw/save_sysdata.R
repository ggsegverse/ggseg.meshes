# Single source of truth for R/sysdata.rda.
#
# Both make_cortical_meshes.R and make_cerebellar_meshes.R source this file and
# call save_sysdata() once their own objects exist. Objects a script does not
# build are carried over from the existing R/sysdata.rda, so neither script can
# delete the other's data and the object list lives in exactly one place.

sysdata_index_base <- c(
  brain_mesh_pial = 1L,
  brain_mesh_white = 1L,
  brain_mesh_semi_inflated = 1L,
  brain_mesh_midthickness = 1L,
  brain_mesh_sphere = 1L,
  brain_mesh_smoothwm = 1L,
  brain_mesh_orig = 1L,
  cerebellar_mesh_suit_flat = 0L
)

assert_mesh <- function(mesh, name, expected_base) {
  if (!all(c("vertices", "faces") %in% names(mesh))) {
    stop(name, ": not a vertices/faces mesh", call. = FALSE)
  }
  if (!identical(names(mesh$vertices), c("x", "y", "z"))) {
    stop(name, ": vertices must be x, y, z", call. = FALSE)
  }
  if (!identical(names(mesh$faces), c("i", "j", "k"))) {
    stop(name, ": faces must be i, j, k", call. = FALSE)
  }
  if (!all(vapply(mesh$faces, is.integer, logical(1)))) {
    stop(name, ": face columns must be integer", call. = FALSE)
  }
  if (anyNA(mesh$vertices) || anyNA(mesh$faces)) {
    stop(name, ": NA in vertices or faces", call. = FALSE)
  }

  idx <- unlist(mesh$faces, use.names = FALSE)
  n <- nrow(mesh$vertices)
  if (min(idx) != expected_base || max(idx) != n - 1L + expected_base) {
    stop(
      sprintf(
        paste0(
          "%s: faces span %d-%d over %d vertices, ",
          "expected %d-%d for a %d-based mesh. ",
          "The upstream reader's index convention may have changed."
        ),
        name,
        min(idx),
        max(idx),
        n,
        expected_base,
        n - 1L + expected_base,
        expected_base
      ),
      call. = FALSE
    )
  }

  invisible(TRUE)
}

assert_sysdata_object <- function(obj, name, expected_base) {
  if (all(c("vertices", "faces") %in% names(obj))) {
    assert_mesh(obj, name, expected_base)
  } else {
    for (hemi in names(obj)) {
      assert_mesh(obj[[hemi]], paste(name, hemi, sep = "$"), expected_base)
    }
  }
  invisible(TRUE)
}

save_sysdata <- function(envir = parent.frame(), path = "R/sysdata.rda") {
  existing <- new.env(parent = emptyenv())
  if (file.exists(path)) {
    load(path, envir = existing)
  }

  out <- new.env(parent = emptyenv())
  names <- names(sysdata_index_base)

  for (name in names) {
    obj <- if (exists(name, envir = envir, inherits = FALSE)) {
      get(name, envir = envir, inherits = FALSE)
    } else if (exists(name, envir = existing, inherits = FALSE)) {
      get(name, envir = existing, inherits = FALSE)
    } else {
      stop(
        name,
        " is neither newly built nor present in ",
        path,
        ". Run the other data-raw script first.",
        call. = FALSE
      )
    }

    assert_sysdata_object(obj, name, sysdata_index_base[[name]])
    assign(name, obj, envir = out)
  }

  save(
    list = names,
    file = path,
    envir = out,
    compress = "xz",
    version = 2
  )

  cli::cli_alert_success(
    "Saved {length(names)} object{?s} to {path}: {.val {names}}"
  )
}
