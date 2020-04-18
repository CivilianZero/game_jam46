local sti = require('libraries.Simple-Tiled-Implementation-master.sti')

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
	local camera = require('libraries.hump-master.camera')

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
	-- Basement = sti('assets/maps/basement.lua')
	-- OverWorld = sti('assets/maps/overWorld.lua')
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

	love.graphics.draw(Player.sprite, Player.body:getX(), Player.body:getY())
	if Player.itemHeld ~= nil then
		love.graphics.draw(Player.itemHeld.sprite, love.graphics.getWidth() - 40, love.graphics.getHeight() - 40, nil, 0.9, 0.9, Player.itemHeld.sprite:getWidth()/2, Player.itemHeld:getHeight()/2)
	end

	-- example item
	local inventoryItem = love.graphics.newQuad(0, 408, 16, 16, Sprites.spriteSheet:getDimensions())
	love.graphics.draw(Sprites.spriteSheet, inventoryItem, love.graphics.getWidth() - 30, love.graphics.getHeight() - 30, nil, 0.75, 0.75, 8, 8)
	-- love.graphics.draw(Player.itemHeld.sprite, love.graphics.getWidth() - 30, love.graphics.getHeight() - 30, nil, nil, nil, Player.itemHeld.sprite:getWidth()/2, Player.itemHeld.sprite:getWidth()/2)
	-- draw held item box
	local itemBox = love.graphics.newQuad(391, 442, 16, 16, Sprites.spriteSheet:getDimensions())
	love.graphics.draw(Sprites.spriteSheet, itemBox, love.graphics.getWidth() - 30, love.graphics.getHeight() - 30, nil, nil, nil, 8, 8)
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