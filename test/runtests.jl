using CircularList
using Test

@testset "CircularList.jl" begin

    CL = circularlist(0) 
    @test length(CL) == 1
    @test current(CL) == previous(CL)
    @test current(CL) == next(CL)

    start = current(CL)
    insert!(CL, 1)
    insert!(CL, 2)
    @test length(CL) == 3
    @test start.next.data == 1
    @test start.next.next.data == 2
    @test start.next.next.next.data == 0
end
