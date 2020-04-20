Heart = {
	x = 5339,
	y = 4048,
	animation = LoveAnimation.new('assets/sprites/heartAnimation.lua'),
	bloodWant = 20
}

function Heart:update(dt)
	Heart.animation:setPosition(Heart.x, Heart.y)
	Heart.animation:update(dt)
end