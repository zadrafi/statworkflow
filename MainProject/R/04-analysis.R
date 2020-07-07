# calling all packages, please report for duty

source(here("R", "01-functions.R")) 

library(brms) 

# This is a script I used previously where I used Bayes for penalization  

# Although these are all generic options 

# of observations

n_1 <- nrow(z)

# of predictors

k_1 <- (ncol(z) - 1)

# prior guess for the number of relevant variables

p0_1 <- 5 

# scale for tau

tau0_1 <- p0_1 / (k_1 - p0_1) * 1 / sqrt(n_1)

# regularized horseshoe prior

hs_prior <- set_prior("horseshoe(scale_global = tau0_1, scale_slab = 1)", 
                      class = "b")

full_mod1_shrunk <- brm_multiple(
  bf(y ~ x1 + x2 + x3 + x4 +
       x5 + x6 + x7 + x8 +
       x9 + x10 + x11 + x12 +
       x13 + x14 + x15 + x16 +
       x17 + x18 + x19 + x20 + x21, quantile = 0.50),
  data = z, prior = hs_prior, 
  family = asym_laplace(), save_all_pars = TRUE,
  iter = 20000, warmup = 5000, chains = 4, 
  cores = 4, thin = 1, combine = TRUE, seed = 1031, 
  control = list(max_treedepth = 15, adapt_delta = 0.9999))

# principled workflow

saveRDS(model1_full_penalized, 
        here("Main Project", "Data", "Models", "model1_full_penalized.rds")) 

beep(3)
