# ==================================================================== #
# TITLE                                                                #
# Antimicrobial Resistance (AMR) Data Analysis for R                   #
#                                                                      #
# SOURCE                                                               #
# https://github.com/msberends/AMR                                     #
#                                                                      #
# LICENCE                                                              #
# (c) 2018-2021 Berends MS, Luz CF et al.                              #
# Developed at the University of Groningen, the Netherlands, in        #
# collaboration with non-profit organisations Certe Medical            #
# Diagnostics & Advice, and University Medical Center Groningen.       # 
#                                                                      #
# This R package is free software; you can freely use and distribute   #
# it for both personal and commercial purposes under the terms of the  #
# GNU General Public License version 2.0 (GNU GPL-2), as published by  #
# the Free Software Foundation.                                        #
# We created this package for both routine data analysis and academic  #
# research and it was publicly released in the hope that it will be    #
# useful, but it comes WITHOUT ANY WARRANTY OR LIABILITY.              #
#                                                                      #
# Visit our website for the full manual and a complete tutorial about  #
# how to conduct AMR data analysis: https://msberends.github.io/AMR/   #
# ==================================================================== #

# set up package environment, used by numerous AMR functions
pkg_env <- new.env(hash = FALSE)
pkg_env$mo_failed <- character(0)

# determine info icon for messages
utf8_supported <- isTRUE(base::l10n_info()$`UTF-8`)
is_latex <- tryCatch(import_fn("is_latex_output", "knitr", error_on_fail = FALSE)(),
                     error = function(e) FALSE)
if (utf8_supported && !is_latex) {
  # \u2139 is a symbol officially named 'information source'
  pkg_env$info_icon <- "\u2139"
} else {
  pkg_env$info_icon <- "i"
}

.onLoad <- function(libname, pkgname) {
  # Support for tibble headers (type_sum) and tibble columns content (pillar_shaft)
  # without the need to depend on other packages. This was suggested by the 
  # developers of the vctrs package: 
  # https://github.com/r-lib/vctrs/blob/05968ce8e669f73213e3e894b5f4424af4f46316/R/register-s3.R
  s3_register("pillar::pillar_shaft", "ab")
  s3_register("pillar::pillar_shaft", "mo")
  s3_register("pillar::pillar_shaft", "rsi")
  s3_register("pillar::pillar_shaft", "mic")
  s3_register("pillar::pillar_shaft", "disk")
  s3_register("tibble::type_sum", "ab")
  s3_register("tibble::type_sum", "mo")
  s3_register("tibble::type_sum", "rsi")
  s3_register("tibble::type_sum", "mic")
  s3_register("tibble::type_sum", "disk")
  # Support for frequency tables from the cleaner package
  s3_register("cleaner::freq", "mo")
  s3_register("cleaner::freq", "rsi")
  # Support from skim() from the skimr package
  s3_register("skimr::get_skimmers", "mo")
  s3_register("skimr::get_skimmers", "rsi")
  s3_register("skimr::get_skimmers", "mic")
  s3_register("skimr::get_skimmers", "disk")
  s3_register("ggplot2::ggplot", "rsi")
  s3_register("ggplot2::ggplot", "mic")
  s3_register("ggplot2::ggplot", "disk")
  s3_register("ggplot2::ggplot", "resistance_predict")
  
  # if mo source exists, fire it up (see mo_source())
  try({
    if (file.exists(getOption("AMR_mo_source", "~/mo_source.rds"))) {
      invisible(get_mo_source())
    }
  }, silent = TRUE)
}
