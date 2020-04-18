Doors = {}

-- used for generating new doors from tilemap object layer, also used for stairs, ladders, etc.
function GenerateDoor(x, y, width, height)
	for i,obj in pairs(OverWorld.layers["Doors"].objects) do
		local door = {}
		door.x = x
		door.y = y
		door.width = width
		door.height = height
		door.name = "Door"
		World:add(door, x, y, width, height)

		table.insert(Doors, door)
	end
end