#include "constants.agc"


// Whether this state has been initialized
global characterSelectStateInitialized as integer = 0

global csc1 as CharacterSelectController
global csc2 as CharacterSelectController

global crabNames as string[NUM_CRABS] = [
	"SPACE CRAB",
	"LADDER WIZARD",
	"TOP CRAB",
	"RAVE CRAB",
	"CHRONO CRAB",
	"NINJA CRAB"]

global crabDescs as string[NUM_CRABS] = [
	"",
	"",
	"",
	"",
	"",
	"Ninja Crab is a crab ninja."]
	
	
	/*[
	"Space Crab is a crab in space.",
	"Wizard Crab is a crab wizard.",
	"Top Crab is a crab top.",
	"Rave Crab is a raving crab.",
	"Chrono Crab is a... crab with chrono?",
	"Ninja Crab is a crab ninja."]*/


// Controller that holds state data for each screen
type CharacterSelectController
	
	// Player ID (1 or 2)
	player as integer
	
	// Game state
	ready as integer
	crabSelected as integer
	glideFrame as float
	glideDirection as integer
	
	// Sprite indices
	sprReady as integer
	sprLeftArrow as integer
	sprRightArrow as integer
	sprBG as integer
	txtCrabName as integer
	txtCrabDesc as integer
	txtReady as integer
	// Sprite index of the first crab shown on the select screen
	sprCrabs as integer
	
endtype


// Initialize the sprites within a CSC
// "player" -> 1 or 2
function InitCharacterSelectController(csc ref as CharacterSelectController)
	
	p as integer, f as integer
	if csc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if csc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
	
	LoadSprite(csc.sprReady, "ready.png")
	SetSpriteSize(csc.sprReady, w/3, h/16)
	SetSpriteMiddleScreenOffset(csc.sprReady, 0, p*7*h/16)
	SetSpriteFlip(csc.sprReady, f, f)
	
	LoadSprite(csc.sprLeftArrow, "leftArrow.png")
	SetSpriteSize(csc.sprLeftArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprLeftArrow, p*-3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprLeftArrow, f, f)
	SetSpriteVisible(csc.sprLeftArrow, 0)
	
	LoadSprite(csc.sprRightArrow, "rightArrow.png")
	SetSpriteSize(csc.sprRightArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprRightArrow, p*3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprRightArrow, f, f)
	
	CreateSprite(csc.sprBG, bg5I)
	SetBGRandomPosition(csc.sprBG)
	SetSpriteDepth(csc.sprBG, 100)
	
	for i = 0 to NUM_CRABS-1
		if i = 0
			CreateSprite(csc.sprCrabs + i, crab1select1I)
		else
			LoadSprite(csc.sprCrabs + i, "crab1.png")
		endif
		SetSpriteSize(csc.sprCrabs + i, 390, 260)
		SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*i*w, p*335)
		SetSpriteFlip(csc.sprCrabs + i, f, f)
	next i
	
	//Descriptions were moved down here to include newline characters
	crabDescs[0] = "Known across the cosmos for his quick dodges!" + chr(10) + "Has connections in high places."
	crabDescs[1] = "He's been hitting the books AND the gym!" + chr(10) + "His new meteor spells are a force to be reckoned with."
	crabDescs[2] = "Started spinning one day, and never stopped!" + chr(10) + "Learned to weaponize his rotational influence."
	crabDescs[3] = "Always ready to start a party!!" + chr(10) + "How can you say no?"
	crabDescs[4] = "A master of time! Doesn't usually bend the time stream," + chr(10) + "but might make an exception this once."
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, crabNames[0])
	SetTextSize(csc.txtCrabName, 96)
	SetTextAngle(csc.txtCrabName, f*180)
	SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*100)
	//SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*100)
	SetTextAlignment(csc.txtCrabName, 1)
	
	CreateText(csc.txtCrabDesc, crabDescs[0])
	SetTextSize(csc.txtCrabDesc, 44)
	SetTextAngle(csc.txtCrabDesc, f*180)
	SetTextSpacing(csc.txtCrabDesc, -2)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8.5)
	//SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8)
	SetTextAlignment(csc.txtCrabDesc, 1)
	
	CreateText(csc.txtReady, "Waiting for your opponent...")
	SetTextSize(csc.txtReady, 36)
	SetTextAngle(csc.txtReady, f*180)
	SetTextMiddleScreenOffset(csc.txtReady, f, 0, p*7*h/16)
	SetTextVisible(csc.txtReady, 0)
	
endfunction


// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	SetSpriteVisible(split, 1)
	
	// Init controllers
	csc1.player = 1
	csc1.ready = 0
	csc1.crabSelected = 0
	csc1.sprReady = SPR_CS_READY_1
	csc1.sprLeftArrow = SPR_CS_ARROW_L_1
	csc1.sprRightArrow = SPR_CS_ARROW_R_1
	csc1.sprBG = SPR_CS_BG_1
	csc1.txtCrabName = TXT_CS_CRAB_NAME_1
	csc1.txtCrabDesc = TXT_CS_CRAB_DESC_1
	csc1.txtReady = TXT_CS_READY_1
	csc1.sprCrabs = SPR_CS_CRABS_1
	
	csc2.player = 2
	csc2.ready = 0
	csc2.crabSelected = 0
	csc2.sprReady = SPR_CS_READY_2
	csc2.sprLeftArrow = SPR_CS_ARROW_L_2
	csc2.sprRightArrow = SPR_CS_ARROW_R_2
	csc2.sprBG = SPR_CS_BG_2
	csc2.txtCrabName = TXT_CS_CRAB_NAME_2
	csc2.txtCrabDesc = TXT_CS_CRAB_DESC_2
	csc2.txtReady = TXT_CS_READY_2
	csc2.sprCrabs = SPR_CS_CRABS_2
	
	InitCharacterSelectController(csc1)
	InitCharacterSelectController(csc2)
	
	PlayMusicOGG(characterMusic, 1)
	
	characterSelectStateInitialized = 1
	
