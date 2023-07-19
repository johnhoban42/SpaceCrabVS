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
	CreateGame1()
	CreateGame2()
	LoadJumpSounds()
	InitAttackParticles()
	InitJumpParticles()
	gameTimer# = 0
	meteorTotal1 = 0
	meteorTotal2 = 0
	
	SetSpriteVisible(split, 1)
	TransitionEnd()
	
	if spActive = 0 then PlayOpeningScene()
	
	//The pause button
	SetFolder("/media/ui")
	LoadSpriteExpress(pauseButton, "pause.png", 100, 100, 0, 0, 9)
	SetSpriteMiddleScreen(pauseButton)
	//if spActive then SetSpritePosition(pauseButton, 30, 30)
	
	LoadSpriteExpress(playButton, "resume.png", 185, 185, 0, 0, 1)
	SetSpriteMiddleScreen(playButton)
	SetSpriteVisible(playButton, 0)
	
	LoadSpriteExpress(exitButton, "crabselect.png", 140, 140, 0, 0, 1)
	SetSpriteMiddleScreen(exitButton)
	IncSpriteX(exitButton, 270)
	SetSpriteVisible(exitButton, 0)
	
	LoadSpriteExpress(mainmenuButton, "mainmenu.png", 140, 140, 0, 0, 1)
	SetSpriteMiddleScreen(mainmenuButton)
	IncSpriteX(mainmenuButton, -270)
	SetSpriteVisible(mainmenuButton, 0)
	
	AddButton(pauseButton)
	AddButton(playButton)
	AddButton(exitButton)
	AddButton(mainmenuButton)
	
	difficultyMax = 7
	difficultyBar = 10
	//The special classic mode setup
	if spType = CLASSIC
		SetSpriteVisible(split, 0)
		SetViewZoomMode(1)
		SetViewZoom(1.3)
		
		//The game screen adjustments
		SetTextSize(TXT_SP_SCORE, spScoreMinSize-10)
		SetTextSize(TXT_SP_DANGER, spScoreMinSize-10)
		SetTextSpacing(TXT_SP_SCORE, -10)
		SetTextSpacing(TXT_SP_DANGER, -10)
		SetTextPosition(TXT_SP_SCORE, 130, 280)
		SetTextPosition(TXT_SP_DANGER, GetTextX(TXT_SP_SCORE) - 10, GetTextY(TXT_SP_SCORE) + GetTextSize(TXT_SP_SCORE))
		SetTextAlignment(TXT_SP_DANGER, 0)
		SetSpriteSize(bgGame1, h, h)
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
		
		IncSpriteX(exitButton, -70)
		LoadSpriteExpress(phantomExitButton, "crabselect.png", GetSpriteWidth(exitButton)*zoom#, GetSpriteHeight(exitButton)*zoom#, 659-GetSpriteWidth(exitButton)/2, 803-GetSpriteWidth(exitButton)/2, 1)
		SetSpriteColorAlpha(phantomExitButton, 0)
		SetSpriteVisible(phantomExitButton, 0)
		AddButton(phantomPauseButton)
		
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
		
		if spActive
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
	
		if ButtonMultitouchEnabled(pauseButton)
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
		
		SetSpriteX(curtainB, w/2 - GetSpriteWidth(curtainB)/2 + w/4*sin(pauseTimer#))
		IncSpriteAngle(exitButton, -fpsr#)
		IncSpriteAngle(mainmenuButton, -fpsr#)
		IncSpriteAngle(playButton, fpsr#)
		
		if ButtonMultitouchEnabled(playButton)
			paused = 0
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
			if spActive then state = START
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
	endif
	
	if spActive = 1 and crab1Deaths > 0 or crab2Deaths > 0 and state = START
		if spType = MIRRORMODE then EndMirrorScene()
		if spType = CLASSIC then EndClassicScene()
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
	for i = fightAMusic to fightJMusic
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
		endif
	next i
	if GetMusicPlayingOGGSP(spMusic) then StopMusicOGGSP(spMusic)
	if GetMusicPlayingOGGSP(dangerMusic) then StopMusicOGGSP(dangerMusic)
	for i = retro1M to retro8M
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
		endif
	next i
	
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
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				PlayMusicOGGSP(resultsMusic, 1)
				
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
			
			InitResults()
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
	if GetMusicPlayingOGGSP(spMusic) then StopMusicOGGSP(spMusic)

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
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				SetViewZoomMode(0)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				PlayMusicOGGSP(loserMusic, 0)
				
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
	for i = retro1M to retro8M
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
		endif
	next i

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
				CreateSpriteExpress(coverS, w, h, 0, 0, 1)
				SetSpriteColor(coverS, 255, 255, 255, 0)
				SetViewOffset(0, 0)
				SetViewZoom(1)
				SetViewZoomMode(0)
				
				endStage = 4
				PlaySoundR(launchS, 100)
				PlayMusicOGGSP(loserMusic, 0)
				
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
	
	DeleteSprite(pauseButton)
	DeleteSprite(playButton)
	DeleteSprite(exitButton)
	DeleteSprite(mainmenuButton)
	if GetSpriteExists(phantomPauseButton) then DeleteSprite(phantomPauseButton)
	if GetSpriteExists(phantomExitButton) then DeleteSprite(phantomExitButton)
	
	if spActive
		DeleteSprite(SPR_SP_SCORE)
		DeleteText(TXT_SP_SCORE)
		DeleteText(TXT_SP_DANGER)
	endif
endfunction

// Cleanup upon leaving this state
function ExitGame()
	
	//Updating the scores for the single player game
	if spActive
		if spType = MIRRORMODE
			if spHighScore < spScore
				spHighScore = spScore
				if crab1Type = 1 then spHighCrab$ = "Space Crab"
				if crab1Type = 2 then spHighCrab$ = "Ladder Wizard"
				if crab1Type = 3 then spHighCrab$ = "Top Crab"
				if crab1Type = 4 then spHighCrab$ = "Rave Crab"
				if crab1Type = 5 then spHighCrab$ = "Chrono Crab"
				if crab1Type = 6 then spHighCrab$ = "Ninja Crab"
				SaveGame()
			endif
		elseif spType = CLASSIC
			if spHighScoreClassic < spScore
				spHighScoreClassic = spScore
				if crab1Type = 1 then spHighCrabClassic$ = "Space Crab"
				if crab1Type = 2 then spHighCrabClassic$ = "Ladder Wizard"
				if crab1Type = 3 then spHighCrabClassic$ = "Top Crab"
				if crab1Type = 4 then spHighCrabClassic$ = "Rave Crab"
				if crab1Type = 5 then spHighCrabClassic$ = "Chrono Crab"
				if crab1Type = 6 then spHighCrabClassic$ = "Ninja Crab"
				SaveGame()
			endif
		endif
	endif
	
	if GetSpriteExists(999) then DeleteSprite(999)	//The pause menu curtain
	if GetTextExists(TXT_INTRO1) then DeleteText(TXT_INTRO1)
	if GetTextExists(TXT_INTRO2) then DeleteText(TXT_INTRO2)
	paused = 0
	
	for i = fightAMusic to fightJMusic
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
		endif
	next i
	if GetMusicPlayingOGGSP(spMusic) then StopMusicOGGSP(spMusic)
	if GetMusicPlayingOGGSP(dangerMusic) then StopMusicOGGSP(dangerMusic)
	for i = retro1M to retro8M
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
		endif
	next i
	
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
	buffer1 = 0
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
	buffer2 = 0
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
	CreateSpriteExpress(curtainB, h/zoom#, h/zoom#, 0, 0, 2)
	SetSpriteImage(curtainB, bg3I)
	SetSpriteMiddleScreen(curtainB)
	
	CreateSpriteExpress(curtain, w/zoom#, h/zoom#, 0, 0, 2)
	SetSpriteImage(curtain, bgPI)
	SetSpriteMiddleScreen(curtain)
	
	if spType = CLASSIC
		IncSpriteSizeCenteredMult(curtain, GetViewZoom())
		IncSpriteSizeCenteredMult(curtainB, GetViewZoom())
	endif
	
	SetSpriteVisible(pauseButton, 0)
	if GetSpriteExists(phantomPauseButton) then SetSpriteVisible(phantomPauseButton, 0)
	SetSpriteVisible(playButton, 1)
	SetSpriteVisible(exitButton, 1)
	if GetSpriteExists(phantomExitButton) then SetSpriteVisible(phantomExitButton, 1)
	if spActive = 0 then SetSpriteVisible(mainmenuButton, 1)
	
	pauseTimer# = Random(0, 359)
	SetSpriteX(curtainB, w/2 - GetSpriteWidth(curtainB)/2 + w/4*sin(pauseTimer#))
	
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
	SetTextString(pauseTitle1, crabNames[crab1Type])
	SetTextString(pauseDesc1, crabPause1[crab1Type])
	if spActive = 0 then SetTextString(pauseDesc1, GetTextString(pauseDesc1) + chr(10) + chr(10) + crabPause2[crab1Type])
	
	if spActive = 0 and aiActive = 0
		//For a multiplayer game
		SetTextY(pauseTitle2, h/2 - (GetTextY(pauseTitle1)-h/2))
		SetTextY(pauseDesc2, h/2 - (GetTextY(pauseDesc1)-h/2))
		SetTextString(pauseTitle2, crabNames[crab2Type])
		SetTextString(pauseDesc2, crabPause1[crab2Type] + chr(10) + chr(10) + crabPause2[crab2Type])
	endif
	
	//The single player special text
	if spActive = 1
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
	
	endif
	
	if spType = CLASSIC
		SetTextString(pauseTitle2, "Classic Mode")
		SetTextSpacing(pauseTitle2, GetTextSpacing(pauseTitle2) - 3)
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
			SetTextString(pauseDesc2, "Space Crab made an appearance in" + chr(10) + "'Sleep Patrol Alpha' as a playable" + chr(10) + "character! Find every landmark in the" + chr(10) + "first map to unlock him.")
		elseif rand = 7
			SetTextString(pauseDesc2, "Tap and hold on the main menu logo" + chr(10) + "for a fruity suprise!")
		endif
		
		
		IncTextY(pauseTitle1, -80)
		IncTextY(pauseDesc1, -145)
		
		IncSpriteSizeCenteredMult(curtainB, GetViewZoom())
	endif
	
	
endfunction

function UnpauseGame()
	
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
		SetSpriteSize(expSprNum, 16, 16)
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
			IncSpritePosition(spr, (255-alpha)/18*fpsr#*cos(GetSpriteAngle(spr)), (255-alpha)/18*fpsr#*sin(GetSpriteAngle(spr)))

			SetSpriteColorAlpha(spr, GetSpriteColorAlpha(spr) + 10)
		endif

		//Collision for the first/bottom crab
		//dis1 = GetSpriteDistance(spr, crab1)
		if GetSpriteDistance(spr, crab1) < 50
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
				PlaySoundR(exp1S + rnd, volumeSE)

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
					PlaySoundR(exp1S + rnd, volumeSE)
	
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
	SetSpriteScissor(expBar2, GetSpriteX(expHolder1), 0, w, h)
	GlideToX(expBar2, GetSpriteX(expHolder2) - (GetSpriteWidth(expHolder2))*(1.0*expTotal2/specialCost2), 2)
	
	if (GetSpriteX(expBar2) - .116*GetSpriteWidth(expHolder2)*2/3) + GetSpriteWidth(expHolder2) <= GetSpriteX(specialButton2) + GetSpriteWidth(specialButton2) and expTotal2 <> specialCost2
		expTotal2 = specialCost2
		UpdateButtons2()
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
				if GetSpriteY(spr) > h/2 and deleted = 0
					deleted = i
					DeleteSprite(spr)
					badLeave = 1
				endif
			endif
			
			if gameNum = 2
				//This is only for the top crab
				if GetSpriteY(spr) < h/2 and deleted = 0
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

function ShowSpecialAnimation(crabType, fast)
	
	fpsr# = 60.0/ScreenFPS()
	
	PlaySoundR(specialS, volumeSE)
	
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
			SetSpriteImage(i, crab1attack2I - 1 + crabType)
			if crabType = 4
				SetSpriteSizeSquare(i, specSize*1.4)
				SetSpriteColor(i, 255, 255, 255, 0)
			endif
		else
			//Front Sprites
			SetSpriteDepth(i, 1)
			SetSpriteImage(i, crab1attack1I - 1 + crabType)
		endif
		
		if i >= specialSprFront2 then SetSpriteAngle(i, 180)
		
	next i
	
	if crabType = 3 or crabType = 5
		SetFolder("/media/art")
		LoadSprite(specialSprBacker1, "crab" + str(crabType) + "attack3.png")
		LoadSprite(specialSprBacker2, "crab" + str(crabType) + "attack3.png")
		SetSpriteAngle(specialSprBacker1, 180)
		SetSpriteAngle(specialSprBacker2, 180)
		SetSpriteDepth(specialSprBacker1, 3)
		SetSpriteDepth(specialSprBacker2, 3)
		SetSpriteSizeSquare(specialSprBacker1, specSize)
		SetSpriteSizeSquare(specialSprBacker2, specSize)
	endif
	
	//Offsetting the clock hands so that they rotate properly
	if crabType = 5
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
	
	if crabType = 4
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
		if crabType = 1 then SetTextString(i, "METEOR SHOWER")
		if crabType = 2 then SetTextString(i, "CONJURE COMETS")
		if crabType = 3 then SetTextString(i, "ORBITAL NIGHTMARE")
		if crabType = 4 then SetTextString(i, "PARTY TIME!")
		if crabType = 5 then SetTextString(i, "FAST FOWARD")
		if crabType = 6 then SetTextString(i, "SHURI-KRUSTACEAN")
	next i
	
	iEnd = 120/fpsr#
	if fast
		iEnd = 80/fpsr#
		fastM# = 1.5 //This makes the animations multiplicable
	else
		fastM# = 1
	endif
	
	for i = 1 to iEnd
		
		if i <= iEnd*1/4 and i > 2
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
		
		if i = iEnd*2/3 then PlaySoundR(specialExitS, volumeSE)
		
		if crabType = 1 or crabType = 2 or crabType = 4 or crabType = 6
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
		
		if crabType = 4
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
			
		endif
		
		//Top crab
		if crabType = 3 or crabType = 5
			if i = 1
				DrawPolar1(specialSprFront1, 0, 270)
				DrawPolar1(specialSprBack1, 0, 270)
				DrawPolar1(specialSprBacker1, 0, 270)
				DrawPolar2(specialSprFront2, 0, 90)
				DrawPolar2(specialSprBack2, 0, 90)
				DrawPolar2(specialSprBacker2, 0, 90)
				
				if crabType = 5
					IncSpritePosition(specialSprFront2, -2*(specSize*700/1356.0 - specSize/2), -2*(specSize*932/1356.0 - specSize/2))
					IncSpritePosition(specialSprBack2, -2*(specSize*700/1356.0 - specSize/2), -2*(specSize*932/1356.0 - specSize/2))
				endif
			endif
				
			for j = specialSprFront1 to specialSprBacker2
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
			endif
			
			//Goes around once for top, 3 times for chrono
			for j = 3 to crabType
				IncSpriteAngle(specialSprFront1, -1*fpsr# - i/(25.0*fpsr#))
				IncSpriteAngle(specialSprFront2, -1*fpsr# - i/(25.0*fpsr#))
				IncSpriteAngle(specialSprBack1, 1.5*fpsr# + i/(25.0*fpsr#))
				IncSpriteAngle(specialSprBack2, 1.5*fpsr# + i/(25.0*fpsr#))
			next j
			
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
			SetParticlesSize(i, 20)
			SetParticlesStartZone(i, -metSizeX/4, -metSizeX/4, metSizeX/4, metSizeX/4) //The box that the particles can start from
			//SetParticlesStartZone(i, -5, -5, 5, 5) //The box that the particles can start from
    		SetParticlesDirection(i, 30, 20)
    		SetParticlesAngle(i, 360)
    		//SetParticlesVelocityRange (i, 1.8, 3.5 )
    		SetParticlesVelocityRange (i, 0.8, 2.5 )
    		SetParticlesMax (i, 100)
    		SetParticlesDepth(i, 25)
    		
    		 if Mod(i, 4) = 1
				AddParticlesColorKeyFrame (i, 0.0, 255, 255, 255, 255 )
				AddParticlesColorKeyFrame (i, 0.01, 255, 255, 0, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			elseif Mod(i, 4) = 2
				AddParticlesColorKeyFrame (i, 0.0, 0, 0, 239, 255 )
				AddParticlesColorKeyFrame (i, 0.01, 239, 0, 239, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 30, 50, 180, 0 )
			elseif Mod(i, 4) = 3
				AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
				AddParticlesColorKeyFrame (i, 0.01, 255, 100, 100, 255 )
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
				AddParticlesColorKeyFrame (i, .6, 255, 255, 100, 255 )
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
endfunction

function ActivateMeteorParticles(mType, spr, gameNum)

	par = mType + (gameNum-1)*4
	if mType <> 4
		//For general meteors
		SetParticlesPosition (par, GetSpriteMiddleX(spr), GetSpriteMiddleY(spr))
		ResetParticleCount (par)
	else
		//For wizard sparkles
	    SetParticlesActive(par, 1)
		ResetParticleCount(par)
		SetParticlesMax(par, 480)
	endif    
 
endfunction



function GetCrabDefaultR(spr)
	//Returns the normal height that a crab will be at
	r# = planetSize/2 + GetSpriteHeight(spr)/3
endfunction r#

function SetBGRandomPosition(spr)
	//Sets the background to a random angle/spot
	SetSpriteSizeSquare(spr, w*2)
	if spr = bgGame1 then SetSpritePosition(spr, -1*w + Random(0, w), h/2)
	if spr = bgGame2 then SetSpritePosition(spr, -1*w + Random(0, w), h/2-GetSpriteHeight(spr))
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
		
	endif
	
	AddMeteorAnimation(meteorSprNum)
	CreateMeteorGlow(meteorSprNum)
	
	inc meteorSprNum, 1
	
	if gameNum = 1
		meteorActive1.insert(newMet)
	elseif gameNum = 2
		meteorActive2.insert(newMet)
	endif
	
endfunction

function AddMeteorAnimation(spr)
	if fruitMode = 0
		AddSpriteAnimationFrame(spr, meteorI1)
		AddSpriteAnimationFrame(spr, meteorI2)
		AddSpriteAnimationFrame(spr, meteorI3)
		AddSpriteAnimationFrame(spr, meteorI4)
		PlaySprite(spr, 15, 1, 1, 4)
	else
		//FRUITALITY
		rnd = Random(0, 5)
		AddSpriteAnimationFrame(spr, fruit1I+rnd)
		PlaySprite(spr, 15, 0, 1, 1)
		SetSpriteColor(spr, 255, 255, 255, 255)
	endif
	
	if Random(1, 2) = 2 then SetSpriteFlip(spr, 1, 0)
	
	SetSpriteShapeCircle(spr, 0, GetSpriteHeight(spr)/8, GetSpriteWidth(spr)/2.8)
endfunction

function CreateMeteorGlow(spr)
	mult# = 1.6	
	CreateSprite(spr+glowS, meteorGlowI)
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
				SetTextSize(TXT_SP_DANGER, 58)
				SetTextY(TXT_SP_DANGER, h/2 - GetTextSize(TXT_SP_DANGER)/2)
				SetTextX(TXT_SP_DANGER, 622)
			endif
		endif
		
		if spScore > spHighScore
			
		endif
	endif
	
	if GetRawKeyPressed(38) then inc gameDifficulty1, 1
	
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
		if i = par1jump then cType = crab1Type
		if i = par2jump then cType = crab2Type
		
		SetParticlesPosition(i, 2000, 2000)
		
		ClearParticlesColors(i)
		SetParticlesFrequency(i, 300)
		SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
		SetParticlesSize(i, 10)
		SetParticlesStartZone(i, -5, -5, 5, 5) //The box that the particles can start from
		SetParticlesDirection(i, 100, 100)
		SetParticlesAngle(i, 10)
		SetParticlesVelocityRange (i, 0.8, 2.5 )
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
		elseif cType = 3
			AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 255 )
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
		elseif cType = 5
			AddParticlesColorKeyFrame (i, 0.0, 80, 80, 80, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#/2, 200, 255, 60, 255 )
			AddParticlesColorKeyFrame (i, lifeEnd#, 255, 255, 255, 0 )
			SetParticlesRotationRange(i, 470, 870)
			SetParticlesSize(i, 30)
			SetParticlesAngle(i, 360)
			SetParticlesFrequency(i, 1000)
			SetParticlesMax (i, 12)
			SetParticlesVelocityRange (i, 2, 2)
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
		endif
		
	next i
	
	SetParticlesImage(par1jump, jumpPartI[crab1Type])
	SetParticlesImage(par2jump, jumpPartI[crab2Type])

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
			SetParticlesDirection(par, cos(crabTheta#-50*dir)*90, sin(crabTheta#-50*dir)*90)
			SetParticlesPosition(par, GetSpriteMiddleX(crabS) - GetSpriteHeight(crabS)/4*cos(crabTheta#), GetSpriteMiddleY(crabS) - GetSpriteHeight(crabS)/4*sin(crabTheta#))
		elseif crabType = 2
			SetParticlesDirection(par, cos(crabTheta#+60*dir)*200, sin(crabTheta#+60*dir)*200)
		elseif crabType = 3
			SetParticlesDirection(par, cos(crabTheta#+70*dir)*170, sin(crabTheta#+70*dir)*170)
		elseif crabType = 4
			SetParticlesDirection(par, cos(crabTheta#)*400, sin(crabTheta#)*400)
		elseif crabType = 5
			SetParticlesPosition(par, GetSpriteMiddleX(crabS), GetSpriteMiddleY(crabS))
			SetParticlesDirection(par, cos(crabTheta#)*90, sin(crabTheta#)*90)
		elseif crabType = 6
			SetParticlesPosition(par, GetSpriteMiddleX(crabS), GetSpriteMiddleY(crabS))
			SetParticlesDirection(par, cos(crabTheta#)*70, sin(crabTheta#)*70)
		endif
		
		ResetParticleCount(par)
	
	endif
 
endfunction

function StartGameMusic()
	
	
	if spActive = 0 then PlayMusicOGGSP(fightAMusic, 1)	//Todo: put in a music randomizer
	
	if spActive = 1 
		if spType = MIRRORMODE
			PlayMusicOGGSP(spMusic, 1)
		
		elseif GetMusicPlayingOGGSP(retro1M) = 0 and spType = CLASSIC
			StopMusicOGGSP(loserMusic)
			PlayMusicOGGSP(retro1M + Random(0, 7), 1)
		endif
	endif
	if GetMusicExistsOGG(spMusic) then SetMusicLoopTimesOGG(spMusic, 6.932, -1)
	
endfunction

function PlayDangerMusic(startNew)

	//Checking to make sure that the change should happen
	if spActive = 0 and crab1Deaths = 2 and crab2Deaths = 2

		if startNew = 0
			//Stopping the old music
			for i = fightAMusic to fightJMusic
				if GetMusicExistsOGG(i)
					if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
				endif
			next i
			if GetMusicPlayingOGGSP(spMusic) then StopMusicOGGSP(spMusic)
			for i = retro1M to retro8M
				if GetMusicExistsOGG(i)
					if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
				endif
			next i
		else
			//Playing the danger music
			PlayMusicOGGSP(dangerMusic, 1)
		endif
		
		

	endif
	
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
				
				if fruitMode = 0 then PlaySoundR(explodeS, volumeSE)
				if fruitMode = 1 then PlaySoundR(fruitS, volumeSE)
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
			
			if GetPointerPressed()
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
	
	PlaySoundR(gongS, volumeSE)
	
	for i = TXT_INTRO1 to TXT_INTRO2
		SetTextString(i, "SURVIVE!")
		SetTextSize(i, 110)
		SetTextAngle(i, (i-TXT_INTRO1)*180)
		SetTextSpacing(i, -30)
		SetTextY(i, h*3/4  - h/2*(i-TXT_INTRO1))
		SetTextDepth(i, 3)
	next i	
	
	
	
endfunction