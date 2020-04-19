Monsters = {}

function Monsters:init(map)
	for i,obj in pairs(map.layers["Monsters"].objects) do
		local monster = {
			x = obj.x,
			y = obj.y,
			width = obj.width,
			height = obj.height,
			type = "Monster",
			isDead = false,
			animation = LoveAnimation.new('assets/sprites/monsterAnimation.lua')
		}
		World:add(monster, obj.x, obj.y, obj.width, obj.height)
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
		if m.dead then
			table.remove(Monsters, i)
			World:remove(m)
		end
	end
end