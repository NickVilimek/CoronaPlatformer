local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )

local M = {}

function M.new( instance )
	
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	--World and nextlevel file are set in the map editor 
	--and tracked here 
	local world, nextLevel = instance.world, instance.nextLevel
	
	if not instance.bodyType then
		physics.addBody( instance, "static", { isSensor = true } )
	end

	function instance:collision( event )
		local phase, player = event.phase, event.other

		--If it collides with the player 
		if phase == "began" and player.name == "player" then
			--Go to the next level
			fx.fadeOut( function()
				--Pass along world, level associated with gem to help navigate to next level
				--goes to nextLevel.lua
				composer.gotoScene( "nextLevel",{params = { world = world, map = nextLevel } } )
			end, 200, 200 )

		end
	end

	instance:addEventListener( "collision" )
	return instance
end

return M
