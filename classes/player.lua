
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

-- Define module
local M = {}

function M.new( instance, options )
	-- Get the current scene
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	-- Default options for instance
	options = options or {}

	-- Store map placement and hide placeholder
	instance.isVisible = false
	local parent = instance.parent
	local x, y = instance.x, instance.y

	-- Load spritesheet
	local sheetData = { width = 80, height = 110, numFrames = 27, sheetContentWidth = 720, sheetContentHeight = 330 }
	local sheet = graphics.newImageSheet( "images/adventurer_tilesheet.png", sheetData )
	local sequenceData = {
		{ name = "idle", frames = { 1 } },
		{ name = "walk", frames = { 10,11,1 }, time = 300, loopCount = 0 },
		{ name = "jump", frames = { 2 } },
		{ name = "ouch", frames = { 7 } },
	}
	instance = display.newSprite( parent, sheet, sequenceData )
	instance.x,instance.y = x, y
	instance:setSequence( "idle" )

	-- Add physics
	physics.addBody( instance, "dynamic", { density = 3, bounce = 0, friction =  5.0 } )
	instance.isFixedRotation = true

	local max, acceleration, left, right, flip = 400, 2200, 0, 0, 0
	local lastEvent = {}
	local function key( event )
		local phase = event.phase
		local name = event.keyName
		if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  -- Filter repeating keys
		if phase == "down" then
			if "right" == name or "d" == name then
				right = acceleration
				flip = 0.133
			end
			if "left" == name or "a" == name then
				left = -acceleration
				flip = -0.133
			end
			if "space" == name or "buttonA" == name or "button1" == name then
				instance:jump()
			end
			if not ( left == 0 and right == 0 ) and not instance.jumping then
				instance:setSequence( "walk" )
				instance:play()
			end

		elseif phase == "up" then
			if "right" == name or "d" == name then right = 0 end
			if "left" == name or "a" == name then left = 0 end
			if left == 0 and right == 0 and not instance.jumping then
				instance:setSequence("idle")
			end
		end
		lastEvent = event
	end

	function instance:jump()
		if not self.jumping then
			self:applyLinearImpulse( 0, -500 )
			instance:setSequence( "jump" )
			self.jumping = true
		end
	end

	local function enterFrame()
		-- Do this every frame
		local vx, vy = instance:getLinearVelocity()
		local dx = right + left
		if instance.jumping then dx = dx / 4 end
		if ( dx < 0 and vx > -max ) or ( dx > 0 and vx < max ) then
			instance:applyForce( dx or 0, 0, instance.x, instance.y )
		end
		-- Turn around
		instance.xScale = math.min( 1, math.max( instance.xScale + flip, -1 ) )
	end

	function instance:collision( event )
		local phase = event.phase
		local other = event.other
		local y1, y2 = self.y + 50, other.y - ( other.type == "enemy" and 25 or other.height/2 )
		local vx, vy = self:getLinearVelocity()
		if phase == "began" then
			if self.jumping and vy > 0 then
				-- Landed after jumping
				self.jumping = false
				if not ( left == 0 and right == 0 ) and not instance.jumping then
					instance:setSequence( "walk" )
					instance:play()
				else
					self:setSequence( "idle" )
				end
			end
		end
	end

	function instance:finalize()
		Runtime:removeEventListener( "enterFrame", enterFrame )
		Runtime:removeEventListener( "key", key )
		instance:removeEventListener( "collision" )
		Runtime:removeEventListener( "enterFrame", enterFrame )
	end

	Runtime:removeEventListener( "key", key )
	Runtime:addEventListener( "enterFrame", enterFrame )

	instance:addEventListener( "finalize" )

	-- Add our enterFrame listener
	--Runtime:addEventListener( "enterFrame", enterFrame )

	-- Add our key/joystick listeners
	Runtime:addEventListener( "key", key )
	instance:addEventListener( "collision" )


	-- Return instance
	instance.name = "player"
	instance.type = "player"
	return instance
end

return M
