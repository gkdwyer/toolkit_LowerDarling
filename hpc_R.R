# R setup for HPC

# This bit is needed for HPCs, where we need to have already hassled the owner
# to install the C dependencies, or it stuffs up the install because of sf etc

renvpaths <- .libPaths()
.libPaths(new = c(renvpaths,'/ceph-g/opt/R/4.3/lib/R/library' ))
Sys.setenv('R_LIBS' = '/ceph-g/opt/R/4.3/lib/R/library')

renv::install('git@github.com:MDBAuth/HydroBOT.git@galen_working',
              rebuild = TRUE, upgrade = 'always', git = 'external', prompt = FALSE)

# git2r also needs C. And some of this is just dev, which we wouldn't do on an HPC
renv::install(c('ggthemes',
                'knitr',
                'patchwork',
                # 'rmapshaper (>= 0.4.6)',
                'colorspace',
                'rmarkdown',
                'scico',
                # 'testthat (>= 3.0.0)',
                # 'vdiffr',
                # 'withr',
                # 'git2r',
                'jsonlite',
                'foreach',
                'furrr',
                'future',
                'DiagrammeRsvg',
                'rsvg',
                'metR',
                'PCICt',
                'ncdf4',
                'lubridate'))

deps <- unique(renv::dependencies()$Package)
pkgavail <- dimnames(installed.packages())[[1]]

not_installed <- deps[!deps %in% pkgavail]

if (length(not_installed) > 0) {
  message(paste0("These packages are not installed: ", not_installed,
                 '.\nThey are in the object `not_installed`, so first thing to try is `renv::install(not_installed)`\n',
                 'sf may need admin help due to C libraries\n',
                 'CC2 and other github packages seem to need to be handled manually'))
}

# install py-ewr through R?
reticulate::py_install('git+https://github.com/MDBAuth/EWR_tool.git@GalenH')
