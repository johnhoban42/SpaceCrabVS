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
	
	LoadSprite(SPR_START1P, "singlePlayerButton.png")
	SetSpriteSize(SPR_START1P, 250, 150)
	SetSpritePosition(SPR_START1P, 520, 1130)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		num = i-SPR_SP_C1+1
		LoadSprite(i, "art/chibicrab" + str(num) + ".png")
		SetSpriteSizeSquare(i, 150)
		SetSpritePosition(i, w/2 - GetSpriteWidth(i)/2 - 250 + 250*(Mod(num-1,3)), 980 + 250*((num-1)/3))
	next i
	
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
	if spScore > 0
		
		SetSpriteY(SPR_TITLE, -1000)
			
		for i = SPR_SP_C1 to SPR_SP_C6
			num = i-SPR_SP_C1+1
			SetSpriteY(i, 980 + 250*((num-1)/3))
		next i
		//SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
		SetSpriteColorAlpha(SPR_BG_SP, 255)
		
		
		spScore = 0
	elseif spActive = 1 and crab1Deaths = 0 and crab2Deaths = 0
	//Returning from the pause menu
		
	endif
		
	startStateInitialized = 1
	
endfunction


// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStart()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if startStateInitialized = 0
		InitStart()
	endif
	state = START
	
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	//Normal menu happenings
	if startTimer# >= 0
		
		//Multiplayer section
		if GetPointerPressed() and not Button(SPR_START1) and not Button(SPR_START1) and not Button(SPR_SP_C1) and not Button(SPR_SP_C2) and not Button(SPR_SP_C3) and not Button(SPR_SP_C4) and not Button(SPR_SP_C5) and not Button(SPR_SP_C6)
			PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
		endif
		
		SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
		
		// Start button pressed
		if Button(SPR_START1) and spActive = 0
			spActive = 0
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
		
		
	//if the single player screen is in a transitionary state
	else
		if spActive = 1
			
			
		SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#)*(100+startTimer#)/20.0)
		GlideToY(SPR_TITLE, -1000, 10)
			
			for i = SPR_SP_C1 to SPR_SP_C6
				num = i-SPR_SP_C1+1
				GlideToY(i, 980 + 250*((num-1)/3), 3+num)
			next i
			SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
			SetSpriteColor(SPR_BG_SP, 255-GetSpriteColorRed(SPR_BG_SP)/4, 255-GetSpriteColorGreen(SPR_BG_SP)/4, 255-GetSpriteColorBlue(SPR_BG_SP)/4, 255.0*(100.0+startTimer#)/100)
		
		elseif spActive = 0
			//Turning back into a regular menu
			
			GlideToY(SPR_TITLE, h/2-GetSpriteWidth(SPR_TITLE)/2, 15)
			SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
			
			for i = SPR_SP_C1 to SPR_SP_C6
				num = i-SPR_SP_C1+1
				GlideToY(i, 980*5 + 250*((num-1)/3), 3+num)
			next i
			
			SetSpriteColorByCycle(SPR_BG_SP, 100-round(startTimer#))
			SetSpriteColor(SPR_BG_SP, 255-GetSpriteColorRed(SPR_BG_SP)/4, 255-GetSpriteColorGreen(SPR_BG_SP)/4, 255-GetSpriteColorBlue(SPR_BG_SP)/4, 255.0*(0-startTimer#)/100)
		
			
		endif
	
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START
		ExitStart()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStart()
	
	DeleteSprite(SPR_TITLE)
	DeleteSprite(SPR_START1)
	DeleteSprite(SPR_START2)
	DeleteSprite(SPR_START1P)
	DeleteSprite(SPR_BG_START)
	DeleteSprite(SPR_BG_SP)
	
	for i = SPR_SP_C1 to SPR_SP_C6
		DeleteSprite(i)
	next i
	
	startTimer# = 0
	
	startStateInitialized = 0
	
endfunction
