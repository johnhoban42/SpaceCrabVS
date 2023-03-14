#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global startStateInitialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function InitStart()
	
	SetSpriteVisible(split, 0)
	
	SetFolder("/media")
	
	LoadSprite(SPR_TITLE, "title.png")
	SetSpriteSize(SPR_TITLE, w*2/3, w*2/3)
	SetSpriteMiddleScreen(SPR_TITLE)
	//IncSpriteX(SPR_TITLE, 150)
	SetSpriteAngle(SPR_TITLE, 90)
	
	LoadSprite(SPR_START1, "start.png")
	SetSpriteSize(SPR_START1, 600, 160)
	SetSpriteMiddleScreenX(SPR_START1)
	SetSpriteY(SPR_START1, h/2 + 550)
	SetSpriteAngle(SPR_START1, 0)
	SetSpriteDepth(SPR_START1, 75)
	
	LoadSprite(SPR_START2, "start.png")
	SetSpriteSize(SPR_START2, 600, 160)
	SetSpriteMiddleScreenX(SPR_START2)
	SetSpriteY(SPR_START2, h/2 - 550 - GetSpriteHeight(SPR_START2))
	SetSpriteAngle(SPR_START2, 180)
	SetSpriteDepth(SPR_START2, 75)
	
	CreateTextExpress(TXT_WAIT1, "Waiting for your opponent...", 86, fontDescItalI, 1, w/2, GetSpriteY(SPR_START1)+38, 3)
	SetTextColorAlpha(TXT_WAIT1, 0)
	SetTextSpacing(TXT_WAIT1, -30)
	CreateTextExpress(TXT_WAIT2, "Waiting for your opponent...", 86, fontDescItalI, 1, w/2, GetSpriteY(SPR_START2)-38+GetSpriteHeight(SPR_START2), 3)
	SetTextColorAlpha(TXT_WAIT2, 0)
	SetTextSpacing(TXT_WAIT2, -30)
	SetTextAngle(TXT_WAIT2, 180)
	
	LoadSprite(SPR_START1P, "singlePlayerButton.png")
	SetSpriteSize(SPR_START1P, 250, 150)
	SetSpritePosition(SPR_START1P, 520, 1130)
	
	LoadSprite(SPR_STARTAI, "vsAI.png")
	SetSpriteSize(SPR_STARTAI, 250, 150)
	SetSpritePosition(SPR_STARTAI, 50, 1130)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		LoadSprite(i, "art/chibicrab" + str(num) + ".png")
		SetSpriteSizeSquare(i, 150)
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 980 + 250*((num-1)/3))
		
		CreateTweenSprite(i, .7)
		SetTweenSpriteY(i, h + 20, 980 + 250*((num-1)/3), TweenBounce())
	next i
	
	CreateTextExpress(TXT_HIGHSCORE, "High Score: " + str(spHighScore) + chr(10) + "with " + spHighCrab$, 90, fontCrabI, 1, w/2, 300, 5)
	SetTextSpacing(TXT_HIGHSCORE, -26)
	SetTextVisible(TXT_HIGHSCORE, 0)
	
	LoadSpriteExpress(SPR_BG_START, "envi/bg4.png",h*1.5, h*1.5, 0, 0, 100)
	SetSpriteMiddleScreen(SPR_BG_START)
	
	CreateSpriteExpress(SPR_BG_SP, h, h, 0, 0, 70)
	//SetSpriteOffset(SPR_BG_SP, GetSpriteWidth(SPR_BG_SP)/2, GetSpriteHeight(SPR_BG_SP)/2-34)
	SetSpriteMiddleScreen(SPR_BG_SP)
	for i = warpI1 to warpI16
		AddSpriteAnimationFrame(SPR_BG_SP, i)
	next i
	PlaySprite(SPR_BG_SP, 20, 1, 1, 16)
		
	
	//Preparing the menu for the first time viewing
	SetSpriteColorAlpha(SPR_BG_SP, 0)
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 980*5 + 250*((num-1)/3))
	next i
	
	//This is the 'single player results screen' setup
	if spActive = 1
		
		SetSpriteY(SPR_TITLE, -1000)
			
		for i = SPR_SP_C1 to SPR_SP_C6
			num = i-SPR_SP_C1+1
			SetSpriteY(i, 980 + 250*((num-1)/3))
		next i
		//SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
		//SetSpriteColorAlpha(SPR_BG_SP, 255)
		
		SetTextVisible(TXT_HIGHSCORE, 1)
		
		SetSpriteVisible(SPR_START1, 0)
		SetSpriteVisible(SPR_START2, 0)
		SetTextVisible(TXT_WAIT1, 0)
		SetTextVisible(TXT_WAIT2, 0)
		
		
		spScore = 0
	elseif spActive = 1 and crab1Deaths = 0 and crab2Deaths = 0
	//Returning from the pause menu
		
		
		
	endif
		
	if spActive = 0 then PlayMusicOGGSP(titleMusic, 1)
		
	startStateInitialized = 1
	
