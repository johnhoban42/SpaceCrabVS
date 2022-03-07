#include "myLib.agc"
#include "constants.agc"

// Project: SpaceCrabVS 
// Created: 22-03-03

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "SpaceCrabVS" )
SetWindowSize( 800, 1600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

#constant w 800
#constant h 1600

// set display properties
SetVirtualResolution( w, h ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetVSync(1)

LoadBaseImages()

global fpsr#


LoadSprite(split, "sheepstart2.png")
SetSpriteSize(split, w*1.5, 80)
SetSpriteMiddleScreenX(split)
SetSpriteMiddleScreenY(split)

CreateGame1()
CreateGame2()

do
	fpsr# = 60.0/ScreenFPS()
	
	DoGame1()
	
    Print(ScreenFPS())
    Print(fpsr#)
    Print(GetRawLastKey())
    Sync()
loop


function CreateGame1()
	CreateSprite(planet1, planetIRandStart + Random(1, 8))
	SetSpriteSizeSquare(planet1, planetSize)
	DrawPolar1(planet1, 0, 270)
	
	CreateSprite(crab1, LoadImage("crab77walk8.png"))
	SetSpriteSize(crab1, 80, 50)
	crab1Theta# = 270
	DrawPolar1(crab1, planetSize/2 + GetSpriteHeight(crab1)/3, crab1Theta#)
endfunction

function DoGame1()
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if (GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32))
		if crab1Turning = 0
			if crab1Dir# > 0
				crab1Turning = -1
			else
				crab1Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab1Turning = -1*crab1Turning
		endif
		
	endif
	
	//Enacting the crab turn while activated
	if crab1Turning <> 0 then TurnCrab1(crab1Turning)
	
	//Making sure the crab is using proper rotation numbers
	if crab1Theta# > 360 then inc crab1Theta#, -360
	if crab1Theta# < 0 then inc crab1Theta#, 360
	
	//This cancels out the weird issue where the integer is sometimes infinity
	if crab1Theta# > 10000000 then crab1Theta# = 270
	
	//The visual update code
	DrawPolar1(crab1, planetSize/2 + GetSpriteHeight(crab1)/3, crab1Theta#)
	

	
endfunction

function TurnCrab1(dir)
	
	//Accelerating the crab in the specified direction
	inc crab1Dir#, dir * crab1Accel# * fpsr#
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab1Dir#) > Abs(dir)
		crab1Dir# = dir
		crab1Turning = 0
	endif
		
		
	
endfunction

function CreateGame2()
	CreateSprite(planet2, planetIRandStart + Random(1, 8))
	SetSpriteSizeSquare(planet2, planetSize)
	DrawPolar2(planet2, 0, 270)
endfunction

function DoGame2()
	
	
endfunction

function DrawPolar1(spr, rNum, theta#)
	cenX = w/2
	cenY = h*3/4 + GetSpriteHeight(split)/4
	SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
	SetSpriteAngle(spr, theta#+90)
	//if spriteNum >= 111 and spriteNum <= 120 then SetSpriteAngle(spriteNum, theta#+45)
endfunction
	
function DrawPolar2(spr, rNum, theta#)
	cenX = w/2
	cenY = h/4 - GetSpriteHeight(split)/4
	SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
	SetSpriteAngle(spr, theta#+90)
	//if spriteNum >= 111 and spriteNum <= 120 then SetSpriteAngle(spriteNum, theta#+45)
endfunction