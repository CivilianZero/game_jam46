--state management and non-player keybindings
local state
local gameStates = {}
local timer = 5

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
	bindings = {},
	keys = {}
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
	EnemyDie:setLooping(false)

	DoorSound = love.audio.newSource('assets/sounds/DOOR_Indoor_Wood_Close_stereo.wav', 'static')

	GameOver = love.audio.newSource('assets/sounds/yay.wav', 'static')
	GameOver:setLooping(false)


	-- Talkies config
	Talkies.font = PixelFont
	Talkies.talkSound = love.audio.newSource("assets/sounds/bep.wav", "static")

	HeartSayWhat = {};
	HeartSayWhat[1] = "The estate is dying.";
	HeartSayWhat[2] = "...feed me.";

	Talkies.say("The Heart in your Basement", HeartSayWhat, {textSpeed = "slow", onstart = function() OnStart() end, oncomplete = function() OnComplete() end})

	-- create collision objects from tilemaps
	spawnCollisionObjects(Overworld)
	-- use layer objects to spawn everything
	Player:init(Overworld)
	Monsters:init(Overworld)
	Triggers:init(Overworld)
	Doors:init(Overworld)

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
		if math.floor(timer) <= 0 then
			state = gameStates.gameOver
		else
			timer = timer - dt
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
	for i,m in ipairs(Monsters) do
		m.animation:draw()
	end
	Heart.animation:draw()
	Cam:detach()

	love.graphics.setColor(1, 0, 0)
	love.graphics.print("Timer: "..math.floor(timer), 10, 30)
	Talkies.draw()

	-- game over rules
	if state == gameStates.gameOver then
		print("game over ran")
		love.graphics.clear()
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
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

-- function OnMonsterComplete()
-- 	Talkies.say("", "You got some blood!", {onstart = function() OnStart() end, oncomplete = function() OnComplete() end})
-- end