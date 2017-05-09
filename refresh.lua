
local composer = require( "composer" )

local prevScene = composer.getSceneName( "previous" )

local scene = composer.newScene()

local counter = 0

function scene:show( event )

	counter = counter + 1

	print(tostring(counter))

	local phase = event.phase
	local options = { params = event.params }
	if ( phase == "will" ) then
		composer.removeScene( prevScene )
	elseif ( phase == "did" ) then
		composer.gotoScene( prevScene, options )
	end
end

scene:addEventListener( "show", scene )

return scene
