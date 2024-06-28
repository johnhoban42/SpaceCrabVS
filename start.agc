#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global startStateInitialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function InitStart()
	
	SetCrabPauseStrings()
	SetStoryShortStrings()
	
	//spActive = 0
	//spType = 0
	storyActive = 0
	
	SetSpriteVisible(split, 0)
	
	SetFolder("/media/ui")
	
	sDepth = 10
	
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
	AddButton(SPR_TITLE)

	CreateTextExpress(TXT_SINGLE, "Single Player", 84, fontTitleScreenI, 0, 40, 60, sDepth)

	//Enter Story Mode Button
	LoadAnimatedSprite(SPR_STORY_START, "story", 9)
	AddButton(SPR_STORY_START)

	//Mirror Enter Button
	LoadAnimatedSpriteReversible(SPR_STARTMIRROR, "mirror", 8)
	AddButton(SPR_STARTMIRROR)
	
	//Enter VS AI Button
	LoadSprite(SPR_STARTAI, "vsAI.png")
	AddButton(SPR_STARTAI)
	
	//Classic Enter Button
	LoadSprite(SPR_CLASSIC, "classic1.png")
	AddButton(SPR_CLASSIC)
	
	CreateTextExpress(TXT_MULTI, "Local Two Player", 84, fontTitleScreenI, 0, 40, 60, sDepth)
	
	//P1 Start Button
	LoadAnimatedSprite(SPR_START1, "ready", 22)
	PlaySprite(SPR_START1, 10, 1, 7, 14)
	AddButton(SPR_START1)
	SetSpriteDepth(SPR_START1, 75)
	
	CreateTextExpress(TXT_OTHER, "_____________", 84, fontTitleScreenI, 1, w/2, 1300, sDepth)
	
	//Jukebox Button
	LoadAnimatedSprite(SPR_JUKEBOX, "jukebox", 8)
	AddButton(SPR_JUKEBOX)
	PlaySprite(SPR_JUKEBOX, 8, 1, 1, 8)
	
	//Statistics Button
	LoadAnimatedSprite(SPR_STATS, "stats", 9)
	AddButton(SPR_STATS)
	
	//Settings Button
	LoadAnimatedSprite(SPR_SETTINGS, "settingsl", 8)
	AddButton(SPR_SETTINGS)
	
	CreateSprite(SPR_BG_START, bg4I)
	
	LoadSprite(SPR_EXIT_GAME, "exitGame.png")
	AddButton(SPR_EXIT_GAME)
	
	if dispH = 0

		//Background
		SetSpriteExpress(SPR_BG_START,h, h, 0, 0, 100)
		SetSpriteMiddleScreen(SPR_BG_START)
		
		//Title logo
		SetSpriteExpress(SPR_TITLE, w*3/5, w*3/5, 0, 50, sDepth)
		SetSpriteMiddleScreenX(SPR_TITLE)

		SetTextExpress(TXT_SINGLE, "Single Player", 90, fontTitleScreenI, 0, 40, 550, sDepth, -28)
	
		smallBW = 250
		smallBL = smallBW*3/5
		
		//Enter Story Mode Button
		SetSpriteExpress(SPR_STORY_START, smallBW*1.3, smallBL*1.3, w/2+smallBW*(-0.65-0.75), GetTextY(TXT_SINGLE) + smallBL*.7, sDepth)
		//Enter VS AI Button
		SetSpriteExpress(SPR_STARTAI, smallBW*1.3, smallBL*1.3, w/2+smallBW*(-0.65+0.75), GetTextY(TXT_SINGLE) + smallBL*.7, sDepth)

		//Mirror Enter Button
		SetSpriteExpress(SPR_STARTMIRROR, smallBW*1.1, smallBL*1.1, w/2+smallBW*(-0.55-0.6), GetTextY(TXT_SINGLE) + smallBL*2.1, sDepth)
		//Classic Enter Button
		SetSpriteExpress(SPR_CLASSIC, smallBW*1.1, smallBL*1.1, w/2+smallBW*(-0.55+0.6), GetTextY(TXT_SINGLE) + smallBL*2.1, sDepth)

		SetTextExpress(TXT_MULTI, "Local Two Player", 90, fontTitleScreenI, 0, 40, GetTextY(TXT_SINGLE)+500, sDepth, -28)

		//P1 Start Button
		SetSpriteExpress(SPR_START1, 842*.67, 317*.67, 0, GetTextY(TXT_MULTI)+90, sDepth)
		SetSpriteMiddleScreenX(SPR_START1)
		
		SetTextExpress(TXT_OTHER, "_____________", 84, fontTitleScreenI, 1, w/2, GetSpriteY(SPR_START1)+GetSpriteHeight(SPR_START1)-30, sDepth, -5)
		
		//Jukebox Button
		SetSpriteExpress(SPR_JUKEBOX, smallBW*0.9, smallBL*0.9, w/2+smallBW*(-0.4), GetTextY(TXT_OTHER)+100, sDepth)
		
		//Stats Button
		SetSpriteExpress(SPR_STATS, smallBW*0.9, smallBL*0.9, w/2+smallBW*(-0.4-1.05), GetTextY(TXT_OTHER)+100, sDepth)
		
		//Settings Button
		SetSpriteExpress(SPR_SETTINGS, smallBW*0.9, smallBL*0.9, w/2+smallBW*(-0.4+1.05), GetTextY(TXT_OTHER)+100, sDepth)
		
		SetSpritePosition(SPR_EXIT_GAME, 9999, 9999)

	else
		//The Horizontal menu setting
	
		//Background
		SetSpriteExpress(SPR_BG_START, w, w, 0, 0, 100)
		SetSpriteMiddleScreen(SPR_BG_START)
		
		//Title logo
		SetSpriteExpress(SPR_TITLE, h*5/9, h*5/9, 0, 50, sDepth)
		SetSpriteMiddleScreenX(SPR_TITLE)

		centerL = 270
		centerR = w - centerL

		SetTextExpress(TXT_SINGLE, "Single Player", 70, fontTitleScreenI, 1, centerL, 330, sDepth, -23)
	
		smallBW = 180
		smallBL = smallBW*3/5
		//Enter Story Mode Button
		SetSpriteExpress(SPR_STORY_START, smallBW*1.3, smallBL*1.3, centerL+smallBW*(-0.65-0.75), GetTextY(TXT_SINGLE) + smallBL*.7, sDepth)
		//Enter VS AI Button
		SetSpriteExpress(SPR_STARTAI, smallBW*1.3, smallBL*1.3, centerL+smallBW*(-0.65+0.75), GetTextY(TXT_SINGLE) + smallBL*.7, sDepth)

		//Mirror Enter Button
		SetSpriteExpress(SPR_STARTMIRROR, smallBW*1.1, smallBL*1.1, centerL+smallBW*(-0.55-0.6), GetTextY(TXT_SINGLE) + smallBL*2.1, sDepth)
		//Classic Enter Button
		SetSpriteExpress(SPR_CLASSIC, smallBW*1.1, smallBL*1.1, centerL+smallBW*(-0.55+0.6), GetTextY(TXT_SINGLE) + smallBL*2.1, sDepth)

		SetTextExpress(TXT_MULTI, "Local Two Player", 70, fontTitleScreenI, 1, centerR, GetTextY(TXT_SINGLE), sDepth, -23)

		//P1 Start Button
		SetSpriteExpress(SPR_START1, 842*.67*.72, 317*.67*.72, centerR - 842*.67*.72*.5, GetTextY(TXT_MULTI)+smallBL*.7, sDepth)
		
		SetTextExpress(TXT_OTHER, "__________", 66, fontTitleScreenI, 1, centerR, GetSpriteY(SPR_START1)+GetSpriteHeight(SPR_START1)-30, sDepth, -5)
		
		//Jukebox Button
		SetSpriteExpress(SPR_JUKEBOX, smallBW*0.8, smallBL*0.8, centerR+smallBW*(-0.4), GetTextY(TXT_OTHER)+80, sDepth)
		
		//Stats Button
		SetSpriteExpress(SPR_STATS, smallBW*0.8, smallBL*0.8, centerR+smallBW*(-0.4-.85), GetTextY(TXT_OTHER)+80, sDepth)
		
		//Settings Button
		SetSpriteExpress(SPR_SETTINGS, smallBW*0.8, smallBL*0.8, centerR+smallBW*(-0.4+.85), GetTextY(TXT_OTHER)+80, sDepth)
		
		//Settings Button
		SetSpriteExpress(SPR_EXIT_GAME, 110, 110, w - 140, 30, sDepth)
	
	endif

	//Creating the tweens for the main menu pieces
	for i = 0 to 7
		twn = SPR_STORY_START+i
		CreateTweenSprite(twn, .3)
		SetTweenSpriteY(twn, GetSpriteY(twn)+2000, GetSpriteY(twn), TweenEaseIn2())
	next i
	for i = 0 to 2
		twn = TXT_SINGLE+i
		CreateTweenText(twn, .3)
		SetTweenTextY(twn, GetTextY(twn)+2000, GetTextY(twn), TweenEaseIn2())
	next i

	//The mirror/classic stuff
	CreateTextExpress(TXT_SP_LOGO, "MIRROR MODE", 120, fontCrabI, 1, w/2, 60, 5)
	SetTextSpacing(TXT_SP_LOGO, -36)
	SetTextVisible(TXT_SP_LOGO, 0)
	CreateTweenText(TXT_SP_LOGO, .8)
	SetTweenTextSize(TXT_SP_LOGO, 70, 130, TweenOvershoot())
	PlayTweenText(TXT_SP_LOGO, TXT_SP_LOGO, 0)

	//CreateTextExpress(TXT_SP_DESC, "WARNING: Magic mirror ahead." + chr(10) + "Soul split is likely. Keep" + chr(10) + "both halves safe to survive.", 59, fontDescI, 1, w/2, 510, 5)
	CreateTextExpress(TXT_SP_DESC, "", 59, fontDescI, 1, w/2, 510, 5)
	SetTextSpacing(TXT_SP_DESC, -17)
	SetTextVisible(TXT_SP_DESC, 0)

	SetFolder("/media")
	for i = SPR_SP_C1 to SPR_SP_C24
		num = i-SPR_SP_C1+1
		crb = i - SPR_SP_C1
		mImg = LoadImage("art/mystery.png")
		if altUnlocked[Mod(num, 6)+1] < (num)/6
			CreateSprite(i, mImg)
			SetSpriteColor(i, 254, 254, 254, 255)
		else
			LoadSprite(i, "art/chibicrab" + str(Mod(crb, 6)+1) + AltStr((crb)/6) + ".png")
		endif
		
		SetSpriteSizeSquare(i, 200)
		SetSpritePosition(i, 9999, 980 + 150*(Mod(num-1, 6)-2.5))
		//SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 1080 + 250*((num-1)/3))
		
		CreateTweenSprite(i, .7)
		SetTweenSpriteX(i, w + 20, w/2 - GetSpriteWidth(i)/2 + 190*((num-1)/6-1.5) , TweenBounce())
		SetSpriteVisible(i, 0)
		AddButton(i)
	next i

	CreateMirror()
	
		
	if spType = 0 or spType = STORYMODE or spType = AIBATTLE then PlayMusicOGGSP(titleMusic, 1)
	spScore = 0
	
	startStateInitialized = 1
	
