# Get SUIT cerebellar flatmap mesh

Retrieves the SUIT cerebellar flatmap surface mesh. This is a 2D
flattened representation of the cerebellar cortex, useful for
visualising cerebellar parcellations without 3D rendering.

## Usage

``` r
get_cerebellar_flatmap(surface = .cerebellar_surfaces)
```

## Arguments

- surface:

  Surface type. Currently only `"suit_flat"`.

## Value

A list with `vertices` (data.frame with x, y, z) and `faces` (data.frame
with i, j, k, 0-based indices matching `ggseg.formats` convention for
cerebellar meshes). Has attribute `face_index_base = 0L`.

## Details

The projection is exactly flat: `z` is `0` for every one of the 28,935
vertices.

The flatmap's vertices are the first 28,935 of the 30,013 in the SUIT 3D
pial surface in `ggseg.formats`, in the same order. The remaining 1,078
are the peduncular cap, which has no flatmap counterpart. A cerebellar
atlas vertex index below 28,935 therefore applies to this mesh
unchanged; indices from 28,935 upwards cannot be drawn on the flatmap.
101 of the 28,935 vertices appear in no face, so values on them are
carried but never rendered.

## See also

Other cerebellar meshes:
[`available_cerebellar_surfaces()`](https://ggsegverse.github.io/ggseg.meshes/reference/available_cerebellar_surfaces.md)

## Examples

``` r
mesh <- get_cerebellar_flatmap()
str(mesh, max.level = 2)
#> List of 2
#>  $ vertices:'data.frame':    28935 obs. of  3 variables:
#>   ..$ x: num [1:28935] 21.2 20.5 19.7 19 23.2 ...
#>   ..$ y: num [1:28935] 2.57 2.44 1.82 1.82 2.56 ...
#>   ..$ z: num [1:28935] 0 0 0 0 0 0 0 0 0 0 ...
#>  $ faces   :'data.frame':    56588 obs. of  3 variables:
#>   ..$ i: int [1:56588] 0 8 0 139 0 0 1 9 1 1 ...
#>   ..$ j: int [1:56588] 1 7 138 1 7 162 2 8 139 140 ...
#>   ..$ k: int [1:56588] 7 1 1 138 162 138 8 2 140 2 ...
#>  - attr(*, "face_index_base")= int 0
head(mesh$faces)
#>     i   j   k
#> 1   0   1   7
#> 2   8   7   1
#> 3   0 138   1
#> 4 139   1 138
#> 5   0   7 162
#> 6   0 162 138
attr(mesh, "face_index_base")
#> [1] 0
```
