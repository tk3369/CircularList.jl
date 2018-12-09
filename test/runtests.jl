using CircularList
using Test

@testset "CircularList.jl" begin

    # general/peek
    CL = circularlist(0) 
    @test length(CL) == 1
    @test current(CL) == previous(CL)
    @test current(CL) == next(CL)

    # insert!
    start = current(CL)
    insert!(CL, 1)
    insert!(CL, 2)
    @test length(CL) == 3
    @test start.next.data == 1
    @test start.next.next.data == 2
    @test start.next.next.next.data == 0

    # delete!
    @test current(CL).data == 2
    delete!(CL)
    println(CL.current.data)
    @test length(CL) == 2
    @test current(CL).data == 1
    @test current(CL).next.data == 0
    @test current(CL).next.next.data == 1
    @test current(CL).prev.data == 0
    @test current(CL).prev.prev.data == 1

    # auto resize feature
    CL = circularlist("str_0", capacity = 5)
    for i in 1:100
        insert!(CL, "str_$i")
    end
    @test length(CL) == 101
    @test CL.capacity == 160   # 5 * 2 * 2 * 2 * 2 * 2 = 160

    # forward -- testing next links
    let curr = current(CL)
        for i in 1:length(CL)
            forward!(CL)
        end
        @test current(CL) == curr
    end

    # backward -- testing prev links
    let curr = current(CL)
        for i in 1:length(CL)
            backward!(CL)
        end
        @test current(CL) == curr
    end
end
