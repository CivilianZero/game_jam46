Triggers = {}
TriggerFunctions = {}

-- callback functions for triggers
function TriggerFunctions:heart()
	-- handle whether heart wants blood, what kind, whether you have it, etc.
	-- probably best to pass this off to Heart.lua
	return "Placeholder"
end

function Triggers:init(map)
	for i,t in pairs(map.layers["Triggers"].objects) do
		local trigger = {
			x = t.x,
			y = t.y,
			width = t.width,
			height = t.height,
			type = "Trigger",
			trigger = TriggerFunctions[t.properties.trigger]
		}
		World:add(trigger, t.x, t.y, t.width, t.height)

		table.insert(Triggers, trigger)
	end
end