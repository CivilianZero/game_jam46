Monsters = {}

function Monsters:init(map)
	for i,obj in pairs(map.layers["Monsters"].objects) do
		local monster = {
			x = obj.x,
			y = obj.y,
			width = obj.width,
			height = obj.height,
			type = "Monster",
			hasBlood = true,
			bloodType = math.floor(math.random(1, 4)),
			-- grid = Anim8.newGrid(16, 16, 32, 32)
			-- animation = Anim8.newAnimation(monster.grid('1-2',1), 0.5)
		}
		World:add(monster, obj.x, obj.y, obj.width, obj.height)
		table.insert(Monsters, monster)
	end
end

function Monsters:update(dt)
	for i=#Monsters, 1, -1 do
		local m = Monsters[i]
		if m.dead then
			table.remove(Monsters, i)
		end
	end
end