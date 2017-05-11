local composer = require( "composer" )

local scene = composer.newScene()

--Navigates character to the next level
function scene:show( event )

	local phase = event.phase

	--Params are world and level
	local world = event.params.world
	local nextLevel = event.params.map
	local options = { params = event.params }

	local prevScene = composer.getSceneName( "previous" )

	if ( phase == "will" ) then
		composer.removeScene( prevScene )
 	elseif ( phase == "did" ) then
		composer.gotoScene( world, options )
	end
end

scene:addEventListener( "show", scene )

return scene
