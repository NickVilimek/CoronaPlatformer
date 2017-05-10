local composer = require( "composer" )
local fx = require( "com.ponywolf.ponyfx" )

local M = {}

function M.new( instance )
		
	if not instance.bodyType then
		physics.addBody( instance, "static", { isSensor = true } )
	end

	return instance
end

return M
