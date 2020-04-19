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
			link = d.properties.link
		}
		
		World:add(door, d.x, d.y, d.width, d.height)

		table.insert(Doors, door)
	end
end