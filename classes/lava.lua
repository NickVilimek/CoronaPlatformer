local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )

local M = {}

function M.new( instance )
		
	if not instance.bodyType then
		physics.addBody( instance, "dynamic", { isSensor = true } )
	end

	return instance
end

return M
