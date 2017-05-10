-- Include modules/libraries
local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )
local tiled = require( "com.ponywolf.ponytiled" )
local physics = require( "physics" )
local json = require( "json" )

local map, player, gem

local scene = composer.newScene()

function scene:create( event )

	local sceneGroup = self.view  

	physics.start()
	physics.setGravity( 0, 20 )

	-- Load our map
	local filename = event.params.map or "levels/world1level1.json"
	local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
	map = tiled.new( mapData, "levels" )
	map.x,map.y = display.contentCenterX - map.designedWidth/2, display.contentCenterY - map.designedHeight/2
	map.xScale, map.yScale = .5, .5
	
	--Player
	map.extensions = "classes."
	map:extend( "player", "gem", "water" )

	--Give player parameters about the map
	player = map:findObject( "player" )
	player.map = filename
	player.world = "world1"

	sceneGroup:insert( map )

end

--World 1: this moves the screen with the player 
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