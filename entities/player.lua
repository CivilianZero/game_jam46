Player = {}

function Player:init(map)
	for i,spawn in pairs(map.layers["Spawn Point"].objects) do
		Player.x = spawn.x
		Player.y = spawn.y
	end
	World:add(Player, Player.x, Player.y, 11, 14)
	Player.goalX = Player.x
	Player.goalY = Player.y
	Player.speed = 100
	Player.direction = {x = 1, y = 0}
	Player.isMoving = false
	Player.animation = LoveAnimation.new('assets/sprites/playerAnimation.lua')
	Player.whispering = false;
end

local function keyDown(key)
	return love.keyboard.isDown(key)
end

function Player:changeVelocity(dt)
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
	Player.isMoving = true
	local function checkAttack(x,y)
		local actualX, actualY, cols, len = World:check(Player, Player.x + x, Player.y + y)
		for i=1, len do
			local other = cols[i].other
			if other.type == "Monster" then
				EnemyDie:play()
				other.isDead = true
				if #Orbs < Orbs.MaxOrbs then
					Orbs.spawn();
				end
			end
		end
	end
	if Player.direction.y == -1 then
		Player.animation:setState("attackUp")
		checkAttack(0,-16)
		-- Footsteps:play()
	end
	if Player.direction.x == 1 and Player.direction.y == 0 then
		Player.animation:setState("attackRight")
		checkAttack(16,0)
		-- Footsteps:play()
	end
	if Player.direction.x == -1 and Player.direction.y == 0 then
		Player.animation:setState("attackLeft")
		checkAttack(-16,0)
		-- Footsteps:play()
	end
	if Player.direction.y == 1 then
		Player.animation:setState("attackDown")
		checkAttack(0,16)
		-- Footsteps:play()
	end
end

function Player:moveColliding(dt)
	local actualX, actualY, cols, len = World:move(Player, Player.goalX, Player.goalY, self.filter)
	Player.x, Player.y = actualX, actualY

	for i=1, len do
		local other = cols[i].other

		if other.type == "Door" then
			other.linkFunction()
		end
		if other.type == "Trigger" then
			other.trigger()
		end
	end
end

local function changeState(state)
	if Player.animation:getCurrentState() ~= state 
	and Player.animation:getCurrentState() ~= "attackUp" 
	and Player.animation:getCurrentState() ~= "attackDown" 
	and Player.animation:getCurrentState() ~= "attackRight"
	and Player.animation:getCurrentState() ~= "attackLeft" then
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

function Player:checkNearbyEnemies()
	local nearest = 10000000;
	for i,m in ipairs(Monsters) do
		m.animation:draw()
		distance = DistanceBetween(Player.x, Player.y, m.x, m.y)
		if distance < nearest then
			nearest = distance
		end
	end

	if nearest < 500 then
		if Player.whispering == false then
			Whisper:play()
			Player.whispering = true
		end
	else 
		if Player.whispering == true then
			Whisper:stop()
			Player.whispering = false
		end
	end

	Whisper:setVolume((1 - nearest / 500))
end

function Player:update(dt)
	Player:changeVelocity(dt)
	Player:moveColliding(dt)
	Player:handleAnimation(dt)
	Player:checkNearbyEnemies()
end

return Player