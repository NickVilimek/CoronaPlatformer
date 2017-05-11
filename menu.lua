
-- Menu Scene
-- Displays game's name, the cannon and a couple buttons.

local composer = require('composer')
local widget = require('widget')
local controller = require('libs.controller')
local relayout = require('libs.relayout')

local scene = composer.newScene()

function scene:create()
	local _W, _H, _CX, _CY = relayout._W, relayout._H, relayout._CX, relayout._CY

	local group = self.view

	local background = display.newRect(group, _CX-300, _CY, 1000, _H)
	background.fill = {
	    type = 'gradient',
	    color1 = {0.2, 0.45, 0.8},
	    color2 = {0.7, 0.8, 1}
	}
	relayout.add(background)


	local titleGroup = display.newGroup()
	titleGroup.x, titleGroup.y = _CX-315, 128
	group:insert(titleGroup)
	relayout.add(titleGroup)

	local title = 'TREASURE HUNTER!!!'
	local j = 1
	for i = -9, 8 do
		local character = display.newGroup()
		titleGroup:insert(character)
		local rect = display.newRect(character, 0, 0, 32, 32)
		rect.strokeWidth = 2
		rect:setFillColor(0.0, 0.0, 1.0)
		rect:setStrokeColor(0.8)

		local text = display.newText({
			parent = character,
			text = title:sub(j, j),
			x = 0, y = 0,
			font = native.systemFontBold,
			fontSize =32
		})
		text:setFillColor(0.8, 0.5, 0.2)

		character.x, character.y = i * 72/2, 0
		transition.from(character, {time = 500, delay = 100 * j, y = _H + 100, transition = easing.outExpo})
		j = j + 1
	end
	
											
	
	local padding = 30
	local ypadding = 75


	self.startButton = widget.newButton({
		defaultFile = 'images/playgame.png',
		width = 320, height = 188,
		x = 400 - 190, y = -200 - 100,
		onRelease = function()
			composer.gotoScene( "world1", { params={ world = "world1" } } )
		end
	})
	group:insert(self.startButton)

	transition.to(self.startButton, {time = 1200, delay = 500, y = _H - 50 - self.startButton.height / 2, transition = easing.inExpo, onComplete = function(object1)
		transition.to(object1, {time = 800, x = _W - 650 - self.startButton.width / 2, transition = easing.outExpo, onComplete = function(object2)
			relayout.add(object2)
		end})
	end})
end

-- Android's back button action
function scene:gotoPreviousScene()

end

function scene:show(event)

end

function scene:hide(event)

end

function scene:destroy( event )
end

scene:addEventListener('create')
scene:addEventListener('show')
scene:addEventListener('hide')
scene:addEventListener( "destroy" )

return scene