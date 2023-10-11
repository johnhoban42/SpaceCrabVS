#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global startStateInitialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function InitStart()
	
	SetCrabPauseStrings()
	SetStoryShortStrings()
	
	SetSpriteVisible(split, 0)
	
	SetFolder("/media/ui")
	
	if demo
		CreateSprite(SPR_TITLE, 0)
		AddSpriteAnimationFrame(SPR_TITLE, logoDemoI)
	else
		CreateSprite(SPR_TITLE, 0)
		AddSpriteAnimationFrame(SPR_TITLE, logoI)
	endif
	AddSpriteAnimationFrame(SPR_TITLE, logoFruitI)
	SetSpriteFrame(SPR_TITLE, 1)
	if fruitMode then SetSpriteFrame(SPR_TITLE, 2)
	SetSpriteShape(SPR_TITLE, 1)
	//if demo
	//	LoadAnimatedSprite(SPR_TITLE, "titleDemo", 2)
	//else
	//	LoadAnimatedSprite(SPR_TITLE, "title", 1)
	//endif
	SetSpriteSize(SPR_TITLE, w*2/3, w*2/3)
	SetSpriteMiddleScreen(SPR_TITLE)
	//IncSpriteY(SPR_TITLE, -50)
	SetSpriteAngle(SPR_TITLE, 90)
	SetSpriteDepth(SPR_TITLE, 5)
	AddButton(SPR_TITLE)
	
	LoadSpriteExpress(SPR_LOGO_HORIZ, "logoHoriz.png", w-40, (w-40)/2, 0, 80, 5)
	SetSpriteMiddleScreen(SPR_LOGO_HORIZ)
	SetSpriteY(SPR_LOGO_HORIZ, 10)
	SetSpriteVisible(SPR_LOGO_HORIZ, 0)
	
	CreateTextExpress(SPR_LOGO_HORIZ, "MIRROR MODE", 130, fontCrabI, 1, w/2, 360, 5)
	SetTextSpacing(SPR_LOGO_HORIZ, -36)
	SetTextVisible(SPR_LOGO_HORIZ, 0)
	
	CreateTextExpress(TXT_SP_DESC, "WARNING: Magic mirror ahead." + chr(10) + "Soul split is likely. Keep" + chr(10) + "both halves safe to survive.", 59, fontDescI, 1, w/2, 510, 5)
	SetTextSpacing(TXT_SP_DESC, -17)
	SetTextVisible(TXT_SP_DESC, 0)
	
	LoadAnimatedSprite(SPR_START1, "ready", 22)
	PlaySprite(SPR_START1, 10, 1, 7, 14)
	SetSpriteSize(SPR_START1, 842*.7, 317*.7)
	SetSpriteMiddleScreenX(SPR_START1)
	SetSpriteY(SPR_START1, h/2 + 480)
	SetSpriteAngle(SPR_START1, 0)
	SetSpriteDepth(SPR_START1, 75)
	AddButton(SPR_START1)
	
	CreateSpriteExistingAnimation(SPR_START2, SPR_START1)
	PlaySprite(SPR_START2, 11, 1, 15, 22)
	SetSpriteSize(SPR_START2, 842*.7, 317*.7)
	SetSpriteMiddleScreenX(SPR_START2)
	SetSpriteY(SPR_START2, h/2 - 480 - GetSpriteHeight(SPR_START2))	//This is the true good distance
	SetSpriteAngle(SPR_START2, 180)
	SetSpriteDepth(SPR_START2, 75)
	AddButton(SPR_START2)
	
	//The demo adjustments
	IncSpriteY(SPR_START2, -50)
	IncSpriteY(SPR_TITLE, -150)
	IncSpriteY(SPR_START1, -250)
		
	CreateTextExpress(TXT_WAIT1, "Waiting for your opponent...", 90, fontDescItalI, 1, w/2, GetSpriteY(SPR_START1)+48, 3)
	SetTextColorAlpha(TXT_WAIT1, 0)
	SetTextSpacing(TXT_WAIT1, -32)
	CreateTextExpress(TXT_WAIT2, "Waiting for your opponent...", 90, fontDescItalI, 1, w/2, GetSpriteY(SPR_START2)-48+GetSpriteHeight(SPR_START2), 3)
	SetTextColorAlpha(TXT_WAIT2, 0)
	SetTextSpacing(TXT_WAIT2, -32)
	SetTextAngle(TXT_WAIT2, 180)
	
	LoadAnimatedSpriteReversible(SPR_START1P, "mirror", 8)
	SetSpriteExpress(SPR_START1P, 250, 138, 520, 1030, 10)
	AddButton(SPR_START1P)
	
	LoadSpriteExpress(SPR_CLASSIC, "classic1.png", 250, 138, 520, 1180, 10)
	AddButton(SPR_CLASSIC)
	
	//The demo adjustments
	SetSpritePosition(SPR_START1P, 490, GetSpriteY(SPR_START1) + GetSpriteHeight(SPR_START1) + 35)
	SetSpritePosition(SPR_CLASSIC, 490, GetSpriteY(SPR_START1P) + GetSpriteHeight(SPR_START1P) + 10)
	//IncSpriteY(SPR_START1, -200)
	
	CreateTextExpress(TXT_ALONE, "Playing alone?" + chr(10) + "Try these!", 80, fontCrabI, 1, 250, GetSpriteY(SPR_START1)+ GetSpriteHeight(SPR_START1)+100, 4)
	SetTextSpacing(TXT_ALONE, -23)
	
	HS_Offset = -140
	
	LoadAnimatedSprite(SPR_MENU_BACK, "back", 8)
	//PlaySprite(SPR_MENU_BACK, 10, 1, 1, 8)
	SetSpriteFrame(SPR_MENU_BACK, 8)
	SetSpriteExpress(SPR_MENU_BACK, 160, 160, 56, 740, 5)
	SetSpriteVisible(SPR_MENU_BACK, 0)
	AddButton(SPR_MENU_BACK)
	
	LoadSpriteExpress(SPR_LEADERBOARD, "leaderboard.png", 370, 205, 30, 520, 5)
	SetSpriteMiddleScreenX(SPR_LEADERBOARD)
	SetSpriteVisible(SPR_LEADERBOARD, 0)
	AddButton(SPR_LEADERBOARD)
	
	LoadSpriteExpress(SPR_STARTAI, "vsAI.png", 250, 150, 50, 1130, 5)
	SetSpriteSize(SPR_STARTAI, 250, 150)
	SetSpritePosition(SPR_STARTAI, 50, 1130)
	AddButton(SPR_STARTAI)
	SetSpriteVisible(SPR_STARTAI, 0)
	
	LoadSpriteExpress(SPR_STORY_START, "story.png", 250, 150, 250, 1130, 5)
	AddButton(SPR_STORY_START)
	//if demo then SetSpriteVisible(SPR_STORY_START, 0)
	
	if highestScene < 9
		LoadSpriteExpress(SPR_CHALLENGE, "ultimatechallengelock.png", 250, 150, 250, 1130, 5)
	else
		LoadSpriteExpress(SPR_CHALLENGE, "ultimatechallenge.png", 250, 150, 250, 1130, 5)
	endif
	AddButton(SPR_CHALLENGE)
	
	LoadSpriteExpress(SPR_VOLUME, "volume.png", 300, 87, 1000, 1000, 5)
	LoadSpriteExpress(SPR_VOLUME_SLIDER, "volumeslider.png", 300, 87, 1000, 1000, 4)
	AddButton(SPR_VOLUME)
	
	SetFolder("/media")
	
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		LoadSprite(i, "art/chibicrab" + str(num) + ".png")
		SetSpriteSize(i, 406/1.3, 275/1.3)
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 1080 + 250*((num-1)/3))
		
		CreateTweenSprite(i, .7)
		SetTweenSpriteY(i, h + 20, 1080 + 250*((num-1)/3), TweenBounce())
		AddButton(i)
	next i
	
	CreateTextExpress(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$, 74, fontDescI, 1, w*3/4-100, GetSpriteY(SPR_MENU_BACK) + 10, 5)
	if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set.")
	SetTextSpacing(TXT_HIGHSCORE, -22)
	SetTextVisible(TXT_HIGHSCORE, 0)
	
	CreateTextExpress(SPR_SP_C1, "CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH?", 80, fontCrabI, 1, w + 20, 980, 5)
	SetTextSpacing(SPR_SP_C1, -25)
	SetTextVisible(SPR_SP_C1, 0)
	
	LoadSpriteExpress(SPR_BG_START, "envi/bg4.png",h*1.5, h*1.5, 0, 0, 100)
	SetSpriteMiddleScreen(SPR_BG_START)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 1080*5 + 250*((num-1)/3))
	next i
	
	//This is the 'single player results screen' setup
	if spActive = 1  and (crab1Deaths <> 0 or crab2Deaths <> 0)
	//Coming from the lose screen	
		if spType = MIRRORMODE then ToggleStartScreen(MIRRORMODE_LOSE, 0)
		if spType = CLASSIC then ToggleStartScreen(CLASSICMODE_LOSE, 0)		
		
		DeleteText(SPR_SP_C1)
		
		for i = 70 to 1 step -1
			SyncG()
		next i
		
		for i = 17 to 1 step -1
			if GetSpriteExists(coverS) then SetSpriteColorAlpha(coverS, 15*i)
			SyncG()
		next i
		
		CreateTweenText(SPR_LOGO_HORIZ, .8)
		SetTweenTextSize(SPR_LOGO_HORIZ, 70, 140, TweenOvershoot())
		PlayTweenText(SPR_LOGO_HORIZ, SPR_LOGO_HORIZ, 0)
		SetTextVisible(SPR_LOGO_HORIZ, 1)
		
		PlaySoundR(chooseS, 100)
		if GetSpriteExists(coverS) then DeleteSprite(coverS)
		if GetSpriteExists(coverS) then DeleteTween(coverS)
		
		CreateTextExpress(SPR_SP_C1, "WANT TO TRY AGAIN? PICK ANOTHER CRAB! WANT TO TRY AGAIN? PICK ANOTHER CRAB!", 80, fontCrabI, 1, w + 20, 980, 5)
		SetTextSpacing(SPR_SP_C1, -25)
		startTimer# = -440
		
	elseif spActive = 1 and crab1Deaths = 0 and crab2Deaths = 0
	//Returning from the pause menu
		if spType = MIRRORMODE then ToggleStartScreen(MIRRORMODE_START, 0)
		if spType = CLASSIC then ToggleStartScreen(CLASSICMODE_START, 0)		
		StopMusicOGGSP(spMusic)
		for i = retro1M to retro8M
			if GetMusicExistsOGG(i)
				if GetMusicPlayingOGGSP(i) then StopMusicOGGSP(i)
			endif
		next i
		
	endif
	
	spScore = 0
				
	if dispH then HorizontalStart()
		
	if spActive = 0 then PlayMusicOGGSP(titleMusic, 1)
				
	startStateInitialized = 1
	
	if spType = CHALLENGEMODE
		for i = 17 to 1 step -1
			if GetSpriteExists(coverS) then SetSpriteColorAlpha(coverS, 15*i)
			UpdateStartElements()
			SyncG()
		next i
	endif
	
	
	
