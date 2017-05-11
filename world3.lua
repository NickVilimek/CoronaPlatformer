-- Include modules/libraries
local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )
local tiled = require( "com.ponywolf.ponytiled" )
local physics = require( "physics" )
local json = require( "json" )

-- Variables local to scene
local map, player

-- Create a new Composer scene
local scene = composer.newScene()

-- This function is called when scene is created
function scene:create( event )

	local sceneGroup = self.view  

	physics.start()
	physics.setGravity( 0, 20 )

	-- Load our map
	local filename = event.params.map or "levels/world3level4.json"
	local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
	map = tiled.new( mapData, "levels" )
	map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2
	map.xScale, map.yScale = .4, .4
	
	--Player
	map.extensions = "classes."
	map:extend( "player" ,"gem", "lava")
	player = map:findObject( "player" )
	player.filename = filename
	player.map = filename
	player.world = "world2"

	sceneGroup:insert( map )

end

local function enterFrame( event )

	local elapsed = event.time
	if player and player.x and player.y then
		local x, y = player:localToContent( 0, 0 )
		x, y = display.contentCenterX - x, display.contentCenterY - y
		map.x, map.y = map.x + x, map.y + y
	end
end

function scene:show( event )

	local phase = event.phase
	if ( phase == "will" ) then
		fx.fadeIn()	
		Runtime:addEventListener( "enterFrame", enterFrame )
	end
end

function scene:hide( event )

	local phase = event.phase
	if ( phase == "did" ) then
		Runtime:removeEventListener( "enterFrame", enterFrame )
	end
end

function scene:destroy( event )
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene