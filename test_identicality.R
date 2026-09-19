### RUN FROM PATCH R-DEVEL TRUNK, AFTER GENERATING THE BASELINE OBJECT
b <- readRDS("../chol2inv-baseline.rds")

## Existing behaviour must be unchanged
for (i in seq_along(b$U)) {
  print(paste(b$sizes[i], "Factors identical:"))
  print(identical(
    chol2inv(b$U[[i]]),
    b$full[[i]]
  ))
}

## New operation
for (i in seq_along(b$U)) {
  U <- b$U[[i]]

  ref <- diag(chol2inv(U))
  got <- chol2inv(U, diag.only = TRUE)

  cat(
    "n =",
    nrow(U),
    " identical =",
    identical(ref, got),
    " maxdiff =",
    max(abs(ref - got)),
    "\n"
  )

  print(isTRUE(all.equal(
    got,
    ref,
    tolerance = 1e-12
  )))
}
