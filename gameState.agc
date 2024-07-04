#include "constants.agc"
#include "game1.agc"
#include "game2.agc"


// This module's purpose is to abstract away game1.agc and game2.agc into a single
// state, GAME, that gets executed from the main game loop.


// Whether this state has been initialized
global gameStateInitialized as integer = 0


// Initialize the game
function InitGame()
		
	gameDifficulty1 = 1
	gameDifficulty2 = 1
	if gameIsHard and spType <> STORYMODE
		gameDifficulty1 = 4
		gameDifficulty2 = 4
	endif
	CreateGame1()
	CreateGame2()
	LoadJumpSounds()
	InitAttackParticles()
	InitJumpParticles()
	gameTimer# = 0
	meteorTotal1 = 0
	meteorTotal2 = 0
	
	spScore = 0
	
	metSizeX = 58*gameScale#
	metSizeY = 80*gameScale#
	
	SetSpriteVisible(split, 1)
	TransitionEnd()
	
	if GetDeviceBaseName() = "android"
		SetFolder("/media/sounds")
		LoadMusicOGG(exp4S, "exp4.ogg")
		LoadMusicOGG(exp5S, "exp5.ogg")
	endif
	
	if spType = 0 or spType = STORYMODE or spType = AIBATTLE then PlayOpeningScene()
	
	//The pause button
	SetFolder("/media/ui")
	LoadSpriteExpress(pauseButton, "pause.png", 100, 100, 0, 0, 9)
	SetSpriteMiddleScreen(pauseButton)
	
	LoadSpriteExpress(playButton, "resume.png", 185, 185, 0, 0, 2)
	SetSpriteMiddleScreen(playButton)
	SetSpriteVisible(playButton, 0)
	
	LoadSpriteExpress(exitButton, "crabselect.png", 140, 140, 0, 0, 2)
	SetSpriteMiddleScreen(exitButton)
	if dispH = 0 then IncSpriteX(exitButton, 270)
	if dispH then IncSpriteY(exitButton, 220)
	SetSpriteVisible(exitButton, 0)
	
	LoadSpriteExpress(mainmenuButton, "mainmenu.png", 140, 140, 0, 0, 2)
	SetSpriteMiddleScreen(mainmenuButton)
	if dispH = 0 then IncSpriteX(mainmenuButton, -270)
	if dispH then IncSpriteY(mainmenuButton, -220)
	SetSpriteVisible(mainmenuButton, 0)
	
	AddButton(pauseButton)
	AddButton(playButton)
	AddButton(exitButton)
	AddButton(mainmenuButton)
	
	difficultyMax = 7
	diffMod = 0
	if spType = STORYMODE or spType = AIBATTLE then diffMod = 1
	difficultyBar = 9 - diffMod*(knowingAI/3)
	
	if GetTextExists(TXT_SP_SCORE) then SetTextDepth(TXT_SP_SCORE, 5)
	if GetTextExists(TXT_SP_DANGER) then SetTextDepth(TXT_SP_DANGER, 5)
	
	if spType = MIRRORMODE and dispH
		SetTextPosition(TXT_SP_SCORE, w/2 - 120, 40)
		SetTextPosition(TXT_SP_DANGER, w/2, GetTextY(TXT_SP_SCORE) + GetTextSize(TXT_SP_SCORE))
	endif
	
	//The special classic mode setup
	if spType = CLASSIC
		SetSpriteVisible(split, 0)
		SetViewZoomMode(1)
		SetViewZoom(1.3)
		
		//The game screen adjustments
		SetTextSize(TXT_SP_SCORE, spScoreMinSize-10-dispH*10)
		SetTextSize(TXT_SP_DANGER, spScoreMinSize-10-dispH*10)
		SetTextSpacing(TXT_SP_SCORE, -10+dispH*2)
		SetTextSpacing(TXT_SP_DANGER, -10+dispH*2)
		SetTextPosition(TXT_SP_SCORE, 130, 280)
		if dispH then SetTextPosition(TXT_SP_SCORE, 180, 100)
		SetTextPosition(TXT_SP_DANGER, GetTextX(TXT_SP_SCORE) - 10, GetTextY(TXT_SP_SCORE) + GetTextSize(TXT_SP_SCORE))
		SetTextAlignment(TXT_SP_DANGER, 0)
		SetSpriteSize(bgGame1, h, h)
		if dispH then SetSpriteSize(bgGame1, w, w)
		SetSpriteMiddleScreen(bgGame1)
		difficultyMax = 9
		difficultyBar = 9
		
		DeleteSprite(bgGame2)
		zoom# = GetViewZoom()
		
		//Adjusting the pause button positions, as well as creating phantom buttons for collision detection
		SetSpritePosition(pauseButton, w - 120 - GetSpriteWidth(pauseButton), 290)
		IncSpriteSizeCenteredMult(exitButton, 1/zoom#)
		IncSpriteSizeCenteredMult(mainmenuButton, 1/zoom#)
		
		IncSpriteSizeCenteredMult(pauseButton, 1/zoom#*1.2)
		LoadSpriteExpress(phantomPauseButton, "pause.png", GetSpriteWidth(pauseButton)*zoom#, GetSpriteHeight(pauseButton)*zoom#, 697-GetSpriteWidth(pauseButton)/2, 200-GetSpriteWidth(pauseButton)/2, 1)
		SetSpriteColorAlpha(phantomPauseButton, 0)
		AddButton(phantomPauseButton)
		
		IncSpriteSizeCenteredMult(playButton, 1/zoom#)
		SetSpriteShapeCircle(playButton, GetSpriteWidth(playButton)/2, GetSpriteHeight(playButton)/2, GetSpriteWidth(playButton)*zoom#)
		
		if dispH = 0 then IncSpriteX(exitButton, -70)
		LoadSpriteExpress(phantomExitButton, "crabselect.png", GetSpriteWidth(exitButton)*zoom#, GetSpriteHeight(exitButton)*zoom#, 659-GetSpriteWidth(exitButton)/2, 803-GetSpriteWidth(exitButton)/2, 1)
		SetSpriteColorAlpha(phantomExitButton, 0)
		SetSpriteVisible(phantomExitButton, 0)
		AddButton(phantomExitButton)
		
		if dispH
			SetSpritePosition(pauseButton, w - 180 - GetSpriteWidth(pauseButton), 110)
			SetSpritePosition(phantomPauseButton, 1178-GetSpriteWidth(pauseButton)/2, 94-GetSpriteWidth(pauseButton)/2)
			
			IncSpriteY(exitButton, -50)
			SetSpritePosition(phantomExitButton, 639-GetSpriteWidth(pauseButton)/2, 582-GetSpriteWidth(pauseButton)/2)
		endif
		
		StartGameMusic()
	endif
	//For multiplayer mode, the music is started in a different place
	//if spActive = 1 then StartGameMusic()
	
	SetFolder("/media")
	
	gameStateInitialized = 1
		
endfunction


// Game execution loop
// Each time this loop exits, return the next state to enter into
function DoGame()

	// Initialize if we haven't done so
	// Don't write anything before this!
	if gameStateInitialized = 0
		LoadGameImages(1)
		initGame()
		TransitionEnd()
	endif
	state = GAME
	
	if paused = 0
	
		//Dispersing the 'SURVIVE!' text after the opening
		if GetTextExists(TXT_INTRO1)
			if gameTimer# < 50
				for i = TXT_INTRO1 to TXT_INTRO2
					SetTextSpacing(i, gameTimer#/6 - 20)
					for j = 0 to GetTextLength(i)
						SetTextCharY(i, j, -1 * 2 + Random(0, 4) - GetTextSize(i)*(i-TXT_INTRO1))
						SetTextCharAngle(i, j, -1 * 2 + Random(0, 4) + 180*(i-TXT_INTRO1))
					next j
				next i
			else
				//The music should only start once
				if GetTextColorAlpha(TXT_INTRO1) = 255 then StartGameMusic()
				for i = TXT_INTRO1 to TXT_INTRO2
					SetTextSpacing(i, gameTimer#/2 - 36)
					SetTextColorAlpha(i, 255-(gameTimer#-49)*3)
					for j = 0 to GetTextLength(i)
						SetTextCharY(i, j, -1 * (gameTimer#-49)/2 + Random(0, (gameTimer#-49)) - GetTextSize(i)*(i-TXT_INTRO1))
						SetTextCharAngle(i, j, -1 * (gameTimer#-49)/2 + Random(0, gameTimer#-49) + 180*(i-TXT_INTRO1))
					next j
				next i
				if GetTextColorAlpha(TXT_INTRO1) < 10
					DeleteText(TXT_INTRO1)
					DeleteText(TXT_INTRO2)
				endif
			endif
		endif
		
		// Game execution loops
		if hit1Timer# > 0
			//This is the case for getting hit
			state1 = HitScene1()
		else
			//This is the case for normal gameplay
			state1 = DoGame1()
		endif
		if hit2Timer# > 0
			//This is the case for getting hit
			state2 = HitScene2()
		else
			//This is the case for normal gameplay
			if spType = CLASSIC
				state2 = GAME
			else
				state2 = DoGame2()
			endif
		endif
		UpdateExp()
		inc gameTimer#, fpsr#
		
		if hit1Timer# > 0 or hit2Timer# > 0
			DisableAttackButtons()
		endif
		
		if spType = MIRRORMODE or spType = CLASSIC
			UpdateSPScore(0)
			if hit1Timer# > 0 or hit2Timer# > 0
				//The single player game is over
				state = START
			endif
		endif
		
		//Stops the game from crashing if this number gets too high (proper range is 1000 to 2000).
		if meteorSprNum > 1900
			meteorSprNum = 1050
		endif
	
		if ButtonMultitouchEnabled(pauseButton) or inputExit or inputExit2
			if paused = 0 then PauseGame()
			paused = 1
		endif
		
		if GetSpriteExists(phantomPauseButton)
			if ButtonMultitouchEnabled(phantomPauseButton)
				if paused = 0 then PauseGame()
				paused = 1
			endif
		endif
		
		// Check for state updates (pausing, losing). Sorry Player 2, Player 1 gets checked first.
		if state1 <> GAME
			state = state1
		elseif state2 <> GAME
			state = state2
		endif
	
	else
		//The case where the game is paused
		
		inc pauseTimer#, fpsr#/3
		if pauseTimer# > 360 then dec pauseTimer#, 360
		
		if dispH = 0 then SetSpriteX(curtainB, w/2 - GetSpriteWidth(curtainB)/2 + w/4*sin(pauseTimer#))
		if dispH then SetSpriteY(curtainB, h/2 - GetSpriteHeight(curtainB)/2 + h/4*sin(pauseTimer#))
		IncSpriteAngle(exitButton, -fpsr#)
		IncSpriteAngle(mainmenuButton, -fpsr#)
		IncSpriteAngle(playButton, fpsr#)
		IncSpriteAngle(SPR_SETTINGS, fpsr#)
		
		ProcessPopup()
		
		if ButtonMultitouchEnabled(SPR_SETTINGS) then StartSettings()
		if dispH
			if ButtonMultitouchEnabled(SPR_CONTROLS)
				if spType = 0
					Popup(1, -1)
					Popup(2, -1)
				else
					Popup(MIDDLE, -1)
				endif
			endif
		endif
		
		if ButtonMultitouchEnabled(playButton) or inputExit
			paused = 0
			DeletePopup1()
			DeletePopup2()
			UnpauseGame()
		endif
		
		exitG = 0
		if GetSpriteExists(phantomExitButton)
			if ButtonMultitouchEnabled(phantomExitButton) and GetSpriteVisible(phantomExitButton) then exitG = 1
		endif
		
		if (ButtonMultitouchEnabled(exitButton) and GetSpriteVisible(exitButton)) or exitG
			TransitionStart(Random(1,lastTranType))
			SetViewZoom(1)
			state = CHARACTER_SELECT
			if (spType = CLASSIC or spType = MIRRORMODE) and storyActive = 0 then state = START
			UnpauseGame()
		endif
		
		if ButtonMultitouchEnabled(mainmenuButton) and GetSpriteVisible(mainmenuButton)
			TransitionStart(Random(1,lastTranType))
			SetViewZoom(1)
			state = START
			crab1Deaths = 0
			crab2Deaths = 0
			UnpauseGame()
		endif
		
	endif
	
	if state = RESULTS
		EndGameScene()
		
		if storyActive
			//This is the case of ending story mode in a VS battle
			state = STORY
			if spType = CHALLENGEMODE and crab2Deaths = 3 then state = START
			if crab1Deaths = 3 then storyRetry = 1
		endif
	endif
	
	if (spType <> 0 and spType <> STORYMODE and spType <> AIBATTLE) and crab1Deaths > 0 or crab2Deaths > 0 and state = START
		if spType = MIRRORMODE then EndMirrorScene()
		if spType = CLASSIC then EndClassicScene()
		if storyActive
			//This is the case of ending story mode in a single player mode
			state = STORY
			if spScore < storyMinScore then storyRetry = 1
		endif
	endif
	
	
	if GetRawKeyPressed(187) and debug
		inc gameDifficulty1, 1
		inc gameDifficulty2, 1
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> GAME
		LoadGameImages(0)
		ExitGame()
	endif
	
endfunction state

function EndGameScene()
	
	endSceneMax = hitSceneMax*4/5
	hitTimer# = endSceneMax
	crabS = crab1
	crabSR# = crab1R# - 22
	crabSTheta# = crab1Theta#
	if crab2Deaths = 3	//Show the death on 1 by default; on 2 if they have lost all 3 lives
		crabS = crab2
		crabSR# = crab2R# - 22
		crabSTheta# = crab2Theta#
	endif
	
	endStage = 0
	
	SetFolder("/media")
	
	//Setup for the scene
	if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
	LoadSprite(bgHit1, "envi/bg0.png")
	SetSpriteSizeSquare(bgHit1, w)
	if crab1Deaths = 3
		DrawPolar1(bgHit1, 0, crab1Theta#)
	else
		DrawPolar2(bgHit1, 0, crab2Theta#)
	endif
	
	StopSprite(crab1)
	StopSprite(crab2)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		StopSprite(meteorActive2[i].spr)
	next i
	if GetSpriteExists(expBar1) then DeleteGameUI()
	
	//Getting rid of the music
	StopGamePlayMusic()
	
	while hitTimer# > 0
	
		inc hitTimer#, -1*fpsr#
		
		//First bit, crab is hit once
		if hitTimer# >= endSceneMax*3/4
			
			if endStage = 0
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				endStage = 1
			endif
			
			//Changing where the crab is drawn, based on the game that won
			if crab1Deaths = 3
				DrawPolar1(crabS, crabSR#, crabSTheta#)
			else
				DrawPolar2(crabS, crabSR#, crabSTheta#)
			endif
			range = (hitTimer#-endSceneMax*3/4)/2
			IncSpritePosition(crabS, Random(-range, range), Random(-range, range))	
			SetSpriteColorAlpha(bgGame1, 80)
			
			
		//Crab is hit second time
		elseif hitTimer# >= endSceneMax*2/4
			
			if endStage = 1
				
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				SetViewZoom(1.25)
				SetViewOffset(w/16, GetSpriteMiddleY(crabS)/8)
				if dispH then SetViewOffset(GetSpriteMiddleX(crabS)/8, h/16)
				//SetViewOffset(GetSpriteMiddleX(crabS)/8, GetSpriteMiddleY(crabS)/8)
				endStage = 2
			endif
			
			
			//Changing where the crab is drawn, based on the game that won
			if crab1Deaths = 3
				DrawPolar1(crabS, crabSR#, crabSTheta#)
			else
				DrawPolar2(crabS, crabSR#, crabSTheta#)
			endif
			range = (hitTimer#-endSceneMax*2/4)/2
			IncSpritePosition(crabS, Random(-range, range), Random(-range, range))
			
		//Crab is hit third time
		elseif hitTimer# >= endSceneMax/4
			
			if endStage = 2
					
				PlaySoundR(crackS, 100)
				PlaySoundR(crackS, 50)
				PlaySoundR(explodeS, 100)
				
				
				SetViewZoom(2)
				SetViewOffset(w/4, GetSpriteMiddleY(crabS)/2)
				if dispH then SetViewOffset(GetSpriteMiddleX(crabS)/2, h/4)
				//SetViewOffset(GetSpriteMiddleX(crabS)/2, GetSpriteMiddleY(crabS)/2)
				endStage = 3
			endif
			
			
			//Changing where the crab is drawn, based on the game that won
			if crab1Deaths = 3
				DrawPolar1(crabS, crabSR#, crabSTheta#)
			else
				DrawPolar2(crabS, crabSR#, crabSTheta#)
			endif
			range = 20-(endSceneMax*1/4-hitTimer#)/2
			IncSpritePosition(crabS, Random(-range, range), Random(-range, range))	
			
		//Crab flies towards screen
		elseif hitTimer# > 0
			
			if endStage = 3
				//if GetSpriteExists(hitSpr1) then DeleteSprite(hitSpr1)
				//if GetSpriteExists(hitSpr2) then DeleteSprite(hitSpr2)
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				if spType <> STORYMODE and spType <> CHALLENGEMODE then PlayMusicOGGSP(resultsMusic, 1)
				if (spType = STORYMODE or spType = CHALLENGEMODE) and crabS = crab1 then PlayMusicOGGSP(loserMusic, 0)
				
				if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
			endif
			
			SetSpriteColorAlpha(coverS, 255*((endSceneMax/4) - hitTimer#)/(endSceneMax/4))
			SetSpriteSize(crabS, GetSpriteWidth(crabS)*1.05, GetSpriteHeight(crabS)*1.05)
			//Changing where the crab is drawn, based on the game that won
			if crab1Deaths = 3
				DrawPolar1(crabS, crabSR#, crabSTheta#)
			else
				DrawPolar2(crabS, crabSR#, crabSTheta#)
			endif
			SetSpriteAngle(crabS, 76*hitTimer#)
			//if hitTimer# > endSceneMax/8
			//	SetSpriteColorAlpha(crabS, 255 - (endSceneMax/8 - hitTimer#)
			//endif
			
		//Cleaning up before the end of the game
		elseif hitTimer# <= 0
			
			for i = 1 to endSceneMax/5
				SyncG()
			next i
			
			if storyActive = 0 then InitResults()
		endif
		
		SyncG()
		
	endwhile
		
endfunction

function EndMirrorScene()
	
	endSceneMax = hitSceneMax*2/5
	hitTimer# = endSceneMax
	crabS = crab1
	crab1R# = crab1R# - 22
	crab2R# = crab2R# - 22
	crabSR# = crab1R#
	crabSTheta# = crab1Theta#
	if crab2Deaths = 1	//Show the death on 1 by default; on 2 if the other crab was hit
		crabS = crab2
	endif
	
	endStage = 0
	
	//Setup for the scene
	SetFolder("/media")
	LoadSprite(bgHit1, "envi/bg0.png")
	SetSpriteSizeSquare(bgHit1, w)
	if crab1Deaths = 1
		DrawPolar1(bgHit1, 0, crab1Theta#)
	else
		DrawPolar2(bgHit1, 0, crab2Theta#)
	endif
	
	StopSprite(crab1)
	StopSprite(crab2)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		StopSprite(meteorActive2[i].spr)
	next i
	if GetSpriteExists(expBar1) then DeleteGameUI()
	
	//Getting rid of the music
	StopGamePlayMusic()

	PlaySprite(crab1, 0, 1, 13, -1)
	PlaySprite(crab2, 0, 1, 13, -1)

	while hitTimer# > 0
	
		inc hitTimer#, -1*fpsr#
		
		//First bit, crab is hit once
		if hitTimer# >= endSceneMax/2
			
			if endStage = 0
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				SetViewZoom(1.25)
				SetViewZoomMode(1)
				endStage = 3
			endif
			
			//Changing where the crab is drawn, based on the game that won
			DrawPolar1(crab1, crab1R#, crab1Theta#)
			DrawPolar2(crab2, crab2R#, crab2Theta#)
			range = (hitTimer#-endSceneMax*1/2)/2
			IncSpritePosition(crab1, Random(-range, range), Random(-range, range))	
			IncSpritePosition(crab2, Random(-range, range), Random(-range, range))	
			SetSpriteColorAlpha(bgGame1, 80)
			SetSpriteColorAlpha(bgGame2, 80)
			
		//Crab flies towards screen
		elseif hitTimer# > 0
			
			if endStage = 3
				//if GetSpriteExists(hitSpr1) then DeleteSprite(hitSpr1)
				//if GetSpriteExists(hitSpr2) then DeleteSprite(hitSpr2)
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				SetViewZoomMode(0)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				if storyActive = 0 or spScore < storyMinScore then PlayMusicOGGSP(loserMusic, 0)
				
				if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
			endif
			
			SetSpriteColorAlpha(coverS, 255.0*((endSceneMax/2) - hitTimer#)/(endSceneMax/2))
			SetSpriteSize(crab1, GetSpriteWidth(crab1)*1.05, GetSpriteHeight(crab1)*1.05)
			SetSpriteSize(crab2, GetSpriteWidth(crab2)*1.05, GetSpriteHeight(crab2)*1.05)
			
			DrawPolar1(crab1, crab1R#, crab1Theta#)
			DrawPolar2(crab2, crab2R#, crab2Theta#)
				
			SetSpriteAngle(crab1, 76*hitTimer#)
			SetSpriteAngle(crab2, 76*hitTimer#)
			
		endif
		
		SyncG()
		
	endwhile
	
	SetSpriteColorAlpha(coverS, 255)
	SyncG()
	
endfunction

function EndClassicScene()
	
	endSceneMax = hitSceneMax*2/5
	hitTimer# = endSceneMax
	crab1R# = crab1R# - 22
	
	endStage = 0
	
	SetFolder("/media")
	
	//Setup for the scene
	LoadSprite(bgHit1, "envi/bg0.png")
	SetSpriteSizeSquare(bgHit1, w)
	DrawPolar1(bgHit1, 0, crab1Theta#)
	
	StopSprite(crab1)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	if GetSpriteExists(expBar1) then DeleteGameUI()
	
	//Getting rid of the music
	StopGamePlayMusic()

	PlaySprite(crab1, 0, 1, 13, -1)
	
	while hitTimer# > 0
	
		inc hitTimer#, -1*fpsr#
		
		//First bit, crab is hit once
		if hitTimer# >= endSceneMax/2
			
			if endStage = 0
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				SetViewZoom(1.45)
				SetViewZoomMode(1)
				endStage = 3
			endif
			
			//Changing where the crab is drawn, based on the game that won
			DrawPolar1(crab1, crab1R#, crab1Theta#)
			range = (hitTimer#-endSceneMax*1/2)/2
			IncSpritePosition(crab1, Random(-range, range), Random(-range, range))	
			SetSpriteColorAlpha(bgGame1, 80)
			
		//Crab flies towards screen
		elseif hitTimer# > 0
			
			if endStage = 3
				//if GetSpriteExists(hitSpr1) then DeleteSprite(hitSpr1)
				//if GetSpriteExists(hitSpr2) then DeleteSprite(hitSpr2)
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				SetViewZoomMode(0)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				if storyActive = 0 or spScore < storyMinScore then PlayMusicOGGSP(loserMusic, 0)
				
				if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
			endif
			
			SetSpriteColorAlpha(coverS, 255.0*((endSceneMax/2) - hitTimer#)/(endSceneMax/2))
			SetSpriteSize(crab1, GetSpriteWidth(crab1)*1.05, GetSpriteHeight(crab1)*1.05)
			DrawPolar1(crab1, crab1R#, crab1Theta#)
			SetSpriteAngle(crab1, 76*hitTimer#)
			
		endif
		
		SyncG()
		
	endwhile
	
	SetSpriteColorAlpha(coverS, 255)
	SyncG()
	
endfunction

function DeleteGameUI()
	StopSprite(expHolder1)
	StopSprite(expHolder2)
	StopSprite(expBar1)
	StopSprite(expBar2)
	
	//Game 1 (Bottom)
	DeleteAnimatedSprite(meteorButton1)
	DeleteSprite(meteorMarker1)
	DeleteAnimatedSprite(specialButton1)
	DeleteSprite(crab1PlanetS[1])
	DeleteSprite(crab1PlanetS[2])
	DeleteSprite(crab1PlanetS[3])
	if GetTextExists(meteorButton1) then DeleteText(meteorButton1)
	if GetTextExists(specialButton1) then DeleteText(specialButton1)
	
	for i = special2Ex1 to special2Ex5
		DeleteSprite(i)
	next i
	if GetMusicPlayingOGGSP(raveBass2) then StopMusicOGGSP(raveBass2)
		
	//Game 2 (Top)
	DeleteSprite(expHolder2)
	DeleteSprite(expBar2)
	DeleteAnimatedSprite(meteorButton2)
	DeleteSprite(meteorMarker2)
	DeleteAnimatedSprite(specialButton2)
	DeleteSprite(crab2PlanetS[1])
	DeleteSprite(crab2PlanetS[2])
	DeleteSprite(crab2PlanetS[3])
	if GetTextExists(meteorButton2) then DeleteText(meteorButton2)
	if GetTextExists(specialButton2) then DeleteText(specialButton2)
	
	for i = special1Ex1 to special1Ex5
		DeleteSprite(i)
	next i
	if GetMusicPlayingOGGSP(raveBass1) then StopMusicOGGSP(raveBass1)
	
	//Deleting the animated game1 sprites that were referenced in game 2
	DeleteAnimatedSprite(expBar1)
	DeleteAnimatedSprite(expHolder1)
	
	//Extra (both)
	DeleteHalfExp(1)
	DeleteHalfExp(2)
	
	SetParticlesVisible(par1spe1, 0)
	SetParticlesVisible(par2spe1, 0)
	
	DeleteSprite(pauseButton)
	DeleteSprite(playButton)
	DeleteSprite(exitButton)
	DeleteSprite(mainmenuButton)
	if GetSpriteExists(phantomPauseButton) then DeleteSprite(phantomPauseButton)
	if GetSpriteExists(phantomExitButton) then DeleteSprite(phantomExitButton)
	
	if spType <> 0
		DeleteSprite(SPR_SP_SCORE)
		DeleteText(TXT_SP_SCORE)
		DeleteText(TXT_SP_DANGER)
	endif
endfunction

// Cleanup upon leaving this state
function ExitGame()
	
	//Updating the scores for the single player game
	if spType <> 0
		if spType = MIRRORMODE
			if spHighScore < spScore
				spHighScore = spScore
				spHighCrab$ = crabNames[crab1Type + crab1Alt*6]
				if crab1Evil and crab1Type = 1 and crab1Alt = 0 then spHighCrab$ = "CRIXEL"
				if crab1Evil and crab1Type = 1 and crab1Alt = 3 then spHighCrab$ = "BETA CRAB"
				if crab1Evil and crab1Type = 4 and crab1Alt = 3 then spHighCrab$ = "DEVIL CRAB"
				SaveGame()
			endif
		elseif spType = CLASSIC
			if spHighScoreClassic < spScore
				spHighScoreClassic = spScore
				spHighCrabClassic$ = crabNames[crab1Type + crab1Alt*6]
				if crab1Evil and crab1Type = 1 and crab1Alt = 0 then spHighCrabClassic$ = "CRIXEL"
				if crab1Evil and crab1Type = 1 and crab1Alt = 3 then spHighCrabClassic$ = "BETA CRAB"
				if crab1Evil and crab1Type = 4 and crab1Alt = 3 then spHighCrabClassic$ = "DEVIL CRAB"
				SaveGame()
			endif
		endif
	endif
	
	if GetSpriteExists(999) then StopGamePlayMusic() 	//The pause menu curtain
	if GetDeviceBaseName() = "android"
		DeleteMusicOGG(exp4S)
		DeleteMusicOGG(exp5S)
	endif
	
	if GetSpriteExists(999) then DeleteSprite(999)	//The pause menu curtain
	if GetTextExists(TXT_INTRO1) then DeleteText(TXT_INTRO1)
	if GetTextExists(TXT_INTRO2) then DeleteText(TXT_INTRO2)
	paused = 0
	
	
	
	//This is called if the end cutscene for the game never plays
	if GetSpriteExists(expBar1)
		DeleteGameUI()
	endif
	
	//Game 1 (Bottom)
	DeleteSprite(planet1)
	DeleteSprite(crab1)
	DeleteSprite(bgGame1)
	specialTimerAgainst1# = 0
		
	met1CD1# = 50
	met2CD1# = 0
	met3CD1# = 0 
	
	for i = 1 to meteorActive1.length
		DeleteSprite(meteorActive1[i].spr)
		DeleteSprite(meteorActive1[i].spr+glowS)
		if meteorActive1[i].cat = 3 then DeleteSprite(meteorActive1[i].spr + 10000)
	next
	for i = 1 to meteorActive1.length
		meteorActive1.remove()
	next
	meteorActive1.length = 0
	
	crab1Theta# = 270
	crab1Dir# = 1
	crab1Turning = 0
	crab1JumpD# = 0
	nudge1R# = 0
	nudge1Theta# = 0
	expTotal1 = 0
	meteorCost1 = 8
	specialCost1 = 20
	hit1Timer# = 0
	
	//Game 2 (Top)
	DeleteSprite(planet2)
	DeleteSprite(crab2)
	if GetSpriteExists(bgGame2) then DeleteSprite(bgGame2)
	specialTimerAgainst2# = 0
		
	met1CD2# = 50
	met2CD2# = 0
	met3CD2# = 0 
	
	for i = 1 to meteorActive2.length
		DeleteSprite(meteorActive2[i].spr)
		DeleteSprite(meteorActive2[i].spr+glowS)
		if meteorActive2[i].cat = 3 then DeleteSprite(meteorActive2[i].spr + 10000)
	next
	for i = 1 to meteorActive2.length
		meteorActive2.remove()
	next
	meteorActive2.length = 0
		
	crab2Theta# = 270
	crab2Dir# = 1
	crab2Turning = 0
	crab2JumpD# = 0
	nudge2R# = 0
	nudge2Theta# = 0
	expTotal2 = 0
	meteorCost2 = 8
	specialCost2 = 20
	hit2Timer# = 0
	
	//Extra (both)
	if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
	if GetSpriteExists(bgHit2) then DeleteSprite(bgHit2)
	
	// Whatever we do for something like ExitGame1() and ExitGame2() will go here
	gameStateInitialized = 0
	
	
	ClearMultiTouch()
	
endfunction

function PauseGame()
	
	PlaySoundR(buttonSound, 100)
	zoom# = GetViewZoom()
	CreateSpriteExpress(curtainB, h/zoom#, h/zoom#, 0, 0, 3)
	SetSpriteImage(curtainB, bg3I)
	if dispH then SetSpriteSize(curtainB, w/zoom#, w/zoom#)
	SetSpriteMiddleScreen(curtainB)
	
	CreateSpriteExpress(curtain, w/zoom#*1.3, h/zoom#*1.3, 0, 0, 3)
	SetSpriteImage(curtain, bgPI)
	if dispH
		SetSpriteSize(curtain, 800, 1600)
		SetSpriteAngle(curtain, 90)
		
	endif
	SetSpriteMiddleScreen(curtain)
	
	SetFolder("/media/ui")
	LoadSpriteExpress(SPR_SETTINGS, "settingss1.png", 120, 120, w-135, 15, 3)
	
	if dispH then LoadSpriteExpress(SPR_CONTROLS, "controls.png", 217, 120, GetSpriteX(SPR_SETTINGS)-240, 15, 3)
	
	if spType = CLASSIC
		IncSpriteSizeCenteredMult(curtain, GetViewZoom())
		IncSpriteSizeCenteredMult(curtainB, GetViewZoom())
	endif
	
	SetSpriteVisible(pauseButton, 0)
	if GetSpriteExists(phantomPauseButton) then SetSpriteVisible(phantomPauseButton, 0)
	SetSpriteVisible(playButton, 1)
	SetSpriteVisible(exitButton, 1)
	if GetSpriteExists(phantomExitButton) then SetSpriteVisible(phantomExitButton, 1)
	if spType = 0 then SetSpriteVisible(mainmenuButton, 1)
	
	if spType = CHALLENGEMODE then SetSpriteVisible(exitButton, 0)
	
	pauseTimer# = Random(0, 359)
	if dispH = 0 then SetSpriteX(curtainB, w/2 - GetSpriteWidth(curtainB)/2 + w/4*sin(pauseTimer#))
	if dispH then SetSpriteY(curtainB, h/2 - GetSpriteHeight(curtainB)/2 + h/4*sin(pauseTimer#))
	
	iEnd = 5/fpsr#
	for i = 1 to iEnd
		SetSpriteColorAlpha(curtain, 255.0*i/iEnd)
		SetSpriteColorAlpha(curtainB, 255.0*i/iEnd)
		SyncG()
	next i
	
	for i = pauseTitle1 to pauseDesc2
		CreateText(i, "")
		SetTextAlignment(i, 1)
		SetTextDepth(i, 2)
		//The titles
		if i <= 7
			SetTextFontImage(i, fontCrabI)
			SetTextSize(i, 100/zoom#)
			SetTextSpacing(i, -22/zoom#)
			SetTextPosition(i, w/2, 980)
		else //The descriptions
			SetTextFontImage(i, fontDescI)
			SetTextSize(i, 55/zoom#)
			SetTextSpacing(i, -15/zoom#)
			SetTextPosition(i, w/2, 1115)
		endif
		//The bottom (game 1)
		if Mod(i, 2) = 0
			
		else //The top (game 2)
			SetTextAngle(i, 180)
		endif
		
	next i
	
	//Making the crab title and description
	crab1ID = crab1Type+crab1Alt*6
	e1Mod = 0
	if crab1Evil and crab1Type = 1 and crab1Alt = 0 then crab1ID = 25
	if crab1Evil and crab1Type = 1 and crab1Alt = 3 then crab1ID = 26
	if crab1Evil and crab1Type = 4 and crab1Alt = 3
		crab1ID = 27
		e1Mod = 3
	endif
	SetTextString(pauseTitle1, crabNames[crab1ID])
	SetTextString(pauseDesc1, crabPause1[crab1Type])
	if spType = 0 or spType = STORY or spType = AIBATTLE then SetTextString(pauseDesc1, GetTextString(pauseDesc1) + chr(10) + chr(10) + crabPause2[crab1Type+crab1Alt*6+e1Mod])
	
	if (spType = 0)
		//For a multiplayer game
		crab2ID = crab2Type+crab2Alt*6
		e2Mod = 0
		if crab2Evil and crab2Type = 1 and crab2Alt = 0 then crab2ID = 25
		if crab2Evil and crab2Type = 1 and crab2Alt = 3 then crab2ID = 26
		if crab2Evil and crab2Type = 4 and crab2Alt = 3
			crab2ID = 27
			e2Mod = 3
		endif
		SetTextY(pauseTitle2, h/2 - (GetTextY(pauseTitle1)-h/2))
		SetTextY(pauseDesc2, h/2 - (GetTextY(pauseDesc1)-h/2))
		SetTextString(pauseTitle2, crabNames[crab2ID])
		SetTextString(pauseDesc2, crabPause1[crab2Type] + chr(10) + chr(10) + crabPause2[crab2Type+crab2Alt*6+e2Mod])
	endif
	
	//The single player special text
	if spType = MIRRORMODE
		SetTextString(pauseTitle2, "Mirror Mode")
		SetTextString(pauseDesc2, "A mysterious reflective surface split our" + chr(10) + "hero into two! Souls split across space," + chr(10) + "the crab still acts as one. Prove" + chr(10) + "that you can live to fight another day!")
		
		IncTextY(pauseTitle1, 100)
		IncTextY(pauseDesc1, 120)
		
		SetTextAngle(pauseTitle2, 0)
		SetTextAngle(pauseDesc2, 0)
		
		SetTextY(pauseTitle2, 180)
		SetTextSize(pauseTitle2, 120/zoom#)
		SetTextY(pauseDesc2, 380)
		SetTextSize(pauseDesc2, 50/zoom#)
	
		if dispH
			SetTextSpacing(pauseTitle2, GetTextSpacing(pauseTitle2) - 8)
		endif
	
	endif
	
	if spType = CLASSIC
		SetTextString(pauseTitle2, "SPACE CRAB"+chr(10)+"TRIVIA")
		SetTextSpacing(pauseTitle2, GetTextSpacing(pauseTitle2) - 5)
		SetTextSpacing(pauseDesc2, GetTextSpacing(pauseDesc2) + 1)
		IncTextY(pauseTitle2, 190)
		IncTextY(pauseDesc2, 100)
		rand = Random(1, 7)
		if rand = 1
			SetTextString(pauseDesc2, "The initial idea for Space Crab was" + chr(10) + "conceived in 2015, as a game called" + chr(10) + "'Ladder Wizard Wally'. The Ladder" + chr(10) + "Wizard you see in SCVS is the same one!")
		elseif rand = 2
			SetTextString(pauseDesc2, "Did you know that the first Space Crab" + chr(10) + "came out in 2018? In addition, the" + chr(10) + "first playable version was finished" + chr(10) + "in 24 hours. A painless birth!")
		elseif rand = 3
			SetTextString(pauseDesc2, "Space Crab 2 started with two guys in a" + chr(10) + "room. One said, 'What if we made" + chr(10) + "Space Crab 2?' The other said, 'I've" + chr(10) + "been waiting for you to say that.'")
		elseif rand = 4
			SetTextString(pauseDesc2, "Space Crab 2 got a major update in" + chr(10) + "Summer 2020! 'Deep Space' added 3 new" + chr(10) + "planets, 4 new songs, and 27 new" + chr(10) + "crabs. Almost a whole other game!")
		elseif rand = 5
			SetTextString(pauseDesc2, "The 'two players on one phone' concept" + chr(10) + "for SCVS came from early Rondovo game," + chr(10) + "'Rub'. Two players used paintbrushes to" + chr(10) + "cover the screen with their color!")
		elseif rand = 6
			SetTextString(pauseDesc2, "Space Crab made an appearance in" + chr(10) + "'Sleep Patrol Alpha' as a playable" + chr(10) + "character! Find every landmark on the" + chr(10) + "first map to unlock him.")
		elseif rand = 7
			SetTextString(pauseDesc2, "Tap and hold on the main menu logo" + chr(10) + "for a fruity suprise!")
		endif
		
		
		IncTextY(pauseTitle1, -80)
		IncTextY(pauseDesc1, -145)
		
		IncSpriteSizeCenteredMult(curtainB, GetViewZoom())
		
	endif
	
	
	if dispH
		for i = pauseTitle1 to pauseDesc2
			SetTextSize(i, GetTextSize(i) - 11)
			SetTextSpacing(i, GetTextSpacing(i) + 2)
			if i = pauseTitle1
				//SetTextSize(i, GetTextSize(i) - 15)
				//SetTextSpacing(i, GetTextSpacing(i) + 2)
			endif
		next i
		
		SetTextSize(pauseTitle1, GetTextSize(pauseTitle1) - 5)
		SetTextSize(pauseTitle2, GetTextSize(pauseTitle2) - 5)
		
		SetTextY(pauseTitle1, h/5+20)
		SetTextY(pauseTitle2, h/5+20)
		SetTextY(pauseDesc1, GetTextY(pauseTitle1) + 140)
		SetTextY(pauseDesc2, GetTextY(pauseTitle2) + 140)
		SetTextMiddleScreenXDispH1(pauseTitle1)
		SetTextMiddleScreenXDispH1(pauseDesc1)
		SetTextMiddleScreenXDispH2(pauseTitle2)
		SetTextMiddleScreenXDispH2(pauseDesc2)
		
		SetTextAngle(pauseTitle2, 0)
		SetTextAngle(pauseDesc2, 0)
		
		if spType = CLASSIC
			for i = pauseTitle1 to pauseDesc2
				if Mod(i, 2)
					IncTextX(i, -65)
				else
					IncTextX(i, 65)
				endif
				if i < pauseDesc1
					IncTextY(i, 65)
				else
					IncTextY(i, 40)
				endif
				SetTextSize(i, GetTextSize(i)-3)
				SetTextSpacing(i, GetTextSpacing(i))
			next i
			SetTextLineSpacing(pauseTitle2, -10)
			//IncTextY(pauseTitle1, -30)
			IncTextY(pauseDesc2, 20)
		endif
		
	endif
	
	if spType = STORYMODE
		SetTextFontImage(pauseTitle2, fontDescI)
		SetTextSpacing(pauseTitle2, -25)
		
		SetTextString(pauseTitle2, Str(curChapter) + " - " + chapterTitle[curChapter])
		SetTextString(pauseDesc2, chapterDesc[curChapter])
		if dispH
			IncTextY(pauseTitle2, 20)
			IncTextY(pauseDesc2, 20)
			
		endif
		
		if dispH = 0
			SetTextAngle(pauseTitle2, 0)
			SetTextAngle(pauseDesc2, 0)
			
			SetTextY(pauseTitle2, 180)
			SetTextY(pauseDesc2, 380)
		endif
	endif
	
	
endfunction

function UnpauseGame()
	
	TurnOffSelect()
	TurnOffSelect2()
	
	DeleteSprite(SPR_SETTINGS)
	if dispH then DeleteSprite(SPR_CONTROLS)
	
	//Only playing the button sound if the game wasn't exited
	if GetParticlesExists(11) = 0 then PlaySoundR(buttonSound, 100)
	
	SetSpriteVisible(pauseButton, 1)
	if GetSpriteExists(phantomPauseButton) then SetSpriteVisible(phantomPauseButton, 1)
	SetSpriteVisible(playButton, 0)
	SetSpriteVisible(exitButton, 0)
	SetSpriteVisible(mainmenuButton, 0)
	if GetSpriteExists(phantomExitButton) then SetSpriteVisible(phantomExitButton, 0)
	
	
	for i = pauseTitle1 to pauseDesc2
		DeleteText(i)
	next i
	
	iEnd = 5/fpsr#
	for i = iEnd to 1 step -1
		SetSpriteColorAlpha(curtain, 255.0*i/iEnd)
		SetSpriteColorAlpha(curtainB, 255.0*i/iEnd)
		SyncG()
	next i
	
	DeleteSprite(curtain)
	DeleteSprite(curtainB)
	ClearMultiTouch()
	
endfunction

//Functions that are used by both games are down below

function CreateExp(metSpr, metType, planetNum)
	iEnd = 1 + planetNum //The default experience amount, for regular meteors
	if metType = 2 then iEnd = 2 + planetNum
	if metType = 3 then iEnd = 3 + planetNum
	
	

	for i = 1 to iEnd
		CreateSprite(expSprNum, starParticleI)
		SetSpriteSize(expSprNum, 16*gameScale#, 16*gameScale#)
		SetSpritePosition(expSprNum, GetSpriteMiddleX(metSpr) - GetSpriteWidth(expSprNum)/2, GetSpriteMiddleY(metSpr) - GetSpriteHeight(expSprNum)/2)
		SetSpriteColor(expSprNum, 255, 255, 0, 5)
		SetSpriteAngle(expSprNum, Random(1, 360))
		SetSpriteDepth(expSprNum, 7)

		expList.insert(expSprNum)
		inc expSprNum
		if expSprNum = 3000 then expSprNum = 2001
	next i

endfunction

function UpdateExp()

	deleted = 0

	for i = 1 to expList.Length
		spr = expList[i]

		IncSpriteAngle(spr, 20*fpsr#)

		alpha = GetSpriteColorAlpha(spr)
		if alpha < 255
			IncSpritePosition(spr, (255-alpha)/18*fpsr#*cos(GetSpriteAngle(spr))*gameScale#, (255-alpha)/18*fpsr#*sin(GetSpriteAngle(spr))*gameScale#)

			SetSpriteColorAlpha(spr, GetSpriteColorAlpha(spr) + 10)
		endif

		//Collision for the first/bottom crab
		//dis1 = GetSpriteDistance(spr, crab1)
		if GetSpriteDistance(spr, crab1) < 50*gameScale#
			IncSpritePosition(spr, -(0-(GetSpriteMiddleX(crab1)-GetSpriteX(spr)))/4.0*fpsr#, -(0-(GetSpriteMiddleY(crab1)-GetSpriteY(spr)))/4.0*fpsr#)
			//GlideToSpot(spr, GetSpriteMiddleX(crab1), GetSpriteMiddleY(crab1), 5)
			//Either gliding method above works, I like the way the one on top looks more

			//Visual Indicator
			if GetSpriteColorGreen(spr) > 90
				SetSpriteColorGreen(spr, GetSpriteColorGreen(spr) - 40*fpsr#)
			endif

			//This is only for the bottom crab
			if GetSpriteCollision(spr, crab1) and deleted = 0
				deleted = i
				DeleteSprite(spr)

				if expTotal1 < specialCost1
					inc expTotal1, 1
				endif
				
				UpdateButtons1()	
				
				//For second crab, have a different kind pf exp sound //nah
				rnd = Random(0, 4)
				PlaySoundR(exp1S + rnd, 40)

				//This is for instant bar size adjustment
				//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)

				//Add to the exp bar here
				//Todo: Sound effect
			endif


		endif
		
		//Collision for the second/top crab
		//dis1 = GetSpriteDistance(spr, crab2)
		if deleted = 0
			if GetSpriteDistance(spr, crab2) < 50
				IncSpritePosition(spr, -(0-(GetSpriteMiddleX(crab2)-GetSpriteX(spr)))/4.0*fpsr#, -(0-(GetSpriteMiddleY(crab2)-GetSpriteY(spr)))/4.0*fpsr#)
				//GlideToSpot(spr, GetSpriteMiddleX(crab2), GetSpriteMiddleY(crab2), 5)
				//Either gliding method above works, I like the way the one on top looks more
	
				//Visual Indicator
				if GetSpriteColorGreen(spr) > 90
					SetSpriteColorGreen(spr, GetSpriteColorGreen(spr) - 40*fpsr#)
				endif
	
				//This is only for the top crab
				if GetSpriteCollision(spr, crab2) and deleted = 0
					deleted = i
					DeleteSprite(spr)
	
					if expTotal2 < specialCost2
						inc expTotal2, 1
					endif
					
					UpdateButtons2()	
					
					//For second crab, have a different kind pf exp sound??
					rnd = Random(0, 4)
					PlaySoundR(exp1S + rnd, 40)
	
					//This is for instant bar size adjustment
					//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)
	
					//Add to the exp bar here
					//Todo: Sound effect
				endif
	
	
			endif
		endif

	next i

	//Player 1 EXP
	SetSpriteScissor(expBar1, 0, 0, GetSpriteWidth(expHolder1)+GetSpriteX(expHolder1), h)
	GlideToX(expBar1, GetSpriteX(expHolder1) + (GetSpriteWidth(expHolder1))*(1.0*expTotal1/specialCost1), 2)
	
	if (GetSpriteX(expBar1) + .116*GetSpriteWidth(expHolder1)*2/3) >= GetSpriteX(specialButton1) and expTotal1 <> specialCost1
		expTotal1 = specialCost1
		UpdateButtons1()
	endif
	
	//Player 2 EXP
	if dispH = 0
		SetSpriteScissor(expBar2, GetSpriteX(expHolder1), 0, w, h)
		GlideToX(expBar2, GetSpriteX(expHolder2) - (GetSpriteWidth(expHolder2))*(1.0*expTotal2/specialCost2), 2)
		
		if (GetSpriteX(expBar2) - .116*GetSpriteWidth(expHolder2)*2/3) + GetSpriteWidth(expHolder2) <= GetSpriteX(specialButton2) + GetSpriteWidth(specialButton2) and expTotal2 <> specialCost2
			expTotal2 = specialCost2
			UpdateButtons2()
		endif
	endif
	
	if dispH
		SetSpriteScissor(expBar2, 0, 0, GetSpriteWidth(expHolder2)+GetSpriteX(expHolder2), h)
		GlideToX(expBar2, GetSpriteX(expHolder2) + (GetSpriteWidth(expHolder2))*(1.0*expTotal2/specialCost2), 2)
		
		if (GetSpriteX(expBar2) + .116*GetSpriteWidth(expHolder2)*2/3) >= GetSpriteX(specialButton2) and expTotal2 <> specialCost2
			expTotal2 = specialCost2
			UpdateButtons2()
		endif
	endif

	if deleted > 0
		expList.remove(deleted)
	endif

endfunction

//This deletes all experience on half of the board
function DeleteHalfExp(gameNum)
	badLeave = 1
	while badLeave = 1
		
		badLeave = 0
		deleted = 0
		
		for i = 1 to expList.Length
			
			spr = expList[i]
			if gameNum = 1
				//This is only for the bottom crab
				if ((dispH = 0 and GetSpriteY(spr) > h/2) or (dispH and GetSpriteX(spr) < w/2)) and deleted = 0
					deleted = i
					DeleteSprite(spr)
					badLeave = 1
				endif
			endif
			
			if gameNum = 2
				//This is only for the top crab
				if ((dispH = 0 and GetSpriteY(spr) < h/2) or (dispH and GetSpriteX(spr) > w/2)) and deleted = 0
					deleted = i
					DeleteSprite(spr)
					badLeave = 1
				endif
			endif
			
		next i
		
		if deleted > 0
			expList.remove(deleted)
		endif
	endwhile
endfunction

function FreezeGameAnimations()
	//Pausing the current animations
	StopSprite(crab1)
	StopSprite(crab2)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		StopSprite(meteorActive2[i].spr)
	next i
	for i = par1met1 to par2spe1
		SetParticlesActive(i, 0)
	next i
	
	//StopSprite(expBar1)
	//StopSprite(expBar2)
	//StopSprite(expHolder1)
	//StopSprite(expHolder2)
	
endfunction

function ResumeGameAnimations()
	//Resuming the current animations
	ResumeSprite(crab1)
	ResumeSprite(crab2)
	for i = 1 to meteorActive1.length
		ResumeSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		ResumeSprite(meteorActive2[i].spr)
	next i
	for i = par1met1 to par2spe1
		SetParticlesActive(i, 1)
	next i
	
	//PlaySprite(expBar1)
	//PlaySprite(expBar2)
	//PlaySprite(expHolder1)
	//PlaySprite(expHolder2)
endfunction

function ShowSpecialAnimation(crabType, crabAlt, playerNum, fast)
	
	fpsr# = 60.0/ScreenFPS()
	
	PlaySoundR(specialS, 40)
	
	//Pausing the current animations
	FreezeGameAnimations()
	
	
	CreateSprite(specialBG, 0)
	SetSpriteColor(specialBG, 0, 0, 0, 80)
	SetSpriteSizeSquare(specialBG, h*3)
	SetSpriteMiddleScreen(specialBG)
	SetSpriteDepth(specialBG, 3)
	
	wid = 400
	hei = 400
	specSize = 600
	
	for i = specialSprFront1 to specialSprBack2
		CreateSprite(i, 0)
		SetSpriteSizeSquare(i, specSize)
		//SetSpriteSizeSquare(i, 400)
		if Mod(i, 2) = 0
			//Back Sprites
			SetSpriteDepth(i, 2)
			SetSpriteColor(i, 220, 220, 220, 255)
			SetSpriteSizeSquare(i, specSize)
			//SetSpriteSizeSquare(i, 300)	//Smaller at Brad's request
			SetSpriteImage(i, crab1attack2I - 1 + playerNum)
			if crabType = 4
				SetSpriteSizeSquare(i, specSize*1.4)
				SetSpriteColor(i, 255, 255, 255, 0)
			endif
		else
			//Front Sprites
			SetSpriteDepth(i, 1)
			SetSpriteImage(i, crab1attack1I - 1 + playerNum)
		endif
		
		if i >= specialSprFront2 then SetSpriteAngle(i, 180)
		
	next i
	animType = 0
	if (crabType = 5 and crabAlt = 3) or (crabType = 3 and crabAlt = 0) or (crabType = 5 and crabAlt = 0) or (crabType = 2 and crabAlt = 2) or (crabType = 6 and crabAlt = 2) or (crabType = 5 and crabAlt = 2) or (crabType = 3 and crabAlt = 2)
		SetFolder("/media/art")
		LoadSprite(specialSprBacker1, "crab" + str(crabType) + AltStr(crabAlt) + "attack3.png")
		LoadSprite(specialSprBacker2, "crab" + str(crabType) + AltStr(crabAlt) + "attack3.png")
		SetSpriteAngle(specialSprBacker1, 180)
		SetSpriteAngle(specialSprBacker2, 180)
		SetSpriteDepth(specialSprBacker1, 3)
		SetSpriteDepth(specialSprBacker2, 3)
		SetSpriteSizeSquare(specialSprBacker1, specSize)
		SetSpriteSizeSquare(specialSprBacker2, specSize)
		animType = 1
	endif
	if (crabType = 4) or (crabType = 3 and crabAlt = 3) then animType = 2
	
	//Offsetting the clock hands so that they rotate properly
	if crabType = 5 and crabAlt = 0
		SetSpriteOffset(specialSprFront1, specSize*700/1356.0, specSize*932/1356.0)
		SetSpriteOffset(specialSprBack1, specSize*700/1356.0, specSize*932/1356.0)
		SetSpriteOffset(specialSprFront2, specSize*700/1356.0, specSize*932/1356.0)
		SetSpriteOffset(specialSprBack2, specSize*700/1356.0, specSize*932/1356.0)
	endif
	offsetY = 30
	
	//For crab specials that move: 1, 2, 4, 6
	//Goes from right to left on bottom
	SetSpritePosition(specialSprFront1, -100 - specSize, h - 700 - offsetY)
	//Goes from left to right on bottom
	SetSpritePosition(specialSprBack1, w + 100, h - 700 - offsetY)
	//SetSpritePosition(specialSprBack1, w + 100, h - 650 - offsetY)
	
	//Goes from right to left on top
	SetSpritePosition(specialSprFront2, w + 100, 100 + offsetY)
	//Goes from left to right on top
	SetSpritePosition(specialSprBack2, -100 - specSize, 100 + offsetY)
	//SetSpritePosition(specialSprBack2, -100 - specSize, 250 + offsetY)
	
	if (crabType = 4) or (crabType = 3 and crabAlt = 3)
		SetSpritePosition(specialSprBack2, -100 - specSize, 100 + offsetY - specSize*0.4)
		SetSpritePosition(specialSprFront2, w + 100, 30 + offsetY)
		SetSpritePosition(specialSprFront1, -100 - specSize, h - 700 - offsetY + 70)
	endif
	
	//The text for the special
	
	tDir = 1
	
	for i = specialSprFront1 to specialSprFront2 step 2
		CreateText(i, "")
		SetTextFontImage(i, fontSpecialI)
		SetTextAlignment(i, 1)
		SetTextSize(i, 106)
		SetTextPosition(i, 2000*tDir, 1490)
		if i = specialSprFront2
			SetTextX(i, -2000*tDir)
			SetTextY(i, h - 1490 )
			SetTextAngle(i, 180)
		endif
		SetTextDepth(i, 1)
		SetTextSpacing(i, -20)
		SetTextString(i, Upper(GetSpecialName(crabType + crabAlt*6)))
		if crabType = 4 and crabAlt = 3 and ((crab1Evil and playerNum = 1) or (crab2Evil and playerNum = 2)) then  SetTextString(i, Upper(GetSpecialName(25)))
	next i
	
	
	
	iEnd = 120/fpsr#
	if fast
		iEnd = 80/fpsr#
		fastM# = 1.5 //This makes the animations multiplicable
	else
		fastM# = 1
	endif
	
	if dispH or spType = STORYMODE
		iEnd = iEnd * 1.2
		SetSpriteVisible(specialSprFront2, 0)
		SetSpriteVisible(specialSprBack2, 0)
		if GetSpriteExists(specialSprBacker2) then SetSpriteVisible(specialSprBacker2, 0)
		SetTextVisible(specialSprFront2, 0)
		SetTextSize(specialSprFront1, GetTextSize(specialSprFront2) + 20)
		SetTextY(specialSprFront1, h-20-GetTextSize(specialSprFront2))
		if spType = STORYMODE and dispH = 0
			SetSpriteMiddleScreenY(specialSprFront1)
			SetSpriteMiddleScreenY(specialSprBack1)
			if GetSpriteExists(specialSprBacker1) then SetSpriteMiddleScreenY(specialSprBacker1)
			SetTextY(specialSprFront1, h/2 + GetSpriteHeight(specialSprFront1)/2)
			SetTextSize(specialSprFront1, GetTextSize(specialSprFront2))
		endif
		if animType = 1
			SetSpriteFlip(specialSprBacker1, 0, 1)
			SetSpriteMiddleScreen(specialSprFront1)
			SetSpriteMiddleScreen(specialSprBack1)
			SetSpriteMiddleScreen(specialSprBacker1)
		endif
	endif
	
	
	for i = 1 to iEnd
		
		if i <= iEnd*1/4 and i > 20
			/*if deviceType = DESKTOP
				if GetPointerPressed() and GetPointerY() > h/2 then buffer1 = 1
				if GetPointerPressed() and GetPointerY() < h/2 then buffer2 = 1
			elseif deviceType = MOBILE
				if GetMultitouchPressedBottom() then buffer1 = 1
				if GetMultitouchPressedTop() then buffer2 = 1
			endif*/
		endif
		
		//Setting the speed of the images based on the progress through the loop
		if i <= iEnd*1/9
			speed = 25*fpsr#*75/60 * fastM#
		elseif i <= iEnd*6/9
			speed = 3*fpsr#*75/60 * fastM#
		else
			speed = 5+(i-iEnd*6/9)*fpsr#*75/60 * fastM#
		endif
		
		if i = iEnd*2/3 then PlaySoundR(specialExitS, 40)
		
		if animType = 0
			/*
			if crabType <> 2
				IncSpriteXFloat(specialSprFront1, -1.2*speed)
				IncSpriteXFloat(specialSprBack1, 1*speed)
				IncSpriteXFloat(specialSprFront2, 1.2*speed)
				IncSpriteXFloat(specialSprBack2, -1*speed)
			else */
				//For wizard crab's positioning
				IncSpriteXFloat(specialSprFront1, 1.3*speed)
				IncSpriteXFloat(specialSprBack1, -1.4*speed)
				IncSpriteXFloat(specialSprFront2, -1.3*speed)
				IncSpriteXFloat(specialSprBack2, 1.4*speed)
			//endif
		endif
		
		if animType = 2
			SetSpriteMiddleScreenX(specialSprBack1)
			SetSpriteMiddleScreenX(specialSprBack2)
			
			if i < iEnd*1/9
				FadeSpriteOut(specialSprBack1, i, 0, iEnd*1/9)
				FadeSpriteOut(specialSprBack2, i, 0, iEnd*1/9)
			elseif i >= iEnd*28/29
				SetSpriteColorAlpha(specialSprBack1, 0)
				SetSpriteColorAlpha(specialSprBack2, 0)
				
			elseif i > iEnd*8/9
				FadeSpriteIn(specialSprBack1, i, iEnd*8/9, iEnd)
				FadeSpriteIn(specialSprBack2, i, iEnd*8/9, iEnd)
			
			else
				SetSpriteColorAlpha(specialSprBack1, 255)
				SetSpriteColorAlpha(specialSprBack2, 255)
			endif
			
			IncSpriteXFloat(specialSprFront1, 1.3*speed)
			IncSpriteXFloat(specialSprFront2, -1.3*speed)
			
		endif
		
		//Top crab & Chrono crab
		if animType = 1
			cake = 0
			if crabType = 5 and crabAlt = 3 then cake = 1
			if cake
				if dispH then SetSpriteFlip(specialSprBacker1, 1, 1)
				MatchSpritePosition(specialSprBack1, specialSprBacker1)
				MatchSpritePosition(specialSprFront1, specialSprBacker1)
				MatchSpritePosition(specialSprBack2, specialSprBacker2)
				MatchSpritePosition(specialSprFront2, specialSprBacker2)
			endif
			
			if i = 1
				if dispH = 0 and spType <> STORYMODE
					DrawPolar1(specialSprFront1, 0, 270)
					DrawPolar1(specialSprBack1, 0, 270)
					DrawPolar1(specialSprBacker1, 0, 270)
					DrawPolar2(specialSprFront2, 0, 90)
					DrawPolar2(specialSprBack2, 0, 90)
					DrawPolar2(specialSprBacker2, 0, 90)
				endif
				
				if crabType = 5
					IncSpritePosition(specialSprFront2, -2*(specSize*700/1356.0 - specSize/2)-500*dispH, -2*(specSize*932/1356.0 - specSize/2))
					IncSpritePosition(specialSprBack2, -2*(specSize*700/1356.0 - specSize/2)-500*dispH, -2*(specSize*932/1356.0 - specSize/2))
					if dispH or spType = STORYMODE
						IncSpriteX(specialSprFront1, -2*(specSize*700/1356.0 - specSize/2)-1*dispH)
						IncSpriteX(specialSprBack1, -2*(specSize*700/1356.0 - specSize/2)-1*dispH)
					endif
				endif
			endif
				
			for j = specialSprFront1 to specialSprBacker2
				if cake and i < iEnd*1/9 and (j <> specialSprBacker1 and j <> specialSprBacker2) then continue
				if i < iEnd*1/9
					FadeSpriteOut(j, i, 0, iEnd*1/9)
					FadeSpriteOut(j, i, 0, iEnd*1/9)
				elseif i >= iEnd*28/29
					SetSpriteColorAlpha(j, 0)
					SetSpriteColorAlpha(j, 0)
					
				elseif i > iEnd*8/9
					FadeSpriteIn(j, i, iEnd*8/9, iEnd)
					FadeSpriteIn(j, i, iEnd*8/9, iEnd)
				
				else
					SetSpriteColorAlpha(j, 255)
					SetSpriteColorAlpha(j, 255)
				endif	
			next j
			
			if cake and i < iEnd*8/9
				for j = specialSprFront1 to specialSprBacker2
					if (j = specialSprBacker1 or j = specialSprBacker2) then continue
					SetSpriteColorAlpha(j, 255-255.0*i/(iEnd*8/9))
				next j
				
				if i <= iEnd/29
					for j = specialSprFront1 to specialSprBacker2
						SetSpriteColorAlpha(j, 0)
					next j
				endif
					
			endif
			if cake and i > iEnd*8/9-1
				SetSpriteVisible(specialSprFront1, 0)
				SetSpriteVisible(specialSprBack1, 0)
				SetSpriteVisible(specialSprFront2, 0)
				SetSpriteVisible(specialSprBack2, 0)
			endif
			
			
			if cake = 0
				//Making the components bigger, and also repositioning the top
				IncSpriteSizeCentered(specialSprBacker1, 1*fpsr#)
				IncSpriteSizeCentered(specialSprBacker2, 1*fpsr#)
				IncSpriteSizeCentered(specialSprBack1, 1*fpsr#)
				IncSpriteSizeCentered(specialSprBack2, 1*fpsr#)
				IncSpriteSizeCentered(specialSprFront1, 1*fpsr#)
				IncSpriteSizeCentered(specialSprFront2, 1*fpsr#)
				if crabType = 5
					IncSpritePosition(specialSprFront2, -.125*fpsr#, -.25*fpsr#)
					IncSpritePosition(specialSprBack2, -.125*fpsr#, -.25*fpsr#)
					if dispH or spType = STORYMODE
						IncSpritePosition(specialSprFront1, -.125*fpsr#, .25*fpsr#*0)
						IncSpritePosition(specialSprBack1, -.125*fpsr#, .25*fpsr#*0)
					endif
				endif
				
				//Goes around once for top, 3 times for chrono
				for j = 2 to 4
					//TODO: Make this display right
					IncSpriteAngle(specialSprFront1, -1*fpsr# - i/(25.0)*fpsr#)
					IncSpriteAngle(specialSprFront2, -1*fpsr# - i/(25.0)*fpsr#)
					IncSpriteAngle(specialSprBack1, 1.5*fpsr# + i/(25.0)*fpsr#)
					IncSpriteAngle(specialSprBack2, 1.5*fpsr# + i/(25.0)*fpsr#)
				next j 
			endif
			
		endif
		
		if i < iEnd*5/7
			GlideTextToX(specialSprFront1, w/2, 6)
			GlideTextToX(specialSprFront2, w/2, 6)
		else
			GlideTextToX(specialSprFront1, -2000*tDir, 30)
			GlideTextToX(specialSprFront2, 2000*tDir, 30)
		endif
		
		//Special coloring for the letters
		for j = specialSprFront1 to specialSprFront2 step 2
			for k = 0 to GetTextLength(j)
				SetTextCharColor(j, k, GetColorByCycle(i*1.1 + k*10, "r"), GetColorByCycle(i*1.1 + k*10, "g"), GetColorByCycle(i*1.1 + k*10, "b"), 255)
			next k
		next j
	
		SyncG()
	next i
	

	
	
	for i = specialBG to specialSprBacker2
		if GetSpriteExists(i) then DeleteSprite(i)
	next i
	
	//Resuming the current animations
	ResumeGameAnimations()
	for i = specialSprFront1 to specialSprFront2 step 2
		DeleteText(i)
	next i
	
	ClearMultiTouch()
	
	SetFolder("/media")
	
endfunction

function InitAttackParticles()
	//This makes sure the particles are only created once
	if GetParticlesExists(par1met1) = 0
		
		SetFolder("/media")
		
		img = LoadImage("envi/explode.png")
		lifeEnd# = 1.2
		//lifeEnd# = 2.2
		
		for i = par1met1 to par2spe1
			CreateParticles(i, 2000, 2000)	//This is out of range so that
    		SetParticlesImage (i, img)
			SetParticlesFrequency(i, 300)
			SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
			SetParticlesSize(i, 20*gameScale#)
			SetParticlesStartZone(i, -metSizeX/4, -metSizeX/4, metSizeX/4, metSizeX/4) //The box that the particles can start from
			//SetParticlesStartZone(i, -5, -5, 5, 5) //The box that the particles can start from
    		SetParticlesDirection(i, 30, 20)
    		SetParticlesAngle(i, 360)
    		//SetParticlesVelocityRange (i, 1.8, 3.5 )
    		SetParticlesVelocityRange (i, 0.8, 2.5 )
    		SetParticlesMax (i, 100)
    		SetParticlesDepth(i, 25)
    		
    		meteorAlpha = 150
    		
    		 if Mod(i, 4) = 1
				AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, meteorAlpha )
				AddParticlesColorKeyFrame (i, 0.01, 255, 255, 0, meteorAlpha )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			elseif Mod(i, 4) = 2
				AddParticlesColorKeyFrame (i, 0.0, 0, 0, 239, meteorAlpha )
				AddParticlesColorKeyFrame (i, 0.01, 239, 0, 239, meteorAlpha )
				AddParticlesColorKeyFrame (i, lifeEnd#, 30, 50, 180, 0 )
			elseif Mod(i, 4) = 3
				AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, meteorAlpha )
				AddParticlesColorKeyFrame (i, 0.01, 255, 100, 100, meteorAlpha )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			elseif Mod(i, 4) = 0
				//For the special wizard sparkles
				SetParticlesImage (i, expOrbI)
				SetParticlesPosition (i, w/2, h*3/4 - h/2*(i/4-1))	//Places them on different screen centers
				SetParticlesFrequency(i, 60)
	    		SetParticlesMax(i, 0)
				SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
				SetParticlesSize(i, 8)
				SetParticlesStartZone(i, -w/2, -h/4, w/2, h/4) //The box that the particles can start from
	    		SetParticlesDirection(i, 0, 5)
	    		SetParticlesAngle(i, 360)
	    		SetParticlesVelocityRange (i, .1, .6)
	    		SetParticlesDepth(i, 5)
	    		
	    		AddParticlesColorKeyFrame (i, 0.0, 255, 255, 100, 0 )
				AddParticlesColorKeyFrame (i, .6, 255, 255, 100, meteorAlpha )
				AddParticlesColorKeyFrame (i, lifeEnd#, 205, 205, 50, 0 )
    		endif
		next i
		
		par = parAttack
		lifeEnd# = .4
		CreateParticles(par, 2000, 2000)	//This is out of range of visibility
		SetParticlesImage (par, attackPartI)
		SetParticlesFrequency(par, 100)
		SetParticlesLife(par, lifeEnd#)	//Time in seconds that the particles stick around
		SetParticlesSize(par, 70)
		SetParticlesStartZone(par, 0, 0, 0, 0)
		SetParticlesDirection(par, 0, 1)
		SetParticlesVelocityRange(par, 700, 700)
		SetParticlesAngle(par, 0)
		SetParticlesMax (par, 1)
		SetParticlesDepth(par, GetSpriteDepth(meteorButton2)+1)
		
		AddParticlesColorKeyFrame (par, 0.0, 255, 255, 255, 255 )
		AddParticlesColorKeyFrame (par, lifeEnd#/4, 255, 255, 255, 255)
		AddParticlesColorKeyFrame (par, lifeEnd#, 255, 255, 255, 0 )
	
	endif
	
	for i = par1met1 to par2spe1
		if i <> par1spe1 and i <> par2spe1
			SetParticlesSize(i, 20*gameScale#)
			SetParticlesDirection(i, 30*gameScale#, 20*gameScale#)
	    	SetParticlesVelocityRange (i, 0.8*gameScale#, 2.5*gameScale#)
	    	SetParticlesStartZone(i, -metSizeX/4*gameScale#, -metSizeX/4*gameScale#, metSizeX/4*gameScale#, metSizeX/4*gameScale#) //The box that the particles can start from
		endif
		if i = par1spe1
			if dispH
				SetParticlesPosition (i, w/4, h/2)
				SetParticlesStartZone(i, -w/2, -h/2, w/4, h/2)
			else
				SetParticlesPosition (i, w/2, h*3/4)
				SetParticlesStartZone(i, -w/2, -h/4, w/2, h/4)
			endif
		endif
		if i = par2spe1
			if dispH
				SetParticlesPosition (i, w*3/4, h/2)
				SetParticlesStartZone(i, -w/4, -h/2, w/4, h/2)
			else
				SetParticlesPosition (i, w/2, h/4)
				SetParticlesStartZone(i, -w/2, -h/4, w/2, h/4)
			endif
		endif
	next i
endfunction

function ActivateMeteorParticles(mType, spr, gameNum)

	par = mType + (gameNum-1)*4
	if mType <> 4
		//For general meteors
		SetParticlesPosition (par, GetSpriteMiddleX(spr), GetSpriteMiddleY(spr))
		ResetParticleCount (par)
	else
		//For wizard sparkles
		SetParticlesVisible(par, 1)
	    SetParticlesActive(par, 1)
		ResetParticleCount(par)
		SetParticlesMax(par, 480)
	endif    
 
endfunction



function GetCrabDefaultR(spr)
	//Returns the normal height that a crab will be at
	r# = planetSize/2*gameScale# + GetSpriteHeight(spr)/3
endfunction r#

function SetBGRandomPosition(spr)
	//Sets the background to a random angle/spot
	if dispH = 0
		SetSpriteSizeSquare(spr, w*2)
		if spr = bgGame1 then SetSpritePosition(spr, -1*w + Random(0, w), h/2)
		if spr = bgGame2 then SetSpritePosition(spr, -1*w + Random(0, w), h/2-GetSpriteHeight(spr))
	else
		SetSpriteSizeSquare(spr, h*2)
		if spr = bgGame1 then SetSpritePosition(spr, w/2-h*2, 0 - Random(0,h))
		if spr = bgGame2 then SetSpritePosition(spr, w/2, 0 - Random(0,h))
	endif
	SetSpriteAngle(spr, 90*Random(1, 4))
	
	if appState = CHARACTER_SELECT
		SetSpriteSizeSquare(spr, w)
		if spr = SPR_CS_BG_1
			SetSpriteAngle(spr, 0)
			SetSpritePosition(spr, 0, h/2)
		endif
		if spr = SPR_CS_BG_1B
			SetSpriteSizeSquare(spr, w*1.3)
			SetSpriteAngle(spr, 0)
			SetSpriteMiddleScreenX(spr)
			SetSpriteY(spr, h*3/4 - GetSpriteHeight(spr)/2-20)
		endif
		if spr = SPR_CS_BG_2
			SetSpritePosition(spr, 0, h/2-GetSpriteHeight(spr))
			SetSpriteAngle(spr, 180)
		endif
		if spr = SPR_CS_BG_2B
			SetSpriteSizeSquare(spr, w*1.3)
			SetSpriteAngle(spr, 180)
			SetSpriteMiddleScreenX(spr)
			SetSpriteY(spr, h/4 - GetSpriteHeight(spr)/2+20)
		endif
		//For the character selection
	endif
	
endfunction

function DisableAttackButtons()
	SetSpriteColor(meteorButton1, 100, 100, 100, 255)
	SetSpriteColor(specialButton1, 100, 100, 100, 255)
	SetSpriteColor(meteorButton2, 100, 100, 100, 255)
	SetSpriteColor(specialButton2, 100, 100, 100, 255)
endfunction

function EnableAttackButtons()
	UpdateButtons1()
	UpdateButtons2()
endfunction

//#constant

function CreateMeteor(gameNum, category, special)
	newMet as meteor
	newMet.cat = 0
	
	newMet.theta = Random(1, 360)
	newMet.r = metStartDistance
	newMet.spr = meteorSprNum
	newMet.cat = category
	
	CreateSprite(meteorSprNum, 0)
	SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
	SetSpriteDepth(meteorSprNum, 20)
	SetSpritePosition(meteorSprNum, 9999, 9999)
	
	if category = 1	//Normal
		SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
	elseif category = 2	//Spin
		SetSpriteSize(meteorSprNum, metSizeX*1.1, metSizeY*1.1)
		SetSpriteColor(meteorSprNum, 150, 40, 150, 255)
	elseif category = 3	//Fast
		newMet.r = 5000
		SetSpriteSize(meteorSprNum, metSizeX*1.2, metSizeY*1.2)
		SetSpriteColor(meteorSprNum, 235, 60, 60, 255)
		
		CreateSprite(meteorSprNum + 10000, meteorTractorI)
		SetSpriteSize(meteorSprNum + 10000, 1, 1000)
		SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
		SetSpriteDepth(meteorSprNum + 10000, 30)
		
	elseif category = 4	//Attack from other player (this 4 indexing is only used here)
		newMet.r = metStartDistance-50
		newMet.cat = 1
		SetSpriteColor(meteorSprNum, 40, 160, 255, 254)
		
		if gameNum = 1 then newMet.theta = crab1Theta# + Random(80, 100)*crab1Dir#*crab1Vel#
		if gameNum = 2 then newMet.theta = crab2Theta# + Random(80, 100)*crab2Dir#*crab2Vel#
		
	endif
	
	AddMeteorAnimation(meteorSprNum, 0)
	
	inc meteorSprNum, 1
	
	if gameNum = 1
		meteorActive1.insert(newMet)
	elseif gameNum = 2
		meteorActive2.insert(newMet)
	endif
	
endfunction

function AddMeteorAnimation(spr, animType)
	if fruitMode = 0 and (animType = 0 or animType = 3)
		AddSpriteAnimationFrame(spr, meteorI1)
		AddSpriteAnimationFrame(spr, meteorI2)
		AddSpriteAnimationFrame(spr, meteorI3)
		AddSpriteAnimationFrame(spr, meteorI4)
		PlaySprite(spr, 15, 1, 1, 4)
	elseif fruitMode = 1
		//FRUITALITY
		rnd = Random(0, 5)
		AddSpriteAnimationFrame(spr, fruit1I+rnd)
		PlaySprite(spr, 15, 0, 1, 1)
		//The red, green, and blue is set seperately so that we don't trigger any alpha changes
		SetSpriteColorRed(spr, 255)
		SetSpriteColorGreen(spr, 255)
		SetSpriteColorBlue(spr, 255)
	elseif animType = 1
		//King Crab cannonball
		AddSpriteAnimationFrame(spr, mAlt2aI)
		PlaySprite(spr, 15, 0, 1, 1)
		SetSpriteColorRed(spr, 255)
		SetSpriteColorGreen(spr, 255)
		SetSpriteColorBlue(spr, 255)
	elseif animType = 2
		//Crabacus numbers
		AddSpriteAnimationFrame(spr, mAlt1I + Random(0,8))
		PlaySprite(spr, 15, 0, 1, 1)
		SetSpriteColorRed(spr, 255)
		SetSpriteColorGreen(spr, 255)
		SetSpriteColorBlue(spr, 255)
	endif
	
	
	if Random(1, 2) = 2 and animType <> 2 then SetSpriteFlip(spr, 1, 0)
	
	SetSpriteShapeCircle(spr, 0, GetSpriteHeight(spr)/8, GetSpriteWidth(spr)/2.8)
	
	CreateMeteorGlow(spr, animType)
endfunction

function CreateMeteorGlow(spr, animType)
	mult# = 1.6	
	CreateSprite(spr+glowS, meteorGlowI)
	SetSpritePosition(spr+glowS, 9999, 9999)
	SetSpriteSize(spr+glowS, GetSpriteWidth(spr)*mult#, GetSpriteHeight(spr)*mult#)
	SetSpriteDepth(spr+glowS, 21)
	SetSpriteColor(spr+glowS, GetSpriteColorRed(spr), GetSpriteColorGreen(spr), GetSpriteColorBlue(spr), 255)
	if fruitMode = 1
		AddSpriteAnimationFrame(spr+glowS, flameI1)
		AddSpriteAnimationFrame(spr+glowS, flameI2)
		AddSpriteAnimationFrame(spr+glowS, flameI3)
		AddSpriteAnimationFrame(spr+glowS, flameI4)
		PlaySprite(spr+glowS, 15, 1, 1, 4)
		if GetSpriteImageID(spr) = fruit1I then SetSpriteColor(spr+glowS, 0, 51, 204, 255)
		if GetSpriteImageID(spr) = fruit2I then SetSpriteColor(spr+glowS, 255, 9, 9, 255)
		if GetSpriteImageID(spr) = fruit3I then SetSpriteColor(spr+glowS, 122, 244, 0, 255)
		if GetSpriteImageID(spr) = fruit4I then SetSpriteColor(spr+glowS, 255, 51, 133, 255)
		if GetSpriteImageID(spr) = fruit5I then SetSpriteColor(spr+glowS, 255, 255, 0, 255)
		if GetSpriteImageID(spr) = fruit6I then SetSpriteColor(spr+glowS, 168, 36, 255, 255)
		
		if GetSpriteFlippedH(spr) then SetSpriteFlip(spr+glowS, 1, 0)
		
		SetSpriteSize(spr+glowS, GetSpriteWidth(spr), GetSpriteHeight(spr))
	elseif animType = 1
		//King Crab
		AddSpriteAnimationFrame(spr+glowS, flameI1)
		AddSpriteAnimationFrame(spr+glowS, flameI2)
		AddSpriteAnimationFrame(spr+glowS, flameI3)
		AddSpriteAnimationFrame(spr+glowS, flameI4)
		PlaySprite(spr+glowS, 15, 1, 1, 4)
		SetSpriteColor(spr+glowS, 255, 30, 0, 255)
		if GetSpriteFlippedH(spr) then SetSpriteFlip(spr+glowS, 1, 0)
		
		SetSpriteSize(spr+glowS, GetSpriteWidth(spr), GetSpriteHeight(spr))
	elseif animType = 2
		//Crabacus
		AddSpriteAnimationFrame(spr+glowS, flameI1)
		AddSpriteAnimationFrame(spr+glowS, flameI2)
		AddSpriteAnimationFrame(spr+glowS, flameI3)
		AddSpriteAnimationFrame(spr+glowS, flameI4)
		PlaySprite(spr+glowS, 15, 1, 1, 4)
		SetSpriteColor(spr+glowS, 255, 255, 255, 255)
		SetSpriteSize(spr+glowS, GetSpriteWidth(spr), GetSpriteHeight(spr))
	endif
endfunction

function UpdateSPScore(added)
	size = GetTextSize(TXT_SP_SCORE)
	maxSize = 95
	//The rainbows if the score is high enough
	if spScore > 24
		
		speed = 2
		if spScore > 49 then speed = 3
		if spScore > 74 then speed = 4
		if spScore > 99 then speed = 5
		if spScore > 124 then speed = 6
		if spScore > 149 then speed = 7
		if spScore > 174 then speed = 8
		if spScore > 199 then speed = 90
		
		for i = 0 to Len(GetTextString(TXT_SP_SCORE))
			SetTextCharColor(TXT_SP_SCORE, i, GetColorByCycle(gameTimer#*(speed/2) - i*speed, "r"), GetColorByCycle(gameTimer#*(speed/2) - i*speed, "g"), GetColorByCycle(gameTimer#*(speed/2) - i*speed, "b"), 255)
			SetTextCharColor(TXT_SP_SCORE, i, (GetTextCharColorRed(TXT_SP_SCORE, i))*2/3 + 85, (GetTextCharColorGreen(TXT_SP_SCORE, i))*2/3 + 85, (GetTextCharColorBlue(TXT_SP_SCORE, i))*2/3 + 85, 255)
		next i
		
		
	
	endif
	//SetTextColorByCycle(TXT_SP_SCORE, gameTimer#)
	//SetTextColor(TXT_SP_SCORE, (GetTextColorRed(TXT_SP_SCORE))/3 * (10+size-spScoreMinSize)/10, (GetTextColorGreen(TXT_SP_SCORE))/3* (10+size-spScoreMinSize)/10, (GetTextColorBlue(TXT_SP_SCORE))/3* (10+size-spScoreMinSize)/10, 255)
	if added = 1 or added = 2
		//When the score is going up
		SetTextString(TXT_SP_SCORE, "Score: " + str(spScore))
		SetTextString(TXT_SP_DANGER, "Danger: " + str(gameDifficulty1))
		
		//SetTextColor(TXT_SP_DANGER, 255, 255-(gameDifficulty1-1)*240/7.0, 255-(gameDifficulty1-1)*240/7.0, 255)
		if gameDifficulty1 = difficultyMax
			SetTextString(TXT_SP_DANGER, "MAX DANGER")
			if spType = MIRRORMODE
				SetTextSize(TXT_SP_DANGER, 58-dispH*10)
				SetTextY(TXT_SP_DANGER, h/2 - GetTextSize(TXT_SP_DANGER)/2)
				SetTextX(TXT_SP_DANGER, 622)
			endif
		endif
		
		if spScore > spHighScore
			
		endif
		
		
		if spScore = storyMinScore and storyActive then PlaySoundR(rainbowSweepS, 100)
		
	endif
	
	if spScore >= storyMinScore and storyActive
		for i = 7 to Len(GetTextString(TXT_SP_SCORE))
			SetTextCharColor(TXT_SP_SCORE, i, 50, 255, 50, 255)
		next i
	endif
	
	//The flashing warning text
	SetTextColor(TXT_SP_DANGER, 255, 160 - 10*(gameDifficulty1) + (0.0+10*gameDifficulty1)*sin(gameTimer#*(5+gameDifficulty1)), 160 - 10*(gameDifficulty1) + (0.0+10*gameDifficulty1)*sin(gameTimer#*(5+gameDifficulty1)), 255)
	
endfunction

function InitJumpParticles()
	
	lifeEnd# = .6
	
	//This makes sure the particles are only created once
	if GetParticlesExists(par1jump) = 0
			
		CreateParticles(par1jump, 2000, 2000)
		CreateParticles(par2jump, 2000, 2000)
				
	endif
	
	for i = par1jump to par2jump
		cType = 0
		if i = par1jump then cType = crab1Type + crab1Alt*10
		if i = par2jump then cType = crab2Type + crab2Alt*10
		
		SetParticlesPosition(i, 2000, 2000)
		
		ClearParticlesColors(i)
		SetParticlesFrequency(i, 300)
		SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
		SetParticlesSize(i, 10*gameScale#)
		SetParticlesStartZone(i, -5*gameScale#, -5*gameScale#, 5*gameScale#, 5*gameScale#) //The box that the particles can start from
		SetParticlesDirection(i, 100*gameScale#, 100*gameScale#)
		SetParticlesAngle(i, 10)
		SetParticlesVelocityRange (i, 0.8*gameScale#, 2.5*gameScale#)
		SetParticlesMax (i, 100)
		SetParticlesDepth(i, 25)
		
		if cType = 1
			AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 255, 255, 0, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 255, 0, 0 )
			SetParticlesRotationRange(i, 710, 890)
			SetParticlesSize(i, 8)
			SetParticlesFrequency(i, 200)
			SetParticlesMax (i, 50)
			SetParticlesAngle(i, 40)
		elseif cType = 11	//Mad Crab
			AddParticlesColorKeyFrame (i, 0.0, 255, 155, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 255, 40, 0, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 40, 0, 0 )
			SetParticlesRotationRange(i, 1710, 1890)
			SetParticlesSize(i, 7)
			SetParticlesFrequency(i, 260)
			SetParticlesMax (i, 70)
			SetParticlesAngle(i, 30)
		elseif cType = 21	//Al Legal
			AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 0, 0, 255, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#, 0, 0, 255, 0 )
			SetParticlesDirection(i, 120*gameScale#, 120*gameScale#)
			SetParticlesRotationRange(i, 410, 590)
			SetParticlesSize(i, 8)
			SetParticlesFrequency(i, 200)
			SetParticlesMax (i, 50)
			SetParticlesAngle(i, 30)
		elseif cType = 31	//Future Crab
			SetParticlesLife(i, lifeEnd#/2)
			AddParticlesColorKeyFrame (i, 0.0, 0, 0, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 255, 255, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 0, 0, 0, 0 )
			SetParticlesDirection(i, 5*gameScale#, 5*gameScale#)
			SetParticlesRotationRange(i, 1410, 1590)
			SetParticlesSize(i, 7)
			SetParticlesFrequency(i, 200)
			SetParticlesMax (i, 60)
			SetParticlesAngle(i, 360)
		elseif cType = 2
			AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 0, 0, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 0, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 120, 100, 255, 0 )
			SetParticlesRotationRange(i, 770, 1070)
			SetParticlesSize(i, 15)
			SetParticlesFrequency(i, 70)
			SetParticlesMax (i, 30)
			SetParticlesAngle(i, 40)
		elseif cType = 12	//King Crab
			AddParticlesColorKeyFrame (i, 0.0, 255, 233, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*4/5, 255, 233, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 233, 0, 0 )
			SetParticlesRotationRange(i, 770, 1070)
			SetParticlesSize(i, 15)
			SetParticlesFrequency(i, 70)
			SetParticlesMax (i, 30)
			SetParticlesAngle(i, 40)
		elseif cType = 22	//Crabacus
			AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#*4/5, 255, 255, 255, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#, 0, 255, 255, 0)
			SetParticlesRotationRange(i, -50, 50)
			SetParticlesSize(i, 18)
			SetParticlesFrequency(i, 70)
			SetParticlesMax (i, 20)
			SetParticlesAngle(i, 0)
		elseif cType = 32	//Crabyss Knight
			AddParticlesColorKeyFrame (i, 0.0, 132, 0, 255, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#*4/5, 255, 0, 0, 255)
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0)
			SetParticlesRotationRange(i, -50, 50)
			SetParticlesSize(i, 22)
			SetParticlesFrequency(i, 70)
			SetParticlesMax (i, 20)
			SetParticlesAngle(i, 30)
		elseif cType = 3
			AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 100, 100, 100, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 40, 40, 40, 0 )
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesSize(i, 20)
			SetParticlesFrequency(i, 300)
			SetParticlesMax (i, 20)
			SetParticlesAngle(i, 40)
		elseif cType = 13	//Taxi Crab
			AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 100, 100, 100, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 40, 40, 40, 0 )
			SetParticlesFrequency(i, 300)
			SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
			SetParticlesSize(i, 14*gameScale#)
			SetParticlesStartZone(i, -5*gameScale#, -5*gameScale#, 5*gameScale#, 5*gameScale#) //The box that the particles can start from
			SetParticlesDirection(i, 100*gameScale#, 100*gameScale#)
			SetParticlesAngle(i, 10)
			SetParticlesMax (i, 80)
		elseif cType = 23	//Space Bark
			AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 40, 40, 40, 0 )
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesDirection(i, 20*gameScale#, 20*gameScale#)
			SetParticlesSize(i, 7)
			SetParticlesFrequency(i, 300)
			SetParticlesMax (i, 10)
			SetParticlesAngle(i, 360)
		elseif cType = 33	//Sk8r Crab
			AddParticlesColorKeyFrame (i, 0.0, 200, 140, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 100, 100, 100, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 40, 40, 40, 0 )
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesSize(i, 20)
			SetParticlesFrequency(i, 300)
			SetParticlesMax (i, 20)
			SetParticlesAngle(i, 40)
		elseif cType = 4
			AddParticlesColorKeyFrame (i, 0.0, 0, 255, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 0, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 255, 255, 0, 0 )
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesAngle(i, 20)
		elseif cType = 14	//#1 Fan Crab
			AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 100, 100, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 255, 200, 200, 0 )
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesDirection(i, 80*gameScale#, 80*gameScale#)
			SetParticlesSize(i, 25)
			SetParticlesFrequency(i, 80)
			SetParticlesMax (i, 5)
			SetParticlesAngle(i, 40)
		elseif cType = 24	//Hawaiian
			AddParticlesColorKeyFrame (i, 0.0, 0, 100, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 0, 200, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 0, 50, 255, 0 )
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesDirection(i, 80*gameScale#, 80*gameScale#)
			SetParticlesSize(i, 14)
			SetParticlesFrequency(i, 150)
			SetParticlesMax (i, 100)
			SetParticlesAngle(i, 20)
		elseif cType = 34	//Holy Crab
			AddParticlesColorKeyFrame (i, 0.0, 255, 255, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 255, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 255, 0, 0 )
			SetParticlesRotationRange(i, 470, 870)
			if (i = par1jump and crab1Evil) or (i = par2jump and crab2Evil)
				ClearParticlesColors(i)
				AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 0, 0, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			endif
			SetParticlesAngle(i, 30)
		elseif cType = 5
			AddParticlesColorKeyFrame (i, 0.0, 80, 80, 80, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 200, 255, 60, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 255, 255, 0 )
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesSize(i, 22)
			SetParticlesAngle(i, 360)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 12)
			SetParticlesVelocityRange (i, 2, 2)
		elseif cType = 15	//Jeff
			AddParticlesColorKeyFrame (i, 0.0, 150, 160, 60, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/4, 150, 80, 60, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 150, 80, 60, 0)
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesSize(i, 20)
			SetParticlesAngle(i, 360)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 12)
			SetParticlesVelocityRange (i, 2, 2)
		elseif cType = 25	//Rock Lobster
			AddParticlesColorKeyFrame (i, 0.0, 50, 160, 250, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 150, 80, 250, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 150, 80, 60, 0)
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesSize(i, 14)
			SetParticlesAngle(i, 360)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 12)
			SetParticlesRotationRange(i, 100, 300)
			SetParticlesVelocityRange (i, 2, 2)
		elseif cType = 35	//Crab Cake
			AddParticlesColorKeyFrame (i, 0.0, 255, 150, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 200, 0, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			SetParticlesRotationRange(i, 52, 400)
			SetParticlesSize(i, 15)
			SetParticlesFrequency(i, 70)
			SetParticlesMax (i, 10)
			SetParticlesAngle(i, 40)
		elseif cType = 6
			AddParticlesColorKeyFrame (i, 0.0, 150, 150, 150, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 255, 255, 255, 120 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 255, 255, 255, 0 )
			SetParticlesLife(i, lifeEnd#/2)
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesSize(i, 30)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 40)
			SetParticlesAngle(i, 360)
			SetParticlesDepth(i, 2)
		elseif cType = 16 	//Team Player
			AddParticlesColorKeyFrame (i, 0.0, 150, 150, 150, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 50, 155, 50, 120 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 50, 155, 50, 0 )
			SetParticlesLife(i, lifeEnd#)
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesSize(i, 12)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 40)
			SetParticlesAngle(i, 40)
			SetParticlesDepth(i, 2)
		elseif cType = 26	//Cranime
			AddParticlesColorKeyFrame (i, 0.0, 255, 50, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#*2/3, 255, 180, 255, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 60, 255, 0 )
			SetParticlesRotationRange(i, 10, 360)
			SetParticlesSize(i, 16)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 15)
			SetParticlesAngle(i, 360)
			SetParticlesDepth(i, 2)
		elseif cType = 36	//Chimera Crab
			AddParticlesColorKeyFrame (i, 0.0, 30, 155, 30, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/3, 180, 255, 180, 120 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 180, 255, 180, 0 )
			SetParticlesLife(i, lifeEnd#/2)
			SetParticlesRotationRange(i, 10, 90)
			SetParticlesSize(i, 30)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 40)
			SetParticlesAngle(i, 360)
			SetParticlesDepth(i, 2)
		endif
		
	next i
	
	SetParticlesImage(par1jump, jumpPartI[crab1Type, crab1Alt])
	SetParticlesImage(par2jump, jumpPartI[crab2Type, crab2Alt])

endfunction

function ActivateJumpParticles(gameNum)
	
	crabS = 0
	crabType = 0
	crabTheta# = 0
	dir = 0
	par = 0
	if gameNum = 1
		crabS = crab1
		crabType = crab1Type
		crabTheta# = crab1Theta#
		if crab1Dir# > 0
			dir = 1
		else
			dir = -1
		endif
		par = par1jump
	elseif gameNum = 2
		crabS = crab2
		crabType = crab2Type
		crabTheta# = crab2Theta#
		if dispH then inc crabTheta#, 180
		if crab2Dir# > 0
			dir = 1
		else
			dir = -1
		endif
		par = par2jump
	endif

	if par <> 0
		
		SetParticlesPosition(par, GetSpriteMiddleX(crabS) - GetSpriteHeight(crabS)/2*cos(crabTheta#), GetSpriteMiddleY(crabS) - GetSpriteHeight(crabS)/2*sin(crabTheta#))
		
		if crabType = 1
			SetParticlesDirection(par, cos(crabTheta#-50*dir)*90*gameScale#, sin(crabTheta#-50*dir)*90*gameScale#)
			SetParticlesPosition(par, GetSpriteMiddleX(crabS) - GetSpriteHeight(crabS)/4*cos(crabTheta#), GetSpriteMiddleY(crabS) - GetSpriteHeight(crabS)/4*sin(crabTheta#))
		elseif crabType = 2
			SetParticlesDirection(par, cos(crabTheta#+60*dir)*200*gameScale#, sin(crabTheta#+60*dir)*200*gameScale#)
		elseif crabType = 3
			SetParticlesDirection(par, cos(crabTheta#+70*dir)*170*gameScale#, sin(crabTheta#+70*dir)*170*gameScale#)
		elseif crabType = 4
			SetParticlesDirection(par, cos(crabTheta#)*400*gameScale#, sin(crabTheta#)*400*gameScale#)
		elseif crabType = 5
			SetParticlesPosition(par, GetSpriteMiddleX(crabS), GetSpriteMiddleY(crabS))
			SetParticlesDirection(par, cos(crabTheta#)*90*gameScale#, sin(crabTheta#)*90*gameScale#)
		elseif crabType = 6
			SetParticlesPosition(par, GetSpriteMiddleX(crabS), GetSpriteMiddleY(crabS))
			SetParticlesDirection(par, cos(crabTheta#)*70*gameScale#, sin(crabTheta#)*70*gameScale#)
		endif
		
		ResetParticleCount(par)
	
	endif
 
endfunction

function StartGameMusic()
	
	if gameSongSet <> 0 and storyActive = 0
		StopGamePlayMusic()
		if gameSongSet <= musicUnlocked
			PlayMusicOGGSP(GetMusicByID(gameSongSet), 1)
		else
			//The retro songs
			PlayMusicOGGSP(GetMusicByID(gameSongSet-musicUnlocked+30), 1)
		endif
		
		exitFunction
	endif
	
	if storyActive = 0 and spType <> CHALLENGEMODE
		if spType = 0 or spType = AIBATTLE
			rnd = 5
			while (rnd >= 4 and rnd <= 7) or GetMusicByID(rnd) = oldSong
				rnd = Random(1, musicUnlocked)
			endwhile
			PlayMusicOGGSP(GetMusicByID(rnd), 1)
			oldSong = GetMusicByID(rnd)
		endif
		
		if spType = MIRRORMODE
			PlayMusicOGGSP(spMusic, 1)
			if GetMusicExistsOGG(spMusic) then SetMusicLoopTimesOGG(spMusic, 6.932, -1)
		endif
		if spType = CLASSIC and GetMusicPlayingOGGSP(retro1M) = 0
			StopMusicOGGSP(loserMusic)
			PlayMusicOGGSP(retro1M + Random(0, 7), 1)
		endif
		
	endif
	
	if spType = CHALLENGEMODE
		PlayMusicOGGSP(spMusic, 1)
		SetMusicLoopTimesOGG(spMusic, 6.932, -1)
	endif
	
endfunction

function PlayDangerMusic(startNew)

	//Checking to make sure that the change should happen
	if spType <> MIRRORMODE and spType <> CLASSIC and crab1Deaths = 2 and crab2Deaths = 2

		if startNew = 0
			
			//Getting the song ID and stopping the music
			oldSong = 0
			if GetMusicPlayingOGGSP(fightAMusic) then oldSong = fightAMusic
			if GetMusicPlayingOGGSP(fightBMusic) then oldSong = fightBMusic
			if GetMusicPlayingOGGSP(fightJMusic) then oldSong = fightJMusic
			if GetMusicPlayingOGGSP(spMusic) then oldSong = spMusic
			if GetMusicPlayingOGGSP(tomatoMusic) then oldSong = tomatoMusic
			if GetMusicPlayingOGGSP(fightFMusic) then oldSong = fightFMusic
			if GetMusicPlayingOGGSP(fightAJMusic) then oldSong = fightAJMusic
			
			if oldSong <> 0 then StopGamePlayMusic()
			
		else
			//Playing the matching danger music
			if oldSong = fightAMusic then PlayMusicOGGSP(dangerAMusic, 1)
			if oldSong = fightBMusic then PlayMusicOGGSP(dangerBMusic, 1)
			if oldSong = fightJMusic then PlayMusicOGGSP(dangerJMusic, 1)
			if oldSong = spMusic then PlayMusicOGGSP(dangerCMusic, 1)
			if oldSong = tomatoMusic then PlayMusicOGGSP(dangerTMusic, 1)
			if oldSong = fightFMusic then PlayMusicOGGSP(dangerFMusic, 1)
			if oldSong = fightAJMusic then PlayMusicOGGSP(dangerAJMusic, 1)
			
		endif
		
	endif
	
endfunction

function StopGamePlayMusic()
	
	for i = fightAMusic to fightJMusic
		if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
	next i
	
	if GetMusicPlayingOGGSP(spMusic) then StopMusicOGGSP(spMusic)
	if GetMusicPlayingOGGSP(tomatoMusic) then StopMusicOGGSP(tomatoMusic)
	if GetMusicPlayingOGGSP(emotionMusic) then StopMusicOGGSP(emotionMusic)
	if GetMusicPlayingOGGSP(fightFMusic) then StopMusicOGGSP(fightFMusic)
	if GetMusicPlayingOGGSP(fightAJMusic) then StopMusicOGGSP(fightAJMusic)
	if GetMusicPlayingOGGSP(chillMusic) then StopMusicOGGSP(chillMusic)
	if GetMusicPlayingOGGSP(ragMusic) then StopMusicOGGSP(ragMusic)
	if GetMusicPlayingOGGSP(ssidMusic) then StopMusicOGGSP(ssidMusic)
	if GetMusicPlayingOGGSP(mcbMusic) then StopMusicOGGSP(mcbMusic)
	if GetMusicPlayingOGGSP(loveMusic) then StopMusicOGGSP(loveMusic)
	if GetMusicPlayingOGGSP(raveBass1) then StopMusicOGGSP(raveBass1)
	if GetMusicPlayingOGGSP(raveBass2) then StopMusicOGGSP(raveBass2)
	if GetMusicPlayingOGGSP(characterMusic) then StopMusicOGGSP(characterMusic)
	if GetMusicPlayingOGGSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
	for i = dangerAMusic to dangerAJMusic
		if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
	next i
	
	for i = retro1M to retro11M
		if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
	next i
	
	//if GetMusicPlayingOGGSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
endfunction

function PlayOpeningScene()
	
	CreateSpriteExpress(curtain, w, h, 0, 0, 8)
	SetSpriteColor(curtain, 0, 0, 0, 200)
	
	phase = 0
	oMax# = 800.0
	if firstFight = 0 then oMax# = 62
	oTimer# = oMax#
	
	PlayMusicOGGSP(tutorialMusic, 0)
	
	if firstFight = 1
	
		CreateTextExpress(TXT_INTRO1, "1. Dodge meteors -" + chr(10) + "collect their power.", 70, fontCrabI, 1, w/2, h/2 + 80, 3)
		SetTextSpacing(TXT_INTRO1, -19)
		
		SetSpritePosition(crab1, 9999, 9999)
		SetSpritePosition(crab2, 9999, 9999)
		
		CreateMeteor(1, 1, 0)
		met1S = meteorActive1[1].spr
		SetSpriteSize(met1S, GetSpriteWidth(met1S)*1.3, GetSpriteHeight(met1S)*1.3)
		SetSpriteMiddleScreenX(met1S)
		SetSpriteY(met1S, h/2 + 220)
		SetSpriteAngle(met1S, 270)
		SetSpriteVisible(met1S, 0)
		SetSpriteVisible(met1S+glowS, 0)
		SetSpriteDepth(met1S, 1)
		for i = expBar1 to specialButton1
			IncSpriteY(i, -200)
			SetSpriteVisible(i, 0)
			SetSpriteDepth(i, GetSpriteDepth(i) - 11)
		next i
		SetParticlesDepth(par1met1, 8)
		
		for i = 1 to 3
			SetSpriteDepth(crab1PlanetS[i], GetSpriteDepth(crab1PlanetS[i]) + 10)
		next i
		
		CreateTextExpress(TXT_INTRO2, GetTextString(TXT_INTRO1), 70, fontCrabI, 1, w/2, h/2 - 80, 3)
		SetTextSpacing(TXT_INTRO2, -19)
		SetTextAngle(TXT_INTRO2, 180)
		
		CreateMeteor(2, 1, 0)
		met2S = meteorActive2[1].spr
		SetSpriteSize(met2S, GetSpriteWidth(met2S)*1.3, GetSpriteHeight(met2S)*1.3)
		SetSpriteMiddleScreenX(met2S)
		SetSpriteY(met2S, h/2 - 220 - GetSpriteHeight(met2S))
		SetSpriteAngle(met2S, 90)
		SetSpriteVisible(met2S, 0)
		SetSpriteVisible(met2S+glowS, 0)
		SetSpriteDepth(met2S, 1)
		for i = expBar2 to specialButton2
			IncSpriteY(i, 200)
			SetSpriteVisible(i, 0)
			SetSpriteDepth(i, GetSpriteDepth(i) - 11)
		next i
		SetParticlesDepth(par2met1, 8)
		
		for i = 1 to 3
			SetSpriteDepth(crab2PlanetS[i], GetSpriteDepth(crab2PlanetS[i]) + 10)
		next i
		
		if dispH
			//Repsitioning for the intro cutscene
			SetTextY(TXT_INTRO1, 80)
			SetTextSize(TXT_INTRO1, 56)
			SetTextSpacing(TXT_INTRO1, -14)
			SetSpriteY(met1S, 205)
			
			for i = expBar1 to specialButton1
				IncSpriteX(i, 350)
				IncSpriteY(i, -30)
			next i
			
			SetTextX(TXT_INTRO2, 9999)
			SetSpriteY(met2S, 9999)
		endif
		
		
		phase = 1
		
		while oTimer# > 0
			fpsr# = 60.0/ScreenFPS()
			
			if oTimer# < oMax#*9/10 and GetSpriteExists(met1S) = 1
				SetSpriteVisible(met1S, 1)
				SetSpriteVisible(met2S, 1)
				//SetSpriteVisible(met1S+glowS, 1)	//This stays invisible because I couldn't get the Y positioning right, lol
			endif
			
			if oTimer# < oMax#*8/10 and GetSpriteExists(met1S) = 1
				ActivateMeteorParticles(1, met1S, 1)
				CreateExp(met1S, 2, 1)		
				DeleteSprite(met1S)
				if GetSpriteExists(met1S+glowS) then DeleteSprite(met1S + glowS)
				meteorActive1.remove(1)
				
				ActivateMeteorParticles(1, met2S, 2)
				CreateExp(met2S, 2, 1)		
				DeleteSprite(met2S)
				if GetSpriteExists(met2S+glowS) then DeleteSprite(met2S + glowS)
				meteorActive2.remove(1)
				
				if fruitMode = 0 then PlaySoundR(explodeS, 40)
				if fruitMode = 1 then PlaySoundR(fruitS, 40)
			endif
			
			
			if oTimer# < oMax#*7/10 and phase = 1
				//The one time stuff
				phase = 2
				SetTextString(TXT_INTRO1, GetTextString(TXT_INTRO1) + chr(10) + chr(10) + chr(10) + "2. Power your bar" + chr(10) + "and fight back.")
				SetTextString(TXT_INTRO2, GetTextString(TXT_INTRO1))	
				
				for i = expBar1 to specialButton1
					SetSpriteVisible(i, 1)
				next i
				for i = expBar2 to specialButton2
					SetSpriteVisible(i, 1)
				next i
			endif
			
			if oTimer# < oMax#*6/10 and expTotal1 < specialCost1
				expTotal1 = Min(-1*(oTimer#-(oMax#*6/10))/8, specialCost1)
			endif
			
			if oTimer# < oMax#*6/10 and expTotal2 < specialCost2
				expTotal2 = Min(-1*(oTimer#-(oMax#*6/10))/8, specialCost2)
			endif
			
			if phase = 2 and oTimer# < oMax#*3/10
				phase = 3
				
				SetTextString(TXT_INTRO1, GetTextString(TXT_INTRO1) + chr(10) + chr(10) + chr(10) + "3. And most importantly...")
				SetTextString(TXT_INTRO2, GetTextString(TXT_INTRO1))
				
			endif
			
			if oTimer# < oMax#*3/10
				SetMusicVolumeOGG(tutorialMusic, Max(oTimer#/3, 0))
			endif
			
			DoInputs()
			if GetPointerPressed() or inputSelect or inputSelect2 or inputTurn1 or inputTurn2
				inc oTimer#, -oMax#/5
				PingFF()
			endif
			
			dec oTimer#, fpsr#
			UpdateButtons1()
			UpdateButtons2()
			PingUpdate()
			UpdateExp()
			SyncG()
		endwhile
		
		expTotal1 = 0
		expTotal2 = 0
		
		for i = expBar1 to specialButton1
			IncSpriteY(i, 200)
			SetSpriteDepth(i, GetSpriteDepth(i) + 11)
		next i
		for i = expBar2 to specialButton2
			IncSpriteY(i, -200)
			SetSpriteDepth(i, GetSpriteDepth(i) + 11)
		next i
		
		if dispH
			//Un-repsitioning for the intro cutscene
			for i = expBar1 to specialButton1
				IncSpriteX(i, -350)
				IncSpriteY(i, 30)
			next i
		endif
		
		for i = 1 to 3
			SetSpriteDepth(crab1PlanetS[i], GetSpriteDepth(crab1PlanetS[i]) - 10)
			SetSpriteDepth(crab2PlanetS[i], GetSpriteDepth(crab2PlanetS[i]) - 10)
		next i
		SetParticlesDepth(par1met1, 25)
		SetParticlesDepth(par2met1, 25)
		
		DeleteHalfExp(1)
		DeleteHalfExp(2)
		UpdateButtons1()
		UpdateButtons2()
		
		firstFight = 0
		
		StopMusicOGGSP(tutorialMusic)

	else
		//The repeated cutscene
		
		CreateTextExpress(TXT_INTRO1, "Three...", 90, fontCrabI, 1, w/2, h*3/4 + 30, 3)
		SetTextSpacing(TXT_INTRO1, -22)
		
		CreateTextExpress(TXT_INTRO2, "Three...", 90, fontCrabI, 1, w/2, h/4 - GetTextSize(TXT_INTRO1), 3)
		SetTextSpacing(TXT_INTRO2, -22)
		SetTextAngle(TXT_INTRO2, 180)
		
		if dispH
			SetTextMiddleScreen(TXT_INTRO1, 0)
			SetTextY(TXT_INTRO2, 9999)
		endif
		
		phase = 1
		
		while oTimer# > 0
			
			if oTimer# < oMax#*2/3 and phase = 1
				phase = 2
				for i = TXT_INTRO1 to TXT_INTRO2
					SetTextString(i, "Two...")
					SetTextAngle(i, (i-TXT_INTRO1)*180 - 10 + Random(0, 20))
					SetTextSize(i, 95)
				next i
			endif
			
			if oTimer# < oMax#/3 and phase = 2
				phase = 3
				for i = TXT_INTRO1 to TXT_INTRO2
					SetTextString(i, "One...")
					SetTextAngle(i, (i-TXT_INTRO1)*180 - 15 + Random(0, 30))
					SetTextSize(i, 100)
				next i
			endif
			
			if oTimer# < oMax#/6 and phase = 3
				phase = 4
				StopMusicOGGSP(tutorialMusic)
			endif
			
			dec oTimer#, fpsr#
			SyncG()
		endwhile
		
		
		
	endif
	
	DeleteSprite(curtain)
	
	ClearMultiTouch()
	
	PlaySoundR(gongS, 40)
	
	for i = TXT_INTRO1 to TXT_INTRO2
		SetTextString(i, "SURVIVE!")
		SetTextSize(i, 110)
		SetTextAngle(i, (i-TXT_INTRO1)*180)
		SetTextSpacing(i, -30)
		SetTextY(i, h*3/4  - h/2*(i-TXT_INTRO1))
		SetTextDepth(i, 4)
		
		if dispH
			SetTextMiddleScreen(TXT_INTRO1, 0)
			SetTextY(TXT_INTRO2, 9999)
		endif
	next i	
	
endfunction

//function SetCrabStats(cType as integer, cAlt as integer, framerate ref as Integer, specialCost ref as Integer, vel# ref as Float, accel# ref as float, jumpHMax# ref as float, jumpSpeed# ref as float, jumpDMax# ref as float)
	
//endfunction