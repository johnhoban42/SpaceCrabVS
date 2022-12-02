#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global startStateInitialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function InitStart()
	
	SetSpriteVisible(split, 0)
	
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
	
	LoadSprite(SPR_START2, "start.png")
	SetSpriteSize(SPR_START2, 600, 160)
	SetSpriteMiddleScreenX(SPR_START2)
	SetSpriteY(SPR_START2, h/2 - 550 - GetSpriteHeight(SPR_START2))
	SetSpriteAngle(SPR_START2, 180)
	
	LoadSprite(SPR_START1P, "singlePlayerButton.png")
	SetSpriteSize(SPR_START1P, 250, 150)
	SetSpritePosition(SPR_START1P, 520, 1130)
	
	LoadSpriteExpress(SPR_BG_START, "envi/bg4.png",h*1.5, h*1.5, 0, 0, 100)
	SetSpriteMiddleScreen(SPR_BG_START)
		
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
	
	if GetPointerPressed() and not Button(SPR_START1)
		PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
	endif
	
	SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	// Start button pressed
	if Button(SPR_START1)
		state = CHARACTER_SELECT
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
	
	startTimer# = 0
	
	startStateInitialized = 0
	
endfunction
