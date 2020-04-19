Heart = {
	x = 184,
	y = 480,
	animation = LoveAnimation.new('assets/sprites/heartAnimation.lua')
}

function Heart:update(dt)
	Heart.animation:setPosition(Heart.x, Heart.y)
	Heart.animation:update(dt)
end