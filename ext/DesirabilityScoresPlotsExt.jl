module DesirabilityScoresPlotsExt

using DesirabilityScores
using Plots
using Plots.PlotMeasures

_require_argument(condition, message) = condition || throw(ArgumentError(message))

"""
    des_plot(x, y; des_line_col = :black, des_line_width = 3, hist_args...)

Plots a histogram and overlays the desirability scores.

# Arguments
- `x`: A non-empty vector of values to map. Non-missing elements must
  be a subtype of `Real`. Need not be sorted -- this is done before
  passing to the plotting function. This also means that tuples
  are not acceptable (since they are immutable).

- `y`: A non-empty vector of desirability scores. Need not be sorted,
  but must be in the proper order with respect to x (i.e., datum `x[1]`
  has desirability `y[1]`. As with `x`, tuples are not acceptable.

- `des_line_col`: A string or symbol specifying color of the line.

- `des_line_width`: An integer specifying the line width.

- `hist_args...`: Additional arguments for the `Plot.jl`'s
  `histogram()` function.

# Examples
```julia-repl
    x = randn(1000)
    y = d_high(x, -1, 1; des_min = 0.1, des_max = 0.8, scale = 2)

    des_plot(x, y, des_line_col = :orange1; color = :steelblue)
```
"""
function DesirabilityScores.des_plot(
    x::AbstractVector,
    y::AbstractVector;
    des_line_col = :black,
    des_line_width = 3,
    hist_args...,
)
    skip_missing_x = collect(skipmissing(x))
    skip_missing_y = collect(skipmissing(y))
    _require_argument(length(x) == length(y), "x and y must have equal lengths")
    _require_argument(length(skip_missing_x) > 1, "x must contain more than 1 non-missing value")
    _require_argument(length(skip_missing_y) > 1, "y must contain more than 1 non-missing value")
    _require_argument(eltype(skip_missing_x) <: Real, "Non-missing elements of x must be a subtype of Real")
    _require_argument(eltype(skip_missing_y) <: Real, "Non-missing elements of y must be a subtype of Real")

    y = y[sortperm(x)]
    x = sort(x)

    p = histogram(x, label = false; right_margin = 15mm, hist_args...)

    y_axis_values = p[1][1][:y]
    max_y = maximum(filter(!isnan, y_axis_values))

    p = plot!(x, y * max_y, color = des_line_col, lw = des_line_width, label = false)
    p = plot!(twinx(), [0, 0], label = false, ylim = (0, 1), ylabel = "Desirability")

    return p
end

end
