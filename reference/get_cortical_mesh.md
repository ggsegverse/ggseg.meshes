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

  Surface type: `"pial"`, `"white"`, `"midthickness"`,
  `"semi-inflated"`, `"sphere"`, `"smoothwm"`, or `"orig"`

## Value

A list with `vertices` (data.frame with x, y, z, in the rotated
convention described above) and `faces` (data.frame with i, j, k,
1-based indices). Has attribute `face_index_base = 1L`.

## Details

The stored coordinates are rotated 90 degrees from FreeSurfer's native
axes, so they do not mean what the names x, y, z usually mean on a
FreeSurfer-derived surface. `x` is the anterior-posterior axis (positive
anterior), `y` is the left-right axis (positive left, so the left
hemisphere sits at positive `y`), and `z` is the superior-inferior axis
(positive superior, unrotated). Plotting `x` against `z` therefore gives
a lateral view with anterior to the right and superior at the top;
plotting `y` against `z` gives a coronal view.

## See also

[`ggseg.formats::get_brain_mesh()`](https://ggsegverse.github.io/ggseg.formats/reference/get_brain_mesh.html)
for the inflated cortical mesh bundled with the core packages, whose
faces are 0-based, and `ggseg3d::resolve_brain_mesh()`, which resolves
these surfaces for 3D rendering.

Other cortical meshes:
[`available_cortical_surfaces()`](https://ggsegverse.github.io/ggseg.meshes/reference/available_cortical_surfaces.md)

## Examples

``` r
mesh <- get_cortical_mesh("lh", "pial")
str(mesh, max.level = 2)
#> List of 2
#>  $ vertices:'data.frame':    10242 obs. of  3 variables:
#>   ..$ x: num [1:10242] -19.3434 -69.0612 -9.2333 43.1149 0.0493 ...
#>   ..$ y: num [1:10242] 38.74 16.66 9.72 24.02 59.86 ...
#>   ..$ z: num [1:10242] 67.22 61.28 46.58 23.93 8.97 ...
#>  $ faces   :'data.frame':    20480 obs. of  3 variables:
#>   ..$ i: int [1:20480] 1 1 1 1 1 4 4 4 5 5 ...
#>   ..$ j: int [1:20480] 2565 2563 2566 2568 2570 2575 2573 2576 2582 2580 ...
#>   ..$ k: int [1:20480] 2563 2566 2568 2570 2565 2573 2576 2578 2580 2583 ...
#>  - attr(*, "face_index_base")= int 1
head(mesh$faces)
#>   i    j    k
#> 1 1 2565 2563
#> 2 1 2563 2566
#> 3 1 2566 2568
#> 4 1 2568 2570
#> 5 1 2570 2565
#> 6 4 2575 2573
attr(mesh, "face_index_base")
#> [1] 1
```
