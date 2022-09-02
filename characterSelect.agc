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
	sprTxtBack as integer
	// Sprite index of the first crab shown on the select screen
	sprCrabs as integer
	
endtype

#constant charWid 390
#constant charHei 357 //257

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
	
	//The background on the Descriptions
	LoadSprite(csc.sprTxtBack, "charInfo.png")
	SetSpriteSize(csc.sprTxtBack, w, 160)
	SetSpriteMiddleScreenOffset(csc.sprTxtBack, 0, p*3*h/8.5)
	SetSpriteColorAlpha(csc.sprTxtBack, 160)
	
	CreateSprite(csc.sprBG, bg5I)
	SetBGRandomPosition(csc.sprBG)
	SetSpriteDepth(csc.sprBG, 100)
	
	for i = 0 to NUM_CRABS-1
		if i = 0 or i = 1 or i = 5
			CreateSprite(csc.sprCrabs + i, 0)
			for j = 1 to 6
				AddSpriteAnimationFrame(csc.sprCrabs + i, crab1select1I - 1 + j + (i+1)*10)
			next j
			PlaySprite(csc.sprCrabs + i, 18, 1, 1, 6)
			
		else
			LoadSprite(csc.sprCrabs + i, "crab1.png")
		endif
		SetSpriteSize(csc.sprCrabs + i, charWid, charHei)
		SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*i*w, p*335)
		SetSpriteFlip(csc.sprCrabs + i, f, f)
	next i
	
	//Descriptions were moved down here to include newline characters
	crabDescs[0] = "Known across the cosmos for his quick dodges!" + chr(10) + "Has connections in high places."
	crabDescs[1] = "He's been hitting the books AND the gym! His" + chr(10) + "new meteor spells are a force to be reckoned with."
	crabDescs[2] = "Started spinning one day, and never stopped!" + chr(10) + "Learned to weaponize his rotational influence."
	crabDescs[3] = "Always ready to start a party!!" + chr(10) + "How can you say no?"
	crabDescs[4] = "A master of time! Doesn't like to bend time," + chr(10) + "but will make an exception in a fight."
	crabDescs[5] = "Lurking in black holes, opponents will" + chr(10) + "never expect his spinning-star blades!"
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, crabNames[0])
	SetTextSize(csc.txtCrabName, 96)
	SetTextAngle(csc.txtCrabName, f*180)
	SetTextFontImage(csc.txtCrabName, fontCrabI)
	SetTextSpacing(csc.txtCrabName, -22)
	SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*130)
	//SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*100)
	SetTextAlignment(csc.txtCrabName, 1)
	
	CreateText(csc.txtCrabDesc, crabDescs[0])
	SetTextSize(csc.txtCrabDesc, 47)
	SetTextAngle(csc.txtCrabDesc, f*180)
	SetTextFontImage(csc.txtCrabDesc, fontDescI)
	SetTextSpacing(csc.txtCrabDesc, -15)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8.5)
	//SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8)
	SetTextAlignment(csc.txtCrabDesc, 1)
	
	
	
	CreateText(csc.txtReady, "Waiting for your opponent...")
	SetTextSize(csc.txtReady, 86)
	SetTextAngle(csc.txtReady, f*180)
	SetTextFontImage(csc.txtReady, fontDescItalI)
	SetTextSpacing(csc.txtReady, -30)
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
	csc1.sprTxtBack = SPR_CS_TXT_BACK_1
	
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
	csc2.sprTxtBack = SPR_CS_TXT_BACK_2
	
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
	glideMax = 24/fpsr#
		
	// Start the glide
	if csc.glideFrame = 0 or startCycle = 1
		csc.glideFrame = glideMax
		csc.glideDirection = dir
		SetSpriteVisible(csc.sprLeftArrow, 0)
		SetSpriteVisible(csc.sprRightArrow, 0)
		SetSpriteVisible(csc.sprReady, 0)
		
		//The change of the crab is done up here to make the glide work
		csc.crabSelected = csc.crabSelected + dir
		//This is moved up so that people can see the names quicker
		SetTextString(csc.txtCrabName, crabNames[csc.crabSelected])
		SetTextMiddleScreenX(csc.txtCrabName, f)
		SetTextString(csc.txtCrabDesc, crabDescs[csc.crabSelected])
		SetTextMiddleScreenX(csc.txtCrabDesc, f)
	endif
	
	cNum = csc.crabSelected
	
	// Glide
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1
		num = spr - csc.sprCrabs
		GlideToX(spr, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, 4)
		//SnapbackToX(spr, glideMax - csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, -40*dir*p, 4, 5)	//Andy Version
		//SnapbackToX(spr, csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 * cNum*1000, 30, 10)
		//GlideToX(spr, GetSpriteX(spr) + -1*p*dir*w, 30)
		//Print(GetSPriteX(spr))
		
		if csc.glideFrame > glideMax/2
			SetSpriteSize(spr, charWid - 45 + (glideMax - csc.glideFrame)/glideMax*90, charHei - 30 + (glideMax - csc.glideFrame)/glideMax*60)
			color = (glideMax - csc.glideFrame)/glideMax*110
		SetSpriteColor(spr, 200 + color, 200 + color, 200 + color, 255)
		endif
		
		
	next spr
	dec csc.glideFrame
	
	Print(cNum)
	//Sleep(500)
	
	// Finish the glide and change the displayed crab
	if csc.glideFrame = 0
		
		
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
	
	
	//Text gets bigger to show that a selection has been locked in
	SetTextSize(csc.txtCrabName, GetTextSize(csc.txtCrabName) + 10)
	
	csc.ready = 1
	
