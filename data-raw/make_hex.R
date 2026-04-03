# Generate hex logo for ggseg.meshes
#
# Run with: source("data-raw/make_hex.R")

library(hexSticker)
library(ggplot2)
devtools::load_all(".")

mesh <- get_cortical_mesh("lh", "pial")
verts <- mesh$vertices
faces <- mesh$faces

edges <- rbind(
  data.frame(from = faces$i, to = faces$j),
  data.frame(from = faces$i, to = faces$k),
  data.frame(from = faces$j, to = faces$k)
)
edges$key <- paste(pmin(edges$from, edges$to), pmax(edges$from, edges$to))
edges <- edges[!duplicated(edges$key), ]

segments <- data.frame(
  x = verts$x[edges$from],
  y = verts$z[edges$from],
  xend = verts$x[edges$to],
  yend = verts$z[edges$to]
)

p <- ggplot(segments) +
  geom_segment(
    aes(x = x, y = y, xend = xend, yend = yend),
    colour = "#a8c5cb",
    linewidth = 0.03,
    alpha = 0.6
  ) +
  coord_fixed() +
  theme_void() +
  theme_transparent()

hex_args <- list(
  package = "ggseg.meshes",
  s_y = 1.15,
  s_x = 1,
  s_width = 1.6,
  s_height = 1.2,
  p_family = "mono",
  p_size = 7,
  p_color = "#a8c5cb",
  p_y = .5,
  h_fill = "#13293a",
  h_color = "#29393e"
)

do.call(sticker, c(list(p, filename = "man/figures/logo.svg"), hex_args))
do.call(sticker, c(list(p, filename = "man/figures/logo.png"), hex_args))
