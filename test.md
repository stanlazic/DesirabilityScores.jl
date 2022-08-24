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
