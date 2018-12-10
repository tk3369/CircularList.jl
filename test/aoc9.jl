# Advent of Code - Day 9

using CircularList, Dates, Test

function play(num_players, last_marble)
    leaderboard = fill(0, num_players)
    game = circularlist(0, capacity = last_marble)
    marble = 0
    while marble < last_marble
        marble += 1
        if marble % 23 == 0
            player = (marble % num_players) + 1
            leaderboard[player] += marble   # win current marble
            shift!(game, 7, :backward)
            leaderboard[player] += game.current.data  # win the other marble
            delete!(game)
            forward!(game)
        else
            forward!(game) 
            insert!(game, marble)
        end
    end
    return (scores = leaderboard, 
        highest = maximum(leaderboard),
        num_players = num_players,
        last_marble = last_marble
        )
end

# @test play(9, 25).highest == 32
# @test play(10, 1618).highest == 8317
# @time play(431, 70950)
@time play(431, 7095000)
# play(9, 25)

