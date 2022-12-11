#include "constants.agc"


// Whether this state has been initialized
global resultsStateInitialized as integer = 0


// Initialize the results screen
// Does nothing right now, just a placeholder
function InitResults()
	
	PlayMusicOGGSP(resultsMusic, 1)
	
	resultsStateInitialized = 1
	
endfunction


// Results screen execution loop
// Each time this loop exits, return the next state to enter into
function DoResults()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if resultsStateInitialized = 0
		InitResults()
	endif
	state = RESULTS
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> RESULTS
		ExitResults()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitResults()
	
	if GetMusicPlayingOggSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
	resultsStateInitialized = 0
	
endfunction
