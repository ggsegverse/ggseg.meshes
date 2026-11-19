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

A list with `vertices` (data.frame with x, y, z, in FreeSurfer's native
axes) and `faces` (data.frame with i, j, k, 1-based indices). Has
attributes `face_index_base = 1L` and `mesh_space`.

## Details

Coordinates are FreeSurfer's own: `x` is left-right (negative left), `y`
is anterior-posterior (positive anterior) and `z` is superior-inferior
(positive superior). Plotting `y` against `z` gives a lateral view with
anterior to the right; `x` against `z` gives a coronal view.

Each mesh carries a
[`ggseg.formats::mesh_space()`](https://ggsegverse.github.io/ggseg.formats/reference/mesh_space.html),
read with
[`ggseg.formats::get_mesh_space()`](https://ggsegverse.github.io/ggseg.formats/reference/set_mesh_space.html),
recording its vertex space, hemisphere, whether the coordinates are
anatomical, and the mapping to MNI305. Reading that is how a consumer
places a point without knowing where the mesh came from. `pial`,
`white`, `smoothwm`, `orig` and `midthickness` are anatomical and map to
MNI305 by the identity, fsaverage being an MNI305 average;
`semi-inflated` and `sphere` have had every vertex moved and so record
no mapping at all.

## Coordinates changed in 0.0.1.9002

Before that version the stored coordinates were rotated 90 degrees from
FreeSurfer's native axes – stored `x` was anterior-posterior and stored
`y` was left-right – and `ggseg3d` rotated them back, so the pair was a
round trip to identity for the only consumer there was. Code that read
these meshes directly and relied on the rotated convention needs its
axes swapped: old `x` is now `y`, and old `y` is now `-x`.

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
#>   ..$ x: num [1:10242] -38.74 -16.66 -9.72 -24.02 -59.86 ...
#>   ..$ y: num [1:10242] -19.3434 -69.0612 -9.2333 43.1149 0.0493 ...
#>   ..$ z: num [1:10242] 67.22 61.28 46.58 23.93 8.97 ...
#>  $ faces   :'data.frame':    20480 obs. of  3 variables:
#>   ..$ i: int [1:20480] 1 1 1 1 1 4 4 4 5 5 ...
#>   ..$ j: int [1:20480] 2565 2563 2566 2568 2570 2575 2573 2576 2582 2580 ...
#>   ..$ k: int [1:20480] 2563 2566 2568 2570 2565 2573 2576 2578 2580 2583 ...
#>  - attr(*, "face_index_base")= int 1
#>  - attr(*, "mesh_space")=List of 8
#>   ..$ schema_version: int 1
#>   ..$ vertex_space  : chr "fsaverage5"
#>   ..$ hemi          : chr "left"
#>   ..$ anatomical    : logi TRUE
#>   ..$ to_mni305     : num [1:4, 1:4] 1 0 0 0 0 1 0 0 0 0 ...
#>   ..$ units         : chr "mm"
#>   ..$ surface       : chr "pial"
#>   ..$ source        : chr "freesurfer-macOS-darwin_arm64-8.2.0-20260314-d932c45 fsaverage5 lh.pial"
#>   ..- attr(*, "class")= chr "mesh_space"
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
