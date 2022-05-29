#include "constants.agc"


// Whether this state has been initialized
global characterSelectStateInitialized as integer = 0

// Controller that holds state data for each screen
type CharacterSelectController
	
	// Game state
	ready as integer
	crabSelected as integer
	// Sprite indices
	sprReady as integer
	sprLeftArrow as integer
	sprRightArrow as integer
	txtCrabName as integer
	txtCrabDesc as integer
	// Sprite index of the first crab shown on the select screen
	sprCrabs as integer
	
endtype

// Initialize the sprites within a CSC
// "player" -> 1 or 2
function InitCharacterSelectController(csc as CharacterSelectController, player as integer)
	
	p as integer, f as integer
	if player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if player = 1 then f = 0 else f = 1 // makes the flip calculations easier
	
	LoadSprite(csc.sprReady, "ready.png")
	SetSpriteSize(csc.sprReady, w/3, h/16)
	SetSpriteMiddleScreenOffset(csc.sprReady, 0, p*7*h/16)
	SetSpriteFlip(csc.sprReady, f, f)
	
	LoadSprite(csc.sprLeftArrow, "leftArrow.png")
	SetSpriteSize(csc.sprLeftArrow, 50, 50)
	SetSpriteMiddleScreenOffset(csc.sprLeftArrow, p*-3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprLeftArrow, f, f)
	
	LoadSprite(csc.sprRightArrow, "rightArrow.png")
	SetSpriteSize(csc.sprRightArrow, 50, 50)
	SetSpriteMiddleScreenOffset(csc.sprRightArrow, p*3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprRightArrow, f, f)
	
	for i = 0 to 5
		LoadSprite(csc.sprCrabs + i, "crab1.png")
		SetSpriteSize(csc.sprCrabs + i, 350, 350)
		SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*i*w, p*335)
		SetSpriteFlip(csc.sprCrabs + i, f, f)
	next i
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, "GAMMA CRAB")
	SetTextSize(csc.txtCrabName, 96)
	SetTextAngle(csc.txtCrabName, f*180)
	SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*100)
	
	CreateText(csc.txtCrabDesc, "This whimsical crab is ready for a fight of galactic proportions.")
	SetTextSize(csc.txtCrabDesc, 36)
	SetTextAngle(csc.txtCrabDesc, f*180)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8)
	
endfunction


// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	SetSpriteVisible(split, 1)
	
	// Init controllers
	csc1 as CharacterSelectController
	csc1.ready = 0
	csc1.crabSelected = 0
	csc1.sprReady = SPR_CS_READY_1
	csc1.sprLeftArrow = SPR_CS_ARROW_L_1
	csc1.sprRightArrow = SPR_CS_ARROW_R_1
	csc1.txtCrabName = TXT_CS_CRAB_NAME_1
	csc1.txtCrabDesc = TXT_CS_CRAB_DESC_1
	csc1.sprCrabs = SPR_CS_CRABS_1
	
	csc2 as CharacterSelectController
	csc2.ready = 0
	csc2.crabSelected = 0
	csc2.sprReady = SPR_CS_READY_2
	csc2.sprLeftArrow = SPR_CS_ARROW_L_2
	csc2.sprRightArrow = SPR_CS_ARROW_R_2
	csc2.txtCrabName = TXT_CS_CRAB_NAME_2
	csc2.txtCrabDesc = TXT_CS_CRAB_DESC_2
	csc2.sprCrabs = SPR_CS_CRABS_2
	
	InitCharacterSelectController(csc1, 1)
	InitCharacterSelectController(csc2, 2)
	
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
