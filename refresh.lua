
local composer = require( "composer" )
local scene = composer.newScene()

function scene:show( event )

	local phase = event.phase
	local world = event.params.world
	
	local options = { params = event.params }
	
	if ( phase == "will" ) then
		composer.removeScene( world )
	elseif ( phase == "did" ) then
		composer.gotoScene( world, options )
	end
end

scene:addEventListener( "show", scene )

return scene
