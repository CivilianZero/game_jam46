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

-- local imports
local sti = require('libraries.sti.sti')

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	-- physics world config
	World = love.physics.newWorld(0, 0, false)
	World:setCallbacks(BeginContact, EndContact)

	-- required files
	require('show')
	require('sprites')
	require('player')
	require('heart')
	-- required libraries
	Anim8 = require('libraries.anim8.anim8')
	Talkies = require('libraries.talkies.talkies')
	local camera = require('libraries.hump.camera')

	-- table for storing save data
	SaveData = {}

	-- check for saved data, load using table.show if exists
	if love.filesystem.getInfo("data.lua") then
		local data = love.filesystem.load("data.lua")
		data()
	end

	-- TiledMap = Tiled('assets/maps/TiledMap.lua')
	PixelFont = love.graphics.newFont('assets/fonts/Kenney Pixel.ttf', 50)

	-- camera object
	Cam = camera(Player.body:getX(), Player.body:getY(), 3)


	-- tilemaps
	-- Basement = sti('assets/maps/basement.lua')
	-- OverWorld = sti('assets/maps/overWorld.lua')
	CamX = 0
	CamY = 0
	WorldX = 0
	WorldY = 0

	state = gameStates.gameLoop

	-- Talkies config
	Talkies.font = PixelFont
	Talkies.talkSound = love.audio.newSource("assets/sounds/typeSound.wav", "static")
	
end

function love.update(dt)
	World:update(dt)
	if state == gameStates.gameLoop then
		UpdatePlayer(dt)
	end
	Talkies.update(dt)
	-- Player.animation:update(dt)
	-- Heart.animation:update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)
	love.graphics.print("Cam: " .. CamX .. ", " .. CamY .. "    World: " .. WorldX .. ", " .. WorldY)
	Cam:attach()
	love.graphics.draw(Player.sprite, Player.body:getX(), Player.body:getY())
	love.graphics.draw(Heart.sprite, 300, 300)
	Cam:detach()
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
  return InputHandler(binding)
end

-- utility function for handling input
function InputHandler( input )
	local action = state.bindings[input]
	if action then
		return action()
	end
end

-- utility function for determing collision
-- returns a boolean
-- probably not needed
function CheckCollision(obj1, obj2)
	local distance = math.sqrt((obj2.y - obj1.y)^2 + (obj2.x - obj1.x)^2)
	return distance < obj1.size + obj2.size
end

-- callback functions for physics World
function BeginContact()
end

function EndContact()
end