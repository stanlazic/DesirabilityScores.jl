using DesirabilityScores
using Plots
using Test

data = 1:20
data_missing = Array{Union{Missing,Int64}}(undef, 20)
data_missing[2:20] = 2:20
to_rank = [2, 2, 1, 0, -1, 5, 7]
to_rank_missing = [2, 2, missing, 0, missing, 5, 7]

@testset "des_data" begin 

    farmer = des_data() 

    @test typeof(farmer) == "DataFrame" 
    @test size(farmer) == (1000, 8) 

end 

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
    
    @test_throws AssertionError d_4pl([-1, 0, 3]; hill = 1, inflec = 1) 
    @test_throws AssertionError d_4pl(data; hill = 0, inflec = 10)
    @test_throws AssertionError d_4pl(data; hill = 1, inflec = 10, des_min = -1)
    @test_throws AssertionError d_4pl(data; hill = 1, inflec = 10, des_max = 2)

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

    @test_throws AssertionError d_central(data, 10, 8, 15, 20)
    @test_throws AssertionError d_central(data, 8, 15, 10, 20)
    @test_throws AssertionError d_central(data, 8, 10, 20, 15)
    @test_throws AssertionError d_central(data, 8, 10, 15, 20; scale = 0)
    @test_throws AssertionError d_central(data, 8, 10, 15, 20; des_min = -1)
    @test_throws AssertionError d_central(data, 8, 10, 15, 20; des_max = 2)

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

    @test_throws AssertionError d_ends(data, 10, 8, 15, 20)
    @test_throws AssertionError d_ends(data, 8, 15, 10, 20)
    @test_throws AssertionError d_ends(data, 8, 10, 20, 15)
    @test_throws AssertionError d_ends(data, 8, 10, 15, 20; scale = 0)
    @test_throws AssertionError d_ends(data, 8, 10, 15, 20; des_min = -1)
    @test_throws AssertionError d_ends(data, 8, 10, 15, 20; des_max = 2)

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

    @test_throws AssertionError d_high(data, 12.5, 7.5)
    @test_throws AssertionError d_high(data, 7.5, 12.5; scale = 0)
    @test_throws AssertionError d_high(data, 7.5, 12.5; des_min = -1)
    @test_throws AssertionError d_high(data, 7.5, 12.5; des_max = 2)

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

    @test_throws AssertionError d_low(data, 12.5, 7.5)
    @test_throws AssertionError d_low(data, 7.5, 12.5; scale = 0)
    @test_throws AssertionError d_low(data, 7.5, 12.5; des_min = -1)
    @test_throws AssertionError d_low(data, 7.5, 12.5; des_max = 2)

end

@testset "d_overall" begin

    d = hcat(d_4pl(data; hill = 1, inflec = 10), d_high(data, 7.5, 12.5))
    d_missing = hcat(
        d_4pl(data; hill = 1, inflec = 10),
        d_high(data, 7.5, 12.5),
        d_low(data_missing, 7.5, 12.5),
    )

    test_values = d_overall(d; weights = [2, 1])
    test_values_missing = d_overall(d_missing)

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

    @test_throws AssertionError d_overall([1, 2])
    @test_throws AssertionError d_overall([[1 0]; ["a" "b"]])
    @test_throws AssertionError d_overall([[1 0]; [2 -3]])
    @test_throws AssertionError d_overall(d; weights = [-1, 3])

end

@testset "d_rank" begin

    test_values_ordinal = d_rank(to_rank; method = "ordinal")
    test_values_tied = d_rank(to_rank; method = "tied")
    test_values_compete = d_rank(to_rank; method = "compete")
    test_values_missing = d_rank(to_rank_missing; method = "ordinal")
    test_values_reversed = d_rank(to_rank; low_to_high = false, method = "ordinal")

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

    @test_throws AssertionError d_rank(["a", "b", "c"])
    @test_throws AssertionError d_rank(to_rank; low_to_high = 1)
    @test_throws AssertionError d_rank(to_rank; method = "abc")

end

@testset "des_line" begin

    plots = Array{Any}(missing, 6)
    plots[1] = des_line(data; des_func = "d_4pl", key_args = (hill = 1, inflec = 10))
    plots[2] = des_line(data; des_func = "d_central", pos_args = (5, 10, 15, 20))
    plots[3] = des_line(
        data;
        des_func = "d_ends",
        pos_args = (5, 10, 15, 20),
        key_args = (scale = 5, des_min = 0.5, des_max = 0.7),
    )
    plots[4] = des_line(data; des_func = "d_high", pos_args = (7.5, 12.5))
    plots[5] = des_line(data; des_func = "d_low", pos_args = (7.5, 12.5))
    plots[6] = des_line(data; des_func = "d_rank", key_args = (method = "tied",))

    for i = 1:6
        @test typeof(plots[i]) <: Plots.Plot
    end

    @test_throws AssertionError des_line(
        ["a", "b"];
        des_func = "d_4pl",
        pos_args = (5, 10, 15, 20),
    )
    @test_throws AssertionError des_line(data; des_func = "abc", pos_args = (5, 10, 15, 20))
    @test_throws AssertionError des_line(
        data;
        des_func = "d_4pl",
        key_args = (des_min = 0.2, des_max = 0.7),
    )
    @test_throws AssertionError des_line(data; des_func = "d_ends", pos_args = (5, 10, 15))
    @test_throws AssertionError des_line(
        data;
        des_func = "d_central",
        pos_args = (5, 10, 15, 20),
        key_args = (0.5, 0.7),
    )
    @test_throws AssertionError des_line(data; des_func = "d_high", pos_args = 7.5)
    @test_throws AssertionError des_line(
        data;
        des_func = "d_low",
        pos_args = (7.5, 12.5),
        key_args = (scale = 4),
    )
    @test_throws AssertionError des_line(data; des_func = "d_central")
    @test_throws AssertionError des_line(data; des_func = "d_low", key_args = (scale = 3,))

end
