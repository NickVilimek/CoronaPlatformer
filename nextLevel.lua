local composer = require( "composer" )

local prevScene = composer.getSceneName( "previous" )
local scene = composer.newScene()
local counter = 0


function scene:show( event )

	local phase = event.phase
	local nextLevel = event.params.nextLevel
	local world = event.params.world

	if ( phase == "will" ) then
		composer.removeScene( prevScene )
 	elseif ( phase == "did" ) then
		composer.gotoScene( world, { params = { map = nextLevel}  } )
	end
end

scene:addEventListener( "show", scene )

return scene
