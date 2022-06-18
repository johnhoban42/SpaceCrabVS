#include "myLib.agc"
#include "constants.agc"
#include "gameState.agc"
#include "start.agc"
#include "characterSelect.agc"

// Project: SpaceCrabVS 
// Created: 22-03-03

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "SpaceCrabVS" )
SetWindowSize( 700, 1400, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

#constant w 800
#constant h 1600

SetAntialiasMode( 1 )

// set display properties
SetVirtualResolution( w, h ) // doesn't have to match the window
SetOrientationAllowed(1, 0, 0, 0) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery	//LOL
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetVSync(1)

LoadBaseImages()
LoadBaseSounds()
LoadBaseMusic()

global fpsr#

global gameTime#

//SetPhysicsDebugOn()


LoadSprite(split, "sheepstart2.png")
SetSpriteSize(split, w*1.5, 80)
SetSpriteMiddleScreenX(split)
SetSpriteMiddleScreenY(split)

appState = START

gameTime# = 0

do
	fpsr# = 60.0/ScreenFPS()
	
	if gameTime# > 10000000 then gameTime# = 0
	if gameTimer# > 1000000000 then gameTimer# = 0
	inc gameTime#, fpsr#
	
	if appState = START
		appState = DoStart()
	elseif appState = CHARACTER_SELECT
		appState = DoCharacterSelect()
	elseif appState = GAME
		appState = DoGame()
	elseif appState = RESULTS
		// appState = DoResults()
	endif
	
    Print(ScreenFPS())
    Print(fpsr#)
    Print(GetRawLastKey())
    Print(meteorTotal1)
    Print(specialTimerAgainst2#)
    Sync()
loop

/*
THE GRAVEYARD OF THE METEOR QUEUE

	meteorQueue1.insert(newMet)

	if meteorQueue1.length > 0
		
		meteorActive1.insert(meteorQueue1[1])
		
		meteorQueue1.remove(1)
		
	endif

*/