endfunction


// Change the selected crab
// dir -> -1 for left, 1 for right
function ChangeCrabs(csc ref as CharacterSelectController, dir as integer, startCycle as integer)
	
	p as integer, f as integer
	if csc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if csc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
		
	//This goes on the outside so it can be used for the glide loop
	glideMax = 30/fpsr#
		
	// Start the glide
	if csc.glideFrame = 0 or startCycle = 1
		csc.glideFrame = glideMax
		csc.glideDirection = dir
		SetSpriteVisible(csc.sprLeftArrow, 0)
		SetSpriteVisible(csc.sprRightArrow, 0)
		SetSpriteVisible(csc.sprReady, 0)
		
		//The change of the crab is done up here to make the glide work
		csc.crabSelected = csc.crabSelected + dir
	endif
	
	cNum = csc.crabSelected
	
	// Glide
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1
		num = spr - csc.sprCrabs
		SnapbackToX(spr, glideMax - csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000, -40*dir, 4, 5)
		//SnapbackToX(spr, csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 * cNum*1000, 30, 10)
		//GlideToX(spr, GetSpriteX(spr) + -1*p*dir*w, 30)
		//Print(GetSPriteX(spr))
	next spr
	dec csc.glideFrame//, //fpsr#
	
	Print(cNum)
	//Sleep(500)
	
	// Finish the glide and change the displayed crab
	if csc.glideFrame = 0
		
		SetTextString(csc.txtCrabName, crabNames[csc.crabSelected])
		SetTextMiddleScreenX(csc.txtCrabName, f)
		SetTextString(csc.txtCrabDesc, crabDescs[csc.crabSelected])
		SetTextMiddleScreenX(csc.txtCrabDesc, f)
		if csc.CrabSelected <> 0
			SetSpriteVisible(csc.sprLeftArrow, 1)
		endif
		if csc.CrabSelected <> NUM_CRABS-1
			SetSpriteVisible(csc.sprRightArrow, 1)
		endif
		SetSpriteVisible(csc.sprReady, 1)
	endif
	
endfunction


// Select a crab, cannot be undone by the player
function SelectCrab(csc ref as CharacterSelectController)
	
	// We need this off-by-one adjustment because the crab types are based on 1-based indexing,
	// whereas the selected crabs are based on 0-based indexing
	if csc.player = 1
		crab1Type = csc.crabSelected + 1
	else
		crab2Type = csc.crabSelected + 1
	endif
	
	SetSpriteVisible(csc.sprReady, 0)
	SetSpriteVisible(csc.sprLeftArrow, 0)
	SetSpriteVisible(csc.sprRightArrow, 0)
	SetTextVisible(csc.txtReady, 1)
	
	csc.ready = 1
	
endfunction


// Game loop for a single screen
function DoCharacterSelectController(csc ref as CharacterSelectController)

	// Scroll left
	if Button(csc.sprLeftArrow) and not csc.ready and csc.crabSelected > 0
		ChangeCrabs(csc, -1, 1)
	// Scroll right
	elseif Button(csc.sprRightArrow) and not csc.ready and csc.crabSelected < NUM_CRABS-1
		ChangeCrabs(csc, 1, 1)
	// Ready button
	elseif Button(csc.sprReady)
		SelectCrab(csc)
	endif
	
	
	
	// Continue an existing glide
	if csc.glideFrame > 0
		ChangeCrabs(csc, csc.glideDirection, 0)
	endif
	
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
	
	DoCharacterSelectController(csc1)
	DoCharacterSelectController(csc2)
	
	if csc1.ready and csc2.ready
		state = GAME
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> CHARACTER_SELECT
		ExitCharacterSelect()
	endif
	
endfunction state


// Dispose of assets from a single controller
function CleanupCharacterSelectController(csc ref as CharacterSelectController)
	
	DeleteSprite(csc.sprReady)
	DeleteSprite(csc.sprLeftArrow)
	DeleteSprite(csc.sprRightArrow)
	DeleteSprite(csc.sprBG)
	DeleteText(csc.txtCrabName)
	DeleteText(csc.txtCrabDesc)
	DeleteText(csc.txtReady)
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1
		DeleteSprite(spr)
	next spr
	
endfunction


// Cleanup upon leaving this state
function ExitCharacterSelect()
	
	CleanupCharacterSelectController(csc1)
	CleanupCharacterSelectController(csc2)
	
	if GetMusicPlayingOGG(characterMusic) then StopMusicOGG(characterMusic)
	
	characterSelectStateInitialized = 0
	
endfunction
