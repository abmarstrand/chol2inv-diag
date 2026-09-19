sizes <- c(
    1,
    2,
    3,
    5,
    10,
    20,
    30,
    50,
    100,
    200,
    300,
    500,
    1000,
    2000,
    3000,
    5000,
    7500,
    10000
)

seed0 <- 20260918L

nrep <- function(n) {
    c(50, 20, 10, 7, 5, 3)[1 + sum(n > c(100, 500, 1000, 2000, 5000))]
}

make_U <- function(n, seed) {
    set.seed(seed)
    U <- matrix(0, n, n)
    for (j in seq_len(n)[-1]) {
        U[seq_len(j - 1), j] <- rnorm(j - 1, sd = 0.05 / sqrt(n))
    }
    diag(U) <- runif(n, 1.25, 1.75)
    U
}

chol2inv_diag_benchmark <- do.call(
    rbind,
    lapply(sizes, function(n) {
        U <- make_U(n, seed0 + n)
        ref <- diag(chol2inv(U))
        got <- chol2inv(U, diag.only = TRUE)
        reps <- nrep(n)

        s <- summary(
            microbenchmark::microbenchmark(
                full = diag(chol2inv(U)),
                diag_only = chol2inv(U, diag.only = TRUE),
                times = reps,
                unit = "s"
            ),
            unit = "s"
        )

        full <- s[s$expr == "full", ]
        diag_only <- s[s$expr == "diag_only", ]

        data.frame(
            n,
            matrix_gib = 8 * n^2 / 1024^3,
            repetitions = reps,
            identical = identical(ref, got),
            max_abs_diff = max(abs(ref - got)),
            full_median_s = full$median,
            diag_only_median_s = diag_only$median,
            speedup = full$median / diag_only$median,
            full_min_s = full$min,
            diag_only_min_s = diag_only$min,
            full_max_s = full$max,
            diag_only_max_s = diag_only$max
        )
    })
)

write.csv(
    chol2inv_diag_benchmark,
    "chol2inv_diag_benchmark.csv",
    row.names = FALSE
)

with(chol2inv_diag_benchmark, {
    png("chol2inv_diag_timing_loglog.png", 1200, 800, res = 130)
    matplot(
        n,
        cbind(full_median_s, diag_only_median_s),
        log = "xy",
        type = "b",
        pch = 1:2,
        lty = 1,
        xlab = "Matrix dimension n (log scale)",
        ylab = "Median time, seconds (log scale)"
    )
    legend(
        "topleft",
        c("diag(chol2inv(U))", "chol2inv(U, diag.only=TRUE)"),
        pch = 1:2,
        lty = 1,
        bty = "n"
    )
    dev.off()

    png("chol2inv_diag_speedup.png", 1200, 800, res = 130)
    plot(
        n,
        speedup,
        log = "x",
        type = "b",
        pch = 1,
        xlab = "Matrix dimension n (log scale)",
        ylab = "Speedup"
    )
    abline(h = 1, lty = 2)
    dev.off()
})

chol2inv_diag_benchmark
