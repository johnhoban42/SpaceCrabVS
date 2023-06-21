#include "myLib.agc"
#include "constants.agc"
#include "gameState.agc"
#include "start.agc"
#include "characterSelect.agc"
#include "results.agc"
#include "ai.agc"
#include "story.agc"
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

if GetGameCenterExists() = 1 // This checks to see if Game Center/Game Services exist on the device
	GameCenterSetup()
endif
GameCenterLogin()

//The resolution/device setup
#constant MOBILE 1
#constant DESKTOP 2

#constant APPLE 1
#constant ANDROID 2

device$ = GetDeviceBaseName()
global deviceType = DESKTOP
global mPlatform = APPLE

if device$ = "android" or device$ = "ios" then deviceType = MOBILE
if device$ = "android" then mPlatform = ANDROID

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

if deviceType = MOBILE then SetScissor(0, 0, w, h)
SetImmersiveMode(1)

LoadBaseImages()
LoadBaseSounds()
//LoadBaseMusic()
SetFolder("/media")

global fpsr#

global gameTime#

global demo = 1

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
	WriteInteger(1, spHighScoreClassic)
	WriteString(1, spHighCrabClassic$)
	
	CloseFile(1)
endfunction

function LoadGame()
	SetFolder("/media")
	if GetFileExists("save.txt") = 0 then SaveGame()
	OpenToRead(1, "save.txt")
	
	spHighScore = ReadInteger(1)
	spHighCrab$ = ReadString(1)
	spHighScoreClassic = ReadInteger(1)
	spHighCrabClassic$ = ReadString(1)
	
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
	elseif appState = STORY
		appState = DoStory()
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
	Print(GetImageMemoryUsage())
	
	//Print(GetPointerX())
	//Print(GetPointerY())
	
    SyncG()
loop

