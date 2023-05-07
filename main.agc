#include "myLib.agc"
#include "constants.agc"
#include "gameState.agc"
#include "start.agc"
#include "characterSelect.agc"
#include "results.agc"
#include "ai.agc"
#company_name "rondovo"

// Project: SpaceCrabVS 
// Created: 22-03-03

// show all errors

//#renderer "Basic"

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
SetSyncRate( 120, 0 ) // 30fps instead of 60 to save battery	//LOL
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetVSync(1)

LoadBaseImages()
LoadBaseSounds()
//LoadBaseMusic()
SetFolder("/media")

global fpsr#

global gameTime#

device$ = GetDeviceBaseName()
global deviceType = DESKTOP

if device$ = "android" or device$ = "ios" then deviceType = MOBILE

if deviceType = MOBILE then SetScissor(0, 0, w, h)
SetImmersiveMode(1)

//SetPhysicsDebugOn()

//RIP Sheep
//LoadSprite(split, "sheepstart2.png")
//SetSpriteSize(split, w*1.5, 80)
LoadSprite(split, "belt.png")
SetSpriteSize(split, w, 120)
SetSpriteColor(split, 200, 200, 200, 255)
SetSpriteMiddleScreenX(split)
SetSpriteMiddleScreenY(split)

global appState = START

gameTime# = 0

function SaveGame()
	SetFolder("/media")
	OpenToWrite(1, "save.txt")
	
	WriteInteger(1, spHighScore)
	WriteString(1, spHighCrab$)
	
	CloseFile(1)
endfunction

function LoadGame()
	SetFolder("/media")
	if GetFileExists("save.txt") = 0 then SaveGame()
	OpenToRead(1, "save.txt")
	
	spHighScore = ReadInteger(1)
	spHighCrab$ = ReadString(1)
	
	CloseFile(1)
endfunction

LoadGame()



do
	fpsr# = 60.0/ScreenFPS()
	
	if gameTime# > 10000000 then gameTime# = 0
	if gameTimer# > 1000000000 then gameTimer# = 0
	inc gameTime#, fpsr#
	
	ProcessMultitouch()
	
	if appState = START
		appState = DoStart()
	elseif appState = CHARACTER_SELECT
		appState = DoCharacterSelect()
	elseif appState = GAME
		appState = DoGame()
	elseif appState = RESULTS
		appState = DoResults()
	endif
	
	touch = GetRawFirstTouchEvent(1)
	while touch <> 0
		//Print(touch)
		touch = GetRawNextTouchEvent()
	endwhile
	
    Print(ScreenFPS())
    //Print(fpsr#)
    //Print(GetRawLastKey())
    //Print(meteorTotal1)
    //Print(specialTimerAgainst2#)
    
		//Print(GetDeviceBaseName())
		
	PingUpdate()
	UpdateAllTweens(GetFrameTime())
	Print(GetImageMemoryUsage())
    Print(GetImageExists(101))
    Sync()
loop

function TransitionStart()
	
	//Making the particles for the first time
	if GetParticlesExists(11) = 0
		lifeEnd# = .7
		for i = 11 to 13
			CreateParticles(i, 0, 0)
			SetParticlesImage (i, LoadImage("starParticle.png"))
			SetParticlesFrequency(i, 300)
			SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
			SetParticlesSize(i, 240)
			SetParticlesStartZone(i, -GetParticlesSize(i), 0, -GetParticlesSize(i), h) //The box that the particles can start from
			SetParticlesDirection(i, 50, 0)
			SetParticlesAngle(i, 0)
			SetParticlesRotationRange(i, 400, 800)
			SetParticlesVelocityRange (i, 30, 60)
			SetParticlesMax (i, 200)
			SetParticlesDepth(i, 1)
		next i
		
		AddParticlesColorKeyFrame (11, 0.0, 0, 255, 255, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/8, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/4, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#*3/8, 0, 255, 255, 255)
		
		SetParticlesSize(12, 180)
		SetParticlesMax (12, 250)
		SetParticlesVelocityRange (12, 40, 70)
		AddParticlesColorKeyFrame (12, 0.0, 121, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#/8, 255, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#/4, 121, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#*3/8, 255, 255, 0, 255)
		
		SetParticlesSize(13, 120)
		SetParticlesMax (13, 300)
		SetParticlesVelocityRange (13, 50, 80)
		AddParticlesColorKeyFrame (13, 0.0, 255, 0, 0, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#/8, 255, 15, 171, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#/4, 255, 0, 0, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#*3/8, 255, 15, 171, 255)
		
	else
		//If the particles are already made, then just resetting them
		for i = 11 to 13
			ResetParticleCount(i)
		next i
	endif
	
	iEnd = 21/fpsr#
	for i = 1 to iEnd
		//Sync()
	next i
	
	//#constant parStar1 11
//#constant parStar2 12
//#constant parStar3 13
	
endfunction

function TransitionEnd()
	
	
endfunction

/*
THE GRAVEYARD OF THE METEOR QUEUE

	meteorQueue1.insert(newMet)

	if meteorQueue1.length > 0
		
		meteorActive1.insert(meteorQueue1[1])
		
		meteorQueue1.remove(1)
		
	endif

*/
