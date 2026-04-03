# ggseg.meshes

Additional brain surface meshes for the
[ggsegverse](https://ggsegverse.github.io/ggseg/) ecosystem. Ships
cortical and cerebellar surfaces beyond the inflated cortical and SUIT
3D pial meshes bundled with the core packages.

## Meshes

### Cortical (fsaverage5)

All cortical meshes are at fsaverage5 resolution (10,242 vertices,
20,480 faces per hemisphere).

| Surface         | Description                                 |
|-----------------|---------------------------------------------|
| `pial`          | Grey matter / CSF boundary                  |
| `white`         | Grey / white matter boundary                |
| `semi-inflated` | 35/65 blend of white and inflated           |
| `sphere`        | Spherical registration surface              |
| `smoothwm`      | Smoothed white matter surface               |
| `orig`          | Original surface before topology correction |

### Cerebellar (SUIT)

| Surface     | Description                               |
|-------------|-------------------------------------------|
| `suit_flat` | SUIT flatmap projection (28,935 vertices) |

## Installation

Install from the [ggsegverse
r-universe](https://ggsegverse.r-universe.dev):

``` r
options(
  repos = c(
    ggsegverse = "https://ggsegverse.r-universe.dev",
    CRAN = "https://cloud.r-project.org"
  )
)
install.packages("ggseg.meshes")
```

Or from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("ggsegverse/ggseg.meshes")
```

## Usage

``` r
library(ggseg.meshes)

mesh <- get_cortical_mesh("lh", "pial")
str(mesh)
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
```

``` r
available_cortical_surfaces()
#> [1] "pial"          "white"         "semi-inflated" "sphere"       
#> [5] "smoothwm"      "orig"
available_cerebellar_surfaces()
#> [1] "suit_flat"
```

### With ggseg3d

ggseg.meshes integrates with
[ggseg3d](https://ggsegverse.github.io/ggseg3d/) through
`resolve_brain_mesh()`. When installed, all surfaces become available
for 3D rendering:

``` r
library(ggseg3d)

ggseg3d(atlas = dk(), surface = "pial") |>
  pan_camera("left lateral")
```

## Citation

Mowinckel & Vidal-Piñeiro (2020). *Visualization of Brain Statistics
With R Packages ggseg and ggseg3d.* Advances in Methods and Practices in
Psychological Science.
[doi:10.1177/2515245920928009](https://doi.org/10.1177/2515245920928009)

## Funding

This tool is partly funded by:

**EU Horizon 2020 Grant:** Healthy minds 0-100 years: Optimising the use
of European brain imaging cohorts (Lifebrain).

**Grant agreement number:** 732592.

**Call:** Societal challenges: Health, demographic change and well-being
