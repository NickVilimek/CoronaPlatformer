-- Include the Composer library
local composer = require( "composer" )

display.setStatusBar( display.HiddenStatusBar ) 

-- Removes bottom bar on Android 
if system.getInfo( "androidApiLevel" ) and system.getInfo( "androidApiLevel" ) < 19 then
	native.setProperty( "androidSystemUiVisibility", "lowProfile" )
else
	native.setProperty( "androidSystemUiVisibility", "immersiveSticky" ) 
end

-- Corona simulator 
local isSimulator = "simulator" == system.getInfo( "environment" )
local isMobile = ( "ios" == system.getInfo("platform") ) or ( "android" == system.getInfo("platform") )

-- Debugging on simulator 
if isSimulator then 

	-- Show FPS
	local visualMonitor = require( "com.ponywolf.visualMonitor" )
	local visMon = visualMonitor:new()
	visMon.isVisible = false

	local function debugKeys( event )
		local phase = event.phase
		local key = event.keyName
		if phase == "up" then
			if key == "f" then
				visMon.isVisible = not visMon.isVisible 
			end
		end
	end
	Runtime:addEventListener( "key", debugKeys )
end

-- Add joystick to screen 
require( "com.ponywolf.joykey" ).start()
system.activate("multitouch")

if isMobile or isSimulator then
	local vjoy = require( "com.ponywolf.vjoy" )
	local stick = vjoy.newStick()
	stick.xScale, stick.yScale = 0.5, 0.5
	stick.x, stick.y = -192, display.contentHeight - 96
	local button = vjoy.newButton()
	button.x, button.y = display.contentWidth + 128 + 32, display.contentHeight - 96
end

-- reserve music channel
audio.reserveChannels(1)

composer.gotoScene( "world1", { params={ } } )
