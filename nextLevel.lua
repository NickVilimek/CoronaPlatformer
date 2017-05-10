local composer = require( "composer" )

local scene = composer.newScene()
local counter = 0


function scene:show( event )

	local phase = event.phase
	local nextLevel = event.params.nextLevel
	local world = event.params.world

	local prevScene = composer.getSceneName( "previous" )

	if ( phase == "will" ) then
		composer.removeScene( prevScene )
 	elseif ( phase == "did" ) then
		composer.gotoScene( world, { params = { map = nextLevel, world = world}  } )
	end
end

scene:addEventListener( "show", scene )

return scene
