using DesirabilityScores
using Plots
using Test
using Random 

# set plots backend, but don't display the plots
gr()
ENV["GKSwstype"] = "100"

data = 1:20
data_vector = collect(data)
data_missing = Array{Union{Missing,Int64}}(undef, 20)
data_missing[2:20] = 2:20
data_all_missing = fill(missing, 3)
to_rank = [2, 2, 1, 0, -1, 5, 7]
to_rank_missing = [2, 2, missing, 0, missing, 5, 7]


@testset "d_4pl" begin

    test_values = d_4pl(data; hill = 1, inflec = 10)
    test_values_missing = d_4pl(data_missing; hill = 1, inflec = 10)

    true_values = [
        0.0909091,
        0.1666667,
        0.2307692,
        0.2857143,
        0.3333333,
        0.3750000,
        0.4117647,
        0.4444444,
        0.4736842,
        0.5000000,
        0.5238095,
        0.5454545,
        0.5652174,
        0.5833333,
        0.6000000,
        0.6153846,
        0.6296296,
        0.6428571,
        0.6551724,
        0.6666667,
    ]

    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing[1] === missing
    @test d_4pl(view(data_vector, :); hill = 1, inflec = 10) ≈ true_values atol = 0.001
    
    @test_throws DomainError d_4pl([-1, 0, 3]; hill = 1, inflec = 1) 
    @test_throws DomainError d_4pl(data; hill = 0, inflec = 10)
    @test_throws DomainError d_4pl(data; hill = 1, inflec = 10, des_min = -1)
    @test_throws DomainError d_4pl(data; hill = 1, inflec = 10, des_max = 2)
    @test_throws ArgumentError d_4pl(Int[]; hill = 1, inflec = 10)
    @test_throws ArgumentError d_4pl(data_all_missing; hill = 1, inflec = 10)

end

@testset "d_central" begin

    test_values = d_central(data, 5, 10, 15, 20)
    test_values_missing = d_central(data_missing, 5, 10, 15, 20)

    true_values = [
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.2,
        0.4,
        0.6,
        0.8,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        0.8,
        0.6,
        0.4,
        0.2,
        0.0,
    ]

    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing[1] === missing
    @test d_central(view(data_vector, :), 5, 10, 15, 20) ≈ true_values atol = 0.001

    @test_throws ArgumentError d_central(data, 10, 8, 15, 20)
    @test_throws ArgumentError d_central(data, 8, 15, 10, 20)
    @test_throws ArgumentError d_central(data, 8, 10, 20, 15)
    @test_throws DomainError d_central(data, 8, 10, 15, 20; scale = 0)
    @test_throws DomainError d_central(data, 8, 10, 15, 20; des_min = -1)
    @test_throws DomainError d_central(data, 8, 10, 15, 20; des_max = 2)
    @test_throws ArgumentError d_central(Int[], 8, 10, 15, 20)

end

@testset "d_ends" begin

    test_values = d_ends(data, 5, 10, 15, 20)
    test_values_missing = d_ends(data_missing, 5, 10, 15, 20)

    true_values = [
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        0.8,
        0.6,
        0.4,
        0.2,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.2,
        0.4,
        0.6,
        0.8,
        1.0,
    ]

    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing[1] === missing
    @test d_ends(view(data_vector, :), 5, 10, 15, 20) ≈ true_values atol = 0.001

    @test_throws ArgumentError d_ends(data, 10, 8, 15, 20)
    @test_throws ArgumentError d_ends(data, 8, 15, 10, 20)
    @test_throws ArgumentError d_ends(data, 8, 10, 20, 15)
    @test_throws DomainError d_ends(data, 8, 10, 15, 20; scale = 0)
    @test_throws DomainError d_ends(data, 8, 10, 15, 20; des_min = -1)
    @test_throws DomainError d_ends(data, 8, 10, 15, 20; des_max = 2)
    @test_throws ArgumentError d_ends(Int[], 8, 10, 15, 20)

