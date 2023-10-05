// File: statistics.agc
// Created: 23-10-03


global statisticsStateInitialized as integer = 0

// Initialize the story screen
function InitStatistics()
	
	//Created of the sprites/anything else needed goes here
	
	
	statisticsStateInitialized = 1
endfunction

// Stats screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStatistics()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if statisticsStateInitialized = 0
		InitStatistics()
	endif
	state = STATISTICS
	
	
	
	//Do loop for the mode is here
	
	
	
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> STATISTICS
		ExitStatistics()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStatistics()

	//Deletion of the assets/setting variables correctly to leave is here

	statisticsStateInitialized = 0
endfunction