function TransitionStart(tranType)
	
	//Making the particles for the first time
	//if GetParticlesExists(11) = 0
		lifeEnd# = .7
		for i = 11 to 13
			DeleteParticles(i)
			CreateParticles(i, 0, 0)
			SetParticlesImage (i, starParticleI)	//Load this image in seperatly!
			SetParticlesFrequency(i, 300)
			SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
			SetParticlesSize(i, 240)
			SetParticlesStartZone(i, -GetParticlesSize(i), 0, -GetParticlesSize(i), h) //The box that the particles can start from
			SetParticlesDirection(i, 50, 0)
			SetParticlesAngle(i, 0)
			SetParticlesRotationRange(i, 400, 800)
			SetParticlesVelocityRange (i, 30, 60)
			//SetParticlesMax (i, 200)
			SetParticlesMax (i, -1)
			SetParticlesDepth(i, 1)
		next i
		SetParticlesSize(12, 180)
		//SetParticlesMax (12, 250)
		//SetParticlesMax (12, -1)
		
		SetParticlesSize(13, 120)
		//SetParticlesMax (13, 300)
		//SetParticlesMax (13, -1)
		 	//else
		//If the particles are already made, then just resetting them
		//for i = 11 to 13
		//	ResetParticleCount(i)
			
		//next i
	//endif
	
	if tranType = 1
		//The star swipe
		for i = 11 to 13
			SetParticlesStartZone(i, -GetParticlesSize(i), 0, -GetParticlesSize(i), h) //The box that the particles can start from
			SetParticlesDirection(i, 50, 0)
			SetParticlesRotationRange(i, 400, 800)
			SetParticlesVelocityRange (i, 30, 60)
			ClearParticlesColors(i)
		next i
		
		AddParticlesColorKeyFrame (11, 0.0, 0, 255, 255, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/8, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/4, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#*3/8, 0, 255, 255, 255)
		//SetParticlesMax (11, 225)
		
		SetParticlesVelocityRange (12, 40, 70)
		AddParticlesColorKeyFrame (12, 0.0, 121, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#/8, 255, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#/4, 121, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#*3/8, 255, 255, 0, 255)
		//SetParticlesMax (12, 275)

		SetParticlesVelocityRange (13, 50, 80)
		AddParticlesColorKeyFrame (13, 0.0, 255, 0, 0, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#/8, 255, 15, 171, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#/4, 255, 0, 0, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#*3/8, 255, 15, 171, 255)
		//SetParticlesMax (13, 325)
	elseif tranType = 2
		//The star boil
		for i = 11 to 13
			SetParticlesStartZone(i, 0, 0, w, h) //The box that the particles can start from
			SetParticlesDirection(i, 0, -5)
			SetParticlesRotationRange(i, 600, 900)
			SetParticlesVelocityRange (i, 30, 60)
			ClearParticlesColors(i)
		next i
		
		AddParticlesColorKeyFrame (11, 0.0, 0, 255, 255, 0)
		AddParticlesColorKeyFrame (11, lifeEnd#/8, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/4, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#*3/8, 0, 255, 255, 0)
		//AddParticlesScaleKeyFrame(11, 0.0, 
		//SetParticlesMax (11, 250)
		
		SetParticlesVelocityRange (12, 40, 70)
		AddParticlesColorKeyFrame (12, 0.0, 121, 255, 0, 0)
		AddParticlesColorKeyFrame (12, lifeEnd#/8, 255, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#/4, 121, 255, 0, 255)
		AddParticlesColorKeyFrame (12, lifeEnd#*3/8, 255, 255, 0, 0)
		//SetParticlesMax (12, 300)

		SetParticlesVelocityRange (13, 50, 80)
		AddParticlesColorKeyFrame (13, 0.0, 255, 0, 0, 0)
		AddParticlesColorKeyFrame (13, lifeEnd#/8, 255, 15, 171, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#/4, 255, 0, 0, 255)
		AddParticlesColorKeyFrame (13, lifeEnd#*3/8, 255, 15, 171, 0)
		//SetParticlesMax (13, 450)
		
	elseif tranType = 11
		//The transition for Mirror mode
		lifeEnd# = lifeEnd#
		DeleteParticles(11)
		CreateParticles(11, 0, 0)
		SetParticlesImage (11, starParticleI)	//Load this image in seperatly!
		SetParticlesFrequency(11, 40)
		SetParticlesLife(11, lifeEnd#)	//Time in seconds that the particles stick around
		SetParticlesSize(11, 240)
		SetParticlesStartZone(11, w/2, h/2, w/2, h/2) //The box that the particles can start from
		SetParticlesDirection(11, 0, 0)
		SetParticlesAngle(11, 0)
		SetParticlesRotationRange(11, 400, 800)
		SetParticlesVelocityRange (11, 0, 0)
		//SetParticlesMax (11, 10)
		SetParticlesDepth(11, 1)
		
		AddParticlesColorKeyFrame (11, 0.0, 0, 255, 255, 0)
		AddParticlesColorKeyFrame (11, lifeEnd#/4, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#/2, 0, 255, 102, 255)
		AddParticlesColorKeyFrame (11, lifeEnd#*3/4, 0, 255, 255, 255)
		AddParticlesScaleKeyFrame (11, 0.0, .01)
		AddParticlesScaleKeyFrame (11, lifeEnd#/8, 2)
		AddParticlesScaleKeyFrame (11, lifeEnd#, 14)
		//SetParticlesMax (12, 0)
		//SetParticlesMax (13, 0)
	
	endif
	
	PlaySoundR(specialS, 100)
	PlaySoundR(gongS, 40)
	PlaySoundR(launchS, 60)
	
	iEnd = 21/fpsr#
	for i = 1 to iEnd
		if appState = START then UpdateStartElements()
		SyncG()
	next i
	
	//#constant parStar1 11
//#constant parStar2 12
//#constant parStar3 13
	
endfunction

function TransitionEnd()
	for i = 11 to 13
		if GetParticlesExists(i) then SetParticlesMax(i, 1)
	next i
	
endfunction


function ShowLeaderBoard(num)
	
	if mPlatform = APPLE
		boardM$ = "scvs.mirrormode"
		boardC$ = "scvs.classic"
	elseif mPlatform = ANDROID
		boardM$ = ""
		boardC$ = ""
	endif
	
	board$ = ""
	if num = 1 then board$ = boardM$ 	//Mirror Mode
	if num = 2 then board$ = boardC$ 	//Classic
	
	/*
	Apple Codes
	Mirror: scvs.mirrormode
	Classic: scvs.classic
	
	Android Codes
	Mirror:
	Classic:	
	*/
	
	if GetGameCenterLoggedIn()
		
		GameCenterSubmitScore(spHighScore, "")
		GameCenterSubmitScore(0, "")
		
		GameCenterShowLeaderBoard(board$)
	else
		GameCenterLogin()
	endif
endfunction

/*
THE GRAVEYARD OF THE METEOR QUEUE

	meteorQueue1.insert(newMet)

	if meteorQueue1.length > 0
		
		meteorActive1.insert(meteorQueue1[1])
		
		meteorQueue1.remove(1)
		
	endif

*/
