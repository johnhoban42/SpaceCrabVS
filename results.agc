#include "constants.agc"


// Whether this state has been initialized
global resultsStateInitialized as integer = 0
global resultsWinner as integer = 0

global rc1 as ResultsController
global rc2 as ResultsController


// Controller that holds state data for each screen
type ResultsController
	
	// Player ID (1 or 2)
	player as integer
	
endtype

function InitResultsController(rc ref as ResultsController)
	
	p as integer, f as integer
	if rc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if rc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
	
endfunction

// Initialize the results screen
function InitResults()
	
	PlayMusicOGGSP(resultsMusic, 1)
	
	// Determine the winner
	if crab1Deaths = 3
		resultsWinner = 2
	else
		resultsWinner = 1
	endif
		
	// Init controllers
	rc1.player = 1
	
	rc2.player = 2
	
	InitResultsController(rc1)
	InitResultsController(rc2)
	
	PlayMusicOGG(resultsMusic, 1)
	
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
