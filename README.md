# DesirabilityScores


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://stanlazic.github.io/DesirabilityScores.jl/stable/)
[![Build Status](https://github.com/stanlazic/DesirabilityScores.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/stanlazic/DesirabilityScores.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://app.travis-ci.com/stanlazic/DesirabilityScores.jl.svg?branch=master)](https://app.travis-ci.com/stanlazic/DesirabilityScores.jl)
[![Coverage](https://codecov.io/gh/stanlazic/DesirabilityScores.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/stanlazic/DesirabilityScores.jl)


This package is a port of the `desiR` R package ([https://cran.r-project.org/web/packages/desiR/](https://cran.r-project.org/web/packages/desiR/)). It contains functions for ranking, selecting, and integrating data. Main uses to date have been (1) prioritising genes, proteins, and metabolites from high dimensional biology experiments, (2) multivariate hit calling in high-content drug discovery screens, and (3) combining data from diverse sources.

The [vignette](https://cran.r-project.org/web/packages/desiR/vignettes/Gene_ranking.pdf) and [publication](https://peerj.com/articles/1444/) provide more details.

## Plotting

`des_plot` is provided through an extension, so plotting users should load both `DesirabilityScores` and `Plots`:

```julia
using DesirabilityScores
using Plots

x = randn(100)
y = d_high(x, -1, 1)

p = des_plot(x, y)
```
