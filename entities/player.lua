Player = {}

function Player:init(map)
	for i,spawn in pairs(map.layers["Spawn Point"].objects) do
		Player.x = spawn.x
		Player.y = spawn.y
	end
	World:add(Player, Player.x, Player.y, 10, 16)
	Player.goalX = Player.x
	Player.goalY = Player.y
	Player.speed = 30
	Player.direction = {x = 0, y = 0}
	Player.isMoving = false
	Player.animation = LoveAnimation.new('assets/sprites/playerAnimation.lua')
end

local function keyDown(key)
	return love.keyboard.isDown(key)
end

function Player:changeVelocity(dt)
	Player.isMoving = false
	if keyDown("w") then
		Player.goalY = Player.y - Player.speed * dt
		Player.direction.y = -1
		Player.isMoving = true
	end
	if keyDown("s") then
		Player.goalY = Player.y + dt * Player.speed
		Player.direction.y = 1
		Player.isMoving = true
	end
	if keyDown("a") then
		Player.goalX = Player.x - dt * Player.speed
		Player.direction.x , Player.direction.y = -1, 0
		Player.isMoving = true
	end
	if keyDown("d") then
		Player.goalX = Player.x + dt * Player.speed
		Player.direction.x, Player.direction.y = 1, 0
		Player.isMoving = true
	end

	if keyDown("a") and keyDown("w") then
		Player.direction.x, Player.direction.y = -1, -1
	end
	if keyDown("d") and keyDown("w") then
		Player.direction.x, Player.direction.y = 1, -1
	end
end

function Player:attack()
end

function Player:moveColliding(dt)
	local actualX, actualY = World:move(Player, Player.goalX, Player.goalY, self.filter)
	Player.x, Player.y = actualX, actualY
end

local function changeState(state)
	if Player.animation:getCurrentState() ~= state then
		Player.animation:setState(state)
	end 
end

function Player:filter(other)
	local type = other.type
	if type == "Wall" then return "slide"
	elseif type == "Monster" then return "slide"
	elseif type == "Trigger" then return "cross"
	elseif type == "Door" then return "cross"
	end
end

function Player:handleAnimation(dt)
	if Player.direction.y == -1 then
		if Player.direction.x > -1 then
			changeState("upRight")
		else
			changeState("upLeft")
		end
	else
		if Player.direction.x == 1 then
			changeState("right")
		elseif Player.direction.x == -1 then
			changeState("left")
		end
	end

	if Player.isMoving then
		Player.animation:unpause()
	else
		Player.animation:pause()
	end

	Player.animation:setPosition(Player.x, Player.y)
	Player.animation:update(dt)
end

function Player:update(dt)
	Player:changeVelocity(dt)
	Player:moveColliding(dt)
	Player:handleAnimation(dt)
	ObjectTest ="X: "..Player.direction.x.." Y: "..Player.direction.y.." State: "..Player.animation:getCurrentState()
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

return Player