#include "constants.agc"
#include "game1.agc"
#include "game2.agc"


// This module's purpose is to abstract away game1.agc and game2.agc into a single
// state, GAME, that gets executed from the main game loop.


// Whether this state has been initialized
global gameStateInitialized as integer = 0


// Initialize the game
function InitGame()
	
	CreateGame1()
	CreateGame2()
	gameStateInitialized = 1
	
endfunction


// Start screen execution loop
// Each time this loop exits, return the next state to enter into
function DoGame()

	// Initialize if we haven't done so
	// Don't write anything before this!
	if gameStateInitialized = 0
		initGame()
	endif
	state = GAME
	
	// Game execution loops
	state1 = DoGame1()
	state2 = DoGame2()
	UpdateExp()
	
	// Check for state updates (pausing, losing). Sorry Player 2, Player 1 gets checked first.
	if state1 <> GAME
		state = state1
	elseif state2 <> GAME
		state = state2
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> GAME
		ExitGame()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitGame()
	
	// Whatever we do for something like ExitGame1() and ExitGame2() will go here
	gameStateInitialized = 0
	
endfunction
