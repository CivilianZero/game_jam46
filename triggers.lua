Triggers = {}
TriggerFunctions = {}

function TriggerFunctions:Heart()
	-- handle whether heart wants blood, what kind, whether you have it, etc.
	-- probably best to pass this off to Heart.lua
	return "Placeholder"
end

function GenerateTriggers(map)
	for i,t in pairs(map.layers["Triggers"].objects) do
		local trigger = {}
		World:add(trigger, t.x, t.y, t.width, t.height)
		trigger.x = t.x
		trigger.y = t.y
		trigger.width = t.width
		trigger.height = t.height
		trigger.type = "Trigger"
		trigger.trigger = TriggerFunctions[t.properties.trigger]
		
		table.insert(Triggers, trigger)
	end
end