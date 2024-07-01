#include "myLib.agc"
#include "constants.agc"
#include "gameState.agc"
#include "start.agc"
#include "characterSelect.agc"
#include "results.agc"
#include "ai.agc"
#include "story.agc"
#include "soundtest.agc"
#include "statistics.agc"
#include "settings.agc"
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

global demo = 0
global debug = 1
global onWeb = 0

if debug = 0
	if GetGameCenterExists() = 1 // This checks to see if Game Center/Game Services exist on the device
		GameCenterSetup()
	endif
	GameCenterLogin()
endif

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
if deviceType = 5//DESKTOP
	dispH = 1
	w = 1280
	h = 720
	gameScale# = regDScale
	//SetPhysicsDebugOn()
	SetWindowSize(w, h, 0)
endif
CreateSelectButtons()


SetAntialiasMode(1)

// set display properties
SetVirtualResolution(w, h)
SetOrientationAllowed(1, 0, 0, 0) // allow both portrait and landscape on mobile devices
SetSyncRate( 120, 0 ) // 30fps instead of 60 to save battery	//LOL
SetScissor(0, 0, 0, 0) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetVSync(1)



if demo then SetWindowTitle("Space Crab VS Demo")

if deviceType = MOBILE then SetScissor(0, 0, w, h)
if deviceType = DESKTOP and debug = 0 then SetScissor(0, 0, w, h)
SetImmersiveMode(1)

LoadBaseImages()
LoadBaseSounds()
//LoadBaseMusic()
SetFolder("/media")

global fpsr#

global gameTime#





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
SetSpriteVisible(split, 0)

global appState = START

gameTime# = 0

