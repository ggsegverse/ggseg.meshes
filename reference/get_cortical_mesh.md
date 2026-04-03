# Get cortical brain surface mesh

Retrieves a cortical brain surface mesh for the specified hemisphere and
surface type. All surfaces are fsaverage5 resolution (10,242 vertices,
20,480 faces per hemisphere).

## Usage

``` r
get_cortical_mesh(hemisphere = c("lh", "rh"), surface = .cortical_surfaces)
```

## Arguments

- hemisphere:

  `"lh"` or `"rh"`

- surface:

  Surface type: `"pial"`, `"white"`, `"semi-inflated"`, `"sphere"`,
  `"smoothwm"`, or `"orig"`

## Value

A list with `vertices` (data.frame with x, y, z) and `faces` (data.frame
with i, j, k, 1-based indices). Has attribute `face_index_base = 1L`.

## Examples

``` r
mesh <- get_cortical_mesh("lh", "pial")
nrow(mesh$vertices)
#> [1] 10242
```
