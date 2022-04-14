#include "constants.agc"


// Whether this state has been initialized
global characterSelectStateInitialized as integer = 0


// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	characterSelectStateInitialized = 1
	
endfunction


// Character select screen execution loop
// Each time this loop exits, return the next state to enter into
function DoCharacterSelect()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if characterSelectStateInitialized = 0
		InitCharacterSelect()
	endif
	state = CHARACTER_SELECT
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> CHARACTER_SELECT
		ExitCharacterSelect()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitCharacterSelect()
	
	characterSelectStateInitialized = 0
	
endfunction
