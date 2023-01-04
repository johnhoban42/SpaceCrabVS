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
	stage as integer		//Stage is how far the player is into the
	
	// Sprite indices
	sprReady as integer
	sprLeftArrow as integer
	sprRightArrow as integer
	sprBG as integer
	sprBGB as integer
	txtCrabName as integer
	txtCrabDesc as integer
	txtCrabStats as integer
	txtReady as integer
	sprTxtBack as integer
	// Sprite index of the first crab shown on the select screen
	sprCrabs as integer
	
endtype

#constant charWid 390
#constant charHei 357 //257
#constant charVer 286
#constant charVerSmall 370
#constant charVerSmallGap 250
#constant charHorSmallGap 250

// Initialize the sprites within a CSC
// "player" -> 1 or 2
function InitCharacterSelectController(csc ref as CharacterSelectController)
	
	p as integer, f as integer
	if csc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if csc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
	
	csc.stage = 1
	
	SetFolder("/media")
	
	LoadSprite(csc.sprReady, "ready.png")
	SetSpriteSize(csc.sprReady, w/3, h/16)
	SetSpriteMiddleScreenOffset(csc.sprReady, 0, p*7*h/16 + p*40)
	SetSpriteFlip(csc.sprReady, f, f)
	
	LoadSprite(csc.sprLeftArrow, "leftArrow.png")
	SetSpriteSize(csc.sprLeftArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprLeftArrow, p*-3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprLeftArrow, f, f)
	if csc.crabSelected = 0 then SetSpriteVisible(csc.sprLeftArrow, 0)
	
	LoadSprite(csc.sprRightArrow, "rightArrow.png")
	SetSpriteSize(csc.sprRightArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprRightArrow, p*3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprRightArrow, f, f)
	if csc.crabSelected = 5 then SetSpriteVisible(csc.sprRightArrow, 0)
	
	//The background on the Descriptions
	LoadSprite(csc.sprTxtBack, "charInfo.png")
	//SetSpriteSize(csc.sprTxtBack, w, 160)
	SetSpriteSize(csc.sprTxtBack, w, 240)
	SetSpriteMiddleScreenOffset(csc.sprTxtBack, 0, p*3*h/8.5)
	SetSpriteColorAlpha(csc.sprTxtBack, 160)
	
	CreateSprite(csc.sprBG, bg5I)
	SetBGRandomPosition(csc.sprBG)
	SetSpriteDepth(csc.sprBG, 100)
	
	LoadSprite(csc.sprBGB, "bg5B.png")
	SetBGRandomPosition(csc.sprBGB)
	SetSpriteDepth(csc.sprBGB, 99)
	SetSpriteColorAlpha(csc.sprBGB, 255) 
	
	for i = 0 to NUM_CRABS-1
		if i = 0 or i = 1 or i = 3 or i = 5
			CreateSprite(csc.sprCrabs + i, 0)
			for j = 1 to 6
				AddSpriteAnimationFrame(csc.sprCrabs + i, crab1select1I - 1 + j + (i+1)*10)
			next j
			PlaySprite(csc.sprCrabs + i, 18, 1, 1, 6)
			
		else
			LoadSprite(csc.sprCrabs + i, "crab1.png")
		endif
		SetSpriteSize(csc.sprCrabs + i, charWid/2, charHei/2)
		//SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*(i-csc.crabSelected)*w, p*335)	//The old way to position the sprites
		SetSpriteFlip(csc.sprCrabs + i, f, f)
		
		CreateTweenSprite(csc.sprCrabs + i, selectTweenTime#)
		SetTweenSpriteSizeX(csc.sprCrabs + i, charWid, charWid/2, TweenOvershoot())
		SetTweenSpriteSizeY(csc.sprCrabs + i, charHei, charHei/2, TweenOvershoot())
		SetTweenSpriteX(csc.sprCrabs + i, w/2-charWid/2, w/2 - charWid/4 + p*charHorSmallGap*(Mod(i,3)-1), TweenOvershoot())
		SetTweenSpriteY(csc.sprCrabs + i, h/2-charHei/2 + p*charVer, h/2 - charHei/4 + p*charVerSmall + p*charVerSmallGap*((i)/3), TweenOvershoot())
			
		SetSpritePosition(csc.sprCrabs + i, w/2 - GetSpriteWidth(csc.sprCrabs + i)/2 + p*charHorSmallGap*(Mod(i,3)-1), h/2 - charHei/4 + p*charVerSmall + p*charVerSmallGap*((i)/3))
	
	next i
		
	//Descriptions were moved down here to include newline characters
	/*crabDescs[0] = "Known across the cosmos for his quick dodges!" + chr(10) + "Has connections in high places."
	crabDescs[1] = "He's been hitting the books AND the gym! His" + chr(10) + "new meteor spells are a force to be reckoned with."
	crabDescs[2] = "Started spinning one day, and never stopped!" + chr(10) + "Learned to weaponize his rotational influence."
	crabDescs[3] = "Always ready to start a party!!" + chr(10) + "How can you say no?"
	crabDescs[4] = "A clockwork master! Doesn't like to bend time," + chr(10) + "but will make an exception in a fight."
	crabDescs[5] = "Lurking in black holes, opponents will" + chr(10) + "never expect his spinning-star blades!" */
	
	//crabDescs[0] = "Known far and wide, he's" + chr(10) + "ready to claim his fame!" + chr(10) + "Double-tap for his galaxy" + chr(10) + "famous quick-dodge move!"
	//crabDescs[1] = "He's been hitting the books AND the gym! His" + chr(10) + "new meteor spells are a force to be reckoned with."
	//crabDescs[2] = "Started spinning one day, and never stopped!" + chr(10) + "Learned to weaponize his rotational influence."
	//crabDescs[3] = "Always ready to start a party!!" + chr(10) + "How can you say no?"
	//crabDescs[4] = "A clockwork master! Doesn't like to bend time," + chr(10) + "but will make an exception in a fight."
	//crabDescs[5] = "Lurking in black holes, opponents will" + chr(10) + "never expect his spinning-star blades!"
	crabDescs[0] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "Known far and wide, he's ready to claim his fame!" + chr(10) + "Double-tap for his galaxy famous quick-dodge!" + chr(10) + "Special Attack: Meteor Shower"
	crabDescs[1] = "Speed: {{}}} Turn: {{{{}" + chr(10) + "The most magical being this side of the nebula." + chr(10) + "Launch into the skies with a double-tap spell!" + chr(10) + "Special Attack: Conjure Comets"
	crabDescs[2] = "Speed: {{{{{ Turn: {}}}}" + chr(10) + "Grew up at the Rotation Station, and it shows." + chr(10) + "Very fast! Double-tap to skid & stop a sec'." + chr(10) + "Special Attack: Orbital Nightmare"
	crabDescs[3] = "Speed: {{{{} Turn: {{}}}" + chr(10) + "Always ready to party!! How can you say no?" + chr(10) + "He'll stop and mosh when he hears a double-tap." + chr(10) + "Special Attack: Party Time!"
	crabDescs[4] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "A clockwork master! Sends his opponents forward" + chr(10) + "in time, and rewinds his clock by double-tapping." + chr(10) + "Special Attack: Fast Forward"
	crabDescs[5] = "Speed: {{{}} Turn: {{{{{" + chr(10) + "Quieter than a rising sun, deadlier than a black" + chr(10) + "hole! Instantly turns but has no double-tap move." + chr(10) + "Special Attack: Shuri-Krustacean"
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, crabNames[csc.crabSelected])
	SetTextSize(csc.txtCrabName, 96)
	SetTextAngle(csc.txtCrabName, f*180)
	SetTextFontImage(csc.txtCrabName, fontCrabI)
	SetTextSpacing(csc.txtCrabName, -22)
	SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*130)
	//SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*100)
	SetTextAlignment(csc.txtCrabName, 1)
	
	//CreateText(csc.txtCrabDesc, crabDescs[csc.crabSelected])
	CreateText(csc.txtCrabDesc, crabDescs[csc.crabSelected] )
	SetTextSize(csc.txtCrabDesc, 40)
	SetTextAngle(csc.txtCrabDesc, f*180)
	SetTextFontImage(csc.txtCrabDesc, fontDescI)
	SetTextSpacing(csc.txtCrabDesc, -10)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, -w/5, p*3*h/8.5)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8.5)
	//SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8)
	SetTextAlignment(csc.txtCrabDesc, 1)
	
	CreateText(csc.txtCrabStats, "Speed: {{}}" + chr(10) + "Turn: {{{}" + chr(10) + "Special:" + chr(10) + "Meteor Shower")
	SetTextSize(csc.txtCrabStats, 40)
	SetTextAngle(csc.txtCrabStats, f*180)
	SetTextFontImage(csc.txtCrabStats, fontDescI)
	SetTextSpacing(csc.txtCrabStats, -10)
	SetTextMiddleScreenOffset(csc.txtCrabStats, f, w/2-w/5, p*3*h/8.5)
	//SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8)
	SetTextAlignment(csc.txtCrabStats, 1)
	SetTextVisible(csc.txtCrabStats, 0)
	
	
	CreateText(csc.txtReady, "Waiting for your opponent...")
	SetTextSize(csc.txtReady, 86)
	SetTextAngle(csc.txtReady, f*180)
	SetTextFontImage(csc.txtReady, fontDescItalI)
	SetTextSpacing(csc.txtReady, -30)
	SetTextMiddleScreenOffset(csc.txtReady, f, 0, p*7*h/16)
	SetTextVisible(csc.txtReady, 0)
	
	
	SetVisibleCharacterUI(1, csc)
	
