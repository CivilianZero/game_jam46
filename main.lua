function love.load()
	-- physics world config
	World = love.physics.newWorld(0, 0, false)
	World:setCallbacks(BeginContact, EndContact)

	-- required files
	require('show')
	require('sprites')
	require('player')
	require('heart')
	-- required libraries
	Anim8 = require('libraries.anim8-master.anim8')
	Tiled = require('libraries.Simple-Tiled-Implementation-master.sti')
	local camera = require('libraries.hump-master.camera')

	-- table for including sprites
	Sprites = {}

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
	Cam = camera()

	-- tilemaps
	-- Basement = Tiled('assets/maps/basement.lua')
	-- OverWorld = Tiled('assets/maps/overWorld.lua')
end

function love.update(dt)
	World:update(dt)
	UpdatePlayer(dt)
	-- Player.animation:update(dt)
	-- Heart.animation:update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)
	love.graphics.print("this is a font test")

	love.graphics.draw(Player.sprite, Player.x, Player.y)
end

-- utility function for determing collision
-- returns a boolean
function CheckCollision(obj1, obj2)
	local distance = math.sqrt((obj2.y - obj1.y)^2 + (obj2.x - obj1.x)^2)
	return distance < obj1.size + obj2.size
end

-- callback functions for physics World
function BeginContact()
end

function EndContact()
end