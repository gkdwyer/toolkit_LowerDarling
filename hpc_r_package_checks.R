# I don't think the renv install is necessary-it should auto-install since there's a project skeleton

# This bit is needed for HPCs, where we need to have already hassled the owner
# to install the C dependencies, or it stuffs up the install because of sf etc

renvpaths <- .libPaths()
.libPaths(new = c(renvpaths,'/ceph-g/opt/R/4.3/lib/R/library' ))
Sys.setenv('R_LIBS' = '/ceph-g/opt/R/4.3/lib/R/library')
# # TESTING DELETE
# library(foreach)
# library(doFuture)
#
# plan(list(tweak(future.batchtools::batchtools_slurm,
#                 template = "batchtools.slurm.tmpl",
#                 resources = list(time = 10,
#                                  ntasks.per.node = 12,
#                                  mem = "70GB",
#                                  job.name = 'area_inundated')),
#           multicore))
#
# mi <- list(rver = getRversion(), libs = .libPaths())
# wi %<-% list(rver = getRversion(), libs = .libPaths())
#
# mi
# wi
# # END TESTING

# renv::install('git@github.com:MDBAuth/HydroBOT.git',
#               # dependencies = 'most',
#               # exclude = 'git2r', # requires its own C lib
#               rebuild = TRUE, upgrade = 'always', git = 'external', prompt = FALSE)

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

# NOTE:
# renv might think it has installed sf, but fail, and then need to actually remove it and just send through the .libPaths.
