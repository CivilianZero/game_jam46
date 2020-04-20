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

function Orbs:update(playerXPosTable, playerYPosTable, dt)
	table.insert(Orbs.PlayerXPositions, 1, x)
	table.insert(Orbs.PlayerYPositions, 1, y)
	if #Orbs.PlayerXPositions > 500 then
			table.remove(Orbs.PlayerXPositions);
			table.remove(Orbs.PlayerYPositions);
	end
	for i,o in ipairs(Orbs) do
		local x = playerXPosTable[i*20]
		local y = playerYPosTable[i*20]
		o.x = x
		o.y = x
		o.animation:setPosition(x, y)
		o.animation:update(dt)
	end
end

return Org