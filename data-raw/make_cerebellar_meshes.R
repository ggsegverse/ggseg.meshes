# Generate cerebellar flatmap mesh for ggseg.meshes
#
# Reads the SUIT flatmap GIFTI surface from ggseg.extra and stores it
# as a mesh object alongside the cortical meshes.
# Requires gifti package.
#
# Run with: source("data-raw/make_cerebellar_meshes.R")

if (!requireNamespace("gifti", quietly = TRUE)) {
  stop("gifti package is required. Install with: install.packages('gifti')")
}

if (!requireNamespace("ggseg.extra", quietly = TRUE)) {
  stop("ggseg.extra is required for SUIT surface paths.")
}

flatmap_path <- ggseg.extra::suit_flatmap_path()
cli::cli_alert_info("Reading SUIT flatmap from {flatmap_path}")

gii <- gifti::readgii(flatmap_path)

vertices <- as.data.frame(gii$data[[1]])
names(vertices) <- c("x", "y", "z")

faces <- as.data.frame(gii$data[[2]])
names(faces) <- c("i", "j", "k")

cerebellar_mesh_suit_flat <- list(
  vertices = vertices,
  faces = faces
)

cli::cli_alert_success(
  "SUIT flatmap: {nrow(vertices)}v, {nrow(faces)}f"
)

source("data-raw/save_sysdata.R")
save_sysdata()
