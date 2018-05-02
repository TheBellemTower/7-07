-----------------------------------------------------------------------------------------
--
-- main.lua
--
--Created by Ethan Bellem
--Createed on April 2018
-----------------------------------------------------------------------------------------

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only

local playerBullets = {} -- Table that holds the players Bullets

local theGround = display.newImage( "./assets/sprites/land.png" )
theGround.x = display.contentCenterX 
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local fight = display.newText( "Fight", 1000, 200, native.systemFont, 350)
fight.alpha = .5
fight:setTextColor( .7, 0, 0)

local Ground = display.newImage( "./assets/sprites/land.png" )
Ground.x = display.contentCenterX + 900
Ground.y = display.contentHeight
Ground.id = "the Ground"
physics.addBody( Ground, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local rightWall = display.newRect( 2048, display.contentHeight / 2, 1, display.contentHeight )
--myRectangle.strokeWidth = 3
--myRectangle:setFillColor( 0.5 )
--myRectangle:setStrokeColor( 1, 0, 0 )
rightWall.alpha = 0.0
rightWall.id = "wall"
physics.addBody( rightWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local theCharacter = display.newImage( "./assets/sprites/ninja.png" )
theCharacter.x = display.contentCenterX + 900
theCharacter.y = 900
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.3, 
    bounce = .3
    } )
theCharacter.isFixedRotation = true

local theCharacter2 = display.newImage( "./assets/sprites/ninjaG.png" )
theCharacter2.x = display.contentCenterX 
theCharacter2.y = 900
theCharacter2.id = "bad character"
physics.addBody( theCharacter2, "dynamic", { 
    density = 3.0, 
    friction = 0.3, 
    bounce = .3
    } )
theCharacter2.isFixedRotation = true

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 150
dPad.alpha = 0.50
dPad.id = "d-pad"

local up = display.newImage( "./assets/sprites/upArrow.png" )
up.x = 150
up.y = display.contentHeight - 260
up.id = "up arrow"

local down = display.newImage( "./assets/sprites/downArrow.png" )
down.x = 150
down.y = display.contentHeight - 40
down.id = "down arrow"

local left = display.newImage( "./assets/sprites/leftArrow.png" )
left.x = 40
left.y = display.contentHeight - 150
left.id = "left arrow"

local right = display.newImage( "./assets/sprites/rightArrow.png" )
right.x = 260
right.y = display.contentHeight - 150
right.id = "right arrow"

local jump = display.newImage( "./assets/sprites/jumpButton.png" )
jump.x = display.contentWidth - 80
jump.y = display.contentHeight - 80
jump.id = "jump button"
jump.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.id == "bad character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "bad character" ) ) then
            -- Remove both the laser and asteroid
            display.remove( obj1 )
            display.remove( obj2 )
            
            -- remove the bullet
            local bulletCounter = nil
            
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end

            --remove character
            theCharacter2:removeSelf()
            theCharacter2 = nil

            -- Increase score
            print ("you could increase a score here.")

            -- make an explosion sound effect
            local expolsionSound = audio.loadStream( "./assets/sounds/8bit_bomb_explosion.wav" )
            local explosionChannel = audio.play( expolsionSound )

        end
    end
end

function up:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 in the x direction 
            y = -50, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function down:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 in the x direction 
            y = 50, -- move up 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end

    return true
end

function left:touch( event )
    if ( event.phase == "ended" ) then
        theCharacter.xScale = -1 -- flips the sprite to face the right direction
        -- move the character up
        transition.moveBy( theCharacter, { 
            x = -50, 
            y = 0, 
            time = 100 
            } )
    end

    return true
end

function right:touch( event )
    if ( event.phase == "ended" ) then
        theCharacter.xScale = 1
        -- move the character up
        transition.moveBy( theCharacter, { 
            x = 50,  
            y = 0, 
            time = 100 
            } )
    end

    return true
end

function jump:touch( event )
    if ( event.phase == "ended" ) then
        -- make the character jump
        theCharacter:setLinearVelocity( 0, -750 )
    end

    return true
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic', { 
            density =0
            } )
        aSingleBullet.xScale = -1
       


        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( -1500, 0 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end

function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX + 900
        theCharacter.y = 900
    end
end


up:addEventListener( "touch", up )
down:addEventListener( "touch", down )
left:addEventListener( "touch", left )
right:addEventListener( "touch", right )
jump:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )
Runtime:addEventListener( "enterFrame", checkCharacterPosition )
theCharacter.collision = characterCollision
theCharacter:addEventListener( "collision" )
Runtime:addEventListener( "collision", onCollision )