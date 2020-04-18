Items = {}

local item = {}
function item.new(x, y, name, category, sprite)
	item.x = x
	item.y = y
	item.name = name
	item.category = category
	item.sprite = Sprites[sprite]

	table.insert(Items, item)
end

function GenerateItem(x, y, name, category, sprite)
	item.new(x, y, name, category, sprite)
end

function RemoveItem(name)
	for i = #Items, 1, -1 do
		if Items[i].name == name then
			table.remove(Items, i)
		end
	end
end