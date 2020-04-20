--state management and non-player keybindings
local state
local gameStates = {}

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
		wall.height = obj.height
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
	
	-- debugging for collision
	ObjectTest = " "

	-- coordinates for debugging camera and player position
	CamX = 0
	CamY = 0
	WorldX = 0
	WorldY = 0

	-- set default state (set to skip menu)
	state = gameStates.gameLoop

	-- setup music
	SpookyMusic = love.audio.newSource('assets/sounds/spookmeister3D.wav', 'stream')
	SpookyMusic:setVolume(55)
	SpookyMusic:setLooping(true)
	SpookyMusic:play()

	-- Talkies config
	Talkies.font = PixelFont
	Talkies.talkSound = love.audio.newSource("assets/sounds/bep.wav", "static")

	heartSayWhat = {};
	heartSayWhat[1] = "The estate is dying.";
	heartSayWhat[2] = "...feed me.";

	Talkies.say("The Heart in your Basement", heartSayWhat, {textSpeed = "slow", onstart = function() OnStart() end, oncomplete = function() OnComplete() end})

	-- create collision objects from tilemaps
	spawnCollisionObjects(Overworld)
	-- use layer objects to spawn everything
	Player:init(Overworld)
	Monsters:init(Overworld)
	Triggers:init(Overworld)
	Doors:init(Overworld)

	-- camera object
	Cam = camera(Player.x, Player.y, 3)
end

function love.update(dt)
	Cam:lockPosition(Player.x, Player.y)
	Overworld:update(dt)
	Heart:update(dt)
	if state == gameStates.gameLoop then
		Player:update(dt)
		Monsters:update(dt)
	end
	Talkies.update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)

	Cam:attach()

	love.graphics.setColor(1, 1, 1)
	Overworld:drawLayer(Overworld.layers["Tilemap"])
	-- love.graphics.setColor(1, 0, 0)
	-- love.graphics.rectangle("fill", Player.x, Player.y, 10, 14)
	Player.animation:draw()
	for i,m in ipairs(Monsters) do
		m.animation:draw()
		-- love.graphics.setColor(0, 0, 1)
		-- love.graphics.rectangle("fill", m.x, m.y, m.width, m.height)
	end
	Heart.animation:draw()
	Cam:detach()

	love.graphics.setColor(1, 0, 0)
	love.graphics.print("Cam: " .. CamX .. ", " .. CamY .. "    World: " .. WorldX .. ", " .. WorldY)
	love.graphics.print(ObjectTest, 0, 30)
	Talkies.draw()
end

function love.mousepressed(x, y, b, istouch)
	if b == 1 then
		CamX, CamY = Cam:cameraCoords(love.mouse.getPosition())
		WorldX, WorldY = Cam:worldCoords(love.mouse.getPosition())
		CamX = math.floor(CamX)
		CamY = math.floor(CamY)
		WorldX = math.floor(WorldX)
		WorldY = math.floor(WorldY)
	end
end

function love.keypressed(key)
	local binding = state.keys[key]
  inputHandler(binding)
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