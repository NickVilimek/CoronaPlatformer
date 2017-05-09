
local fx = require( "com.ponywolf.ponyfx" )
local composer = require( "composer" )

local M = {}

function M.new( instance, options )
	local scene = composer.getScene( composer.getSceneName( "current" ) )

	--Grab custom properties set in the map editor 
	instance.isVisible = false
	local parent = instance.parent
	local x, y = instance.x, instance.y
	local world, nextLevel, currentLevel = instance.world, instance.nextLevel, instance,currentLevel

	-- Load spritesheet
	local sheetData = { width = 80, height = 110, numFrames = 27, sheetContentWidth = 720, sheetContentHeight = 330 }
	local sheet = graphics.newImageSheet( "images/adventurer_tilesheet.png", sheetData )
	local sequenceData = {
		{ name = "idle", frames = { 1 } },
		{ name = "walk", frames = { 10,11,1 }, time = 300, loopCount = 0 },
		{ name = "jump", frames = { 2 } },
		{ name = "dead", frames = { 5 } },
	}
	instance = display.newSprite( parent, sheet, sequenceData )
	instance.x,instance.y = x, y
	instance:setSequence( "idle" )

	physics.addBody( instance, "dynamic", { density = 3, bounce = 0, friction =  5.0 } )
	instance.isFixedRotation = true

	local max, acceleration, left, right, flip = 400, 2200, 0, 0, 0
	local lastEvent = {}
	local function key( event )
		local phase = event.phase
		local name = event.keyName
		--Filter Reapeating 
		if ( phase == lastEvent.phase ) and ( name == lastEvent.keyName ) then return false end  
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
			self:applyLinearImpulse( 0, -600 )
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

			if other.type == "water" then

				instance:setSequence( "dead" )
				instance:play()

				fx.fadeOut( function()
					composer.removeScene(world)
					composer.gotoScene( world,
						 { params = { map = currentLevel } } )
				end )
			elseif phase == "began" and other.type == "gem" then 
				fx.fadeOut( function()
					composer.removeScene(world)
					composer.gotoScene( world,
						 { params = { map = nextLevel } } )
				end )
			end
		end
 	end

	function instance:finalize()
		Runtime:removeEventListener( "enterFrame", enterFrame )
		Runtime:removeEventListener( "key", key )
		instance:removeEventListener( "collision" )
	end

	Runtime:addEventListener( "enterFrame", enterFrame )
	Runtime:addEventListener( "key", key )
	instance:addEventListener( "finalize" )
	instance:addEventListener( "collision" )

	instance.name = "player"
	instance.type = "player"
	return instance
end

return M
