using DesirabilityScores
using Test

data = 1:20
#data2 = [missing, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]


@testset "d_4pl" begin
    test_values = d_4pl(data; hill=1, inflec=10, des_min = 0, des_max = 1)
    true_values = [
        0.0909091, 0.1666667, 0.2307692, 0.2857143, 0.3333333, 0.3750000,
        0.4117647, 0.4444444, 0.4736842, 0.5000000, 0.5238095, 0.5454545,
        0.5652174, 0.5833333, 0.6000000, 0.6153846, 0.6296296, 0.6428571,
        0.6551724, 0.6666667
    ]
    @test test_values ≈ true_values atol = 0.001

    @test_throws AssertionError d_4pl(data; hill=0, inflec=10)
    @test_throws AssertionError d_4pl(data; hill=1, inflec=10, des_min = -1)
    @test_throws AssertionError d_4pl(data; hill=1, inflec=10, des_max = 2)
end


@testset "d_central" begin
    test_values = d_central(data, 5, 10, 15, 20)
    
    true_values = [
        0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.4, 0.6, 0.8, 1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 0.8, 0.6, 0.4, 0.2, 0.0
    ]

    @test test_values ≈ true_values atol = 0.001
    @test d_central([missing], 5, 10, 15, 20)[1] === missing
    
    @test_throws AssertionError d_central(data, 10, 8, 15, 20)    
    @test_throws AssertionError d_central(data, 8, 15, 10, 20)
    @test_throws AssertionError d_central(data, 8, 10, 20, 15)
    @test_throws AssertionError d_central(data, 10, 8, 15, 20; scale = 0)
    @test_throws AssertionError d_central(data, 10, 8, 15, 20; des_min = -1)
    @test_throws AssertionError d_central(data, 10, 8, 15, 20; des_max = 2) 
end
