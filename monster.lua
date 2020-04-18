Monsters = {}

function SpawnMonster()
	for i,obj in pairs(OverWorld.layers["monsters"].objects) do
		local monster = {}
		monster.body = love.physics.newBody(World, obj.x, obj.y, "dynamic")
		monster.shape = love.physics.newRectangleShape(obj.width/2, obj.height/2, obj.width, obj.height)
		monster.fixture = love.physics.newFixture(monster.body, monster.shape)
		monster.dead = false
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