endfunction

function CreateMirror()
	
	SetFolder("/media/ui")

	
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
	
	//Mostly incomprehensible below here
	SetFolder("/media")
	
	
	
	CreateTextExpress(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$, 74, fontDescI, 1, w*3/4-100, GetSpriteY(SPR_MENU_BACK) + 10, 5)
	if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set.")
	SetTextSpacing(TXT_HIGHSCORE, -22)
	SetTextVisible(TXT_HIGHSCORE, 0)
	
	CreateTextExpress(SPR_SP_C1, "CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH?", 80, fontCrabI, 1, w + 20, 980, 5)
	SetTextSpacing(SPR_SP_C1, -25)
	SetTextVisible(SPR_SP_C1, 0)
	
	
	//This is the 'single player results screen' setup
	if spType = MIRRORMODE or spType = CLASSIC and (crab1Deaths <> 0 or crab2Deaths <> 0)
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
		
		
		
		PlaySoundR(chooseS, 100)
		if GetSpriteExists(coverS) then DeleteSprite(coverS)
		if GetSpriteExists(coverS) then DeleteTween(coverS)
		
		CreateTextExpress(SPR_SP_C1, "WANT TO TRY AGAIN? PICK ANOTHER CRAB! WANT TO TRY AGAIN? PICK ANOTHER CRAB!", 80, fontCrabI, 1, w + 20, 980, 5)
		SetTextSpacing(SPR_SP_C1, -25)
		startTimer# = -440
		
	elseif spType = MIRRORMODE or spType = CLASSIC and crab1Deaths = 0 and crab2Deaths = 0
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
	
