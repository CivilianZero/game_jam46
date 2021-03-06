Orbs = {}

function Orbs:init() 
    Orbs.PlayerXPositions = {}
    Orbs.PlayerYPositions = {}
	Orbs.Orbs = 0;
	Orbs.MaxOrbs = 3;
end

function Orbs:spawn() 
    local orb = {
        x = 0,
        y = 0,
        width = 5,
        height = 5,
        type = "Orb",
        animation = LoveAnimation.new('assets/sprites/orb.lua')
    }
    World:add(orb, orb.x, orb.y, 1, 1)
    table.insert(Orbs, orb)
end

function Orbs:update(x, y, dt)
    table.insert(Orbs.PlayerXPositions, 1, x)
    table.insert(Orbs.PlayerYPositions, 1, y)
    if #Orbs.PlayerXPositions > 500 then
        table.remove(Orbs.PlayerXPositions);
        table.remove(Orbs.PlayerYPositions);
    end
    for i,o in ipairs(Orbs) do
        local x = Orbs.PlayerXPositions[i*20]
        local y = Orbs.PlayerYPositions[i*20]
        o.x = x
        o.y = y
		o.animation:setPosition(x, y)
		o.animation:update(dt)
	end
end

function Orbs:clear()
	for i=#Orbs, 1, -1 do
		table.remove(Orbs, i)
	end
end

return Orbs