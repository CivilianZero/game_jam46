Doors = {}

-- used for generating new doors from tilemap object layer, also used for stairs, ladders, etc.
function Doors:init(map)
	for i,d in pairs(map.layers["Doors"].objects) do
		local door = {
			x = d.x,
			y = d.y,
			width = d.width,
			height = d.height,
			type = "Door",
			location = d.properties.location,
			link = d.properties.link,
			destX = tonumber(d.properties.destX),
			destY = tonumber(d.properties.destY)
		}
		function door:linkFunction()
			for i,d in ipairs(Doors) do
				if d.link == door.location then
					if d.link ~= "well" and d.location ~= "well" then
						DoorSound:play()
					end
					Player.x, Player.y = d.destX, d.destY
					Player.goalX, Player.goalY = d.destX, d.destY
					World:update(Player, Player.x, Player.y)
					break
				end
			end
		end

		World:add(door, d.x, d.y, d.width, d.height)

		table.insert(Doors, door)
	end
end