endfunction

function HorizontalStart()
	
	SetSpriteSize(SPR_TITLE, h*2/3, h*2/3)
	SetSpritePosition(SPR_TITLE, w/11, h/7)
	
	SetSpriteMiddleScreen(SPR_LOGO_HORIZ)
	SetSpriteY(SPR_LOGO_HORIZ, 10)
	
	//CreateTextExpress(SPR_LOGO_HORIZ, "MIRROR MODE", 130, fontCrabI, 1, w/2, 360, 5)
	
	SetSpriteSize(SPR_START1, 842*.7, 317*.7)
	SetSpriteMiddleScreenX(SPR_START1)
	SetSpriteY(SPR_START1, h/2 + 480)
	
	SetSpriteSize(SPR_START2, 842*.7, 317*.7)
	SetSpriteMiddleScreenX(SPR_START2)
	
	//CreateTextExpress(TXT_WAIT1, "Waiting for your opponent...", 90, fontDescItalI, 1, w/2, GetSpriteY(SPR_START1)+48, 3)
	//CreateTextExpress(TXT_WAIT2, "Waiting for your opponent...", 90, fontDescItalI, 1, w/2, GetSpriteY(SPR_START2)-48+GetSpriteHeight(SPR_START2), 3)
	SetTextAngle(TXT_WAIT2, 0)
	
	//LoadAnimatedSpriteReversible(SPR_START1P, "mirror", 8)
	SetSpriteExpress(SPR_START1P, 250, 138, 520, 1030, 10)
	
	//LoadSpriteExpress(SPR_CLASSIC, "classic1.png", 250, 138, 520, 1180, 10)
	
	//The demo adjustments
	//SetSpritePosition(SPR_START1P, 490, GetSpriteY(SPR_START1) + GetSpriteHeight(SPR_START1) + 35)
	//SetSpritePosition(SPR_CLASSIC, 490, GetSpriteY(SPR_START1P) + GetSpriteHeight(SPR_START1P) + 10)
	//IncSpriteY(SPR_START1, -200)
	
	//CreateTextExpress(TXT_ALONE, "Playing alone?" + chr(10) + "Try these!", 80, fontCrabI, 1, 250, GetSpriteY(SPR_START1)+ GetSpriteHeight(SPR_START1)+100, 4)
		
	SetSpriteExpress(SPR_MENU_BACK, 160, 160, 56, 740, 5)
	
	SetSpriteMiddleScreenX(SPR_LEADERBOARD)
	
	SetSpriteExpress(SPR_STARTAI, 250, 150, w*3/5, h*3/5 + 100, 5)
	SetSpriteExpress(SPR_STORY_START, 250, 150, w*3/5 + 40, h*3/5 - 100 - 120, 5)
	SetSpriteExpress(SPR_CHALLENGE, 250, 150, w*3/5 + 40, h*3/5 + 70 - 120, 5)
	
	SetSpriteExpress(SPR_VOLUME, 300, 87, 780, 580, 5)
	SetSpriteExpress(SPR_VOLUME_SLIDER, 300, 87, 780, 580, 5)
	
	myX = Min(Max(GetPointerX(), 875), 1045)
	SetSpriteX(SPR_VOLUME_SLIDER, (875 + volumeM*(1045.0-875)/100) -87*3)
	
	//Print(myX)
	//volumeM = (myX-875)*100/(1045-875)
	//SetMusicSystemVolumeOGG(volumeM)
	//volumeSE = (myX-875)*100.0/(1045-875)
	
		
		
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		SetSpriteSize(i, 406/1.3, 275/1.3)
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 1080 + 250*((num-1)/3))
	next i
	
	//CreateTextExpress(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$, 74, fontDescI, 1, w*3/4-100, GetSpriteY(SPR_MENU_BACK) + 10, 5)
		
	//CreateTextExpress(SPR_SP_C1, "CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH?", 80, fontCrabI, 1, w + 20, 980, 5)
		
	SetSpriteSize(SPR_BG_START, w*1.1, w*1.1)
	SetSpriteMiddleScreen(SPR_BG_START)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		//SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 1080*5 + 250*((num-1)/3))
	next i
	
	
