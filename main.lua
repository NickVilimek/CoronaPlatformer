local composer = require( "composer" )
local visualMonitor = require( "com.ponywolf.visualMonitor" )
local joypad = require( "com.ponywolf.joykey" )
local joystick = require("com.ponywolf.vjoy")

display.setStatusBar( display.HiddenStatusBar ) 

-- Corona simulator 
local isSimulator = "simulator" == system.getInfo( "environment" )
local isMobile = ( "ios" == system.getInfo("platform") ) or ( "android" == system.getInfo("platform") )

-- Debugging on simulator 
if isSimulator then 
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
joypad.start()
system.activate("multitouch")

if isMobile or isSimulator then
	local stick = joystick.newStick()
	stick.xScale, stick.yScale = 0.5, 0.5
	stick.x, stick.y = -192, display.contentHeight - 96
	local button = joystick.newButton()
	button.x, button.y = display.contentWidth + 128 + 32, display.contentHeight - 96
end

-- reserve music channel
audio.reserveChannels(1)

composer.gotoScene( "world3", { params={ world = "world3" } } )