end

@testset "d_high" begin

    test_values = d_high(data, 7.5, 12.5)
    test_values_missing = d_high(data_missing, 7.5, 12.5)

    true_values = [
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.1,
        0.3,
        0.5,
        0.7,
        0.9,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
    ]


    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing[1] === missing
    @test d_high(view(data_vector, :), 7.5, 12.5) ≈ true_values atol = 0.001

    @test_throws ArgumentError d_high(data, 12.5, 7.5)
    @test_throws DomainError d_high(data, 7.5, 12.5; scale = 0)
    @test_throws DomainError d_high(data, 7.5, 12.5; des_min = -1)
    @test_throws DomainError d_high(data, 7.5, 12.5; des_max = 2)
    @test_throws ArgumentError d_high(Int[], 7.5, 12.5)

end

@testset "d_low" begin

    test_values = d_low(data, 7.5, 12.5)
    test_values_missing = d_low(data_missing, 7.5, 12.5)

    true_values = [
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        1.0,
        0.9,
        0.7,
        0.5,
        0.3,
        0.1,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
    ]

    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing[1] === missing
    @test d_low(view(data_vector, :), 7.5, 12.5) ≈ true_values atol = 0.001

    @test_throws ArgumentError d_low(data, 12.5, 7.5)
    @test_throws DomainError d_low(data, 7.5, 12.5; scale = 0)
    @test_throws DomainError d_low(data, 7.5, 12.5; des_min = -1)
    @test_throws DomainError d_low(data, 7.5, 12.5; des_max = 2)
    @test_throws ArgumentError d_low(Int[], 7.5, 12.5)

end

@testset "d_overall" begin

    d = hcat(d_4pl(data; hill = 1, inflec = 10), d_high(data, 7.5, 12.5))
    d_missing = hcat(
        d_4pl(data; hill = 1, inflec = 10),
        d_high(data, 7.5, 12.5),
        d_low(data_missing, 7.5, 12.5),
    )
    d_partial = Union{Missing, Float64}[0.8 missing; 0.8 0.2; missing missing]
    d_all_missing_row = Union{Missing, Float64}[0.8 0.2; missing missing; 0.6 0.3]

    test_values = d_overall(d; weights = [2, 1])
    test_values_missing = d_overall(d_missing)
    test_values_partial = d_overall(d_partial)
    test_values_partial_weighted = d_overall(d_partial; weights = [1, 2])
    test_values_all_missing_row = d_overall(d_all_missing_row)

    true_values = [
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.2703201,
        0.4067863,
        0.5000000,
        0.5769634,
        0.6445450,
        0.6836130,
        0.6981432,
        0.7113787,
        0.7234876,
        0.7346099,
        0.7448629,
        0.7543457,
        0.7631428,
    ]

    true_values_missing = [
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.3419952,
        0.4633431,
        0.5000000,
        0.4791420,
        0.3661567,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
        0.0000000,
    ]

    @test test_values ≈ true_values atol = 0.001
    @test test_values_missing ≈ true_values_missing atol = 0.001
    @test test_values_partial[1] ≈ 0.8 atol = 0.001
    @test test_values_partial[2] ≈ 0.4 atol = 0.001
    @test test_values_partial[3] === missing
    @test test_values_partial_weighted[1] ≈ 0.8 atol = 0.001
    @test test_values_partial_weighted[2] ≈ exp((log(0.8) + 2 * log(0.2)) / 3) atol = 0.001
    @test test_values_partial_weighted[3] === missing
    @test test_values_all_missing_row[1] ≈ 0.4 atol = 0.001
    @test test_values_all_missing_row[2] === missing
    @test test_values_all_missing_row[3] ≈ sqrt(0.18) atol = 0.001
    @test d_overall(view(d, :, :); weights = [2, 1]) ≈ true_values atol = 0.001

    @test_throws MethodError d_overall([1, 2])
    @test_throws ArgumentError d_overall([[1 0]; ["a" "b"]])
    @test_throws DomainError d_overall([[1 0]; [2 -3]])
    @test_throws DomainError d_overall(d; weights = [-1, 3])
    @test_throws ArgumentError d_overall(Matrix{Union{Missing, Float64}}(missing, 0, 0))