endfunction


// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	SetSpriteVisible(split, 1)
	
	// Init controllers
	csc1.player = 1
	csc1.ready = 0
	csc1.crabSelected = crab1Type - 1
	csc1.sprReady = SPR_CS_READY_1
	csc1.sprLeftArrow = SPR_CS_ARROW_L_1
	csc1.sprRightArrow = SPR_CS_ARROW_R_1
	csc1.sprBG = SPR_CS_BG_1
	csc1.sprBGB = SPR_CS_BG_1B
	csc1.txtCrabName = TXT_CS_CRAB_NAME_1
	csc1.txtCrabDesc = TXT_CS_CRAB_DESC_1
	csc1.txtCrabStats = TXT_CS_CRAB_STATS_1
	csc1.txtReady = TXT_CS_READY_1
	csc1.sprCrabs = SPR_CS_CRABS_1
	csc1.sprTxtBack = SPR_CS_TXT_BACK_1
	
	csc2.player = 2
	csc2.ready = 0
	csc2.crabSelected = crab2Type - 1
	csc2.sprReady = SPR_CS_READY_2
	csc2.sprLeftArrow = SPR_CS_ARROW_L_2
	csc2.sprRightArrow = SPR_CS_ARROW_R_2
	csc2.sprBG = SPR_CS_BG_2
	csc2.sprBGB = SPR_CS_BG_2B
	csc2.txtCrabName = TXT_CS_CRAB_NAME_2
	csc2.txtCrabDesc = TXT_CS_CRAB_DESC_2
	csc2.txtCrabStats = TXT_CS_CRAB_STATS_2
	csc2.txtReady = TXT_CS_READY_2
	csc2.sprCrabs = SPR_CS_CRABS_2
	csc2.sprTxtBack = SPR_CS_TXT_BACK_2
	
	InitCharacterSelectController(csc1)
	InitCharacterSelectController(csc2)
	
	LoadSpriteExpress(SPR_MENU_BACK, "crab77walk8.png", 140, 140, 0, 0, 3)
	SetSpriteMiddleScreen(SPR_MENU_BACK)
	
	
	PlayMusicOGGSP(characterMusic, 1)
	PlayMusicOGGSP(fireMusic, 1)
	SetMusicVolumeOGG(fireMusic, 20)
	
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
		//SetTextMiddleScreenX(csc.txtCrabName, f)
		SetTextString(csc.txtCrabDesc, crabDescs[csc.crabSelected])
		//SetTextMiddleScreenX(csc.txtCrabDesc, f)
		
		space = 12
		for i = 0 to FindString(crabDescs[csc.crabSelected], chr(10))-1
			SetTextCharY(csc.txtCrabDesc, i, -space*p - GetTextSize(csc.txtCrabDesc)*f)
			//SetTextCharColor(csc.txtCrabDesc, i, 255, 100, 100, 255)
		next i
		
		for i = Len(crabDescs[csc.crabSelected])to FindStringReverse(crabDescs[csc.crabSelected], chr(10))-1 step -1
			SetTextCharY(csc.txtCrabDesc, i, GetTextSize(csc.txtCrabDesc)*3*p + space*p - GetTextSize(csc.txtCrabDesc)*f)
		next i
		
	endif
	
	cNum = csc.crabSelected
	
	//if GetSpriteWidth(csc.sprCrabs+csc.crabSelected) < charWid/2+1 then SetSpriteMiddleScreenX(csc.sprCrabs+csc.crabSelected)
	
	// Glide
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1
		num = spr - csc.sprCrabs
		//SnapbackToX(spr, glideMax - csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, -40*dir*p, 4, 5)	//Andy Version
		//SnapbackToX(spr, csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 * cNum*1000, 30, 10)
		//GlideToX(spr, GetSpriteX(spr) + -1*p*dir*w, 30)
		//Print(GetSPriteX(spr))
		
		
		
		if csc.glideFrame > glideMax/2
			SetSpriteSize(spr, charWid - 45 + (glideMax - csc.glideFrame)/glideMax*90, charHei - 30 + (glideMax - csc.glideFrame)/glideMax*60)
			color = (glideMax - csc.glideFrame)/glideMax*110
			SetSpriteColor(spr, 200 + color, 200 + color, 200 + color, 255)
		endif
		
		
		GlideToX(spr, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, 4)
		
		if csc.player = 1 then GlideToY(spr, h/2 - GetSpriteHeight(spr)/2 + charVer, 2)
		if csc.player = 2 then GlideToY(spr, h/2 - GetSpriteHeight(spr)/2 - charVer, 2)
		
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
		
		//The 6-crab view
		if csc.stage = 1
			for i = 0 to NUM_CRABS-1
				spr = csc.sprCrabs + i
				if ButtonMultitouchEnabled(spr)
					SetVisibleCharacterUI(2, csc)
					csc.crabSelected = i-1
					PlaySoundR(arrowS, 100)
					ChangeCrabs(csc, 1, 1)
					csc.stage = 2
					i = NUM_CRABS
				endif
			next i
		
		//The 1-crab view
		elseif csc.stage = 2
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
			
			if csc.glideFrame <= 0
				SetSpriteSize(csc.sprCrabs+csc.crabSelected, charWid, charHei)
				SetSpriteX(csc.sprCrabs+csc.crabSelected, w/2 - GetSpriteWidth(csc.sprCrabs+csc.crabSelected)/2)
				if csc.player = 1 then SetSpriteY(csc.sprCrabs+csc.crabSelected, h/2 - GetSpriteHeight(csc.sprCrabs+csc.crabSelected)/2 + charVer)
				if csc.player = 2 then SetSpriteY(csc.sprCrabs+csc.crabSelected, h/2 - GetSpriteHeight(csc.sprCrabs+csc.crabSelected)/2 - charVer)
			endif
			
			for i = 0 to NUM_CRABS-1
				spr = csc.sprCrabs + i
				if ButtonMultitouchEnabled(spr)
					SetVisibleCharacterUI(1, csc)
					for j = 0 to NUM_CRABS-1
						PlayTweenSprite(csc.sprCrabs + j, csc.sprCrabs + j, 0)
					next j
					PlaySoundR(arrowS, 100)
					csc.stage = 1
					spr = NUM_CRABS
				endif
			next i
		endif
	endif
		
	//Slowly lighting the backgrounds
	SetSpriteColorAlpha(csc.sprBG, 205+abs(50*cos(90*csc.player + 80*GetMusicPositionOGG(characterMusic))))
	IncSpriteAngle(csc.sprBGB, 6*fpsr#)
	
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
		LoadCharacterSelectImages(1)
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
			if csc1.stage = 1 and i > 12 then SetTextCharY(csc1.txtCrabName, i, -1 * (jitterNum + csc1.glideFrame) + Random(0, (jitterNum + csc1.glideFrame)*2) + GetTextSize(txt))
			SetTextCharAngle(txt, i, -1 * (jitterNum + csc1.glideFrame) + Random(0, jitterNum + csc1.glideFrame)*2)
		next i
	else
		txt = csc1.txtReady
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, GetTextLength(txt)-i, 58.0 - 8.0*abs(8*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
		next i		
	endif
	
	if csc2.ready = 0 and doJit
		txt = csc2.txtCrabName
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, i, -102 -1 * (jitterNum + csc2.glideFrame) + Random(0, (jitterNum + csc2.glideFrame)*2))
			if csc2.stage = 1 and i > 12 then SetTextCharY(csc2.txtCrabName, i, -102 -1 * (jitterNum + csc2.glideFrame) + Random(0, (jitterNum + csc2.glideFrame)*2) - GetTextSize(txt))
			SetTextCharAngle(txt, i, 180 - 1*(jitterNum + csc2.glideFrame) + Random(0, jitterNum + csc2.glideFrame)*2)
		next i
	else
		txt = csc2.txtReady
		for i = 0 to GetTextLength(txt)
			SetTextCharY(txt, GetTextLength(txt)-i, -140.0 + 8.0*abs(8*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
		next i
	endif
	
	if ButtonMultitouchEnabled(SPR_MENU_BACK)
		state = START
	endif
	
	if csc1.ready and csc2.ready
		spActive = 0
		state = GAME
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> CHARACTER_SELECT
		ExitCharacterSelect()
		LoadCharacterSelectImages(0)
	endif
	
endfunction state


function SetVisibleCharacterUI(stage, csc ref as CharacterSelectController)
	
	if stage = 1 then SetTextString(csc.txtCrabName, "CHOOSE YOUR" + chr(13)+chr(10) + "CRUSTACEAN!")
	
	SetSpriteVisible(csc.sprReady, stage-1)
	SetSpriteVisible(csc.sprLeftArrow, stage-1)
	SetSpriteVisible(csc.sprRightArrow, stage-1)
	SetTextVisible(csc.txtCrabDesc, stage-1)
	SetSpriteVisible(csc.sprTxtBack, stage-1)
	
	csc.glideFrame = 0
endfunction

// Dispose of assets from a single controller
function CleanupCharacterSelectController(csc ref as CharacterSelectController)
	
	DeleteSprite(csc.sprReady)
	DeleteSprite(csc.sprLeftArrow)
	DeleteSprite(csc.sprRightArrow)
	DeleteSprite(csc.sprBG)
	DeleteSprite(csc.sprBGB)
	DeleteText(csc.txtCrabName)
	DeleteText(csc.txtCrabDesc)
	DeleteText(csc.txtCrabStats)
	DeleteText(csc.txtReady)
	DeleteSprite(csc.sprTxtBack)
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1
		DeleteSprite(spr)
		DeleteTween(spr)
	next spr
	
endfunction


// Cleanup upon leaving this state
function ExitCharacterSelect()
	
	CleanupCharacterSelectController(csc1)
	CleanupCharacterSelectController(csc2)
	DeleteSprite(SPR_MENU_BACK)
	
	if GetMusicPlayingOGGSP(characterMusic) then StopMusicOGGSP(characterMusic)
	if GetMusicPlayingOGGSP(fireMusic) then StopMusicOGGSP(fireMusic)
	
	characterSelectStateInitialized = 0
	
	ClearMultiTouch()
	
endfunction
