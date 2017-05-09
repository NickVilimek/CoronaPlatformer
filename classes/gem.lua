local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )

local M = {}

function M.new( instance )
	
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	local world, nextLevel = instance.world, instance.nextLevel
	
	if not instance.bodyType then
		physics.addBody( instance, "static", { isSensor = true } )
	end

	function instance:collision( event )
		local phase, player = event.phase, event.other

		if phase == "began" and player.name == "player" then

			fx.fadeOut( function()
				composer.gotoScene( "nextLevel",
			 	{params = {world = world, nextLevel = nextLevel}} )
			end, 300, 300 )

		end
	end

	instance:addEventListener( "collision" )
	return instance
end

return M
