Triggers = {}
TriggerFunctions = {}

-- callback functions for triggers
function TriggerFunctions:heart()
	Timer = Timer + (15 * #Orbs)
	Heart.bloodWant = Heart.bloodWant - #Orbs
	Orbs.clear()
	if Heart.bloodWant ~= 0 then
		Talkies.say("The Heart in your Basement", "Moooore...I..need...more", {textSpeed = slow, onstart = function() OnStart() end, oncomeplete = function () OnComplete() end})
	else
		Talkies.say("The Heart in your Basement", "Well done, I shall live...for now.", {textSpeed = slow, onstart = function() OnStart() end, oncomeplete = function () OnComplete() end})
	end
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