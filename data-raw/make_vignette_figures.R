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

  is_flat <- diff(range(verts$z)) < 1e-6

  if (is_flat) {
    x <- verts$x
    y <- verts$y
  } else {
    x <- verts$x
    y <- verts$z
  }

  edges <- rbind(
    data.frame(from = faces$i, to = faces$j),
    data.frame(from = faces$i, to = faces$k),
    data.frame(from = faces$j, to = faces$k)
  )
  edges$key <- paste(pmin(edges$from, edges$to), pmax(edges$from, edges$to))
  edges <- edges[!duplicated(edges$key), ]

  bg <- "#13293a"
  fg <- "#a8c5cb"

  grDevices::png(filename, width = width, height = height, bg = bg)
  graphics::par(mar = c(1, 1, 1, 1))
  graphics::plot(
    NULL,
    xlim = range(x),
    ylim = range(y),
    asp = 1,
    axes = FALSE,
    xlab = "",
    ylab = ""
  )

  graphics::segments(
    x[edges$from], y[edges$from],
    x[edges$to], y[edges$to],
    col = grDevices::adjustcolor(fg, alpha.f = 0.4),
    lwd = 0.15
  )

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
