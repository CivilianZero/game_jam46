Doors = {}

-- used for generating new doors from tilemap object layer, also used for stairs, ladders, etc.
function GenerateDoor(x, y, width, height)
	local door = {}
	door.body = love.physics.newBody(World, x, y, "static")
	door.shape = love.physics.newRectangleShape(width/2, height/2, width, height)
	door.fixture = love.physics.newFixture(door.body, door.shape)
	door.fixture:setSensor(true)
	door.width = width
	door.height = height

	table.insert(Doors, door)
end