endfunction


// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStart()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if startStateInitialized = 0
		LoadStartImages(1)
		InitStart()
	endif
	state = START
	
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	//Normal menu happenings
	if startTimer# >= 0
		
		//Multiplayer section
		if GetPointerPressed() and not Button(SPR_START1) and not Button(SPR_START2) and not Button(SPR_START1P) and not Button(SPR_SP_C1) and not Button(SPR_SP_C2) and not Button(SPR_SP_C3) and not Button(SPR_SP_C4) and not Button(SPR_SP_C5) and not Button(SPR_SP_C6)
			PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
		endif
		
		SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
		
		// Start button pressed
		if Button(SPR_START1) and spActive = 0
			//spActive = 0
			//state = CHARACTER_SELECT
		endif
		
		
		if ButtonMultitouchEnabled(SPR_START1) and spActive = 0
			if GetSpriteColorAlpha(SPR_START1) = 255
				//Pressing player one
				SetSpriteColorAlpha(SPR_START1, 70)
				SetTextColorAlpha(TXT_WAIT1, 255)
			else
				//Cancelling player one
				SetSpriteColorAlpha(SPR_START1, 255)
				SetTextColorAlpha(TXT_WAIT1, 0)
			endif
		endif
		
		if ButtonMultitouchEnabled(SPR_START2) and spActive = 0
			if GetSpriteColorAlpha(SPR_START2) = 255
				//Pressing player one
				SetSpriteColorAlpha(SPR_START2, 70)
				SetTextColorAlpha(TXT_WAIT2, 255)
			else
				//Cancelling player one
				SetSpriteColorAlpha(SPR_START2, 255)
				SetTextColorAlpha(TXT_WAIT2, 0)
			endif
		endif
		
		if spActive = 0
			for i = 0 to GetTextLength(TXT_WAIT1)
				SetTextCharAngle(TXT_WAIT1, GetTextLength(TXT_WAIT1)-i, -7+14*sin(9*startTimer# + i*6))	//Code from SnowTunes
			next i		
			for i = 0 to GetTextLength(TXT_WAIT2)
				SetTextCharAngle(TXT_WAIT2, GetTextLength(TXT_WAIT2)-i, 180 - 7+14*sin(9*startTimer# + i*6))	//Code from SnowTunes
			next i
			for i = SPR_SP_C1 to SPR_SP_C6
				//if GetTweenSpritePlaying(i, i) then UpdateTweenCustom(i, 0-GetFrameTime()*2)
			next i
			
		endif
		
		if GetTextColorAlpha(TXT_WAIT1) = 255 and GetTextColorAlpha(TXT_WAIT2) = 255
			spActive = 0
			aiActive = 0
			state = CHARACTER_SELECT
		endif
		
		//Transition between modes button
		if Button(SPR_START1P)
			//Switching between 1 and 0
			spActive = Mod(spActive+1, 2)
			startTimer# = -70
		endif

		//Single player section
		SetSpriteColorByCycle(SPR_BG_SP, round(startTimer#))
		SetSpriteColor(SPR_BG_SP, 255-GetSpriteColorRed(SPR_BG_SP)/4, 255-GetSpriteColorGreen(SPR_BG_SP)/4, 255-GetSpriteColorBlue(SPR_BG_SP)/4, GetSpriteColorAlpha(SPR_BG_SP))
		//SetSpriteColor(SPR_BG_SP, GetSpriteColorRed(SPR_BG_SP)*3/4, GetSpriteColorGreen(SPR_BG_SP)*3/4, GetSpriteColorBlue(SPR_BG_SP)*3/4, 255)
		//SetSpriteAngle(SPR_BG_SP, startTimer#)
	
	
		//Starting a single player game
		for i = 1 to 6
			if Button(SPR_SP_C1 + i - 1)
				spActive = 1
				crab1Type = i
				crab2Type = crab1Type
				state = GAME
			endif
		next i
		
		//Starting an AI game
		if Button(SPR_STARTAI) and GetSpriteVisible(SPR_STARTAI)
			aiActive = 1
			firstFight = 0
			//To do: take this to the character selection screen, figure out if first fight should play
			crab1Type = 1
			crab2Type = 1
			state = GAME
		endif
		
	//if the single player screen is in a transitionary state
	else
		if spActive = 1
			
			startTimer# = 0
			
				
			SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#)*(100+startTimer#)/20.0)
			//GlideToY(SPR_TITLE, -1000, 10)
			SetSpriteY(SPR_TITLE, -1000)
			
			StopMusicOGGSP(titleMusic)
			PlayMusicOGGSP(spMusic, 1)
			
			for i = SPR_SP_C1 to SPR_SP_C6
				//num = i-SPR_SP_C1+1
				//GlideToY(i, 980 + 250*((num-1)/3), 3+num)
				
				PlayTweenSprite(i,  i, (i-SPR_SP_C1)*.06)
				
			next i
			//SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
			//SetSpriteColor(SPR_BG_SP, 255-GetSpriteColorRed(SPR_BG_SP)/4, 255-GetSpriteColorGreen(SPR_BG_SP)/4, 255-GetSpriteColorBlue(SPR_BG_SP)/4, 255.0*(100.0+startTimer#)/100)
		
			SetSpriteVisible(SPR_START1, 0)
			SetSpriteVisible(SPR_START2, 0)
			SetSpriteVisible(SPR_STARTAI, 0)
			SetTextVisible(TXT_WAIT1, 0)
			SetTextVisible(TXT_WAIT2, 0)
			SetTextVisible(TXT_HIGHSCORE, 1)
		
		elseif spActive = 0
			//Turning back into a regular menu
			
			startTimer# = 0
			
			StopMusicOGGSP(spMusic)
			PlayMusicOGGSP(titleMusic, 1)
			
			SetSpriteY(SPR_TITLE, h/2-GetSpriteWidth(SPR_TITLE)/2)
			//GlideToY(SPR_TITLE, h/2-GetSpriteWidth(SPR_TITLE)/2, 15)
			//SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
			
			for i = SPR_SP_C1 to SPR_SP_C6
				//num = i-SPR_SP_C1+1
				//GlideToY(i, 980*5 + 250*((num-1)/3), 3+num)
				//PlayTweenSprite(i,  i, 0)
				StopTweenSprite(i, i)
				SetSpriteY(i, 2000)
			next i
			
			//SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
			//SetSpriteColor(SPR_BG_SP, 255-GetSpriteColorRed(SPR_BG_SP)/4, 255-GetSpriteColorGreen(SPR_BG_SP)/4, 255-GetSpriteColorBlue(SPR_BG_SP)/4, 255.0*(0-startTimer#)/100)
		
			SetSpriteVisible(SPR_START1, 1)
			SetSpriteVisible(SPR_START2, 1)
			SetSpriteVisible(SPR_STARTAI, 1)
			SetTextVisible(TXT_WAIT1, 1)
			SetTextVisible(TXT_WAIT2, 1)
			SetTextVisible(TXT_HIGHSCORE, 0)
			
		endif
	
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START
		ExitStart()
		LoadStartImages(0)
		if spActive then PlaySoundR(specialS, volumeSE)
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStart()
	
	DeleteSprite(SPR_TITLE)
	DeleteSprite(SPR_START1)
	DeleteSprite(SPR_START2)
	DeleteSprite(SPR_START1P)
	DeleteSprite(SPR_STARTAI)
	DeleteSprite(SPR_BG_START)
	DeleteSprite(SPR_BG_SP)
	DeleteText(TXT_WAIT1)
	DeleteText(TXT_WAIT2)
	DeleteText(TXT_HIGHSCORE)
	
	StopMusicOGGSP(titleMusic)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		DeleteSprite(i)
		DeleteTween(i)
	next i
		
	startTimer# = 0
	
	startStateInitialized = 0
	
endfunction
