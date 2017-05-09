local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )

local M = {}

function M.new( instance )
	
	local scene = composer.getScene( composer.getSceneName( "current" ) )
	
	if not instance.bodyType then
		physics.addBody( instance, "static", { isSensor = true } )
	end
	--[[
	function instance:collision( event )
		local phase, other = event.phase, event.other
		if phase == "began" and other.name == "player" then
			fx.fadeOut( function()
				composer.removeScene("world1")
				composer.gotoScene( "world1", { params = { map = instance.nextLevel } } )
			end )
		end
	end
	]]--

	--instance:addEventListener( "collision" )
	return instance
end

return M
