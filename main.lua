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
	},
	keys = {
		escape = "openMenu",
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

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- required libraries
	Anim8 = require('libraries.anim8.anim8')
	Talkies = require('libraries.talkies.talkies')
	local camera = require('libraries.hump.camera')
	local bump = require('libraries.bump.bump')

	-- physics world config
	World = bump.newWorld(16)

	-- required files
	require('show')
	require('sprites')
	require('player')
	require('heart')
	require('monster')

	-- table for storing save data
	SaveData = {}

	-- check for saved data, load using table.show if exists
	if love.filesystem.getInfo("data.lua") then
		local data = love.filesystem.load("data.lua")
		data()
	end

	-- TiledMap = Tiled('assets/maps/TiledMap.lua')
	PixelFont = love.graphics.newFont('assets/fonts/Kenney Pixel.ttf', 40)

	-- camera object
	Cam = camera(180, 532, 3)

	-- tilemaps
	-- Basement = sti('assets/maps/basement.lua')
	OverWorld = sti('assets/maps/tilemap.lua')
	
	-- debugging for collision
	ObjectTest = "Test: "

	-- creare collision objects for tilemaps
	for i,obj in pairs(OverWorld.layers["Collision"].objects) do
		SpawnCollisionObjects(obj.x, obj.y, obj.width, obj.height)
	end

	-- coordinates for debugging camera and player position
	CamX = 0
	CamY = 0
	WorldX = 0
	WorldY = 0

	-- set default state (set to skip menu)
	state = gameStates.gameLoop

	-- Talkies config
	Talkies.font = PixelFont
	Talkies.talkSound = love.audio.newSource("assets/sounds/bep.wav", "static")

	Talkies.say("The Heart in your Basement", "...feed me", {textSpeed = "slow", onstart = function() OnStart() end, oncomplete = function() OnComplete() end})

	SpawnMonsters()
end

function love.update(dt)
	OverWorld:update(dt)
	if state == gameStates.gameLoop then
		Player:update(dt)
	end
	Talkies.update(dt)
	-- Player.animation:update(dt)
	-- Heart.animation:update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)

	Cam:attach()

	love.graphics.setColor(1, 1, 1)
	OverWorld:drawLayer(OverWorld.layers["Tilemap"])
	love.graphics.draw(Player.sprite, Player.x, Player.y, nil, nil, nil, 2.5, nil)
	love.graphics.draw(Heart.sprite, Heart.x, Heart.y, nil, .5, .5, Heart.sprite:getWidth()/2, Heart.sprite:getHeight()/2)
	for i,m in ipairs(Monsters) do
		love.graphics.setColor(0, 0, 1)
		love.graphics.rectangle("fill", m.x, m.y, m.width, m.height)
	end
	
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
  InputHandler(binding)
end

-- utility function for handling input
function InputHandler(input)
	local action = state.bindings[input]
	if action then
		return action()
	end
end

-- creates collision objects
function SpawnCollisionObjects(x, y, w, h)
	local wall = {}
	wall.name = "Wall"
	wall.x = x
	wall.y = y
	wall.width = w
	wall.height = h
	World:add(wall, x, y, w, h)
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