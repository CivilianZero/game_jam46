Heart = {
	x = 155,
	y = 448,
	animation = LoveAnimation.new('assets/sprites/heartAnimation.lua')
}

function Heart:update(dt)
	Heart.animation:setPosition(Heart.x, Heart.y)
	Heart.animation:update(dt)
end