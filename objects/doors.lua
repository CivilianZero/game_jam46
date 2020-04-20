Doors = {}
DoorFunctions = {}

function DoorFunctions:basement()
	for i,d in ipairs(Doors) do
		if d.location == "stairs" then
			World:update(Player, math.floor(d.x), math.floor(d.y) + 16)
			Player.x, Player.y = math.floor(d.x), math.floor(d.y) + 16
			break
		end
	end
end

function DoorFunctions:stairs()
	--
	return
end

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
			link = DoorFunctions[d.properties.location]
		}
		
		World:add(door, d.x, d.y, d.width, d.height)

		table.insert(Doors, door)
	end
end