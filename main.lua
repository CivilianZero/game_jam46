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

-- utility function for determing distance between two points
function DistanceBetween(x1, y1, x2, y2)
	return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end