endfunction

function UnselectCrab(csc ref as CharacterSelectController)
	
	// We need this off-by-one adjustment because the crab types are based on 1-based indexing,
	// whereas the selected crabs are based on 0-based indexing
	//if csc.player = 1
	//	crab1Type = csc.crabSelected + 1
	//else
	//	crab2Type = csc.crabSelected + 1
	//endif
	
	SetSpriteVisible(csc.sprReady, 1)
	
	if csc.crabSelected <> 0 then SetSpriteVisible(csc.sprLeftArrow, 1)
	if csc.crabSelected <> 5 then SetSpriteVisible(csc.sprRightArrow, 1)
	SetTextVisible(csc.txtReady, 0)
	
	
	//Text gets smaller again
	SetTextSize(csc.txtCrabName, GetTextSize(csc.txtCrabName) - 10)
	
	csc.ready = 0
	
endfunction


// Game loop for a single screen
function DoCharacterSelectController(csc ref as CharacterSelectController)

	if not csc.ready
		// Ready button
		if Button(csc.sprReady)
			PlaySoundR(chooseS, 100)
			SelectCrab(csc)
		// Scroll left
		elseif (ButtonMultitouchEnabled(csc.sprLeftArrow) or (GetMultitouchPressedTopRight() and csc.player = 2) or (GetMultitouchPressedBottomLeft() and csc.player = 1)) and csc.crabSelected > 0
			PlaySoundR(arrowS, 100)
			ChangeCrabs(csc, -1, 1)
		// Scroll right
		elseif (ButtonMultitouchEnabled(csc.sprRightArrow) or (GetMultitouchPressedTopLeft() and csc.player = 2) or (GetMultitouchPressedBottomRight() and csc.player = 1)) and csc.crabSelected < NUM_CRABS-1
			ChangeCrabs(csc, 1, 1)
			PlaySoundR(arrowS, 100)
		endif
	endif
	
	
	
	// Continue an existing glide
	if csc.glideFrame > 0
		ChangeCrabs(csc, csc.glideDirection, 0)
	endif
	
endfunction

#constant jitterNum 5
#constant TextJitterFPS 40
global TextJitterTimer# = 0

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
		
	//Unselects the crab if the screen is touched again (only works on mobile for testing)
	if csc1.ready = 1 and GetMultitouchPressedBottom() then UnselectCrab(csc1)
	if csc2.ready = 1 and GetMultitouchPressedTop() then UnselectCrab(csc2)
	
	doJit = 0
	inc TextJitterTimer#, GetFrameTime()
	if TextJitterTimer# >= 1.0/TextJitterFPS
		doJit = 1
		inc TextJitterTimer#, -TextJitterFPS
		if TextJitterTimer# < 0 then TextJitterTimer# = 0
	endif
	//Print(GetFrameTime())
	//Print(TextJitterTimer#)
	
	//Jittering the letters
	if csc1.ready = 0 and doJit
		txt = csc1.txtCrabName
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, i, -1 * (jitterNum + csc1.glideFrame) + Random(0, (jitterNum + csc1.glideFrame)*2))
			SetTextCharAngle(txt, i, -1 * (jitterNum + csc1.glideFrame) + Random(0, jitterNum + csc1.glideFrame)*2)
		next i
	else
		txt = csc1.txtReady
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, GetTextLength(txt)-i, 48.0 - 8.0*abs(10*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
		next i		
	endif
	
	if csc2.ready = 0 and doJit
		txt = csc2.txtCrabName
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, i, -102 -1 * (jitterNum + csc2.glideFrame) + Random(0, (jitterNum + csc2.glideFrame)*2))
			SetTextCharAngle(txt, i, 180 - 1*(jitterNum + csc2.glideFrame) + Random(0, jitterNum + csc2.glideFrame)*2)
		next i
	else
		txt = csc2.txtReady
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, GetTextLength(txt)-i, -130.0 + 8.0*abs(10*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
		next i
	endif
	
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
	DeleteSprite(csc.sprTxtBack)
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
