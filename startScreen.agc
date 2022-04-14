#include "constants.agc"


// Whether this state has been initialized
state_initialized as integer = 0


// Initialize the start screen
// Does nothing right now, just a placeholder
function initStartScreen()
	
	state_initialized = 1
	
endfunction


// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStartScreen()
	
	state_initialized = 0
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if state_initialized = 0
		initStartScreen()
	endif
	state = START_SCREEN
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> START_SCREEN
		ExitStartScreen()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStartScreen()
	
	state_initialized = 0
	
endfunction