endfunction



// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStart()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if startStateInitialized = 0
		InitStart()
		TransitionEnd()
		
		if firstStartup = 0
			Popup(MIDDLE, -2)
			firstStartup = 1
		endif
		
	endif
	state = START

	UpdateStartElements()
	
	//Multiplayer section
	if GetPointerPressed() and not Button(SPR_TITLE) and not Button(SPR_SETTINGS) and not Button(SPR_CLASSIC) and not Button(SPR_STORY_START) and not Button(SPR_START1) and not Button(SPR_LEADERBOARD) and not Button(SPR_MENU_BACK) and not Button(SPR_STARTMIRROR) and not Button(SPR_SP_C1)
		PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
	endif
	
	
	//if ButtonMultitouchEnabled(SPR_START1) and spActive = 0 and dispH = 1
	if ButtonMultitouchEnabled(SPR_START1) //and dispH = 1
		spType = 0
		storyActive = 0
		spType = 0
		state = CHARACTER_SELECT
	endif
	
	if p1Ready and p2Ready
		p1Ready = 0
		p2Ready = 0
		spType = 0
		state = CHARACTER_SELECT
	endif
	
	//Transition into mirror mode
	if ButtonMultitouchEnabled(SPR_STARTMIRROR) and GetSpriteVisible(SPR_STARTMIRROR)
		spType = MIRRORMODE
		ToggleStartScreen(MIRRORMODE_START, 1)
	endif
	
	//Transition into classic
	if Button(SPR_CLASSIC) and GetSpriteVisible(SPR_CLASSIC)
		spType = CLASSIC
		ToggleStartScreen(CLASSICMODE_START, 1)
	endif
	
	//Transition to main screen
	if ButtonMultitouchEnabled(SPR_MENU_BACK) and GetSpriteVisible(SPR_MENU_BACK)
		spType = 0
		ToggleStartScreen(MAINSCREEN, 1)
	endif

	//Starting a single player game
	for i = 1 to 24
		if Button(SPR_SP_C1 + i - 1) and GetSpriteColorRed(SPR_SP_C1 + i - 1) <> 254
			crab1Type = Mod(i-1, 6)+1
			crab2Type = crab1Type
			crab1Alt = (i-1)/6
			crab2Alt = crab1Alt
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
		//UnlockCrab(1, 1, 1)
		spType = AIBATTLE
		state = CHARACTER_SELECT
	endif
	
	//Going to the settings screen
	if ButtonMultitouchEnabled(SPR_SETTINGS)
		ClearMultiTouch()
		StartSettings()
	endif
	
	//Going to story mode, will eventually bring you to character select
	if (Button(SPR_STORY_START) and GetSpriteVisible(SPR_STORY_START)) or ((inputSelect and selectTarget = 0))
		spType = STORYMODE
		state = CHARACTER_SELECT
		//TransitionStart(Random(1,lastTranType))
	endif
	
	//Bringing up the leaderboard
	if Button(SPR_LEADERBOARD) and GetSpriteVisible(SPR_LEADERBOARD)
		ShowLeaderBoard(spType)
	endif
	
	if ButtonMultitouchEnabled(SPR_EXIT_GAME) then End
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START
		if spType = 0 or spType = STORYMODE or spType = AIBATTLE then TransitionStart(Random(1,lastTranType))
		ExitStart()
	endif
	