endfunction

// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStart()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if startStateInitialized = 0
		InitStart()
		TransitionEnd()
	endif
	state = START
	
	UpdateStartElements()
	
	//Multiplayer section
	if GetPointerPressed() and not Button(SPR_TITLE) and not Button(SPR_VOLUME) and not Button(SPR_CLASSIC) and not Button(SPR_STORY_START) and not Button(SPR_CHALLENGE) and not Button(SPR_START1) and not Button(SPR_LEADERBOARD) and not Button(SPR_MENU_BACK) and not Button(SPR_START2) and not Button(SPR_START1P) and not Button(SPR_SP_C1) and not Button(SPR_SP_C2) and not Button(SPR_SP_C3) and not Button(SPR_SP_C4) and not Button(SPR_SP_C5) and not Button(SPR_SP_C6)
		PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
	endif
	
	//875 to 1045
	if Hover(SPR_VOLUME) and GetPointerState()
		myX = Min(Max(GetPointerX(), 875), 1045)
		SetSpriteX(SPR_VOLUME_SLIDER, myX-87*3)
		
		volumeM = (myX-875)*100/(1045-875)
		SetMusicVolumeOGG(titleMusic, volumeM)
		volumeSE = (myX-875)*100.0/(1045-875)
	endif
	
	if ButtonMultitouchEnabled(SPR_VOLUME) and GetPointerState() = 0
		if volumeM = 0
			volumeM = 100
			volumeSE = 100
			SetSpriteX(SPR_VOLUME_SLIDER, 1045-87*3)
		elseif volumeM < 26
			volumeM = 0
			volumeSE = 0
			SetSpriteX(SPR_VOLUME_SLIDER, 875-87*3)
		elseif volumeM < 51
			volumeM = 25
			volumeSE = 25
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.25 -87*3)
		elseif volumeM < 76
			volumeM = 50
			volumeSE = 50
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.5 -87*3)
		else
			volumeM = 75
			volumeSE = 75
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.75 -87*3)
		endif
		SetMusicVolumeOGG(titleMusic, volumeM)
	endif
	
	if ButtonMultitouchEnabled(SPR_START1) and spActive = 0
		if GetSpriteColorAlpha(SPR_START1) = 255
			//Pressing player one
			PlayTweenSprite(tweenSprFadeOut, SPR_START1, 0)
			PlayTweenText(tweenTxtFadeIn, TXT_WAIT1, 0)
			//SetSpriteColorAlpha(SPR_START1, 140)
			//SetTextColorAlpha(TXT_WAIT1, 255)				
			PlaySprite(SPR_START1, 12, 1, 1, 6)
			p1Ready = 1
		else
			//Cancelling player one
			StopTweenSprite(tweenSprFadeOut, SPR_START1)
			StopTweenText(tweenTxtFadeIn, TXT_WAIT1)
			SetSpriteColorAlpha(SPR_START1, 255)
			SetTextColorAlpha(TXT_WAIT1, 0)
			PlaySprite(SPR_START1, 10, 1, 7, 14)
			p1Ready = 0
		endif
	endif
	
	if ButtonMultitouchEnabled(SPR_START2) and spActive = 0
		if GetSpriteColorAlpha(SPR_START2) = 255
			//Pressing player two
			PlayTweenSprite(tweenSprFadeOut, SPR_START2, 0)
			PlayTweenText(tweenTxtFadeIn, TXT_WAIT2, 0)
			//SetSpriteColorAlpha(SPR_START2, 140)
			//SetTextColorAlpha(TXT_WAIT2, 255)		
			PlaySprite(SPR_START2, 12, 1, 1, 6)
			p2Ready = 1
		else
			//Cancelling player two
			StopTweenSprite(tweenSprFadeOut, SPR_START2)
			StopTweenText(tweenTxtFadeIn, TXT_WAIT2)
			SetSpriteColorAlpha(SPR_START2, 255)
			SetTextColorAlpha(TXT_WAIT2, 0)
			PlaySprite(SPR_START2, 11, 1, 15, 22)
			p2Ready = 0
		endif
	endif
	
	if p1Ready and p2Ready
		p1Ready = 0
		p2Ready = 0
		spActive = 0
		aiActive = 0
		state = CHARACTER_SELECT
	endif
	
	//Transition into mirror mode
	if Button(SPR_START1P) and GetSpriteVisible(SPR_START1P)
		spActive = 1
		spType = MIRRORMODE
		ToggleStartScreen(MIRRORMODE_START, 1)
	endif
	
	//Transition into classic
	if Button(SPR_CLASSIC) and GetSpriteVisible(SPR_CLASSIC)
		spActive = 1
		spType = CLASSIC
		ToggleStartScreen(CLASSICMODE_START, 1)
	endif
	
	//Transition to main screen
	if Button(SPR_MENU_BACK) and GetSpriteVisible(SPR_MENU_BACK)
		spActive = 0
		spType = 0
		ToggleStartScreen(MAINSCREEN, 1)
	endif

	//Starting a single player game
	for i = 1 to 6
		if Button(SPR_SP_C1 + i - 1)
			spActive = 1
			crab1Type = i
			crab2Type = crab1Type
			state = GAME
			if spType = MIRRORMODE then 	PlayMirrorModeScene()
			if spType = CLASSIC
				if GetMusicPlayingOGGSP(retro1M) then SetMusicLoopTimesOGG(retro1M, -1, -1)
				TransitionStart(Random(1, lastTranType))
			endif
		endif
	next i
	
	//Starting an AI game
	if Button(SPR_STARTAI) and GetSpriteVisible(SPR_STARTAI)
		aiActive = 1
		firstFight = 0
		//To do: take this to the character selection screen, figure out if first fight should play
		crab1Type = 4
		crab2Type = 2
		crab2Alt = 2
		state = GAME
	endif
	
	//Going to story mode, will eventually bring you to character select
	if (Button(SPR_STORY_START) and GetSpriteVisible(SPR_STORY_START)) or ((inputSelect and selectTarget = 0))
		spActive = 1
		spType = STORYMODE
		state = CHARACTER_SELECT
		TransitionStart(Random(1,lastTranType))
	endif
	
	//Temporary functionality for the steam demo, will be changed
	if (Button(SPR_CHALLENGE) and GetSpriteVisible(SPR_CHALLENGE) and highestScene > 8)
		SetupChallenge()
		state = GAME
	endif
	
	//Bringing up the leaderboard
	if Button(SPR_LEADERBOARD) and GetSpriteVisible(SPR_LEADERBOARD)
		ShowLeaderBoard(spType)
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START
		if spActive = 0 then TransitionStart(Random(1,lastTranType))
		ExitStart()
	endif
	
