
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

-- Define module
local M = {}

function M.new( instance, options )
	-- Get the current scene
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	local function enterFrame()
		
	end

	function instance:finalize()
		Runtime:removeEventListener( "enterFrame", enterFrame )
	end

	Runtime:addEventListener( "enterFrame", enterFrame )

	-- Return instance
	instance.name = "platform"
	instance.type = "platform"
	return instance
end

return M
