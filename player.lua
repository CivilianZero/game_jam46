Player = {
	x = 0,
	y = 0,
	isMoving = false,
	body = love.physics.newBody(World, 100, 100, "dynamic"),
	shape = love.physics.newRectangleShape(32, 32),
	fixture = love.physics.newFixture(Player.body, Player.shape),
	speed = 200,
	facing = 1, -- 1: down, 2: left, 3: up, 4: right
	moving = false,
	size = 32,
	-- grid = Anim8.newGrid(32, 32, 128, 64),
	-- animation = Anim8.newAnimation(Player.grid('1-2', 1, '1-2', 2, '1-2', 3, '1-2', 4), 0.2)
	-- sprite = Sprites.player_down
}

function UpdatePlayer(dt)
	-- vertical movement
	if love.keyboard.isDown("w") then
		Player.body:setX(Player.body:getX() - Player.speed * dt)
		Player.facing = 3
		Player.walking = true
	elseif love.keyboard.isDown("s") then
		Player.body:setX(Player.body:getX() + Player.speed * dt)
		Player.facing = 1
		Player.walking = true
	else
		Player.walking = false
	end

	-- horizontal movement
	if love.keyboard.isDown("a") then
		Player.body:setY(Player.body:getY() - Player.speed * dt)
		Player.facing = 2
		Player.walking = true
	elseif love.keyboard.isDown("d") then
		Player.body:setY(Player.body:getY() + Player.speed * dt)
		Player.facing = 4
		Player.walking = true
	else
		Player.walking = false
	end

end

-- not sure of animation/sprite implementation, depends on sprite sheet
-- function HandlePlayerSprite()
-- 	if Player.facing == 1 then
-- 		if Player.walking then
-- 			Player.sprite = Sprites.
-- 		else
-- 			Player.sprite = Sprites.player_down
-- 		end
-- 	elseif Player.facing == 2 then
-- 		Player.sprite = Sprites.player_left
-- 	elseif Player.facing == 3 then
-- 		Player.sprite = Sprites.player_up
-- 	elseif Player.facing == 4 then
-- 		Player.sprite = Sprites.player_right
-- 	end
-- end