endfunction state

function UpdateStartElements()
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	if mod(round(startTimer#)+1080, 150) = 0
		if GetSpriteCurrentFrame(SPR_START1P) = 15 or GetSpriteCurrentFrame(SPR_START1P) = 1 then PlaySprite(SPR_START1P, 30, 0, 1, 8)
		if GetSpriteCurrentFrame(SPR_START1P) = 8 then PlaySprite(SPR_START1P, 30, 0, 8, 15)
	endif
	if mod(round(startTimer#)+1080, 90) = 0 then PlaySprite(SPR_MENU_BACK, 10, 0, 1, 8)
	
	SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
	if dispH then SetSpriteAngle(SPR_TITLE, 4*sin(startTimer#*3))
	if GetSpriteVisible(SPR_TITLE)
		if fruitUnlock# < 0
			if GetPointerState() and GetSpriteHitTest(SPR_TITLE, GetPointerX(), GetPointerY())
				IncSpriteAngle(SPR_TITLE, 15*(300 + fruitUnlock#) + .02*fruitUnlock#*fruitUnlock#)
				inc fruitUnlock#, fpsr#
			else
				fruitUnlock# = -300
			endif
			//Print(fruitUnlock#)
			if fruitUnlock# => 0
				PlaySoundR(gongS, 100)
				fruitMode = 1
				SetSpriteFrame(SPR_TITLE, 2)
				startTimer# = 0
			endif
		else
			if ButtonMultitouchEnabled(SPR_TITLE)
				if fruitMode = 1
					fruitMode = 0
					SetSpriteFrame(SPR_TITLE, 1)
				else
					fruitMode = 1
					SetSpriteFrame(SPR_TITLE, 2)
				endif
			endif
		endif
	endif
	
	if spActive = 0
		for i = 0 to GetTextLength(TXT_WAIT1)
			SetTextCharAngle(TXT_WAIT1, GetTextLength(TXT_WAIT1)-i, -7+14*sin(9*startTimer# + i*6))	//Code from SnowTunes
		next i		
		for i = 0 to GetTextLength(TXT_WAIT2)
			SetTextCharAngle(TXT_WAIT2, GetTextLength(TXT_WAIT2)-i, 180 - 7+14*sin(9*startTimer# + i*6))	//Code from SnowTunes
		next i
		
	endif
	
	SetSpriteAngle(SPR_LOGO_HORIZ, -1 + 4*sin(startTimer#*3))
	
	inc TextJitterTimer#, GetFrameTime()
	if TextJitterTimer# >= 1.0/TextJitterFPS
		doJit = 1
		inc TextJitterTimer#, -TextJitterFPS
		if TextJitterTimer# < 0 then TextJitterTimer# = 0
	endif
	txt = SPR_LOGO_HORIZ
	for i = 0 to GetTextLength(txt)
		if doJit
			SetTextCharY(txt, i, -1 * (jitterNum) + Random(0, (jitterNum)*2))
			SetTextCharAngle(txt, i, -1 * (jitterNum) + Random(0, jitterNum*2))
		endif
	next i
	
	if spType = MIRRORMODE
		if GetTextString(SPR_LOGO_HORIZ) <> "LOSER XD"
			for i = 0 to 7
				SetTextCharColor(TXT_SP_DESC, i, 255, 90+90.0*sin(startTimer#*10), 90+90.0*sin(startTimer#*10), 255)
			next i
			for i = 29 to 38
				SetTextCharColor(TXT_SP_DESC, i, GetColorByCycle(360-startTimer# + i*10,"r"), GetColorByCycle(360-startTimer# + i*10,"g"), GetColorByCycle(360-startTimer# + i*10,"b"), 255)
			next i
		endif
	endif

	//The looping crab selection text
	if GetTextString(SPR_LOGO_HORIZ) <> "LOSER XD"
		//For the starting
		SetTextX(SPR_SP_C1, w+20-startTimer#*1243.62/360)
	else
		//For the losing screen
		SetTextX(SPR_SP_C1, w+20-startTimer#*1295.36/360)
	endif
	
	if debug
		/*
		SetFolder("/media/storysprites")
		
		if GetRawKeyState(17)	//Alt
			body$ = Upper(chr(GetRawLastKey()))
			
			if GetFileExists("body" + body$ + ".png") then SetSpriteImage(SPR_CRAB1_BODY, LoadImage("body" + body$ + ".png"))
			if crab1Type <> 1 or crab1Alt <> 0
				if GetFileExists("costume" + str(2) + body$ + ".png") then SetSpriteImage(SPR_CRAB1_COSTUME, LoadImage("costume" + str(2) + body$ + ".png"))
			else
				SetSpriteImage(SPR_CRAB1_COSTUME, LoadImage("blank.png"))
			endif
		elseif GetRawKeyState(16) 	//Face Base
			face$ = Upper(chr(GetRawLastKey()))
			if GetFileExists("face" + face$ + "a.png") then SetSpriteImage(SPR_CRAB1_FACE, LoadImage("face" + face$ + ".png"))
		else
			
			//crab1Type = Val(chr(GetRawLastKey()))
		endif
			
		*/
		
		
	endif
	
endfunction

#constant MAINSCREEN 1
#constant MIRRORMODE_START 2
#constant MIRRORMODE_LOSE 3
#constant CLASSICMODE_START 4
#constant CLASSICMODE_LOSE 5

function ToggleStartScreen(screen, swipe)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		RemoveButton(i)
	next i
	
	if swipe
		if GetSpriteExists(coverS) then DeleteSprite(coverS)
		if GetTweenExists(coverS) then DeleteTween(coverS)
		CreateSpriteExpress(coverS, h*2, h, -h*2, 0, 1)
		SetSpriteImage(coverS, bgRainSwipeI)
		CreateTweenSprite(coverS, 0.6)
		SetTweenSpriteX(coverS, -h*2, w, TweenLinear())
		
		PlayTweenSprite(coverS,coverS, 0)
		//PlaySoundR(rainbowSweepS, 100)
		PlaySoundR(ninjaStarS, 100)
		iEnd = 20/fpsr#
		for i = 1 to iEnd
			UpdateStartElements()
			SyncG()
		next i
	endif
	
	if screen <> MAINSCREEN then startTimer# = -540
	
	
	//Making everything invisible first
	SetSpriteVisible(SPR_LOGO_HORIZ, 0)
	SetTextVisible(TXT_HIGHSCORE, 0)
	SetTextVisible(TXT_SP_DESC, 0)
	SetSpriteVisible(SPR_START1, 0)
	SetSpriteVisible(SPR_START2, 0)
	SetSpriteVisible(SPR_STARTAI, 0)
	SetTextVisible(TXT_WAIT1, 0)
	SetTextVisible(TXT_WAIT2, 0)
	SetTextVisible(SPR_LOGO_HORIZ, 0)
	SetSpriteVisible(SPR_MENU_BACK, 0)
	SetSpriteVisible(SPR_START1P, 0)
	SetTextVisible(SPR_START1P, 0)
	SetTextVisible(SPR_SP_C1, 0) 
	SetTextVisible(TXT_ALONE, 0) 
	SetSpriteVisible(SPR_STORY_START, 0) 
	SetTextY(SPR_LOGO_HORIZ, 360)
	SetTextSize(TXT_SP_DESC, 59)
	SetTextSpacing(TXT_SP_DESC, -17)
	SetTextY(TXT_SP_DESC, 510)
	SetSpriteVisible(SPR_LEADERBOARD, 0)
	SetSpriteY(SPR_LEADERBOARD, 490)
	SetSpriteVisible(SPR_CLASSIC, 0)
	SetSpriteY(SPR_MENU_BACK, 740)
	SetTextString(SPR_SP_C1, "CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH?")
	SetSpriteVisible(SPR_TITLE, 0)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		AddButton(i)
	next i
	
	if screen = MAINSCREEN
		//Showing the main screen
		startTimer# = 540
		
		SetSpriteColor(SPR_BG_START, 255, 255, 255, 255)
		
		StopMusicOGGSP(spMusic)
		StopMusicOGGSP(retro1M)
		StopMusicOGGSP(loserMusic)
		PlayMusicOGGSP(titleMusic, 1)
		
		SetSpriteVisible(SPR_START1, 1)
		SetSpriteVisible(SPR_START2, 1)
		SetSpriteVisible(SPR_TITLE, 1)
		
		for i = SPR_SP_C1 to SPR_SP_C6
			StopTweenSprite(i, i)
			SetSpriteY(i, 2000)
		next i
		
		
		SetSpriteVisible(SPR_START1P, 1)
		SetSpriteVisible(SPR_CLASSIC, 1)
		SetTextVisible(TXT_ALONE, 1) 
		if demo = 0 then SetSpriteVisible(SPR_STARTAI, 1)
		if demo = 0 then SetSpriteVisible(SPR_STORY_START, 1)
		SetTextVisible(TXT_WAIT1, 1)
		SetTextVisible(TXT_WAIT2, 1)
		
		for i = SPR_SP_C1 to SPR_SP_C6
			RemoveButton(i)
		next i
		
	elseif screen = MIRRORMODE_START
		//Showing the start of the mirror mode screen
				
		StopMusicOGGSP(titleMusic)
		PlayMusicOGGSP(spMusic, 1)
		
		SetSpriteColor(SPR_BG_START, 255, 150, 190, 255)
		
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetSpriteVisible(SPR_LOGO_HORIZ, 1)
		SetTextString(SPR_LOGO_HORIZ, "MIRROR MODE")
		SetTextColor(SPR_LOGO_HORIZ, 192, 192, 192, 255)
		SetTextVisible(SPR_LOGO_HORIZ, 1)
		SetTextString(TXT_SP_DESC, "WARNING: Magic mirror ahead." + chr(10) + "Soul split is likely. Keep" + chr(10) + "both halves safe to survive.")
		SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$)
		if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None yet." + chr(10) + "Go set one!")
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(TXT_SP_DESC, 1)
		SetTextVisible(SPR_SP_C1, 1) 
		SetTextX(SPR_SP_C1, w + 20)
		SetTextVisible(SPR_START1P, 1)
		
		for i = SPR_SP_C1 to SPR_SP_C6			
			PlayTweenSprite(i,  i, (i-SPR_SP_C1)*.06)
		next i
		
	elseif screen = MIRRORMODE_LOSE
		
		SetSpriteColor(SPR_BG_START, 255, 150, 190, 255)
		
		for i = SPR_SP_C1 to SPR_SP_C6
			num = i-SPR_SP_C1+1
			SetSpriteY(i, 1080 + 250*((num-1)/3))
		next i
		
		SetTextString(SPR_LOGO_HORIZ, "LOSER XD")
		IncTextY(SPR_LOGO_HORIZ, -230)
		SetTextColor(SPR_LOGO_HORIZ, 255, 255, 255, 255)
		SetTextVisible(TXT_SP_DESC, 1)
		SetTextString(TXT_SP_DESC, "Final Score: " + str(spScore) + chr(10))
		if spScore < 20
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "(You can do better...)")
		elseif spScore < 50
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "Not bad, for a Loser XD.")
		elseif spScore < 100
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "You're getting good!")
		elseif spScore < 200
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "Yipee!")
		else
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "WOW!!!")
		endif
		if spScore = spHighScore and spHighScore <> 0
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + chr(10) + "New High Score!!")
			IncSpriteY(SPR_LEADERBOARD, 46)
			IncSpriteSizeCenteredMult(SPR_LEADERBOARD, 0.85)
		endif
		SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$)
		if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set." + chr(10) + "Go set one!")
		SetTextSize(TXT_SP_DESC, 80)
		SetTextSpacing(TXT_SP_DESC, -22)
		SetTextY(TXT_SP_DESC, 290)
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(SPR_SP_C1, 1)
		SetTextX(SPR_SP_C1, w + 20)
		SetSpriteVisible(SPR_LEADERBOARD, 1)
		//SetTextString(SPR_SP_C1, "WANT TO TRY AGAIN? PICK ANOTHER CRAB! WANT TO TRY AGAIN? PICK ANOTHER CRAB!")
		
	elseif screen = CLASSICMODE_START
				
		SetSpriteColor(SPR_BG_START, 150, 255, 190, 255)
		
		StopMusicOGGSP(titleMusic)
		PlayMusicOGGSP(retro1M, 1)
		SetMusicLoopTimesOGG(retro1M, -1, 6.316)
		
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetSpriteVisible(SPR_LOGO_HORIZ, 1)
		SetTextString(SPR_LOGO_HORIZ, "CLASSIC")
		SetTextColor(SPR_LOGO_HORIZ, 192, 240, 210, 255)
		SetTextVisible(SPR_LOGO_HORIZ, 1)
		SetTextString(TXT_SP_DESC, "A classic round of Space Crab," + chr(10) + "with all new VS moves!")
		for i = 0 to Len(GetTextString(TXT_SP_DESC))
			SetTextCharColor(TXT_SP_DESC, i, 255, 255, 255, 255)
		next i
		SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScoreClassic) + chr(10) + "with " + spHighCrabClassic$)
		if spHighScoreClassic = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None yet." + chr(10) + "Go set one!")
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(TXT_SP_DESC, 1)
		SetTextVisible(SPR_SP_C1, 1) 
		SetTextX(SPR_SP_C1, w + 20)
		IncSpriteY(SPR_MENU_BACK, -40)
		
		SetTextVisible(SPR_START1P, 1)
		for i = SPR_SP_C1 to SPR_SP_C6			
			PlayTweenSprite(i,  i, (i-SPR_SP_C1)*.06)
		next i
		
	elseif screen = CLASSICMODE_LOSE
		
		SetSpriteColor(SPR_BG_START, 150, 255, 190, 255)
			
		for i = SPR_SP_C1 to SPR_SP_C6
			num = i-SPR_SP_C1+1
			SetSpriteY(i, 1080 + 250*((num-1)/3))
		next i
		
		SetTextString(SPR_LOGO_HORIZ, "LOSER XD")
		IncTextY(SPR_LOGO_HORIZ, -230)
		SetTextColor(SPR_LOGO_HORIZ, 255, 255, 255, 255)
		SetTextVisible(TXT_SP_DESC, 1)
		SetTextString(TXT_SP_DESC, "Final Score: " + str(spScore) + chr(10))
		if spScore < 20
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "(You can do better...)")
		elseif spScore < 50
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "Not bad, for a Loser XD.")
		elseif spScore < 100
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "You're getting good!")
		elseif spScore < 200
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "Yipee!")
		else
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + "WOW!!!")
		endif
		if spScore = spHighScoreClassic and spHighScoreClassic <> 0
			SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + chr(10) + "New High Score!!")
			IncSpriteY(SPR_LEADERBOARD, 46)
			IncSpriteSizeCenteredMult(SPR_LEADERBOARD, 0.85)
		endif
		SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScoreClassic) + chr(10) + "with " + spHighCrabClassic$)
		if spHighScoreClassic = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set." + chr(10) + "Go set one!")
		SetTextSize(TXT_SP_DESC, 80)
		SetTextSpacing(TXT_SP_DESC, -22)
		SetTextY(TXT_SP_DESC, 290)
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(SPR_SP_C1, 1)
		SetTextX(SPR_SP_C1, w + 20)
		SetSpriteVisible(SPR_LEADERBOARD, 1)
		//SetTextString(SPR_SP_C1, "WANT TO TRY AGAIN? PICK ANOTHER CRAB! WANT TO TRY AGAIN? PICK ANOTHER CRAB!")
		
	endif
	
	//The setting of stuff based on other values
	SetTextY(TXT_HIGHSCORE, GetSpriteY(SPR_MENU_BACK))

endfunction

function PlayMirrorModeScene()
	
	if GetSpriteExists(coverS)
		DeleteSprite(coverS)
	endif
	if GetTweenExists(coverS)
		DeleteTween(coverS)
	endif
	
	if GetMusicPlayingOGGSP(loserMusic) then StopMusicOGGSP(loserMusic)
	if GetMusicPlayingOGGSP(spMusic) = 0 then StartGameMusic()
	SetMusicLoopTimesOGG(spMusic, 6.932, -1)
	
	CreateSpriteExpress(coverS, w, h, 0, 0, 4)
	SetSpriteColor(coverS, 255, 255, 255, 100)
	
	SetFolder("/media/art")
	
	spr = SPR_SP_C1 - 1 + crab1Type
	spr2 = spr + 1000
	LoadSprite(spr2, "chibicrab" + str(crab1Type) + ".png")
	MatchSpritePosition(spr2, spr)
	MatchSpriteSize(spr2, spr)
	
	
	DeleteTween(spr)
	
	for i = spr to spr2 step 1000
		
		SetSpriteDepth(i, 3)

		CreateTweenSprite(i, .3)
		SetTweenSpriteX(i, GetSpriteX(i), w/2 - GetSpriteWidth(i)*3/4, TweenEaseIn1())
		SetTweenSpriteY(i, GetSpriteY(i), h/2 - GetSpriteHeight(i)*3/4, TweenEaseIn1())
		SetTweenSpriteSizeX(i, GetSpriteWidth(i), GetSpriteWidth(i)*1.5, TweenEaseIn1())
		SetTweenSpriteSizeY(i, GetSpriteHeight(i), GetSpriteHeight(i)*1.5, TweenEaseIn1())
		
	next i
	
	stage = 0
	iEnd = 70/fpsr#
	for i = 1 to iEnd
		
		if i <= iEnd/3
			if stage = 0
				PlayTweenSprite(spr, spr, 0)
				PlayTweenSprite(spr2, spr2, 0)
				PlaySoundR(arrowS, 100)
				PlaySoundR(specialExitS, 100)
				stage = 1
			endif
			
			SetSpriteColorAlpha(coverS, 255*(i/(iEnd/3.0)))
			SetSpriteColor(spr, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
			SetSpriteColor(spr2, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
		
		else//if //i <= iEnd*2/3
			
			if stage = 1
				SetSpriteColorAlpha(coverS, 255)
				PlaySoundR(mirrorBreakS, 100)
				
				for j = spr to spr2 step 1000
					SetSpriteMiddleScreen(j)
					DeleteTween(j)
					CreateTweenSprite(j, .8)
					SetTweenSpriteAlpha(j, 0, 255, TweenEaseOut1())
				next j
				SetTweenSpriteY(spr, GetSpriteY(spr), h/2 - GetSpriteHeight(spr)/2 + 400, TweenOvershoot())
				SetTweenSpriteY(spr2, GetSpriteY(spr), h/2 - GetSpriteHeight(spr)/2 - 400, TweenOvershoot())
				
				PlayTweenSprite(spr, spr, 0)
				PlayTweenSprite(spr2, spr2, 0)
				
				stage = 2
			endif
			
		endif
		
		
		SyncG()
	next i
	
	for i = 2 to 0 step -1
		SetSpriteColor(coverS, i*85, i*85, i*85, 255)
		SyncG()
	next i
	
	TransitionStart(Random(1,lastTranType))
	
	DeleteSprite(spr2)
	DeleteTween(spr2)
	DeleteSprite(coverS)
	
endfunction

// Cleanup upon leaving this state
function ExitStart()
	
	DeleteSprite(SPR_TITLE)
	DeleteSprite(SPR_LOGO_HORIZ)
	DeleteSprite(SPR_START2)
	DeleteAnimatedSprite(SPR_START1)
	DeleteAnimatedSprite(SPR_START1P)
	DeleteSprite(SPR_STARTAI)
	DeleteSprite(SPR_BG_START)
	DeleteSprite(SPR_MENU_BACK)
	DeleteSprite(SPR_LEADERBOARD)
	DeleteSprite(SPR_CLASSIC)
	DeleteSprite(SPR_STORY_START)
	DeleteSprite(SPR_CHALLENGE)
	DeleteText(SPR_LOGO_HORIZ)
	DeleteText(TXT_WAIT1)
	DeleteText(TXT_WAIT2)
	DeleteText(TXT_HIGHSCORE)
	DeleteText(TXT_SP_DESC)
	DeleteText(SPR_SP_C1)
	DeleteText(TXT_ALONE)
	if GetSpriteExists(coverS) then DeleteSprite(coverS)
	if GetTweenExists(SPR_LOGO_HORIZ) then DeleteTween(SPR_LOGO_HORIZ)
	
	DeleteSprite(SPR_VOLUME)
	DeleteSprite(SPR_VOLUME_SLIDER)
	
	if debug
		for i = SPR_CRAB1_BODY to SPR_CRAB1_COSTUME
			DeleteSprite(i)
		next i
	endif
	
	StopMusicOGGSP(titleMusic)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		DeleteSprite(i)
		DeleteTween(i)
	next i
		
	startTimer# = 0
	p1Ready = 0
	p2Ready = 0
	
	startStateInitialized = 0
	
endfunction

function SetupChallenge()
	aiActive = 1
		firstFight = 0
		spActive = 0
		storyActive = 1
		spType = CHALLENGEMODE
		//To do: take this to the character selection screen, figure out if first fight should play
		crab1Type = 3
		crab1Alt = 0
		crab2Type = 5
		crab2Alt = 0
		SetAIDifficulty(11, 0, 3, 0, 9)
		knowingAI = 12
endfunction
