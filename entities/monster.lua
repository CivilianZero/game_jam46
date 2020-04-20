Monsters = {}

local numberOfEnemies = 5
local function hasValue (tab, val)
	for i,value in ipairs(tab) do
			if value.x == val.x then
					return true
			end
	end
	return false
end

function Monsters:init()
	math.randomseed(os.time())
	while #Monsters < numberOfEnemies do
		local layer = Overworld.layers["Monsters"].objects
		math.random(#layer)
		local i = math.random(#layer)
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
		if not hasValue(Monsters, monster) then
			print(i)
			World:add(monster, obj.x, obj.y, 8, 16)
			table.insert(Monsters, monster)
		end
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
	if #Monsters < numberOfEnemies then
		Monsters:init()
	end
end