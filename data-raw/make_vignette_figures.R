# Regenerate vignette mesh figures
#
# Run with: source("data-raw/make_vignette_figures.R")

devtools::load_all(".")

render_mesh_png <- function(mesh, filename, width = 600, height = 400) {
  verts <- mesh$vertices
  faces <- mesh$faces

  base_idx <- attr(mesh, "face_index_base")
  if (!is.null(base_idx) && base_idx == 0L) {
    faces <- faces + 1L
  }

  x <- verts$x
  y <- verts$z

  depth <- (verts$y[faces$i] + verts$y[faces$j] + verts$y[faces$k]) / 3
  face_order <- order(depth)

  shades <- vapply(
    seq_len(nrow(faces)),
    function(idx) {
      v1 <- as.numeric(verts[faces$i[idx], ])
      v2 <- as.numeric(verts[faces$j[idx], ])
      v3 <- as.numeric(verts[faces$k[idx], ])
      e1 <- v2 - v1
      e2 <- v3 - v1
      normal <- c(
        e1[2] * e2[3] - e1[3] * e2[2],
        e1[3] * e2[1] - e1[1] * e2[3],
        e1[1] * e2[2] - e1[2] * e2[1]
      )
      n_len <- sqrt(sum(normal^2))
      if (n_len < 1e-10) {
        return(0.5)
      }
      normal <- normal / n_len
      light <- c(-0.3, -1, 0.7)
      light <- light / sqrt(sum(light^2))
      0.35 + 0.65 * max(0, sum(normal * light))
    },
    numeric(1)
  )

  cols <- grDevices::grey(shades)

  grDevices::png(filename, width = width, height = height, bg = "white")
  graphics::par(mar = c(0, 0, 0, 0))
  graphics::plot(
    NULL,
    xlim = range(x),
    ylim = range(y),
    asp = 1,
    axes = FALSE,
    xlab = "",
    ylab = ""
  )

  for (fi in face_order) {
    xi <- x[c(faces$i[fi], faces$j[fi], faces$k[fi])]
    yi <- y[c(faces$i[fi], faces$j[fi], faces$k[fi])]
    graphics::polygon(xi, yi, col = cols[fi], border = NA)
  }

  grDevices::dev.off()
}


can_render_png <- function() {
  tryCatch(
    {
      tmp <- tempfile(fileext = ".png")
      grDevices::png(tmp, width = 10, height = 10)
      grDevices::dev.off()
      unlink(tmp)
      TRUE
    },
    error = function(e) FALSE
  )
}

fig_dir = "vignettes/figures"
if (!can_render_png()) {
  cli::cli_alert_warning("PNG rendering not available, skipping figures")
  return(invisible(NULL))
}

if (!dir.exists(fig_dir)) {
  dir.create(fig_dir, recursive = TRUE)
}

for (surf in available_cortical_surfaces()) {
  mesh <- get_cortical_mesh("lh", surf)
  outfile <- file.path(fig_dir, paste0("mesh-", surf, ".png"))
  render_mesh_png(mesh, outfile)
  cli::cli_alert_success("Saved {outfile}")
}

flat <- get_cerebellar_flatmap()
outfile <- file.path(fig_dir, "mesh-suit_flat.png")
render_mesh_png(flat, outfile)
cli::cli_alert_success("Saved {outfile}")
invisible(NULL)