endfunction state

function UpdateStartElements()
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	if mod(round(startTimer#)+1080, 150) = 0
		if GetSpriteCurrentFrame(SPR_STARTMIRROR) = 15 or GetSpriteCurrentFrame(SPR_STARTMIRROR) = 1 then PlaySprite(SPR_STARTMIRROR, 30, 0, 1, 8)
		if GetSpriteCurrentFrame(SPR_STARTMIRROR) = 8 then PlaySprite(SPR_STARTMIRROR, 30, 0, 8, 15)
	endif
	if mod(round(startTimer#)+1080, 90) = 0 then PlaySprite(SPR_MENU_BACK, 10, 0, 1, 8)
	if mod(round(startTimer#)+1080, 140) = 0 then PlaySprite(SPR_STORY_START, 10, 0, 1, 9)
	if mod(round(startTimer#)+1080, 216) = 0 then PlaySprite(SPR_STATS, 10, 0, 1, 9)
	if mod(round(startTimer#)+1080, 280) = 0 then PlaySprite(SPR_SETTINGS, 10, 0, 1, 8)
	
	//SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
	SetSpriteAngle(SPR_TITLE, 4*sin(startTimer#*3))
	if GetSpriteVisible(SPR_TITLE)
		contFruit = 0
		switchFruit = 0
		if GetRawJoystickConnected(1)
			if GetRawJoystickButtonPressed(1, 9) and GetRawJoystickButtonPressed(1, 10)
				switchFruit = 1
				if fruitUnlock# >= 0 then PlaySound(buttonSound)
			endif
			if GetRawJoystickButtonState(1, 9) and GetRawJoystickButtonState(1, 10)
				contFruit = 1
			endif
		endif
		if fruitUnlock# < 0
			if (GetPointerState() and GetSpriteHitTest(SPR_TITLE, GetPointerX(), GetPointerY())) or contFruit
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
			if ButtonMultitouchEnabled(SPR_TITLE) or switchFruit
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
	
	//SetSpriteAngle(TXT_SP_LOGO, -1 + 4*sin(startTimer#*3))
	
	inc TextJitterTimer#, GetFrameTime()
	if TextJitterTimer# >= 1.0/TextJitterFPS
		doJit = 1
		inc TextJitterTimer#, -TextJitterFPS
		if TextJitterTimer# < 0 then TextJitterTimer# = 0
	endif
	txt = TXT_SP_LOGO
	for i = 0 to GetTextLength(txt)
		if doJit
			SetTextCharY(txt, i, -1 * (jitterNum) + Random(0, (jitterNum)*2))
			SetTextCharAngle(txt, i, -1 * (jitterNum) + Random(0, jitterNum*2))
		endif
	next i
	
	if spType = MIRRORMODE
		if GetTextString(TXT_SP_LOGO) <> "LOSER XD"
			for i = 0 to 7
				SetTextCharColor(TXT_SP_DESC, i, 255, 90+90.0*sin(startTimer#*10), 90+90.0*sin(startTimer#*10), 255)
			next i
			for i = 29 to 38
				SetTextCharColor(TXT_SP_DESC, i, GetColorByCycle(360-startTimer# + i*10,"r"), GetColorByCycle(360-startTimer# + i*10,"g"), GetColorByCycle(360-startTimer# + i*10,"b"), 255)
			next i
		endif
	endif

	//The looping crab selection text
	if GetTextString(TXT_SP_LOGO) <> "LOSER XD"
		//For the starting
		SetTextX(SPR_SP_C1, w+20-startTimer#*1243.62/360)
	else
		//For the losing screen
		SetTextX(SPR_SP_C1, w+20-startTimer#*1295.36/360)
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
	//The main menu sprites/text in order
	SetSpriteVisible(SPR_TITLE, 0)
	
	SetTextVisible(TXT_SINGLE, 0)
	SetSpriteVisible(SPR_STORY_START, 0) 
	SetSpriteVisible(SPR_STARTAI, 0)
	SetSpriteVisible(SPR_STARTMIRROR, 0)
	SetSpriteVisible(SPR_CLASSIC, 0)
	
	SetTextVisible(TXT_MULTI, 0)
	SetSpriteVisible(SPR_START1, 0)
	
	SetTextVisible(TXT_OTHER, 0)
	SetSpriteVisible(SPR_JUKEBOX, 0)
	SetSpriteVisible(SPR_STATS, 0)
	SetSpriteVisible(SPR_SETTINGS, 0)
	SetSpriteVisible(SPR_EXIT_GAME, 0)
	
	//The mirror/classic sprites
	SetTextVisible(TXT_HIGHSCORE, 0)
	SetTextVisible(TXT_SP_DESC, 0)
	
	for i = SPR_SP_C1 to SPR_SP_C24
		SetSpriteVisible(i, 0)
	next i
	
	SetTextVisible(TXT_SP_LOGO, 0)
	SetSpriteVisible(SPR_MENU_BACK, 0)
	SetTextVisible(SPR_SP_C1, 0) 
	SetTextSize(TXT_SP_DESC, 59)
	SetTextSpacing(TXT_SP_DESC, -17)
	SetTextY(TXT_SP_DESC, 510)
	SetSpriteVisible(SPR_LEADERBOARD, 0)
	SetSpriteY(SPR_LEADERBOARD, 490)
	SetSpriteY(SPR_MENU_BACK, 740)
	SetTextString(SPR_SP_C1, "CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH? WHY NOT CHOOSE A CRUSTACEAN, YEAH?")
	SetTextX(SPR_SP_C1, w + 20)
	
		
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
		
		SetSpriteVisible(SPR_TITLE, 1)
		
		SetTextVisible(TXT_SINGLE, 1)
		SetSpriteVisible(SPR_STORY_START, 1)
		SetSpriteVisible(SPR_STARTAI, 1)
		SetSpriteVisible(SPR_STARTMIRROR, 1)
		SetSpriteVisible(SPR_CLASSIC, 1)
		
		SetTextVisible(TXT_MULTI, 1)
		SetSpriteVisible(SPR_START1, 1)
		
		SetTextVisible(TXT_OTHER, 1)
		SetSpriteVisible(SPR_JUKEBOX, 1)
		SetSpriteVisible(SPR_STATS, 1)
		SetSpriteVisible(SPR_SETTINGS, 1)
		SetSpriteVisible(SPR_EXIT_GAME, 1)
		
		for i = SPR_SP_C1 to SPR_SP_C24
			StopTweenSprite(i, i)
			SetSpriteY(i, 2000)
		next i
	
		for i = SPR_SP_C1 to SPR_SP_C24
			RemoveButton(i)
		next i
	endif
	if screen = MIRRORMODE_START or screen = CLASSICMODE_START
		//Showing the start of the mirror mode screen
				
		StopMusicOGGSP(titleMusic)
		if screen = MIRRORMODE_START
			PlayMusicOGGSP(spMusic, 1)
			SetSpriteColor(SPR_BG_START, 255, 150, 190, 255)
			SetTextString(TXT_SP_LOGO, "MIRROR MODE")
			SetTextColor(TXT_SP_LOGO, 192, 192, 192, 255)
			//SetTextString(TXT_SP_DESC, "WARNING: Magic mirror ahead." + chr(10) + "Soul split is likely. Keep" + chr(10) + "both halves safe to survive.")
			SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$)
			if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None yet." + chr(10) + "Go set one!")
		endif
		if screen = CLASSICMODE_START
			PlayMusicOGGSP(retro1M, 1)
			SetMusicLoopTimesOGG(retro1M, -1, 6.316)
			SetSpriteColor(SPR_BG_START, 150, 255, 190, 255)
			SetTextString(TXT_SP_LOGO, "CLASSIC MODE")
			SetTextColor(TXT_SP_LOGO, 192, 240, 210, 255)
			//SetTextString(TXT_SP_DESC, "A classic round of Space Crab," + chr(10) + "with all new VS moves!")
			SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScoreClassic) + chr(10) + "with " + spHighCrabClassic$)
			if spHighScoreClassic = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None yet." + chr(10) + "Go set one!")
		endif
		
		for i = SPR_SP_C1 to SPR_SP_C24
			SetSpriteVisible(i, 1)
			PlayTweenSprite(i,  i, (i-SPR_SP_C1)*.03)
		next i
		
		
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetTextVisible(TXT_SP_LOGO, 1)
		
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(TXT_SP_DESC, 1)
		SetTextVisible(SPR_SP_C1, 1) 
		SetTextX(SPR_SP_C1, w + 20)
		
		
		for i = 0 to Len(GetTextString(TXT_SP_DESC))
			//SetTextCharColor(TXT_SP_DESC, i, 255, 255, 255, 255)
		next i
		
	endif
	if screen = MIRRORMODE_LOSE or screen = CLASSICMODE_LOSE
		
		if screen = MIRRORMODE_LOSE
			SetSpriteColor(SPR_BG_START, 255, 150, 190, 255)
			if spScore = spHighScore and spHighScore <> 0
				SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + chr(10) + "New High Score!!")
				IncSpriteY(SPR_LEADERBOARD, 46)
				IncSpriteSizeCenteredMult(SPR_LEADERBOARD, 0.85)
			endif
			SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$)
			if spHighScore = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set." + chr(10) + "Go set one!")
			
		elseif screen = CLASSICMODE_LOSE
			SetSpriteColor(SPR_BG_START, 150, 255, 190, 255)
			if spScore = spHighScoreClassic and spHighScoreClassic <> 0
				SetTextString(TXT_SP_DESC, GetTextString(TXT_SP_DESC) + chr(10) + "New High Score!!")
				IncSpriteY(SPR_LEADERBOARD, 46)
				IncSpriteSizeCenteredMult(SPR_LEADERBOARD, 0.85)
			endif
			SetTextString(TXT_HIGHSCORE, "High Score: " + str(spHighScoreClassic) + chr(10) + "with " + spHighCrabClassic$)
			if spHighScoreClassic = 0 then SetTextString(TXT_HIGHSCORE, "High Score: None set." + chr(10) + "Go set one!")
		endif
		
		for i = SPR_SP_C1 to SPR_SP_C24
			SetSpriteVisible(i, 1)
			PlayTweenSprite(i,  i, 0)
			UpdateTweenSprite(i, i, 2)
		next i
		
		SetTextString(TXT_SP_LOGO, "LOSER XD")
		SetTextColor(TXT_SP_LOGO, 255, 255, 255, 255)
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
		
		
		SetTextSize(TXT_SP_DESC, 80)
		SetTextSpacing(TXT_SP_DESC, -22)
		SetTextY(TXT_SP_DESC, 290)
		SetSpriteVisible(SPR_MENU_BACK, 1)
		SetTextVisible(TXT_HIGHSCORE, 1)
		SetTextVisible(SPR_SP_C1, 1)
		SetSpriteVisible(SPR_LEADERBOARD, 1)
		SetTextString(SPR_SP_C1, "WANT TO TRY AGAIN? PICK ANOTHER CRAB! WANT TO TRY AGAIN? PICK ANOTHER CRAB!")
	
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
	if storyActive = 0 then SetMusicLoopTimesOGG(spMusic, 6.932, -1)
	
	CreateSpriteExpress(coverS, w, h, 0, 0, 4)
	SetSpriteColor(coverS, 255, 255, 255, 100)
	
	SetFolder("/media/art")
	
	
	if storyActive = 0
		spr = SPR_SP_C1 - 1 + crab1Type + crab1Alt*6
		spr2 = spr + 1000
		LoadSprite(spr2, "chibicrab" + str(crab1Type) + AltStr(crab1Alt) + ".png")
		MatchSpritePosition(spr2, spr)
		MatchSpriteSize(spr2, spr)
	else		
		spr = SPR_CRAB1_BODY
		spr2 = spr + 1000
		CreateSprite(spr2, GetSpriteImageID(spr))
		MatchSpritePosition(spr2, spr)
		MatchSpriteSize(spr2, spr)
		
		spr3 = SPR_CRAB1_FACE
		spr4 = spr3 + 1000
		CreateSprite(spr4, GetSpriteImageID(spr3))
		MatchSpritePosition(spr4, spr3)
		MatchSpriteSize(spr4, spr3)
		SetSpriteVisible(spr3, 0)
		SetSpriteVisible(spr4, 0)
		//The face is invisible, otherwise it looks creepy
		//I just left the sprite for it in because it makes the for loops easier
		
		spr5 = SPR_CRAB1_COSTUME
		spr6 = spr5 + 1000
		CreateSprite(spr6, GetSpriteImageID(spr5))
		MatchSpritePosition(spr6, spr5)
		MatchSpriteSize(spr6, spr5)
		
		DeleteTween(spr3)
		DeleteTween(spr5)
		
		for i = spr to spr5 step 2
			SetSpriteFlip(i, 1, 0)
		next i
		for i = spr2 to spr6 step 2
			SetSpriteFlip(i, 1, 0)
		next i
	endif
	
	
	DeleteTween(spr)
	
	kEnd = 0
	if storyActive then kEnd = 2
	for k = 0 to kEnd
		for i = spr to spr2 step 1000
			
			SetSpriteDepth(i+k, 3)
	
			CreateTweenSprite(i+k, .3)
			SetTweenSpriteX(i+k, GetSpriteX(i+k), w/2 - GetSpriteWidth(i+k)*3/4, TweenEaseIn1())
			SetTweenSpriteY(i+k, GetSpriteY(i+k), h/2 - GetSpriteHeight(i+k)*3/4, TweenEaseIn1())
			SetTweenSpriteSizeX(i+k, GetSpriteWidth(i+k), GetSpriteWidth(i+k)*1.5, TweenEaseIn1())
			SetTweenSpriteSizeY(i+k, GetSpriteHeight(i+k), GetSpriteHeight(i+k)*1.5, TweenEaseIn1())
			
		next i
	next k
	
	stage = 0
	iEnd = 70/fpsr#
	for i = 1 to iEnd
		
		if i <= iEnd/3
			if stage = 0
				PlayTweenSprite(spr, spr, 0)
				PlayTweenSprite(spr2, spr2, 0)
				if storyActive
					PlayTweenSprite(spr3, spr3, 0)
					PlayTweenSprite(spr4, spr4, 0)
					PlayTweenSprite(spr5, spr5, 0)
					PlayTweenSprite(spr6, spr6, 0)
				endif
				PlaySoundR(arrowS, 100)
				PlaySoundR(specialExitS, 100)
				stage = 1
			endif
			
			SetSpriteColorAlpha(coverS, 255*(i/(iEnd/3.0)))
			SetSpriteColor(spr, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
			SetSpriteColor(spr2, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
			if storyActive
				SetSpriteColor(spr3, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
				SetSpriteColor(spr4, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
				SetSpriteColor(spr5, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
				SetSpriteColor(spr6, 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255 - 255*(i/(iEnd/3.0)), 255)
			endif
		
		else//if //i <= iEnd*2/3
			
			if stage = 1
				SetSpriteColorAlpha(coverS, 255)
				PlaySoundR(mirrorBreakS, 100)
				
				for k = 0 to kEnd
					for j = spr to spr2 step 1000
						SetSpriteMiddleScreen(j+k)
						DeleteTween(j+k)
						CreateTweenSprite(j+k, .8)
						SetTweenSpriteAlpha(j+k, 0, 255, TweenEaseOut1())
					next j
				next k
				
				if dispH
					offset = 50
					SetTweenSpriteX(spr, GetSpriteX(spr), w/4 - GetSpriteWidth(spr)/2 + offset, TweenOvershoot())
					SetTweenSpriteX(spr2, GetSpriteX(spr), w*3/4 - GetSpriteWidth(spr)/2 - offset, TweenOvershoot())
					if storyActive
						SetTweenSpriteX(spr3, GetSpriteX(spr3), w/4 - GetSpriteWidth(spr3)/2 + offset, TweenOvershoot())
						SetTweenSpriteX(spr4, GetSpriteX(spr3), w*3/4 - GetSpriteWidth(spr3)/2 - offset, TweenOvershoot())
						SetTweenSpriteX(spr5, GetSpriteX(spr5), w/4 - GetSpriteWidth(spr5)/2 + offset, TweenOvershoot())
						SetTweenSpriteX(spr6, GetSpriteX(spr5), w*3/4 - GetSpriteWidth(spr5)/2 - offset, TweenOvershoot())
					endif
				else
					offset = 400
					SetTweenSpriteY(spr, GetSpriteY(spr), h/2 - GetSpriteHeight(spr)/2 + offset, TweenOvershoot())
					SetTweenSpriteY(spr2, GetSpriteY(spr), h/2 - GetSpriteHeight(spr)/2 - offset, TweenOvershoot())
					if storyActive
						SetTweenSpriteY(spr3, GetSpriteY(spr3), h/2 - GetSpriteHeight(spr3)/2 + offset, TweenOvershoot())
						SetTweenSpriteY(spr4, GetSpriteY(spr3), h/2 - GetSpriteHeight(spr3)/2 - offset, TweenOvershoot())
						SetTweenSpriteY(spr5, GetSpriteY(spr5), h/2 - GetSpriteHeight(spr5)/2 + offset, TweenOvershoot())
						SetTweenSpriteY(spr6, GetSpriteY(spr5), h/2 - GetSpriteHeight(spr5)/2 - offset, TweenOvershoot())
					endif
				endif
				
				PlayTweenSprite(spr, spr, 0)
				PlayTweenSprite(spr2, spr2, 0)
				if storyActive
					PlayTweenSprite(spr3, spr3, 0)
					PlayTweenSprite(spr4, spr4, 0)
					PlayTweenSprite(spr5, spr5, 0)
					PlayTweenSprite(spr6, spr6, 0)
				endif
				
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
	if storyActive
		DeleteSprite(spr4)
		DeleteTween(spr4)
		DeleteSprite(spr6)
		DeleteTween(spr6)
	endif
	
endfunction

// Cleanup upon leaving this state
function ExitStart()
	
	DeleteSprite(SPR_TITLE)
	DeleteSprite(SPR_STARTAI)
	DeleteSprite(SPR_BG_START)
	DeleteAnimatedSprite(SPR_MENU_BACK)
	DeleteSprite(SPR_LEADERBOARD)
	DeleteSprite(SPR_CLASSIC)
	DeleteSprite(SPR_EXIT_GAME)
	DeleteAnimatedSprite(SPR_STORY_START)
	DeleteAnimatedSprite(SPR_SETTINGS)
	DeleteAnimatedSprite(SPR_JUKEBOX)
	DeleteAnimatedSprite(SPR_STATS)
	DeleteAnimatedSprite(SPR_START1)
	DeleteAnimatedSprite(SPR_STARTMIRROR)
	DeleteText(TXT_SP_LOGO)
	DeleteText(TXT_HIGHSCORE)
	DeleteText(TXT_SP_DESC)
	DeleteText(SPR_SP_C1)
	DeleteText(TXT_SINGLE)
	DeleteText(TXT_MULTI)
	DeleteText(TXT_OTHER)
	if GetSpriteExists(coverS) then DeleteSprite(coverS)
	if GetTweenExists(TXT_SP_LOGO) then DeleteTween(TXT_SP_LOGO)
	
	for i = 0 to 99
		twn = SPR_STORY_START+i
		if GetTweenSpriteExists(twn) then DeleteTween(twn)
		if GetTweenTextExists(twn) then DeleteTween(twn)
	next i
	
	if debug
		for i = SPR_CRAB1_BODY to SPR_CRAB1_COSTUME
			DeleteSprite(i)
		next i
	endif
	
	StopMusicOGGSP(titleMusic)
	
	for i = SPR_SP_C1 to SPR_SP_C24
		DeleteSprite(i)
		DeleteTween(i)
	next i
		
	startTimer# = 0
	p1Ready = 0
	p2Ready = 0
	
	startStateInitialized = 0
	
endfunction

function SetupChallenge()
		firstFight = 0
		//storyActive = 1
		spType = CHALLENGEMODE
		//To do: take this to the character selection screen, figure out if first fight should play
		crab1Type = 3
		crab1Alt = 0
		crab2Type = 5
		crab2Alt = 0
		SetAIDifficulty(11, 0, 3, 0, 9)
		knowingAI = 12
endfunction
