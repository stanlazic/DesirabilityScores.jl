module DesirabilityScores

using StatsBase
using Plots

export d_4pl
export d_central
export d_ends
export d_high
export d_low
export d_overall
export d_rank
export des_line
"""
    d_4pl(x; hill, inflec, des_min = 0, des_max = 1)

Maps a numeric variable to a 0-1 scale with a 4 parameter logistic
function.

# Arguments

- `x`: Vector of reals.

- `des_min, des_max`: The lower and upper asymptotes of the   
   function. Defaults to zero and one, respectively.

- `hill`: Hill coefficient. It controls the steepness and direction of  
   the slope. A value greater than zero has a positive slope and a
   value less than zero has a negative slope. The higher the absolute  
   value, the steeper the slope. 

- `inflec`: Inflection point. Is the point on the x-axis where the
   curvature of the function changes from concave upwards to concave  
   downwards (or vice versa).

# Details 

This function uses a four parameter logistic model to map a
numeric variable onto a 0-1 scale. Whether high or low values are  
deemed desirable can be controlled with the `hill` parameter; when  
`hill` > 0 high values are desirable and when `hill` < 0 low values  
are desirable.

"""
function d_4pl(x; hill, inflec, des_min = 0, des_max = 1)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert hill ≠ 0.0 "The Hill coefficient must not equal zero"
    @assert 0 ≤ des_min ≤ 1 "des_min must be between zero and one"
    @assert 0 ≤ des_max ≤ 1 "des_max must be between zero and one"

    y = @. ((des_min - des_max) / (1 + ((x / inflec)^hill))) + des_max

    return y

end

"""
    d_central(x, cut1, cut2, cut3, cut4; des_min = 0, des_max = 1, scale = 1)

Maps a numeric variable to a 0-1 scale such that values in the
middle of the distribution are desirable. Values less than `cut1`
and greater than `cut4` will have a low desirability. Values
between `cut2` and `cut3` will have a high desirability. Values
between `cut1` and `cut2` and between `cut3` and `cut4` will have
intermediate values. This function is useful when extreme values
are undesirable. For example, outliers or values outside of
allowable ranges. If `cut2` and `cut3` are close to each other,
this function can be used when a target value is desirable.

# Arguments
- `x`: Vector of reals.

- `cut1`, `cut2`, `cut3`, `cut4`: Values of the original data that
define where the desirability function changes.

- `des_min, des_max`: The lower and upper asymptotes of the
function. Defaults to zero and one, respectively.

- `scale`: Controls how steeply the function increases or decreases.
"""
function d_central(x, cut1, cut2, cut3, cut4; des_min = 0, des_max = 1, scale = 1)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert cut1 < cut2 "cut1 must be less than cut2"
    @assert cut2 < cut3 "cut2 must be less than cut3"
    @assert cut3 < cut4 "cut3 must be less than cut4"
    @assert 0 ≤ des_min ≤ 1 "des_min must be between zero and one"
    @assert 0 ≤ des_max ≤ 1 "des_max must be between zero and one"
    @assert scale > 0 "scale must be greater than zero"

    # vector to hold results
    y = similar(x, Union{Float64,Missing})

    for i = 1:size(x, 1)
        if ismissing(x[i])
            y[i] = missing
        elseif x[i] ≤ cut1 || x[i] ≥ cut4
            y[i] = 0
        elseif cut2 ≤ x[i] ≤ cut3 #x[i] ≥ cut2 && x[i] ≤ cut3
            y[i] = 1
        elseif x[i] > cut1 && x[i] < cut2
            y[i] = ((x[i] - cut1) / (cut2 - cut1))^scale
        elseif x[i] > cut3 && x[i] < cut4
            y[i] = ((x[i] - cut4) / (cut3 - cut4))^scale
        end
    end

    # Rescale from des_min to des_max
    y = @. (y * (des_max - des_min)) + des_min

    return y

end

"""
        d_ends(x, cut1, cut2, cut3, cut4; des_min = 0, des_max = 1, scale = 1)

    Maps a numeric variable to a 0-1 scale such that values at the
    ends (both high and low) of the distribution are desirable. Values
    less than `cut1` and greater than `cut4` will have a high
    desirability. Values between `cut2` and `cut3` will have a low
    desirability. Values between `cut1` and `cut2` and between `cut3`
    and `cut4` will have intermediate values. This function is useful
    when the data represent differences between groups, where both
    high an low values are of interest.

    # Arguments
    - `x`: Vector of reals.

    - `cut1`, `cut2`, `cut3`, `cut4`: Values of the original data that
      define where the desirability function changes.

    - `des_min, des_max`: The lower and upper asymptotes of the
      function. Defaults to zero and one, respectively.

    - `scale`: Controls how steeply the function increases or decreases.
"""
function d_ends(x, cut1, cut2, cut3, cut4; des_min = 0, des_max = 1, scale = 1)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert cut1 < cut2 "cut1 must be less than cut2"
    @assert cut2 < cut3 "cut2 must be less than cut3"
    @assert cut3 < cut4 "cut3 must be less than cut4"
    @assert 0 ≤ des_min ≤ 1 "des_min must be between zero and one"
    @assert 0 ≤ des_max ≤ 1 "des_max must be between zero and one"
    @assert scale > 0 "scale must be greater than zero"

    # vector to hold results
    y = similar(x, Union{Float64,Missing})

    for i = 1:size(x, 1)
        if ismissing(x[i])
            y[i] = missing
        elseif x[i] ≤ cut1 || x[i] ≥ cut4
            y[i] = 1
        elseif cut2 ≤ x[i] ≤ cut3
            y[i] = 0
        elseif cut1 < x[i] < cut2
            y[i] = ((x[i] - cut2) / (cut1 - cut2))^scale
        elseif cut3 < x[i] < cut4
            y[i] = ((x[i] - cut3) / (cut4 - cut3))^scale
        end
    end

    # rescale:  des.min to des.max
    y = @. (y * (des_max - des_min)) + des_min

    return y

