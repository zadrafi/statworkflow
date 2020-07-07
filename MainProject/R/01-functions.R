# Necessary Packages

require(rms)
require(mice)
require(VIM)
require(tidyverse)
require(parallel)
require(bayesplot)
require(tidybayes)
require(Hmisc)
require(loo)
require(rstan)
require(rstanarm)
require(brms)
require(boot)
require(corrplot)
require(beepr)

set.seed(1031)

theme_set(theme_bw())
color_scheme_set("red")

rstan_options(auto_write = TRUE)
options(mc.cores = 4)

# define a loss function

kfold_rmse <- function(y, yrep, type = "rmse", reps, m, cores, cl = NULL) {
  yrep_mean <- colMeans(yrep)
  matrix_loss <- cbind(y, yrep_mean)
  n <- ((length(matrix_loss)) / 2)

  if (type == "rmse") {
    for (i in 1:n) {
      loss_looped <- sqrt(mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2])^2)))
      (looped_loss <- round(loss_looped, 2))
    }

    theta <- function(matrix_loss, i) {
      sqrt(mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2])^2)))
    }
  } else if (type == "mae") {
    for (i in 1:n) {
      loss_looped <- (mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2]))))
      (looped_loss <- round(loss_looped, 2))
    }


    theta <- function(matrix_loss, i) {
      (mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2]))))
    }
  }

  loss_bootstrap <- boot(
    data = matrix_loss, statistic = theta, R = reps, stype = "i",
    sim = "ordinary", parallel = "multicore", ncpus = cores, cl = NULL
  )

  loss_se <- sd(loss_bootstrap[["t"]])

  loss_ci <- boot.ci(loss_bootstrap,
    conf = c(0.90, 0.95),
    type = c("norm", "basic", "perc", "bca")
  )

  boot_loss_output <- list(looped_loss, loss_bootstrap, loss_se, loss_ci)
  names(boot_loss_output) <- c(
    "K-Fold Loss", "Bootstrapped K-Fold Loss",
    "Bootstrapped K-Fold Loss SE", "Bootstrapped K-Fold Loss Confidence Interval"
  )
  class(boot_loss_output) <- "concurve"
  return(boot_loss_output)
}


boot_loss <- function(pred, obs, type = "rmse", reps, m, cores, cl = NULL) {
  matrix_loss <- cbind(pred, obs)

  n <- ((length(matrix_loss)) / (2))

  if (type == "rmse") {
    for (i in 1:n) {
      loss_looped <- sqrt(mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2])^2)))
      (looped_loss <- round(loss_looped, 2))
    }

    theta <- function(matrix_loss, i) {
      sqrt(mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2])^2)))
    }
  } else if (type == "mae") {
    for (i in 1:n) {
      loss_looped <- (mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2]))))
      (looped_loss <- round(loss_looped, 2))
    }


    theta <- function(matrix_loss, i) {
      (mean((abs(matrix_loss[i, 1] - matrix_loss[i, 2]))))
    }
  }

  loss_bootstrap <- boot(
    data = matrix_loss, statistic = theta, R = reps, stype = "i",
    sim = "ordinary", parallel = "multicore", ncpus = cores, cl = NULL
  )

  loss_se <- sd(loss_bootstrap[["t"]])

  loss_ci <- boot.ci(loss_bootstrap,
    conf = c(0.90, 0.95),
    type = c("norm", "basic", "perc", "bca")
  )

  boot_loss_output <- list(looped_loss, loss_bootstrap, loss_se, loss_ci)
  names(boot_loss_output) <- c(
    "Looped Iteration Loss", "Bootstrapped Loss",
    "Loss SE", "Loss CI"
  )
  class(boot_loss_output) <- "concurve"
  return(boot_loss_output)
}

pkgbuild::has_build_tools(debug = TRUE)

dotR <- file.path(Sys.getenv("HOME"), ".R")
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, "Makevars")
if (!file.exists(M)) file.create(M)
cat("\nCXX14FLAGS=-O3 -march=native -mtune=native -fPIC",
  "CXX14=g++", # or clang++ but you may need a version postfix
  file = M, sep = "\n", append = TRUE
)
