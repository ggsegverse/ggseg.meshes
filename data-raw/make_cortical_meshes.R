# Generate cortical brain meshes for ggseg.meshes
#
# All fsaverage5 cortical surfaces: pial, white, smoothwm, orig, sphere, plus
# midthickness and semi-inflated, which are interpolated rather than read.
#
# Coordinates are FreeSurfer's own (x = L-R, y = A-P, z = I-S). Until
# 0.0.1.9002 these were stored rotated 90 degrees -- stored x = A-P, stored
# y = -(L-R) -- and ggseg3d rotated them back, so the pair was a round trip to
# identity for the only consumer there was. The rotation is gone and each mesh
# records what its coordinates mean instead, which is what lets a consumer
# place a point without knowing which package the mesh came from.
#
# Reading is ggseg.extra::read_surface_mesh()'s job, not this script's, so the
# ecosystem decides in one place how to read a surface and what its faces
# count from.
#
# Run with: source("data-raw/make_cortical_meshes.R")

rlang::check_installed(c("ggseg.extra", "ggseg.formats"))

if (!freesurfer::have_fs()) {
  stop("FreeSurfer is required to generate brain meshes.")
}

subjects_dir <- freesurfer::fs_subj_dir()
surf_dir <- file.path(subjects_dir, "fsaverage5", "surf")

fs_version <- local({
  stamp <- file.path(Sys.getenv("FREESURFER_HOME"), "build-stamp.txt")
  if (file.exists(stamp)) readLines(stamp, n = 1L) else "unknown"
})

hemi_names <- c(lh = "left", rh = "right")

# Inflation and spherical registration move every vertex, so a position on
# those surfaces corresponds to nowhere in the brain: anatomical = FALSE and
# no affine. The rest keep the brain's own shape, and since fsaverage is an
# MNI305 average and the coordinates are now stored unrotated, the mapping to
# MNI305 is the identity.
anatomical_surfaces <- c("pial", "white", "smoothwm", "orig", "midthickness")

surface_space <- function(hemi, surface) {
  anatomical <- surface %in% anatomical_surfaces
  ggseg.formats::mesh_space(
    vertex_space = "fsaverage5",
    hemi = hemi_names[[hemi]],
    anatomical = anatomical,
    to_mni305 = if (anatomical) diag(4),
    units = "mm",
    surface = surface,
    source = paste(fs_version, "fsaverage5", paste(hemi, surface, sep = "."))
  )
}

read_surface <- function(hemi, surface) {
  path <- file.path(surf_dir, paste(hemi, surface, sep = "."))
  if (!file.exists(path)) {
    stop("Surface file not found: ", path, call. = FALSE)
  }
  ggseg.extra::read_surface_mesh(
    path,
    space = surface_space(hemi, surface),
    face_index_base = 1L
  )
}

# Vertices interpolated between two surfaces that share a topology. The faces
# come from the same source as the weights, so the result indexes the same
# vertex space and an atlas built against it still lands correctly.
interpolate_surface <- function(from, to, weight, hemi, surface) {
  stopifnot(
    identical(nrow(from$vertices), nrow(to$vertices)),
    identical(from$faces, to$faces)
  )
  ggseg.formats::brain_mesh(
    vertices = data.frame(
      x = (1 - weight) * from$vertices$x + weight * to$vertices$x,
      y = (1 - weight) * from$vertices$y + weight * to$vertices$y,
      z = (1 - weight) * from$vertices$z + weight * to$vertices$z
    ),
    faces = from$faces,
    space = surface_space(hemi, surface),
    face_index_base = 1L
  )
}

read_surfaces <- c("pial", "white", "inflated", "sphere", "smoothwm", "orig")
all_meshes <- list()

for (hemi in names(hemi_names)) {
  for (surface in read_surfaces) {
    name <- paste(hemi, surface, sep = "_")
    all_meshes[[name]] <- read_surface(hemi, surface)
    cli::cli_alert_success(
      "{name}: {nrow(all_meshes[[name]]$vertices)}v,
       {nrow(all_meshes[[name]]$faces)}f"
    )
  }

  # semi-inflated is 65% of the way to inflated; midthickness sits halfway
  # between pial and white.
  all_meshes[[paste0(hemi, "_semi-inflated")]] <- interpolate_surface(
    all_meshes[[paste0(hemi, "_white")]],
    all_meshes[[paste0(hemi, "_inflated")]],
    weight = 0.65,
    hemi = hemi,
    surface = "semi-inflated"
  )
  all_meshes[[paste0(hemi, "_midthickness")]] <- interpolate_surface(
    all_meshes[[paste0(hemi, "_pial")]],
    all_meshes[[paste0(hemi, "_white")]],
    weight = 0.5,
    hemi = hemi,
    surface = "midthickness"
  )
  cli::cli_alert_success("{hemi}: semi-inflated and midthickness interpolated")
}

# Left and right must end up on opposite sides of the midline. A mirrored
# surface renders a perfectly plausible brain, so it is checked rather than
# trusted -- this is the one error that cannot be allowed through.
for (surface in c(read_surfaces, "semi-inflated", "midthickness")) {
  if (!surface %in% anatomical_surfaces) {
    next
  }
  lh <- all_meshes[[paste0("lh_", surface)]]$vertices$x
  rh <- all_meshes[[paste0("rh_", surface)]]$vertices$x
  if (!(mean(lh) < 0 && mean(rh) > 0)) {
    stop(
      sprintf(
        paste(
          "%s: hemispheres are not on opposite sides of x = 0",
          "(lh mean %.1f, rh mean %.1f)"
        ),
        surface,
        mean(lh),
        mean(rh)
      ),
      call. = FALSE
    )
  }
}
cli::cli_alert_success("anatomical hemispheres sit on their own sides of x = 0")

make_pair <- function(surface) {
  list(
    lh = all_meshes[[paste0("lh_", surface)]],
    rh = all_meshes[[paste0("rh_", surface)]]
  )
}

brain_mesh_pial <- make_pair("pial")
brain_mesh_white <- make_pair("white")
brain_mesh_semi_inflated <- make_pair("semi-inflated")
brain_mesh_sphere <- make_pair("sphere")
brain_mesh_smoothwm <- make_pair("smoothwm")
brain_mesh_orig <- make_pair("orig")
brain_mesh_midthickness <- make_pair("midthickness")

source("data-raw/save_sysdata.R")
save_sysdata()