#constant tweenFadeLen# .2
#constant tweenSprFadeIn 101
#constant tweenSprFadeOut 102
#constant tweenSprFadeOutFull 105
#constant tweenTxtFadeIn 103
#constant tweenTxtFadeOut 104
CreateTweenSprite(tweenSprFadeIn, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeIn, 0, 255, TweenEaseIn1())
CreateTweenSprite(tweenSprFadeOut, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeOut, 255, 140, TweenEaseIn1())
CreateTweenSprite(tweenSprFadeOutFull, tweenFadeLen#)
SetTweenSpriteAlpha(tweenSprFadeOutFull, 255, 0, TweenEaseIn1())
CreateTweenText(tweenTxtFadeIn, tweenFadeLen#)
SetTweenTextAlpha(tweenTxtFadeIn, 0, 255, TweenEaseIn1())
CreateTweenText(tweenTxtFadeOut, tweenFadeLen#)
SetTweenTextAlpha(tweenTxtFadeOut, 255, 0, TweenEaseIn1())

//volumeM = 0
//SetMusicSystemVolumeOGG(volumeM)

function SaveGame()
	SetFolder("/media")
	OpenToWrite(3, "save.txt")
	
	WriteInteger(3, spHighScore)
	WriteString(3, spHighCrab$)
	WriteInteger(3, spHighScoreClassic)
	WriteString(3, spHighCrabClassic$)
	WriteInteger(3, curChapter)
	WriteInteger(3, highestScene)
	WriteInteger(3, clearedChapter)
	for i = 1 to 6
		WriteInteger(3, altUnlocked[i])
	next i
	WriteInteger(3, firstStartup)
	WriteInteger(3, speedUnlock)
	WriteInteger(3, hardBattleUnlock)
	WriteInteger(3, musicBattleUnlock)
	WriteInteger(3, unlockAIHard)
	WriteInteger(3, musicUnlocked)
	WriteInteger(3, volumeM)
	WriteInteger(3, volumeSE)
	WriteInteger(3, targetFPS)
	WriteInteger(3, windowSize)
	WriteInteger(3, evilUnlock)
	WriteInteger(3, storyEasy)
	
	CloseFile(3)
endfunction

function LoadGame()
	SetFolder("/media")
	if GetFileExists("save.txt") = 0 then SaveGame()
	OpenToRead(3, "save.txt")
	
	spHighScore = ReadInteger(3)
	spHighCrab$ = ReadString(3)
	spHighScoreClassic = ReadInteger(3)
	spHighCrabClassic$ = ReadString(3)
	curChapter = ReadInteger(3)
	highestScene = ReadInteger(3)
	clearedChapter = ReadInteger(3)
	for i = 1 to 6
		altUnlocked[i] = ReadInteger(3)
	next i
	firstStartup = ReadInteger(3)
	speedUnlock = ReadInteger(3)
	hardBattleUnlock = ReadInteger(3)
	musicBattleUnlock = ReadInteger(3)
	unlockAIHard = ReadInteger(3)
	musicUnlocked = ReadInteger(3)
	volumeM = ReadInteger(3)
	volumeSE = ReadInteger(3)
	targetFPS = ReadInteger(3)
	windowSize = ReadInteger(3)
	evilUnlock = ReadInteger(3)
	storyEasy = ReadInteger(3)
	CloseFile(3)
endfunction


//clearedChapter = 0

if debug
	curChapter = 2
	curScene = 3
	highestScene = 100
	appState = START
	crab1Type = 6
	crab1Alt = 3
	
	spType = AIBATTLE
	altUnlocked[1] = 2
	altUnlocked[2] = 2
	altUnlocked[3] = 2
	altUnlocked[4] = 0
	altUnlocked[5] = 2
	altUnlocked[6] = 0
	firstStartup = 0
	speedUnlock = 1
	hardBattleUnlock = 1
	musicBattleUnlock = 1
	unlockAIHard = 1
	musicUnlocked = 7
	evilUnlock = 1
else
	LoadGame()
	//altUnlocked[1] = 2
	//altUnlocked[2] = 2
	//altUnlocked[3] = 1
	//altUnlocked[4] = 0
	//altUnlocked[5] = 1
	//altUnlocked[6] = 0
	if highestScene <= 0 then highestScene = 1
	if firstStartup = 0
		//This is initial variable setting
		volumeM = 100
		volumeSE = 100
		targetFPS = 5
		windowSize = 1
		musicUnlocked = 7
	endif
	//if altUnlocked[1] = 3 or altUnlocked[2] = 3 or altUnlocked[3] = 3 or altUnlocked[4] = 3 or altUnlocked[5] = 3 or altUnlocked[6] = 3 then LoadSelectCrabImages()
	LoadSelectCrabImages()
	targetFPS = Min(5, targetFPS)
	targetFPS = Max(1, targetFPS)
	windowSize = Min(3, windowSize)
	windowSize = Max(1, windowSize)
	if targetFPS <> 5
		SetVSync(0)
		SetSyncRate(fpsChunk[targetFPS], 0)
	endif
	if dispH then SetWindowChunkSize(windowSize)
endif

curChapter = Max(curChapter, 1)
curChapter = Min(curChapter, finalChapter)
clearedChapter = (highestScene-1)/4

do
	fpsr# = 60.0/ScreenFPS()
	
	if gameTime# > 10000000 then gameTime# = 0
	if gameTimer# > 1000000000 then gameTimer# = 0
	inc gameTime#, fpsr#
	
	ProcessMultitouch()
	DoInputs()
	ProcessPopup()
	
	
	if inputLeft or inputRight or inputUp or inputDown then MoveSelect()
	if (inputLeft2 or inputRight2 or inputUp2 or inputDown2) and appState = CHARACTER_SELECT
	//if GetRawJoystickConnected(2) and (inputLeft2 or inputRight2 or inputUp2 or inputDown2)	//Old way, controller only
		if GetSpriteExists(SPR_SELECT5) = 0 then CreateSelectButtons2()
		MoveSelect2()
	endif
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
	elseif appState = SOUNDTEST
		appState = DoSoundTest()
	elseif appState = STATISTICS
		appState = DoStatistics()
	endif
	
	touch = GetRawFirstTouchEvent(1)
	while touch <> 0
		//Print(touch)
		touch = GetRawNextTouchEvent()
	endwhile
	
	
	if debug
	    Print(ScreenFPS())
	    //Print(fpsr#)
	    Print(GetRawLastKey())
	    //Print(meteorTotal1)
	    //Print(specialTimerAgainst2#)
	    
		//Print(GetDeviceBaseName())
		
		Print(GetImageMemoryUsage())
		
		//Print(GetPointerX())
		//Print(GetPointerY())
		
		//Print(highestScene)
	endif
    SyncG()
loop

function DoInputs()
	inputSelect = 0
	inputExit = 0
	inputSkip = 0
	inputLeft = 0
	inputRight = 0
	inputUp = 0
	inputDown = 0
	inputTurn1 = 0
	inputAttack1 = 0
	inputSpecial1 = 0
	

	
	if (GetRawKeyPressed(13) and GetSpriteExists(SPR_SELECT5)=0) or GetRawKeyPressed(32) or GetRawKeyPressed(90) then inputSelect = 1
	if GetRawKeyPressed(27) or GetRawKeyPressed(8) or GetRawKeyPressed(46) then inputExit = 1
	if GetRawKeyState(17) then inputSkip = 1
	if GetRawKeyPressed(37) or GetRawKeyPressed(65) then inputLeft = 1
	if GetRawKeyPressed(39) or GetRawKeyPressed(68) then inputRight = 1
	if GetRawKeyPressed(38) or GetRawKeyPressed(87) then inputUp = 1
	if GetRawKeyPressed(40) or GetRawKeyPressed(83) then inputDown = 1
	if GetRawKeyPressed(32) then inputTurn1 = 1
	if GetRawKeyPressed(90) then inputAttack1 = 1
	if GetRawKeyPressed(88) then inputSpecial1 = 1
	if GetRawKeyPressed(13) then inputTurn2 = 1
	
	if GetRawJoystickConnected(1)
		for i = 1 to 64
			//For testing controller inputs
			if GetRawJoystickButtonState(1, i) and debug then Print(i)
		next i
		if GetRawJoystickButtonPressed(1, 1) or GetRawJoystickButtonPressed(1, 4) then inputSelect = 1
		if GetRawJoystickButtonPressed(1, 7) or GetRawJoystickButtonPressed(1, 8) then inputExit = 1
		if GetRawJoystickButtonPressed(1, 3) or GetRawJoystickButtonPressed(1, 5) then inputAttack1 = 1
		if GetRawJoystickButtonPressed(1, 2) or GetRawJoystickButtonPressed(1, 6) then inputSpecial1 = 1
		if GetRawJoystickButtonPressed(1, 1) or GetRawJoystickButtonPressed(1, 4) then inputTurn1 = 1
		if GetRawJoystickButtonPressed(1, 13) then inputLeft = 1
		if GetRawJoystickButtonPressed(1, 15) then inputRight = 1
		if GetRawJoystickButtonPressed(1, 14) then inputUp = 1
		if GetRawJoystickButtonPressed(1, 16) then inputDown = 1
		if GetRawJoystickButtonState(1, 5) or GetRawJoystickButtonState(1, 6) then inputSkip = 1
	endif
	
	
	inputSelect2 = 0
	inputExit2 = 0
	inputSkip2 = 0
	inputLeft2 = 0
	inputRight2 = 0
	inputUp2 = 0
	inputDown2 = 0
	inputTurn2 = 0
	inputAttack2 = 0
	inputSpecial2 = 0
	//Print(GetRawJoystickExists(1))
	//Print(GetRawJoystickExists(2))
	//Print(GetRawJoystickConnected(2))
	if GetRawKeyPressed(13) and GetSpriteExists(SPR_SELECT5) then inputSelect2 = 1
	if GetRawKeyPressed(74) then inputLeft2 = 1
	if GetRawKeyPressed(76) then inputRight2 = 1
	if GetRawKeyPressed(73) then inputUp2 = 1
	if GetRawKeyPressed(75) then inputDown2 = 1
	if GetRawKeyPressed(13) then inputTurn2 = 1
	if GetRawKeyPressed(78) then inputAttack2 = 1
	if GetRawKeyPressed(77) then inputSpecial2 = 1
	if GetRawJoystickConnected(2)
		//for i = 1 to 64
		//For testing controller inputs
			//if GetRawJoystickButtonState(2, i) then Print(i)
		//next i
		if GetRawJoystickButtonPressed(2, 1) or GetRawJoystickButtonPressed(2, 4) then inputSelect2 = 1
		if GetRawJoystickButtonPressed(2, 7) or GetRawJoystickButtonPressed(2, 8) then inputExit2 = 1
		if GetRawJoystickButtonPressed(2, 3) or GetRawJoystickButtonPressed(2, 5) then inputAttack2 = 1
		if GetRawJoystickButtonPressed(2, 2) or GetRawJoystickButtonPressed(2, 6) then inputSpecial2 = 1
		if GetRawJoystickButtonPressed(2, 1) or GetRawJoystickButtonPressed(2, 4) then inputTurn2 = 1
		if GetRawJoystickButtonPressed(2, 13) then inputLeft2 = 1
		if GetRawJoystickButtonPressed(2, 15) then inputRight2 = 1
		if GetRawJoystickButtonPressed(2, 14) then inputUp2 = 1
		if GetRawJoystickButtonPressed(2, 16) then inputDown2 = 1
	endif
	
endfunction

function TransitionStart(tranType)
	
	TurnOffSelect()
	TurnOffSelect2()
	if GetSpriteExists(SPR_POPUP_BG) then DeletePopup1()
	if GetSpriteExists(SPR_POPUP_BG_2) then DeletePopup2()
	
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
			SetParticlesDirection(i, 50 + dispH*20, 0)
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


function GetHighAlt()
	highAlt = 0
	for i = 1 to 6
		if altUnlocked[i] > highAlt then highAlt = altUnlocked[i]
	next i
endfunction highAlt

global selectTarget = 0
global selectTarget2 = 0
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
		SetSpriteColor(spr, 255, 255, 255, 255)
	next i
	if GetRawJoystickConnected(2)
		for i = 1 to 4
		spr = SPR_SELECT1-1+i
		if GetSpriteExists(spr) then SetSpriteColor(spr, 200, 230, 255, 255)
	next i
	endif
endfunction


function MoveSelect()
	
	for i = SPR_SELECT1 to SPR_SELECT4
		SetSpriteSize(i, 40, 40)
		//SetSpriteDepth(i, 1)
		ClearTweenSprite(i)
	next i
	
	if selectTarget = 0
		//If you're pressing the arrow key for the first time
		if settingsActive
			selectTarget = SPR_VOLUME
		elseif appState = START
			selectTarget = SPR_START1//SPR_STORY_START
		elseif appState = CHARACTER_SELECT
			selectTarget = SPR_CS_READY_1
			if GetSpriteVisible(SPR_CS_READY_1) = 0
				if spType = STORYMODE then selectTarget = SPR_SCENE1
				if spType <> STORYMODE then selectTarget = SPR_CS_CRABS_1 + 1
			endif
		elseif appState = GAME and paused = 1
			selectTarget = playButton
		elseif appState = STORY
			selectTarget = playButton
			if GetSpriteColorAlpha(playButton) = 0 then selectTarget = exitButton
		elseif appState = RESULTS
			selectTarget = SPR_R_REMATCH
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
		
		minDis = 9999
		newT = selectTarget
		for i = 0 to buttons.length
			if GetSpriteExists(buttons[i])
				
				spr = buttons[i]
				if GetSpriteVisible(spr) and GetSpriteColorAlpha(spr) <> 0 and spr <> selectTarget and GetSpriteX(spr) > 0 and GetSpriteX(spr) < w and GetSpriteY(spr) > 0 and GetSpriteY(spr) < h and spr <> SPR_TITLE
					
					xDis = GetSpriteMiddleX(spr)-GetSpriteMiddleX(selectTarget)
					yDis = GetSpriteMiddleY(spr)-GetSpriteMiddleY(selectTarget)
					
					rightT = inputRight and xDis > 0 and Abs(xDis) > Abs(yDis)
					leftT = inputLeft and xDis < 0 and Abs(xDis) > Abs(yDis)
					upT = inputUp and yDis < 0 and Abs(xDis) < Abs(yDis)
					downT = inputDown and yDis > 0 and Abs(xDis) < Abs(yDis)
					
					if (appState = CHARACTER_SELECT) and GetSpriteMiddleX(spr) > w/2+20 and spType = 0
						rightT = 0
						leftT = 0
						upT = 0
						downT = 0
					endif
					
					if (appState = CHARACTER_SELECT) and spType = STORYMODE and (spr >= SPR_CS_CRABS_1 and spr <= SPR_CS_CRABS_1+25)
						rightT = 0
						leftT = 0
						upT = 0
						downT = 0
					endif
					
					if (settingsActive = 1) and GetSpriteDepth(spr) <> 1
						rightT = 0
						leftT = 0
						upT = 0
						downT = 0
					endif
					
					if rightT or leftT or upT or downT
						newDis = Abs(Sqrt(Pow(xDis, 2)) + Sqrt(Pow(yDis, 2)))
						if newDis < minDis
							minDis = newDis
							newT = spr
						endif
					endif

				endif
			endif
		next i
		
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
			
			UpdateSelectTweens1(.4)
			for i = SPR_SELECT1 to SPR_SELECT4
				PlayTweenSprite(i, i, 0)
			next i
		
			//TODO Sound effect
		endif
		
	endif
	
endfunction

function TurnOffSelect()
	if selectTarget <> 0
		selectTarget = 0
		UpdateSelectTweens1(.2)
		for i = SPR_SELECT1 to SPR_SELECT4
			SetSpriteColorAlpha(i, 0)
		next i
	endif
endfunction

function UpdateSelectTweens1(t#)
	for i = SPR_SELECT1 to SPR_SELECT4
		UpdateTweenSprite(i, i, t#)
	next i
endfunction

function CreateSelectButtons2()
	SetFolder("/media/ui")
	img = LoadImage("select.png")
	for i = 1 to 4
		spr = SPR_SELECT5-1+i
		CreateSpriteExpressImage(spr, img, 40, 40, -99, -99, 1) 
		CreateTweenSprite(spr, .16)
		SetSpriteAngle(spr, 90 * (i-1))
		SetSpriteColor(spr, 255, 180, 195, 255)
	next i
	
	//Setting the other select buttons to a different color
	for i = 1 to 4
		spr = SPR_SELECT1-1+i
		if GetSpriteExists(spr) then SetSpriteColor(spr, 170, 200, 255, 255)
	next i
	
endfunction

function MoveSelect2()
	
	for i = SPR_SELECT5 to SPR_SELECT8
		SetSpriteSize(i, 40, 40)
		ClearTweenSprite(i)
	next i
	
	if selectTarget2 = 0

		//If you're pressing the arrow key for the first time
		if appState = START
			selectTarget2 = SPR_START1//SPR_STORY_START
			//selectTarget2 = SPR_START2
		elseif appState = CHARACTER_SELECT and spType = 0
			selectTarget2 = SPR_CS_READY_2
			if GetSpriteVisible(SPR_CS_READY_2) = 0
				//if spType = STORYMODE then selectTarget = SPR_SCENE1
				if spType <> STORYMODE then selectTarget2 = SPR_CS_CRABS_2 + 1
			endif
		elseif appState = GAME and paused = 1
			selectTarget2 = playButton
		elseif appState = RESULTS
			selectTarget2 = SPR_R_REMATCH
		endif
		if selectTarget2 <> 0
			sel = selectTarget2
			SetTweenSpriteX(SPR_SELECT5, GetSpriteMiddleX(sel), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT5, GetSpriteMiddleY(sel), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT6, GetSpriteMiddleX(sel), GetSpriteX(sel)+GetSpriteWidth(sel)-GetSpriteWidth(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT6, GetSpriteMiddleY(sel), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT7, GetSpriteMiddleX(sel), GetSpriteX(sel)+GetSpriteWidth(sel)-GetSpriteWidth(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT7, GetSpriteMiddleY(sel), GetSpriteY(sel)+GetSpriteHeight(sel)-GetSpriteHeight(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteX(SPR_SELECT8, GetSpriteMiddleX(sel), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT5)/2, TweenOvershoot())
			SetTweenSpriteY(SPR_SELECT8, GetSpriteMiddleY(sel), GetSpriteY(sel)+GetSpriteHeight(sel)-GetSpriteHeight(SPR_SELECT5)/2, TweenOvershoot())
			//TODO Sound effect
			for i = SPR_SELECT5 to SPR_SELECT8
				PlayTweenSprite(i, i, 0)
				PlayTweenSprite(tweenSprFadeIn, i, 0)
			next i
		endif
	else
		
		newT = selectTarget2
		minDis = 9999
		for i = 0 to buttons.length
			if GetSpriteExists(buttons[i])
				
				spr = buttons[i]
				if GetSpriteVisible(spr) and GetSpriteColorAlpha(spr) <> 0 and spr <> selectTarget2 and GetSpriteX(spr) > 0 and GetSpriteX(spr) < w and GetSpriteY(spr) > 0 and GetSpriteY(spr) < h and spr <> SPR_TITLE
					
					xDis = GetSpriteMiddleX(spr)-GetSpriteMiddleX(selectTarget2)
					yDis = GetSpriteMiddleY(spr)-GetSpriteMiddleY(selectTarget2)
					
					rightT = inputRight2 and xDis > 0 and Abs(xDis) > Abs(yDis)
					leftT = inputLeft2 and xDis < 0 and Abs(xDis) > Abs(yDis)
					upT = inputUp2 and yDis < 0 and Abs(xDis) < Abs(yDis)
					downT = inputDown2 and yDis > 0 and Abs(xDis) < Abs(yDis)
					
					if (appState = CHARACTER_SELECT) and GetSpriteMiddleX(spr) < w/2-20 and spType = 0
						rightT = 0
						leftT = 0
						upT = 0
						downT = 0
					endif
					
					if (settingsActive = 1) and GetSpriteDepth(spr) <> 1
						rightT = 0
						leftT = 0
						upT = 0
						downT = 0
					endif
					
					if rightT or leftT or upT or downT
						newDis = Abs(Sqrt(Pow(xDis, 2)) + Sqrt(Pow(yDis, 2)))
						if newDis < minDis
							minDis = newDis
							newT = spr
						endif
					endif
				endif
			endif
		next i
		
		if newT <> selectTarget2
			selectTarget2 = newT
			sel = selectTarget2
			twn = TweenEaseOut1()
			SetTweenSpriteX(SPR_SELECT5, GetSpriteX(SPR_SELECT5), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT5)/2, twn)
			SetTweenSpriteY(SPR_SELECT5, GetSpriteY(SPR_SELECT5), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT5)/2, twn)
			SetTweenSpriteX(SPR_SELECT6, GetSpriteX(SPR_SELECT6), GetSpriteX(sel)+GetSpriteWidth(sel) - GetSpriteWidth(SPR_SELECT5)/2, twn)
			SetTweenSpriteY(SPR_SELECT6, GetSpriteY(SPR_SELECT6), GetSpriteY(sel)-GetSpriteHeight(SPR_SELECT5)/2, twn)
			SetTweenSpriteX(SPR_SELECT7, GetSpriteX(SPR_SELECT7), GetSpriteX(sel)+GetSpriteWidth(sel) - GetSpriteWidth(SPR_SELECT5)/2, twn)
			SetTweenSpriteY(SPR_SELECT7, GetSpriteY(SPR_SELECT7), GetSpriteY(sel)+GetSpriteHeight(sel) - GetSpriteHeight(SPR_SELECT5)/2, twn)
			SetTweenSpriteX(SPR_SELECT8, GetSpriteX(SPR_SELECT8), GetSpriteX(sel)-GetSpriteWidth(SPR_SELECT5)/2, twn)
			SetTweenSpriteY(SPR_SELECT8, GetSpriteY(SPR_SELECT8), GetSpriteY(sel)+GetSpriteHeight(sel) - GetSpriteHeight(SPR_SELECT5)/2, twn)
			
			UpdateSelectTweens2(.4)
			for i = SPR_SELECT5 to SPR_SELECT8
				PlayTweenSprite(i, i, 0)
			next i
		
			//TODO Sound effect
		endif
		
	endif
	
endfunction

function TurnOffSelect2()
	if selectTarget2 <> 0
		selectTarget2 = 0
		UpdateSelectTweens2(.2)
		for i = SPR_SELECT5 to SPR_SELECT8
			if GetSpriteExists(i) then SetSpriteColorAlpha(i, 0)
		next i
	endif
endfunction

function UpdateSelectTweens2(t#)
	for i = SPR_SELECT5 to SPR_SELECT8
		UpdateTweenSprite(i, i, t#)
	next i
endfunction

function UnlockCrab(cType, cAlt, animation)
	if animation
		//Popup for crab
		Popup(MIDDLE, cAlt*6 + cType)
	endif
	altUnlocked[cType] = Max(altUnlocked[cType], cAlt)
endfunction

function UnlockSong(sID, animation)
	if musicUnlocked < sID
		if animation
			//Popup for crab
			Popup(MIDDLE, sID+30)
		endif
		musicUnlocked = sID
	endif
endfunction

#constant G1 1
#constant G2 2
#constant MIDDLE 3
function Popup(area, unlockNum)
	
	if GetSpriteExists(SPR_POPUP_BG) and area <> G2 then DeletePopup1()
	if GetSpriteExists(SPR_POPUP_BG_2) and area = G2 then DeletePopup2()
	
//#constant SPR_POPUP_BG 761
//#constant SPR_POPUP_C 762
//#constant TXT_POPUP 763

//#constant SPR_POPUP_BG_2 766
//#constant SPR_POPUP_C_2 767
//#constant TXT_POPUP_2 768
	
	if area <> G2 and unlockNum > 0 then PlayMusicOGGSP(unlockMusic, 0)
	
	//Case that it's in the middle area
	//Ratio is 5 wide, 6 tall
	wid = w*5/8
	if dispH then wid = h*5/8
	hei = w*6/8
	if dispH then hei = h*6/8
	
	x = w/2
	y = h/2
	
	if area = G1
		if dispH then x = w/4
		if dispH = 0 then y = h*3/4
	elseif area = G2
		if dispH then x = w*3/4
		if dispH = 0 then y = h/4
	endif
	
	spr = SPR_POPUP_BG
	if area = G2 then spr = SPR_POPUP_BG_2
	
	SetFolder("/media")
	
	//Creating the background of the popup
	CreateSpriteExpress(spr, wid, hei, x-wid/2, y-hei/2, 1)
	SetSpriteColor(spr, 100, 100, 100, 255)
	
	//Creating the centered sprite of the popup
	chibiSize = wid-40
	CreateSpriteExpress(spr+1, chibiSize, chibiSize, GetSpriteMiddleX(spr)-chibiSize/2, GetSpriteMiddleY(spr)-chibiSize/2, 1)
	SetSpriteColor(spr, 100, 100, 100, 255)
				
	//Setting the focus/contents of the popup
	if unlockNum = 0
		//Locked crab
		img = LoadImage("art/mystery.png")
		SetSpriteImage(spr+1, img)
		trashBag.insert(img)
		PlaySoundR(fruitS, 100)
	elseif unlockNum = -1
		//Controls
		//P1: Keyboard, Controller, Touchscreen
		//P2: Keyboard, Controller, Touchscreen
	elseif unlockNum = -2
		//Autosave message, very beginning of game
	elseif unlockNum <= 24
		//Newly unlocked crab
		crab2Type = Mod(unlockNum-1, 6)+1
		crab2Alt = (unlockNum-1)/6
		SetCrabString(2)
		img = LoadImageR("art/chibicrab" + str(crab2Type) + AltStr(crab2Alt) + ".png")
		SetSpriteImage(spr+1, img)
		trashBag.insert(img)
	elseif unlockNum > 30
		//Newly unlocked song, they are 30+
		sID = unlockNum-30
		img = LoadImageR("musicBanners/banner" + str(sID) + ".png")
		SetSpriteImage(spr+1, img)
		SetSpriteExpress(spr+1, chibiSize, chibiSize*228/772, GetSpriteMiddleX(spr)-chibiSize/2, GetSpriteMiddleY(spr)-(chibiSize*228/772)/2, 1)
		trashBag.insert(img)
	else
		//The 5 other unlocks
		img = 0
		if unlockNum = 25 then img = LoadImageR("art/crab5brWin.png")
		if unlockNum = 26 then img = LoadImageR("ui/hardSquare.png")
		if unlockNum = 27 then img = LoadImageR("ui/speedSquare.png")
		if unlockNum = 28 then img = LoadImageR("ui/evil1Square.png")
		if unlockNum = 29 then img = LoadImageR("ui/vsAISquare.png")
		if unlockNum = 30 then img = LoadImageR("art/crab1crWin.png")
		SetSpriteImage(spr+1, img)
		trashBag.insert(img)
	endif
	
	//Creating the text message of the popup
	CreateTextExpress(spr+2, "", 60, fontScoreI, 1, GetSpriteMiddleX(spr), GetSpriteY(spr) + 10, 1)
	SetTextString(spr+2, "You unlocked" + chr(10) + crab2Str$ + "!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "Now playable" + chr(10) + "in all modes!")
	if unlockNum = 0 then SetTextString(spr+2, "That crab is" + chr(10) + "locked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "Find them in" + chr(10) + "Story Mode!")
	spacing = -11
	SetTextSpacing(spr+2, spacing)
	SetTextLineSpacing(spr+2, 5-(dispH-1)*6)
	
	if unlockNum = -1 then SetTextString(spr+2, "")
	if unlockNum = -2 then SetTextString(spr+2, "Space Crab VS" + chr(10) + "uses autosaves." + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "Progress is saved" + chr(10) + "when exiting game.")
	if unlockNum = 38 then SetTextString(spr+2, "Winds of change" + chr(10) + "are blowing in...")
	if unlockNum = 39 then SetTextString(spr+2, "Steel yourself" + chr(10) + "and FIGHT!")
	if unlockNum = 40 then SetTextString(spr+2, "Metallic seas and" + chr(10) + "reflecting tides!")
	if unlockNum = 41 then SetTextString(spr+2, "A rockin' redo" + chr(10) + "of a classic!")
	if unlockNum = 42 then SetTextString(spr+2, "Like a sweet," + chr(10) + "sitting in the sun...")
	if unlockNum = 43 then SetTextString(spr+2, "Not a date, but" + chr(10) + "the next best thing.")
	if unlockNum = 44 then SetTextString(spr+2, "WHO LET THINGS" + chr(10) + "GET THIS BAD?!")
	if unlockNum = 45 then SetTextString(spr+2, "Will guided soul" + chr(10) + "searching be enough?")
	if unlockNum = 46 then SetTextString(spr+2, "Starlight Rivalry-" + chr(10) + "does it ever end?")
	if unlockNum = 47 then SetTextString(spr+2, "Look to the future" + chr(10) + "with hope, always!")
	if unlockNum = 48 then SetTextString(spr+2, "Soon-to-be chart" + chr(10) + "topper, all yours!")
	if unlockNum = 49 then SetTextString(spr+2, "It turns out, he" + chr(10) + "wrote lyrics too!")
	if unlockNum = 50 then SetTextString(spr+2, "The felt beast lies" + chr(10) + "dormant, waiting...")
	if unlockNum = 51 then SetTextString(spr+2, "The final song!" + chr(10) + "You got them all!")
	if unlockNum > 30 then SetTextString(spr+2, GetTextString(spr+2) + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "New song" + chr(10) + "unlocked!")
	if unlockNum = 25 then SetTextString(spr+2, "Song Selection" + chr(10) + "unlocked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "You can now pick" + chr(10) + "songs pre-match!")
	if unlockNum = 26 then SetTextString(spr+2, "Hard Battle" + chr(10) + "unlocked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "With this on," + chr(10) + "games start harder!")
	if unlockNum = 27 then SetTextString(spr+2, "Fast Battle" + chr(10) + "unlocked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "With this on," + chr(10) + "games are FAST!")
	if unlockNum = 28 then SetTextString(spr+2, "Evil Switch" + chr(10) + "unlocked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "Four crabs are" + chr(10) + "hidden- find them!")
	if unlockNum = 29 then SetTextString(spr+2, "Hardest AI" + chr(10) + "unlocked!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "In AI Battles," + chr(10) + "set crabs HARDER!")
	if unlockNum = 30 then SetTextString(spr+2, "You finished" + chr(10) + "EVERYTHING!" + chr(10)+chr(10)+chr(10)+chr(10)+chr(10) + "You're officially a" + chr(10) + "LOSER XD no more!")
	
	if area = G2 and dispH = 0
		SetTextAngle(spr+2, 180)
		SetTextY(spr+2, GetSpriteY(spr)+GetSpriteHeight(spr)-GetTextSize(spr+2)/4)
	endif
	
	//Creating the tweens for the popup, one for each element
	//Tween is a twisty one that gets bigger
	CreateTweenSprite(spr, .9)
	CreateTweenSprite(spr+1, 1.3)
	for i = spr to spr+1
		SetTweenSpriteSizeX(i, 1, GetSpriteWidth(i), TweenOvershoot())
		SetTweenSpriteSizeY(i, 1, GetSpriteHeight(i), TweenOvershoot())
		SetTweenSpriteAngle(i, -720-180*(1-area)*(dispH-1), -180*(1-area)*(dispH-1), TweenOvershoot())
		if unlockNum > 30 and i = spr+1 then SetTweenSpriteAngle(i, -720-180*(1-area)*(dispH-1), -180*(1-area)*(dispH-1)-20, TweenOvershoot())
		SetTweenSpriteX(i, GetSpriteMiddleX(i), GetSpriteX(i), TweenOvershoot())
		SetTweenSpriteY(i, GetSpriteMiddleY(i), GetSpriteY(i), TweenOvershoot())
	next i
	
	
	//SetTweenSpriteY(spr+1, GetSpriteMiddleY(spr), GetSpriteMiddleY(spr)-chibiSize/2, TweenOvershoot())
	SetTweenSpriteRed(spr+1, 0, 255, TweenSmooth2())
	SetTweenSpriteGreen(spr+1, 0, 255, TweenSmooth2())
	SetTweenSpriteBlue(spr+1, 0, 255, TweenSmooth2())
	
	CreateTweenText(spr+2, 1.3)
	SetTweenTextSize(spr+2, 1, GetTextSize(spr+2), TweenOvershoot())
	SetTweenTextSpacing(spr+2, 0, spacing, TweenOvershoot())
	//SetTweenTextAlpha(spr+2, 
	//SetTweenTextAngle(spr+2, -540-180*area, 180-180*area*(dispH), TweenOvershoot())	
	
	
	
	PlayTweenSprite(spr, spr, 0)
	PlayTweenSprite(spr+1, spr+1, 0)
	PlayTweenText(spr+2, spr+2, 0)
	UpdateAllTweens(.001)
	
	if area = G1 and unlockNum > 0 then Popup(G2, unlockNum)	//Calling this recursivly to make the second popup
	
endfunction

function ClearPopup1()
	StopMusicOGGSP(unlockMusic)
	
	if GetSpriteExists(SPR_POPUP_BG)
		UpdateTweenSprite(SPR_POPUP_BG, SPR_POPUP_BG, 1)
		UpdateTweenSprite(SPR_POPUP_C, SPR_POPUP_C, 1)
		UpdateTweenText(TXT_POPUP, TXT_POPUP, 1)
		
		if GetSpriteColorAlpha(SPR_POPUP_BG) > 200
			PlayTweenSprite(tweenSprFadeOutFull, SPR_POPUP_BG, 0)
			PlayTweenSprite(tweenSprFadeOutFull, SPR_POPUP_C, 0)
			PlayTweenText(tweenTxtFadeOut, TXT_POPUP, 0)	
			PlaySoundR(fwipS, 100)
		endif
		
	endif
endfunction

function ClearPopup2()
	StopMusicOGGSP(unlockMusic)
	
	if GetSpriteExists(SPR_POPUP_BG_2)
		UpdateTweenSprite(SPR_POPUP_BG_2, SPR_POPUP_BG_2, 1)
		UpdateTweenSprite(SPR_POPUP_C_2, SPR_POPUP_C_2, 1)
		UpdateTweenText(TXT_POPUP_2, TXT_POPUP_2, 1)
		
		if GetSpriteColorAlpha(SPR_POPUP_BG_2) > 200
			PlayTweenSprite(tweenSprFadeOutFull, SPR_POPUP_BG_2, 0)
			PlayTweenSprite(tweenSprFadeOutFull, SPR_POPUP_C_2, 0)
			PlayTweenText(tweenTxtFadeOut, TXT_POPUP_2, 0)
			PlaySoundR(fwipS, 100)
		endif
		
	endif
endfunction

function DeletePopup1()
	for i = SPR_POPUP_BG to TXT_POPUP
		if GetSpriteExists(i) then DeleteSprite(i)
		if GetTextExists(i) then DeleteText(i)
		if GetTweenExists(i) then DeleteTween(i)
	next i
endfunction

function DeletePopup2()
	for i = SPR_POPUP_BG_2 to TXT_POPUP_2
		if GetSpriteExists(i) then DeleteSprite(i)
		if GetTextExists(i) then DeleteText(i)
		if GetTweenExists(i) then DeleteTween(i)
	next i
endfunction

function ProcessPopup()
	if GetSpriteExists(SPR_POPUP_BG)
		if (ButtonMultitouchEnabled(SPR_POPUP_BG) or inputSelect) and GetSpriteColorAlpha(SPR_POPUP_BG) > 10
			ClearPopup1()
			ClearMultiTouch()
			inputSelect = 0
		endif
	endif
	if GetSpriteExists(SPR_POPUP_BG_2)
		if (ButtonMultitouchEnabled(SPR_POPUP_BG_2) or inputSelect2) and GetSpriteColorAlpha(SPR_POPUP_BG_2) > 10
			ClearPopup2()
			ClearMultiTouch()
			inputSelect = 0
		endif
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