end

"""
        d_high(x, cut1, cut2; des_min = 0, des_max = 1, scale = 1)

    Maps a numeric variable to a 0-1 scale such that high values are
    desirable. Values less than `cut1` will have a low
    desirability. Values greater than `cut2` will have a high
    desirability. Values between `cut1` and `cut2` will have
    intermediate values.

    # Arguments
    - `x`: Vector of reals.

    - `cut1`, `cut2`: Values of the original data that
      define where the desirability function changes.

    - `des_min, des_max`: The lower and upper asymptotes of the
      function. Defaults to zero and one, respectively.

    - `scale`: Controls how steeply the function increases or decreases.
"""
function d_high(x, cut1, cut2; des_min = 0, des_max = 1, scale = 1)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert cut1 < cut2 "cut1 must be less than cut2"
    @assert 0 ≤ des_min ≤ 1 "des_min must be between zero and one"
    @assert 0 ≤ des_max ≤ 1 "des_max must be between zero and one"
    @assert scale > 0 "scale must be greater than zero"

    # vector to hold results
    y = similar(x, Union{Float64,Missing})

    for i = 1:size(x, 1)
        if ismissing(x[i])
            y[i] = missing
        elseif x[i] < cut1
            y[i] = 0
        elseif x[i] > cut2
            y[i] = 1
        else
            y[i] = ((x[i] - cut1) / (cut2 - cut1))^scale
        end
    end

    # rescale:  des_min to des_max
    y = @. (y * (des_max - des_min)) + des_min

    return y

end

"""
        d_low(x, cut1, cut2; des_min = 0, des_max = 1, scale = 1)

    Maps a numeric variable to a 0-1 scale such that low values are
    desirable. Values less than `cut1` will have a high
    desirability. Values greater than `cut2` will have a low
    desirability. Values between `cut1` and `cut2` will have
    intermediate values.

    # Arguments
    - `x`: Vector of reals.

    - `cut1`, `cut2`: Values of the original data that
      define where the desirability function changes.

    - `des_min, des_max`: The lower and upper asymptotes of the
      function. Defaults to zero and one, respectively.

    - `scale`: Controls how steeply the function increases or decreases.
"""
function d_low(x, cut1, cut2; des_min = 0, des_max = 1, scale = 1)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert cut1 < cut2 "cut1 must be less than cut2"
    @assert 0 ≤ des_min ≤ 1 "des_min must be between zero and one"
    @assert 0 ≤ des_max ≤ 1 "des_max must be between zero and one"
    @assert scale > 0 "scale must be greater than zero"

    # vector to hold results
    y = similar(x, Union{Float64,Missing})

    for i = 1:size(x, 1)
        if ismissing(x[i])
            y[i] = missing
        elseif x[i] < cut1
            y[i] = 1
        elseif x[i] > cut2
            y[i] = 0
        else
            y[i] = ((x[i] - cut2) / (cut1 - cut2))^scale
        end
    end

    # rescale:  des_min to des_max
    y = @. (y * (des_max - des_min)) + des_min

    return y

end

"""
        d_overall(d; weights = nothing)

    Combines any number of desirability values into an overall desirability.

    # Arguments
    - `d`: A matrix of desirabilities. Rows are observations and columns
      are desirabilities. Non-missing values must be a subtype of Real.

    - `weights`: Allows some desirabilities to count for more in the overall calculation.
      Defaults to equal weighting. If specified, must be a non-empty vector with elements
      a subtype of Real.
"""
function d_overall(d; weights = nothing)

    @assert d isa Matrix "First argument must be a matrix."
    skip_missing = collect(skipmissing(d))
    @assert eltype(skip_missing) <: Real "Desirabilities must be a subtype of Real"
    @assert 0 ≤ minimum(skip_missing) "Desirabilities must be between 0 and 1"
    @assert maximum(skip_missing) ≤ 1 "Desirabilities must be between 0 and 1"

    if weights ≠ nothing
        @assert eltype(weights) <: Real "Weights must be a subtype of Real"
        @assert length(weights) == size(d, 2) "Must be as many weights as desirabilities"
        @assert minimum(weights) ≥ 0 "Weights must be positive"
    else
        weights = fill(1 / size(d, 2), size(d, 2))
    end

    # vector for the results
    y = similar(d[:, 1], Union{Float64,Missing})

    for i = 1:size(d, 1)
        desire = d[i, :]
        numer = sum(skipmissing(@. log(desire) * weights))
        denom = sum(weights)
        y[i] = exp(numer / denom)
    end

    return y

