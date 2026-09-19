# Contributing benchmark results

If you are interested in running this on your platform, I would be interested in seeing the results.

Please run [`baseline_object_creation.R`] on unpatched R. Then run 
[`test_identicality.R`] and [`chol2inv_diag_benchmark.R`] with the patched R build and include:

- operating system;
- R version and SVN revision;
- BLAS/LAPACK implementation and version;
- CPU;
- `results` CSV produced by the benchmark;
- whether the correctness check passed.

If you add a pull request with the CSV under `results/`, I will take a look.
