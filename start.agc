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
	
	LoadSprite(SPR_START, "start.png")
	SetSpriteSize(SPR_START, h/2, w/5)
	SetSpriteMiddleScreen(SPR_START)
	IncSpriteX(SPR_START, -250)
	SetSpriteAngle(SPR_START, 90)
	
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
	
	
	
	SetSpriteAngle(SPR_TITLE, 90 + 320*sin(startTimer#) + 50*sin(startTimer#*3))
	
	inc startTimer#, fpsr#
	if startTimer# > 360 then startTimer# = 0
	
	// Start button pressed
	if Button(SPR_START)
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
	DeleteSprite(SPR_START)
	
	startTimer# = 0
	
	startStateInitialized = 0
	
endfunction