end

"""
        d_rank(x; low_to_high = true, method = "ordinal")

    Values are ranked from low to high or high to low,
    and then the ranks are mapped to a 0-1 scale.

    # Arguments
    - `x`: A non-empty vector. Non-missing elements must be a subtype of Real.

    - `low_to_high`: If true, low ranks have high desirabilities;
      if false, high ranks have high desirabilities. Defaults to true.

    - `method`: What method should be used to rank x? Options include
      ordinal, compete, dense, and tied. Note these are the same options
      offered by ranking functions in StatsBase.jl (which this
      funciton uses). See that package's documentation for more details.
"""
function d_rank(x; low_to_high = true, method = "ordinal")

    @assert low_to_high isa Bool "low_to_high must be of type Bool."
    @assert method in ["ordinal", "compete", "dense", "tied"] "method must be one of: ordinal, compete, dense, tied"
    skip_missing = collect(skipmissing(x))
    which_missing = findall(ismissing, x)
    num_missing = length(which_missing)
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real"

    # This is necessary to handle missing values as in R
    x[which_missing] = fill(maximum(skip_missing) + 1, num_missing)

    # "ordinal" = "first" in R
    # "tied" = "average" in R
    # "compete" = "min" in R
    # "dense" has no equivalent in R
    if method == "ordinal"
        y = ordinalrank(x)
    elseif method == "compete"
        y = competerank(x)
    elseif method == "dense"
        y = denserank(x)
    elseif method == "tied"
        y = tiedrank(x)
    end

    if low_to_high == true
        y = length(y) + 1 .- y
    end

    min_y = minimum(y)
    max_y = maximum(y)
    y = @. (y - min_y) / (max_y - min_y)

    return y

end

"""
        des_line(x; des_func, des_args, plot_args...)

    Overlays a plot of any of the provided desirability functions given a vector
    of data. Typically used with an existing histogram or density plot. Note
    that users may have to adjust plotting paramaters of their original
    graphic to ensure that it is aligned with the desirability function.

    # Arguments
    - `x`: A non-empty vector. Non-missing elements must be
      a subtype of Real.

    - `des_func`: A string specifying which of the desirability
      functions to use (i.e., des_func = "d_4pl"). "d_rank" is
      also allowed.

    - `pos_args`: A tuple or vector specifying the positional
      arguments passed to the desirability function of choice. Should
      be ordered as they would be calling the original desirability function.
      NOTE: this should exlude x, which is explicitly passed as the first
      argument to des_line.

    - `key_args`: A named tuple specifying the keyword arguments
      passed to the desirability function of choice. Recall that
      named tuples with only one element must include a comma, i.e.
      one might specify des_line(..., key_args = (scale = 2,)).

    - `plot_args...`: Additional arguments for Plot.jl's plot function.
"""
function des_line(x; des_func, pos_args = nothing, key_args = nothing, plot_args...)

    skip_missing = collect(skipmissing(x))
    @assert eltype(skip_missing) <: Real "Non-missing values must be a subtype of Real."
    @assert des_func in ["d_4pl", "d_central", "d_ends", "d_high", "d_low", "d_rank"]
    "des_func must be one of the provided desiarability functions."
    if key_args != nothing
        @assert key_args isa NamedTuple "key_args must be a named tuple"
    end

    if des_func == "d_4pl"
        @assert :hill in collect(keys(key_args)) "hill paramter must be specified (no default value)"
        @assert :inflec in collect(keys(key_args)) "inflec parameter must be specified (no default value)"
        y = d_4pl(x; key_args...)
    elseif des_func == "d_central" || des_func == "d_ends"
        @assert pos_args != nothing "No cuts specified"
        @assert length(pos_args) == 4 "Incorrect number of cuts specified"
        if key_args != nothing
            y = getfield(Main, Symbol(des_func))(x, pos_args...; key_args...)
        else
            y = getfield(Main, Symbol(des_func))(x, pos_args...)
        end
    elseif des_func == "d_high" || des_func == "d_low"
        @assert pos_args != nothing "No cuts specified"
        @assert length(pos_args) == 2 "Incorrect number of cuts specified"
        if key_args != nothing
            y = getfield(Main, Symbol(des_func))(x, pos_args...; key_args...)
        else
            y = getfield(Main, Symbol(des_func))(x, pos_args...)
        end
    elseif des_func == "d_rank"
        if key_args == nothing
            y = d_rank(x)
        else
            y = d_rank(x; key_args...)
        end
    end

    p = plot!(y, plot_args...)

    return p

end

end # end of module
