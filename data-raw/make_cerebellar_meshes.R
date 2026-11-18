# Generate cerebellar flatmap mesh for ggseg.meshes
#
# Reads the SUIT flatmap GIFTI surface from ggseg.extra and stores it as a
# mesh object alongside the cortical meshes. Reading is
# ggseg.extra::read_surface_mesh()'s job, so the ecosystem decides in one
# place how to read a surface and what its faces count from.
#
# Run with: source("data-raw/make_cerebellar_meshes.R")

rlang::check_installed(c("ggseg.extra", "ggseg.formats"))

flatmap_path <- ggseg.extra::suit_flatmap_path()
cli::cli_alert_info("Reading SUIT flatmap from {flatmap_path}")

# A flatmap is the extreme case of a surface with no anatomical position:
# every vertex has been moved to lie in a plane, so anatomical = FALSE and
# there is no affine to MNI305. Recording that is what stops a consumer
# placing a point on it and believing the coordinates mean something.
cerebellar_mesh_suit_flat <- ggseg.extra::read_surface_mesh(
  flatmap_path,
  space = ggseg.formats::mesh_space(
    vertex_space = "suit",
    hemi = "midline",
    anatomical = FALSE,
    units = "mm",
    surface = "suit-flatmap",
    source = paste("SUIT", basename(flatmap_path))
  ),
  face_index_base = 0L
)

cli::cli_alert_success(
  "SUIT flatmap: {nrow(cerebellar_mesh_suit_flat$vertices)}v,
   {nrow(cerebellar_mesh_suit_flat$faces)}f"
)

source("data-raw/save_sysdata.R")
save_sysdata()
