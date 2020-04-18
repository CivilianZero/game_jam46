Monsters = {}

function SpawnMonster(x, y)
	for i,obj in pairs(OverWorld.layers["monsters"].objects) do
		local monster = {}
		monster.body = love.physics.newBody(World, x, y, "dynamic")
		monster.shape = love.physics.newRectangleShape(6, 11, 12, 12)
		monster.fixture = love.physics.newFixture(monster.body, monster.shape)
		monster.dead = false

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