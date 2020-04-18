Monsters = {}

function SpawnMonsters()
	for i,obj in pairs(OverWorld.layers["Monsters"].objects) do
		local monster = {}
		World:add(monster, obj.x, obj.y, obj.width, obj.height)
		monster.x = obj.x
		monster.y = obj.y
		monster.width = obj.width
		monster.height = obj.height
		monster.name = "Monster"
		monster.hasBlood = true
		monster.bloodType = math.floor(math.random(1, 4))

		monster.grid = Anim8.newGrid(16, 16, 32, 32)
		monster.animation = Anim8.newAnimation(monster.grid('1-2',1), 0.5)

		table.insert(Monsters, monster)
	end
end

function MonstersUpdate(dt)
	for i=#Monsters, 1, -1 do
		local m = Monsters[i]
		if m.dead then
			table.remove(Monsters, i)
		end
	end
end