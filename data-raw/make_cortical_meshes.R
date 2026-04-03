# Generate cortical brain meshes for ggseg.meshes
#
# Creates all cortical fsaverage5 surface meshes:
#   - pial, white, semi-inflated, midthickness (migrated from ggseg3d)
#   - sphere, smoothwm, orig (new)
#
# Requires freesurferformats and freesurfer packages.
#
# Run with: source("data-raw/make_cortical_meshes.R")

if (!requireNamespace("freesurferformats", quietly = TRUE)) {
  stop(
    "freesurferformats is required. ",
    "Install with: install.packages('freesurferformats')"
  )
}

if (!freesurfer::have_fs()) {
  stop("FreeSurfer is required to generate brain meshes.")
}

subjects_dir <- freesurfer::fs_subj_dir()
surf_dir <- file.path(subjects_dir, "fsaverage5", "surf")

surfaces <- c("pial", "white", "inflated", "sphere", "smoothwm", "orig")
hemispheres <- c("lh", "rh")

read_surface <- function(hemi, surf) {
  surf_file <- file.path(surf_dir, paste(hemi, surf, sep = "."))
  if (!file.exists(surf_file)) {
    stop("Surface file not found: ", surf_file)
  }

  mesh <- freesurferformats::read.fs.surface(surf_file)

  # Rotate 90 degrees CCW: (x,y,z) -> (y,-x,z)
  # Lateral view with superior at top, A/P horizontal
  list(
    vertices = data.frame(
      x = mesh$vertices[, 2],
      y = -mesh$vertices[, 1],
      z = mesh$vertices[, 3]
    ),
    faces = data.frame(
      i = mesh$faces[, 1],
      j = mesh$faces[, 2],
      k = mesh$faces[, 3]
    )
  )
}

all_meshes <- list()

for (hemi in hemispheres) {
  for (surf in surfaces) {
    mesh_name <- paste(hemi, surf, sep = "_")
    cli::cli_alert_info("Reading {mesh_name}...")

    all_meshes[[mesh_name]] <- read_surface(hemi, surf)

    nv <- nrow(all_meshes[[mesh_name]]$vertices)
    nf <- nrow(all_meshes[[mesh_name]]$faces)
    cli::cli_alert_success("{mesh_name}: {nv}v, {nf}f")
  }
}

# Semi-inflated = 35/65 interpolation of white and inflated
for (hemi in hemispheres) {
  cli::cli_alert_info("Computing {hemi}_semi-inflated...")

  white_verts <- all_meshes[[paste0(hemi, "_white")]]$vertices
  infl_verts <- all_meshes[[paste0(hemi, "_inflated")]]$vertices

  semi_verts <- data.frame(
    x = 0.35 * white_verts$x + 0.65 * infl_verts$x,
    y = 0.35 * white_verts$y + 0.65 * infl_verts$y,
    z = 0.35 * white_verts$z + 0.65 * infl_verts$z
  )

  all_meshes[[paste0(hemi, "_semi-inflated")]] <- list(
    vertices = semi_verts,
    faces = all_meshes[[paste0(hemi, "_white")]]$faces
  )

  cli::cli_alert_success(
    "{hemi}_semi-inflated: {nrow(semi_verts)}v (interpolated)"
  )
}

# Midthickness = 50/50 interpolation of pial and white
for (hemi in hemispheres) {
  cli::cli_alert_info("Computing {hemi}_midthickness...")

  pial_verts <- all_meshes[[paste0(hemi, "_pial")]]$vertices
  white_verts <- all_meshes[[paste0(hemi, "_white")]]$vertices

  mid_verts <- data.frame(
    x = 0.5 * pial_verts$x + 0.5 * white_verts$x,
    y = 0.5 * pial_verts$y + 0.5 * white_verts$y,
    z = 0.5 * pial_verts$z + 0.5 * white_verts$z
  )

  all_meshes[[paste0(hemi, "_midthickness")]] <- list(
    vertices = mid_verts,
    faces = all_meshes[[paste0(hemi, "_white")]]$faces
  )

  cli::cli_alert_success(
    "{hemi}_midthickness: {nrow(mid_verts)}v (interpolated)"
  )
}

make_pair <- function(surf) {
  list(
    lh = all_meshes[[paste0("lh_", surf)]],
    rh = all_meshes[[paste0("rh_", surf)]]
  )
}

brain_mesh_pial <- make_pair("pial")
brain_mesh_white <- make_pair("white")
brain_mesh_semi_inflated <- make_pair("semi-inflated")
brain_mesh_sphere <- make_pair("sphere")
brain_mesh_smoothwm <- make_pair("smoothwm")
brain_mesh_orig <- make_pair("orig")
brain_mesh_midthickness <- make_pair("midthickness")

usethis::use_data(
  brain_mesh_pial,
  brain_mesh_white,
  brain_mesh_semi_inflated,
  brain_mesh_midthickness,
  brain_mesh_sphere,
  brain_mesh_smoothwm,
  brain_mesh_orig,
  internal = TRUE,
  overwrite = TRUE,
  compress = "xz"
)

cli::cli_alert_success("Saved all cortical meshes to R/sysdata.rda")
