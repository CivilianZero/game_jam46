Doors = {}

-- used for generating new doors from tilemap object layer, also used for stairs, ladders, etc.
function Doors:init(map)
	for i,d in pairs(map.layers["Doors"].objects) do
		local door = {}
		door.x = d.x
		door.y = d.y
		door.width = d.width
		door.height = d.height
		door.type = "Door"
		door.link = d.properties.link
		World:add(door, d.x, d.y, d.width, d.height)

		table.insert(Doors, door)
	end
end