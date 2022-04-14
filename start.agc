#include "constants.agc"


// Whether this state has been initialized
global startStateInitialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function InitStart()
	
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
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START
		ExitStart()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStart()
	
	startStateInitialized = 0
	
endfunction
