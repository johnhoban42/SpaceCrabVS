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
SetWindowTitle( "Space Crab VS" )
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

global w = 800
global h = 1600

SetVirtualResolution(w, h) // doesn't have to match the window

global dispH = 0		//Variable for horizontal display
if deviceType = DESKTOP
	dispH = 1
	w = 1280
	h = 720
	gameScale# = .75
	//SetPhysicsDebugOn()
	SetWindowSize(w, h, 0)
endif
CreateSelectButtons()

SetAntialiasMode( 1 )

// set display properties
SetVirtualResolution(w, h)
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

global demo = 0

CreateTweenSprite(tweenSprFadeIn, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeIn, 0, 255, TweenEaseIn1())
CreateTweenSprite(tweenSprFadeOut, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeOut, 255, 140, TweenEaseIn1())
CreateTweenSprite(tweenSprFadeOutFull, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeOutFull, 255, 0, TweenEaseIn1())
CreateTweenText(tweenTxtFadeIn, tweenFadeLen#)
SetTweenTextAlpha(tweenTxtFadeIn, 0, 255, TweenEaseIn1())

//SetPhysicsDebugOn()

//RIP Sheep
//LoadSprite(split, "sheepstart2.png")
//SetSpriteSize(split, w*1.5, 80)
LoadSprite(split, "belt.png")
SetSpriteSize(split, w, 120)
if dispH then SetSpriteSize(split, h, 120)
SetSpriteColor(split, 200, 200, 200, 255)
SetSpriteMiddleScreenX(split)
SetSpriteMiddleScreenY(split)
if dispH then SetSpriteAngle(split, 90)
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
	DoInputs()
	if inputLeft or inputRight or inputUp or inputDown then MoveSelect()
	
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
	
    //Print(ScreenFPS())
    //Print(fpsr#)
    Print(GetRawLastKey())
    //Print(meteorTotal1)
    //Print(specialTimerAgainst2#)
    
		//Print(GetDeviceBaseName())
	//Print(GetImageMemoryUsage())
	
	//Print(GetPointerX())
    SyncG()
loop

function DoInputs()
	inputSelect = 0
	inputExit = 0
	inputLeft = 0
	inputRight = 0
	inputUp = 0
	inputDown = 0
	inputAttack1 = 0
	inputSpecial1 = 0
	
	if GetRawKeyPressed(13) or GetRawKeyPressed(32) or GetRawKeyPressed(90) then inputSelect = 1
	if GetRawKeyPressed(27) or GetRawKeyPressed(8) or GetRawKeyPressed(46) then inputExit = 1
	if GetRawKeyPressed(37) or GetRawKeyPressed(65) then inputLeft = 1
	if GetRawKeyPressed(39) or GetRawKeyPressed(68) then inputRight = 1
	if GetRawKeyPressed(38) or GetRawKeyPressed(87) then inputUp = 1
	if GetRawKeyPressed(40) or GetRawKeyPressed(83) then inputDown = 1
	if GetRawKeyPressed(90) then inputAttack1 = 1
	if GetRawKeyPressed(88) then inputSpecial1 = 1
	
	if GetRawJoystickConnected(1)
		//for i = 1 to 64
			//For testing controller inputs
		//	if GetRawJoystickButtonState(1, i) then Print(i)
		//next i
		if GetRawJoystickButtonPressed(1, 1) or GetRawJoystickButtonPressed(1, 4) then inputSelect = 1
		if GetRawJoystickButtonPressed(1, 7) or GetRawJoystickButtonPressed(1, 8) then inputExit = 1
		if GetRawJoystickButtonPressed(1, 3) or GetRawJoystickButtonPressed(1, 5) then inputAttack1 = 1
		if GetRawJoystickButtonPressed(1, 2) or GetRawJoystickButtonPressed(1, 6) then inputSpecia1 = 1
		if GetRawJoystickButtonPressed(1, 13) then inputLeft = 1
		if GetRawJoystickButtonPressed(1, 15) then inputRight = 1
		if GetRawJoystickButtonPressed(1, 14) then inputUp = 1
		if GetRawJoystickButtonPressed(1, 16) then inputDown = 1
	endif
	
endfunction

function TransitionStart(tranType)
	
	TurnOffSelect()
	
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
		boardM$ = "grp.scvs.mirrormode"
		boardC$ = "grp.scvs.classic"
	elseif mPlatform = ANDROID
		boardM$ = "CgkI3pbJ898dEAIQAQ"
		boardC$ = "CgkI3pbJ898dEAIQAg"
	endif
	
	board$ = ""
	if num = 1 then board$ = boardM$ 	//Mirror Mode
	if num = 2 then board$ = boardC$ 	//Classic
	
	/*
	Apple Codes
	Mirror: grp.scvs.mirrormode
	Classic: grp.scvs.classic
	
	Android Codes
	Mirror: CgkI3pbJ898dEAIQAQ
	Classic: CgkI3pbJ898dEAIQAg
	*/
	
	if GetGameCenterLoggedIn()
		
		GameCenterSubmitScore(spHighScore, boardM$)
		GameCenterSubmitScore(spHighScoreClassic, boardC$)
		
		GameCenterShowLeaderBoard(board$)
	else
		GameCenterLogin()
	endif
endfunction

global selectTarget = 0
global selectActive = 0
#constant LEFTS 1
#constant RIGHTS 2
#constant UPS 3
#constant DOWNS 4

function CreateSelectButtons()
	SetFolder("/media/ui")
	img = LoadImage("select.png")
	for i = 1 to 4
		spr = SPR_SELECT1-1+i
		CreateSpriteExpressImage(spr, img, 40, 40, -99, -99, 1) 
		CreateTweenSprite(spr, .16)
		SetSpriteAngle(spr, 90 * (i-1))
	next i
	
endfunction

function MoveSelect()
	if selectTarget = 0
		//If you're pressing the arrow key for the first time
		if appState = START
			selectTarget = SPR_STORY_START
		elseif appState = CHARACTER_SELECT
			selectTarget = SPR_CS_READY_1
		elseif appState = GAME and paused = 1
			selectTarget = playButton
		elseif appState = STORY
			selectTarget = playButton
			if GetSpriteColorAlpha(playButton) = 0 then selectTarget = exitButton
		endif
		if selectTarget <> 0
			sel = selectTarget
			SetTweenSpriteX(SPR_SELECT1, GetSpriteMiddleX(sel), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT1, GetSpriteMiddleY(sel), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT2, GetSpriteMiddleX(sel), GetSpriteX(sel)+GetSpriteWidth(sel)-GetSpriteWidth(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT2, GetSpriteMiddleY(sel), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT3, GetSpriteMiddleX(sel), GetSpriteX(sel)+GetSpriteWidth(sel)-GetSpriteWidth(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT3, GetSpriteMiddleY(sel), GetSpriteY(sel)+GetSpriteHeight(sel)-GetSpriteHeight(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT4, GetSpriteMiddleX(sel), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT1)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT4, GetSpriteMiddleY(sel), GetSpriteY(sel)+GetSpriteHeight(sel)-GetSpriteHeight(SPR_SELECT1)/2, TweenOvershoot())
			//TODO Sound effect
			for i = SPR_SELECT1 to SPR_SELECT4
				PlayTweenSprite(i, i, 0)
				PlayTweenSprite(tweenSprFadeIn, i, 0)
			next i
		endif
	else
		
		newT = selectTarget
		for j = 1 to 2
			for i = 0 to buttons.length
				if GetSpriteExists(buttons[i])
					
					spr = buttons[i]
					if GetSpriteVisible(spr) and GetSpriteColorAlpha(spr) <> 0 and spr <> selectTarget and GetSpriteX(spr) > 0 and GetSpriteX(spr) < w and GetSpriteY(spr) > 0 and GetSpriteY(spr) < h and spr <> SPR_TITLE
						rightT = inputRight and GetSpriteX(spr) > GetSpriteX(selectTarget) and (GetSpriteX(spr) < GetSpriteX(newT) or newT = selectTarget)
						leftT = inputLeft and GetSpriteX(spr) < GetSpriteX(selectTarget) and (GetSpriteX(spr) > GetSpriteX(newT) or newT = selectTarget)
						upT = inputUp and GetSpriteY(spr) < GetSpriteY(selectTarget) and (GetSpriteY(spr) > GetSpriteY(newT) or newT = selectTarget)
						downT = inputDown and GetSpriteY(spr) > GetSpriteY(selectTarget) and (GetSpriteY(spr) < GetSpriteY(newT) or newT = selectTarget)
						
						if newT <> selectTarget
							if GetSpriteDistance(spr, selectTarget) > GetSpriteDistance(newT, selectTarget)
								rightT = 0
								leftT = 0
								upT = 0
								downT = 0
							endif
							if Abs(GetSpriteMiddleX(spr) - GetSpriteMiddleX(selectTarget)) < Abs(GetSpriteMiddleY(spr) - GetSpriteMiddleY(selectTarget))
								rightT = 0
								leftT = 0
							else
								upT = 0
								downT = 0
							endif
						endif
						
						if rightT or leftT or upT or downT then newT = spr
					endif
				endif
			next i
		next j
		
		if newT <> selectTarget
			selectTarget = newT
			sel = selectTarget
			twn = TweenEaseOut1()
			SetTweenSpriteX(SPR_SELECT1, GetSpriteX(SPR_SELECT1), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT1)/2, twn)
			SetTweenSpriteY(SPR_SELECT1, GetSpriteY(SPR_SELECT1), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT1)/2, twn)
			SetTweenSpriteX(SPR_SELECT2, GetSpriteX(SPR_SELECT2), GetSpriteX(sel)+GetSpriteWidth(sel) - GetSpriteWidth(SPR_SELECT1)/2, twn)
			SetTweenSpriteY(SPR_SELECT2, GetSpriteY(SPR_SELECT2), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT1)/2, twn)
			SetTweenSpriteX(SPR_SELECT3, GetSpriteX(SPR_SELECT3), GetSpriteX(sel)+GetSpriteWidth(sel) - GetSpriteWidth(SPR_SELECT1)/2, twn)
			SetTweenSpriteY(SPR_SELECT3, GetSpriteY(SPR_SELECT3), GetSpriteY(sel)+GetSpriteHeight(sel) - GetSpriteHeight(SPR_SELECT1)/2, twn)
			SetTweenSpriteX(SPR_SELECT4, GetSpriteX(SPR_SELECT4), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT1)/2, twn)
			SetTweenSpriteY(SPR_SELECT4, GetSpriteY(SPR_SELECT4), GetSpriteY(sel)+GetSpriteHeight(sel) - GetSpriteHeight(SPR_SELECT1)/2, twn)
			
			for i = SPR_SELECT1 to SPR_SELECT4
				PlayTweenSprite(i, i, 0)
			next i
		
			//TODO Sound effect
		endif
		
	endif
	
endfunction

function TurnOffSelect()
	selectTarget = 0
	UpdateAllTweens(.4)
	for i = SPR_SELECT1 to SPR_SELECT4
		SetSpriteColorAlpha(i, 0)
	next i
endfunction

/*
THE GRAVEYARD OF THE METEOR QUEUE

	meteorQueue1.insert(newMet)

	if meteorQueue1.length > 0
		
		meteorActive1.insert(meteorQueue1[1])
		
		meteorQueue1.remove(1)
		
	endif

*/
