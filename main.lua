--state management and non-player keybindings
local state
local gameStates = {}
local musicPlayed = false
local heartbeatPlaying = false
local strongHeartbeatPlaying = false
local musicPlayed = false
Timer = 60

gameStates.menu = {
	bindings = {
		backToGame = function() state = gameStates.gameLoop end
	},
	keys = {
		escape = "backToGame"
	}
}
gameStates.gameLoop = {
	bindings = {
		openMenu = function() state = gameStates.menu end,
		attack = function() Player:attack() end
	},
	keys = {
		escape = "openMenu",
		space = "attack"
	}
}
gameStates.dialog = {
	bindings = {
		progressDialog = function() Talkies.onAction() end
	},
	keys = {
		space = "progressDialog"
	}
}
gameStates.gameOver = {
	bindings = {
		quit = function() love.event.quit() end,
		restart = function() love.event.quit("restart") end
	},
	keys = {
		escape = "quit",
		space = "restart"
	}
}

-- local imports
local sti = require('libraries.sti.sti')

-- local functions

-- creates collision objects
local function spawnCollisionObjects(map)
	for i,obj in pairs(map.layers["Collision"].objects) do
		local wall = {}
		wall.type = "Wall"
		wall.x = obj.x
		wall.y = obj.y
		wall.width = obj.width
		if obj.height > 8 then
			wall.height = obj.height - 8
		else 
			wall.height = obj.height
		end
		World:add(wall, wall.x, wall.y, wall.width, wall.height)
	end
end

-- utility function for handling input
local function inputHandler(input)
	local action = state.bindings[input]
	if action then
		return action()
	end
end

function love.load()
	-- set scaling filter to accomodate for camera zoom
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- required libraries
	Talkies = require('libraries.talkies.talkies')
	local camera = require('libraries.hump.camera')
	local bump = require('libraries.bump.bump')
	require("libraries.loveAnimation.animation")
	require('libraries.show')

	local anim = LoveAnimation.new("assets/sprites/playerAnimation.lua")

	-- physics world config
	World = bump.newWorld(16)

	-- required files
	require('objects.sprites')
	require('entities.player')
	require('entities.heart')
	require('entities.orb')
	require('entities.monster')
	require('objects.doors')
	require('objects.triggers')

	-- table for storing save data
	SaveData = {}

	-- check for saved data, load using table.show if exists
	if love.filesystem.getInfo("data.lua") then
		local data = love.filesystem.load("data.lua")
		data()
	end

	-- TiledMap = Tiled('assets/maps/TiledMap.lua')
	PixelFont = love.graphics.newFont('assets/fonts/Kenney Pixel.ttf', 40)

	-- tilemaps
	-- Basement = sti('assets/maps/basement.lua')
	Overworld = sti('assets/maps/tilemap.lua')
	
	-- debugging print
	TestPrint = " "

	-- set default state (set to skip menu)
	state = gameStates.gameLoop

	-- setup music
	SpookyMusic = love.audio.newSource('assets/sounds/spookmeister3D.wav', 'stream')
	SpookyMusic:setVolume(55)
	SpookyMusic:setLooping(true)
	SpookyMusic:play()

	EnemyDie = love.audio.newSource('assets/sounds/monster1.wav', 'static')
	EnemyDie:setVolume(45)

	Eat = love.audio.newSource('assets/sounds/heartdie.wav', 'static')
	Eat:setVolume(45)
	Eat:setLooping(false)

	Whisper = love.audio.newSource('assets/sounds/whipser.wav', 'static')
	Whisper:setLooping(true)

	DoorSound = love.audio.newSource('assets/sounds/DOOR_Indoor_Wood_Close_stereo.wav', 'static')

	Heartbeat = love.audio.newSource('assets/sounds/heartbeat.wav', 'static')
	Heartbeat:setLooping(true)
	Heartbeat:setVolume(0.6)
	StrongHeartbeat = love.audio.newSource('assets/sounds/heartbeatstrong.wav', 'static')
	StrongHeartbeat:setLooping(true)
	StrongHeartbeat:setVolume(0.9)

	Ritual = love.audio.newSource('assets/sounds/shockwave.wav', 'static')
	Ritual:setLooping(false)
	Ritual:setVolume(0.9)

	GameOver = love.audio.newSource('assets/sounds/yay.wav', 'static')
	GameOver:setLooping(false)


	Footsteps = love.audio.newSource('assets/sounds/footsteps.wav', 'static')


	-- Talkies config
	Talkies.font = PixelFont
	Talkies.talkSound = love.audio.newSource("assets/sounds/bep.wav", "static")

	HeartSayWhat = {
	"The estate is dying.",
	"...feed me...blood"
	}

	Talkies.say("The Heart in your Basement", HeartSayWhat, {textSpeed = "slow", onstart = function() OnStart() end, oncomplete = function() OnComplete() end})

	-- create collision objects from tilemaps
	spawnCollisionObjects(Overworld)
	-- use layer objects to spawn everything
	Player:init(Overworld)
	Monsters:init()
	Triggers:init(Overworld)
	Doors:init(Overworld)
	Orbs:init()

	-- camera object
	Cam = camera(Player.x, Player.y, 2.5)

end

function love.update(dt)
	Cam:lockPosition(Player.x, Player.y)
	Overworld:update(dt)
	Heart:update(dt)
	if state == gameStates.gameLoop then
		Player:update(dt)
		Monsters:update(dt)
		Orbs:update(Player.x, Player.y, dt)
		if math.floor(Timer) <= 0 then
			state = gameStates.gameOver
		else
			Timer = Timer - dt
		end

		if Timer <= 30 then
			if heartbeatPlaying == false then
				heartbeatPlaying = true
				Heartbeat:play();
			end
		else
			if heartbeatPlaying == true then
				Heartbeat:stop();
				heartbeatPlaying = false
			end
		end

		if Timer <= 15 then
			if strongHeartbeatPlaying == false then
				if heartbeatPlaying == true then
					heartbeatPlaying = false
					Heartbeat:stop();
				end
				strongHeartbeatPlaying = true
				StrongHeartbeat:play();
			end
		else
			if strongHeartbeatPlaying == true then
				StrongHeartbeat:stop();
				strongHeartbeatPlaying = false
			end
		end

	end
	Talkies.update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)

	Cam:attach()
	love.graphics.setColor(1, 1, 1)
	Overworld:drawLayer(Overworld.layers["Tilemap"])
	Player.animation:draw()
	for i,o in ipairs(Orbs) do
		o.animation:draw()
	end
	for i,m in ipairs(Monsters) do
		m.animation:draw()
	end
	Heart.animation:draw()
	Cam:detach()

	love.graphics.setColor(1, 0, 0)
	love.graphics.print("Timer: "..math.floor(Timer), 10, 30)
	Talkies.draw()

	-- game over rules
	if state == gameStates.gameOver then
		if not musicPlayed then
			GameOver:play()
			musicPlayed = true
		end
		love.graphics.clear()
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(0,0,0)
		love.graphics.printf("Game Over", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
	end
end

function love.keypressed(key)
	local binding = state.keys[key]
	inputHandler(binding)
	--Debug
	-- if key == "lctrl" then --set to whatever key you want to use
	-- 	debug.debug()
	-- end
end

-- callback functions for Talkies
function OnStart()
	state = gameStates.dialog
end

function OnComplete()
	state = gameStates.gameLoop
end

function DistanceBetween(x1, y1, x2, y2)
	return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end