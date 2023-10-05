// File: soundtest.agc
// Created: 23-10-03

global soundtestStateInitialized as integer = 0

// Initialize the story screen
function InitSoundTest()
	
	//Created of the sprites/anything else needed goes here
	
	
	soundtestStateInitialized = 1
endfunction

// Soundtest screen execution loop
// Each time this loop exits, return the next state to enter into
function DoSoundTest()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if soundtestStateInitialized = 0
		InitSoundTest()
	endif
	state = SOUNDTEST
	
	
	
	//Do loop for the mode is here
	
	
	
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> SOUNDTEST
		ExitSoundTest()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitSoundTest()

	//Deletion of the assets/setting variables correctly to leave is here

	soundtestStateInitialized = 0
endfunction