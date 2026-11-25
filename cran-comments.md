## R CMD check results

0 errors | 0 warnings | 0 notes

Checked with `_R_CHECK_FORCE_SUGGESTS_=false`: `ggseg.formats` is suggested at
a development version that is not on CRAN yet, and an installed-but-older
`Suggests` is a hard ERROR at "checking package dependencies" without that
flag. With it, the three `mesh_space` tests skip and 188 assertions pass.

BEFORE SUBMITTING: `ggseg.formats` goes to CRAN first. Move this floor to its
released version once it is accepted, so the check passes without the flag.

## Test environments

- local macOS (aarch64-apple-darwin20), R 4.5.1

## Notes

This is a maintenance update. There is no change to exported functions or to
the shipped mesh data since 0.0.1; the only change is a reduction in the size
of the vignette figures and the package logo, which brings the source tarball
back under the 5 MB limit.
