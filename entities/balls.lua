Balls = {}

function Balls:init(map)
    Balls.PlayerXPositions = {}
    Balls.PlayerYPositions = {}
	Balls.Balls = 0;
	Balls.MaxBalls = 3;
end

function update(x, y)
    table.insert(Balls.PlayerXPositions, 1, x)
    table.insert(Balls.PlayerYPositions, 1, y)
    if #Balls.PlayerXPositions > 500 then
        table.remove(Balls.PlayerXPositions);
        table.remove(Balls.PlayerYPositions);
    end
end


return Balls