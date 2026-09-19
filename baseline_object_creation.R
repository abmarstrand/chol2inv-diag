### RUN FROM THE UNMODIFIED R-DEVEL TRUNK
set.seed(20260918)

sizes <- c(1L, 2L, 5L, 10L, 20L, 50L, 100L, 200L, 500L, 1000L, 2000L, 5000L)

U <- lapply(sizes, function(n) {
  X <- matrix(rnorm(n * n), n)
  A <- crossprod(X) + diag(n)
  chol(A)
})

full <- lapply(U, chol2inv)

saveRDS(
  list(sizes = sizes, U = U, full = full),
  "../../chol2inv-baseline.rds",
  version = 3
)

q()
