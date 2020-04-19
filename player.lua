Player = {}

Player.x = 176
Player.y = 576
World:add(Player, Player.x, Player.y, 16, 16)
Player.goalX = Player.x
Player.goalY = Player.y
Player.speed = 30
-- Player.grid = Anim8.newGrid(16, 16, 32, 64)
-- Player.animation = Anim8.newAnimation(Player.grid('1-2', 1, '1-2', 2, '1-2', 3, '1-2', 4), 0.2)
Player.sprite = Sprites.player

function Player:changeVelocity(dt)
	HaltMovement()
	if love.keyboard.isDown("w") then
		Player.goalY = Player.y - Player.speed * dt
	elseif love.keyboard.isDown("s") then
		Player.goalY = Player.y + dt * Player.speed
	elseif love.keyboard.isDown("a") then
		Player.goalX = Player.x - dt * Player.speed
	elseif love.keyboard.isDown("d") then
		Player.goalX = Player.x + dt * Player.speed
	end
end

function Player:moveColliding(dt)
	local actualX, actualY, cols, len = World:move(Player, Player.goalX, Player.goalY, self.filter)
	Player.x, Player.y = actualX, actualY
	-- for i=1, len do
	-- 	local col = cols[i]
	-- end
end

function Player:filter(other)
	local type = other.type
	if type == "Wall" then return "slide"
	elseif type == "Monster" then
		if other.hasBlood then
			Talkies.say("Creepy Monster", "Here, have some blood.", {textSpeed = "slow", onstart = function() OnStart() end})
			Talkies.say("", "You got some weird blood!", {oncomplete = function() OnComplete() end})
		else
			Talkies.say("Creepy Monster", "I will not let you drain me dry!", {onstart = function() OnStart() end, oncomplete = function() OnComplete() end})
		end
		other.hasBlood = false
		Player.goalX = Player.x - 1
		return "slide"
	elseif type == "Trigger" then
		return "cross"
	elseif type == "Door" then
		return "cross"
	end
end

function Player:update(dt)
	Player:changeVelocity(dt)
	Player:moveColliding(dt)
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

function HaltMovement()
	local function keyDown(key)
		return love.keyboard.isDown(key)
	end

	if keyDown("w") and keyDown("s")
	or keyDown("w") and keyDown("a")
	or keyDown("w") and keyDown("d")
	or keyDown("a") and keyDown("d")
	or keyDown("s") and keyDown("a")
	or keyDown("s") and keyDown("d") then
		Player.speed = 0
	else
		Player.speed = 30
	end
end