end

@testset "d_rank" begin

    original_to_rank_missing = copy(to_rank_missing)
    test_values_ordinal = d_rank(to_rank; method = :ordinal)
    test_values_tied = d_rank(to_rank; method = :tied)
    test_values_compete = d_rank(to_rank; method = :compete)
    test_values_missing = d_rank(to_rank_missing; method = :ordinal)
    test_values_reversed = d_rank(to_rank; low_to_high = false, method = :ordinal)

    true_values_ordinal =
        [0.5000000, 0.3333333, 0.6666667, 0.8333333, 1.0000000, 0.1666667, 0.0000000]
    true_values_tied =
        [0.4166667, 0.4166667, 0.6666667, 0.8333333, 1.0000000, 0.1666667, 0.0000000]
    true_values_compete =
        [0.5000000, 0.5000000, 0.6666667, 0.8333333, 1.0000000, 0.1666667, 0.0000000]
    true_values_reversed =
        [0.5000000, 0.6666667, 0.3333333, 0.1666667, 0.0000000, 0.8333333, 1.0000000]
    true_values_missing =
        [0.8333333, 0.6666667, 0.1666667, 1.0000000, 0.0000000, 0.5000000, 0.3333333]

    @test test_values_ordinal ≈ true_values_ordinal atol = 0.001
    @test test_values_tied ≈ true_values_tied atol = 0.001
    @test test_values_compete ≈ true_values_compete atol = 0.001
    @test test_values_reversed ≈ true_values_reversed atol = 0.001
    @test test_values_missing ≈ true_values_missing atol = 0.001
    @test isequal(to_rank_missing, original_to_rank_missing)
    @test d_rank(view(to_rank, :); method = :ordinal) ≈ true_values_ordinal atol = 0.001

    @test_throws ArgumentError d_rank(["a", "b", "c"])
    @test_throws ArgumentError d_rank(to_rank; low_to_high = 1)
    @test_throws ArgumentError d_rank(to_rank; method = :abc)
    @test_throws ArgumentError d_rank(Union{Missing, Int}[])
    @test_throws ArgumentError d_rank(data_all_missing)

end

# permute indices to make sure sorting functionality works 
# converts ranges to vectors implicitly, which is needed below 
data = shuffle(data) 
data_missing = shuffle(data_missing) 

@testset "des_plot" begin

    plots = Array{Any}(missing, 5) 
    scores = d_4pl(data; hill = 1, inflec = 10)
    scores_missing = d_4pl(data_missing; hill = 1, inflec = 10) 
    
    plots[1] = des_plot(data, scores) 
    plots[2] = des_plot(data_missing, scores_missing)  
    plots[3] = des_plot(data, scores; weights = 1:20) 
    plots[4] = des_plot(data, scores; normalize = true) 
    plots[5] = des_plot(view(data_vector, :), scores)

    for i = 1:5
        @test typeof(plots[i]) <: Plots.Plot
    end 
 
    @test_throws ArgumentError des_plot(['a', 'b', 'c'], scores) 
    @test_throws ArgumentError des_plot(data, ['a', 'b', 'c']) 
    @test_throws ArgumentError des_plot(data, scores[2:end]) 
    @test_throws ArgumentError des_plot(data[2:end], scores) 
    @test_throws MethodError des_plot(2,2) 
    @test_throws ArgumentError des_plot([data; 'a'], [scores; 'b'])
    @test_throws MethodError des_plot(tuple(data...), tuple(scores...)) 
    @test_throws ArgumentError des_plot(Int[], Float64[])

end
