function love.load()
	-- required files
	require('show')
	-- required libraries
	Anim8 = require('libraries.anim8-master.anim8')
	CameraFile = require('libraries.hump-master.camera')
	Tiled = require('libraries.Simple-Tiled-Implementation-master.sti')

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
end

function love.update(dt)
end

function love.draw()
	love.graphics.setFont(PixelFont)
	love.graphics.print("this is a font test")
end

-- utility function for determing collision
-- returns a boolean
function CheckCollision(obj1, obj2)
	local distance = math.sqrt((obj2.y - obj1.y)^2 + (obj2.x - obj1.x)^2)
	return distance < obj1.size + obj2.size
end