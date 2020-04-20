Monsters = {}

function Monsters:init()
	while #Monsters < 4 do
		local layer = Overworld.layers["Monsters"].objects
		local i = math.floor(math.random(1, #layer))
		local obj = layer[i]
		local monster = {
			x = obj.x,
			y = obj.y,
			width = obj.width,
			height = obj.height,
			type = "Monster",
			isDead = false,
			animation = LoveAnimation.new('assets/sprites/monsterAnimation.lua')
		}
		print("X: "..monster.x.." Y: "..monster.y)
		World:add(monster, obj.x, obj.y, 8, 16)
		table.insert(Monsters, monster)
	end
end

function Monsters:update(dt)
	for i,m in ipairs(Monsters) do
		m.animation:setPosition(m.x, m.y)
		m.animation:update(dt)
	end
	for i=#Monsters, 1, -1 do
		local m = Monsters[i]
		if m.isDead then
			if m.animation:getCurrentState() ~= "dead" then
				m.animation:setState("dead")
				m.animation:onStateEnd("dead", function() table.remove(Monsters, i) World:remove(m) end)
			end
		end
	end
	if #Monsters < 4 then
		Monsters:init()
	end
end