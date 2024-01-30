#include "constants.agc"


// Whether this state has been initialized
global characterSelectStateInitialized as integer = 0

global csc1 as CharacterSelectController
global csc2 as CharacterSelectController

global crabNames as string[NUM_CRABS] = [
	"NULL CRAB",
	"SPACE CRAB",
	"LADDER WIZARD",
	"TOP CRAB",
	"RAVE CRAB",
	"CHRONO CRAB",
	"NINJA CRAB"]

global crabDescs as string[NUM_CRABS]

global chapNames as string[NUM_CHAPTERS] = [
	"NULL CRAB",
	"SPACE CRAB",
	"LADDER WIZARD",
	"#1 FAN CRAB",
	"TOP CRAB",
	"KING CRAB",
	"INIANDA JEFF",
	"TAXI CRAB",
	"HAWAIIAN CRAB",
	"TEAM PLAYER",
	"ROCK LOBSTER",
	"NINJA CRAB",
	"CRAB CAKE",
	"CRANIME",
	"CRABACUS",
	"RAVE CRAB",
	"MAD CRAB",
	"HOLY CRAB",
	"AL LEGAL",
	"SPACE BARC",
	"CRABYSS KNIGHT",
	"CHRONO CRAB",
	"SPACE CRAB 2",
	"SK8R CRAB",
	"KYLE CRAB",
	"FUTURE CRAB"]

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
		
	SetFolder("/media/ui")
	
	LoadAnimatedSprite(csc.sprReady, "ready", 22)
	PlaySprite(csc.sprReady, 9+csc.player, 1, 7+8*(csc.player-1), 14+8*(csc.player-1))
	SetSpriteSize(csc.sprReady, w/3, h/16)
	SetSpriteMiddleScreenOffset(csc.sprReady, 0, p*7*h/16 + p*32)
	SetSpriteFlip(csc.sprReady, f, f)
	AddButton(csc.sprReady)
	
	LoadAnimatedSprite(csc.sprLeftArrow, "lr", 22)
	PlaySprite(csc.sprLeftArrow, 12, 1, 1, 22)
	//LoadSprite(csc.sprLeftArrow, "leftArrow.png")
	SetSpriteSize(csc.sprLeftArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprLeftArrow, p*-3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprLeftArrow, f, f)
	SetSpriteAngle(csc.sprLeftArrow, 180)
	if csc.crabSelected = 0 then SetSpriteVisible(csc.sprLeftArrow, 0)
	AddButton(csc.sprLeftArrow)
	
	SetFolder("/media")
	
	CreateSpriteExistingAnimation(csc.sprRightArrow, csc.sprLeftArrow)
	PlaySprite(csc.sprRightArrow, 13, 1, 1, 22)
	SetSpriteSize(csc.sprRightArrow, 100, 100)
	SetSpriteMiddleScreenOffset(csc.sprRightArrow, p*3*w/8, p*3*h/16)
	SetSpriteFlip(csc.sprRightArrow, f, f)
	if csc.crabSelected = 5 then SetSpriteVisible(csc.sprRightArrow, 0)
	AddButton(csc.sprRightArrow)
	
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
	
	//Big plan for the future of character selection:
	/*
	The crabs will ALL be loaded in at once! Using load image resized, they will be loaded in at .1 size
	Then, when zoomed in, the full sprite sheet will be loaded in, and added to the trash bag
	This way, we can have all 24 crabs on the selection screen
	We'll check for the highest alt unlocked, and make that many rows/columns present
	For nothing unlocked, we can have the original layout of 2 x 3
	Will need to create an 'unlocked crab' array for this, though (6 variables, highestAlt1, highestAlt2...
	*/

	for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
		SyncG()
		//if i = 0 or i = 1 or i = 3 or i = 5
			CreateSprite(csc.sprCrabs + i, 0)
			if spActive = 0
				for j = 1 to 6
					//Make these below frames only load (in the constants file) if there is no story mode
					//If it's story mode, then only the current chapter should have loaded sprites
					AddSpriteAnimationFrame(csc.sprCrabs + i, crab1select1I - 1 + j + (i+1)*10)
				next j
				PlaySprite(csc.sprCrabs + i, 18, 1, 1, 6)
			else
				SetSpriteVisible(csc.sprCrabs + i, 0)
			
			endif
			
			//Do a get sprite frame count to check if a story sprite has frames, then add the frames
			
		//else
		//	LoadSprite(csc.sprCrabs + i, "crab1.png")
		//endif
		SetSpriteSize(csc.sprCrabs + i, charWid*3/5, charHei*3/5)
		//SetSpriteSize(csc.sprCrabs + i, charWid*4/7, charHei*4/7) //Slightly bigger crab size
		//SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*(i-csc.crabSelected)*w, p*335)	//The old way to position the sprites
		SetSpriteFlip(csc.sprCrabs + i, f, f)
		SetSpriteDepth(csc.sprCrabs, 40)
		
		CreateTweenSprite(csc.sprCrabs + i, selectTweenTime#)
		SetTweenSpriteSizeX(csc.sprCrabs + i, charWid, charWid*3/5, TweenOvershoot())
		SetTweenSpriteSizeY(csc.sprCrabs + i, charHei, charHei*3/5, TweenOvershoot())
		SetTweenSpriteX(csc.sprCrabs + i, w/2-charWid/2, w/2 - charWid/4 + p*charHorSmallGap*(Mod(i,3)-1), TweenOvershoot())
		SetTweenSpriteY(csc.sprCrabs + i, h/2-charHei/2 + p*charVer, h/2 - charHei/4 + p*charVerSmall + p*charVerSmallGap*((i)/3), TweenOvershoot())
			
		SetSpritePosition(csc.sprCrabs + i, w/2 - GetSpriteWidth(csc.sprCrabs + i)/2 + p*charHorSmallGap*(Mod(i,3)-1), h/2 - charHei/4 + p*charVerSmall + p*charVerSmallGap*((i)/3))
	
	next i
		
	//Descriptions were moved down here to include newline characters
	crabDescs[0] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "Known far and wide, he's ready to claim his fame!" + chr(10) + "Double-tap for his galaxy famous quick-dodge!" + chr(10) + "Special Attack: Meteor Shower"
	crabDescs[1] = "Speed: {{}}} Turn: {{{{}" + chr(10) + "The most magical being this side of the nebula." + chr(10) + "Launch into the skies with a double-tap spell!" + chr(10) + "Special Attack: Conjure Comets"
	crabDescs[2] = "Speed: {{{{{ Turn: {}}}}" + chr(10) + "Grew up at the Rotation Station, and it shows." + chr(10) + "Very fast! Double-tap to skid & stop a sec'." + chr(10) + "Special Attack: Orbital Nightmare"
	crabDescs[3] = "Speed: {{{{} Turn: {{}}}" + chr(10) + "Always ready to party!! How can you say no?" + chr(10) + "He'll stop and mosh when he hears a double-tap." + chr(10) + "Special Attack: Party Time!"
	crabDescs[4] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "A clockwork master! Sends his opponents forward" + chr(10) + "in time, and rewinds his clock by double-tapping." + chr(10) + "Special Attack: Fast Forward"
	crabDescs[5] = "Speed: {{{}} Turn: {{{{{" + chr(10) + "Quieter than a rising sun, deadlier than a black" + chr(10) + "hole! Instantly turns but has no double-tap move." + chr(10) + "Special Attack: Shuri-Krustacean"
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, crabNames[csc.crabSelected+1])
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
	SetTextColorAlpha(csc.txtReady, 0)
	
	if spActive = 1
		//Creating the story mode exclusive stuff
		CreateTextExpress(TXT_CS_CRAB_STATS_2, "Chapter " + str(curChapter), 96, fontDescItalI, 0, 40, 100, 10)
		CreateTextExpress(TXT_CS_CRAB_NAME_2, chapterTitle[curChapter], 90, fontDescI, 2, w-40, 190, 10)
		CreateTextExpress(TXT_CS_CRAB_DESC_2, chapterDesc[curChapter], 64, fontDescI, 1, w/2, 370, 10)
		
		SetTextSpacing(TXT_CS_CRAB_STATS_2, -27)
		SetTextSpacing(TXT_CS_CRAB_NAME_2, -24)
		SetTextSpacing(TXT_CS_CRAB_DESC_2, -17)
		
		SetSpriteSize(csc.sprTxtBack, w, 140)
		IncSpriteY(csc.sprTxtBack, 40)
		IncTextY(csc.txtCrabDesc, 34)
		
		SetFolder("/media/envi")
		
		LoadSpriteExpress(SPR_CS_BG_2, "bg5.png", w*1.4, w*1.4, -w*0.2, -w*0.2, 199)
		
		for i = 1 to 4
			spr = SPR_SCENE1 - 1 + i
			CreateSpriteExpress(spr, 100, 100, w*2/4 + GetSpriteHeight(split)/4 - 50 + (i-2.5)*130, h - 120, 10)
			CreateTextExpress(spr, Str(i), 60, fontScoreI, 1, GetSpriteX(spr) + 90, GetSpriteY(spr) + 50,  9)
			AddButton(spr)
		next i
		CreateTextExpress(TXT_SCENE, "Scene Select:", 54, fontDescI, 0, 50, h-180, 10)
		SetTextSpacing(TXT_SCENE, -14)
		
		SetSceneImages(1)
		
		SetFolder("/media/ui")
		
		if Mod(highestScene, 4) = 1
			SetSpriteImage(csc.sprReady, LoadImage("storystart.png"))
		else
			SetSpriteImage(csc.sprReady, LoadImage("storycontinue.png"))
		endif
		trashBag.insert(GetSpriteImageID(csc.sprReady))
		
		SetFolder("/media")
	
		if dispH
			for i = 1 to 4
				spr = SPR_SCENE1 - 1 + i
				//SetSpriteExpress(spr, 75, 75, w/2
				SetSpritePosition(spr, w*3/4 + GetSpriteHeight(split)/4 - 50 + (i-2.5)*130, h - 130)
				SetTextPosition(spr, GetSpriteX(spr) + 90, GetSpriteY(spr) + 50)
			next i
			SetTextPosition(TXT_SCENE, w/2 + 100, h-200)
			
			for i = TXT_CS_CRAB_NAME_2 to TXT_CS_CRAB_STATS_2
				if i <> TXT_CS_READY_2
					SetTextSize(i, GetTextSize(i) - 18)
					SetTextSpacing(i, GetTextSpacing(i) + 3)
					
				endif
			next i
			
			SetTextPosition(TXT_CS_CRAB_STATS_2, w/2 + GetSpriteHeight(split)/4 + 30, 70)
			SetTextPosition(TXT_CS_CRAB_NAME_2, w - 30, 145)
			SetTextMiddleScreenXDispH2(TXT_CS_CRAB_DESC_2)
			SetTextY(TXT_CS_CRAB_DESC_2, 300)
			
			SetSpriteSizeSquare(SPR_CS_BG_2, h*1.3)
			SetSpriteMiddleScreenXDispH2(SPR_CS_BG_2)
			SetSpriteMiddleScreenY(SPR_CS_BG_2)
			
			SetSpriteY(csc.sprReady, h-140)
			SetSpriteSize(csc.sprReady, 842/2.7, 317/2.7)
			SetSpriteMiddleScreenXDispH2(csc.sprReady)
						
		endif
	
	endif
	
	if dispH
		if p = 1
			SetSpriteSizeSquare(csc.sprBG, h*1.1)
			SetSpriteMiddleScreenXDispH1(csc.sprBG)
			SetSpriteMiddleScreenY(csc.sprBG)
			SetSpriteSizeSquare(csc.sprBGB, h*1.1)
			SetSpriteMiddleScreenXDispH1(csc.sprBGB)
			SetSpriteMiddleScreenY(csc.sprBGB)
			
			SetTextMiddleScreenXDispH1(csc.txtCrabName)
			SetTextY(csc.txtCrabName, 100)
			SetTextSize(csc.txtCrabName, 82)
			SetTextSpacing(csc.txtCrabName, -23)
						
			SetTextMiddleScreenXDispH1(csc.txtCrabDesc)
			SetTextSize(csc.txtCrabDesc, 34)
			IncTextY(csc.txtCrabDesc, -62)
			SetSpriteSize(csc.sprTxtBack, w/2, 140)
			SetSpriteDepth(csc.sprTxtBack, 50)
			IncSpriteY(csc.sprTxtBack, -70)
			
			SetSpriteSize(csc.sprLeftArrow, 100*gameScale#, 100*gameScale#)
			SetSpriteMiddleScreenXDispH1(csc.sprLeftArrow)
			IncSpriteX(csc.sprLeftArrow, -w/4+86)
			SetSpriteY(csc.sprLeftArrow, GetSpriteY(csc.sprTxtBack)+GetSpriteHeight(csc.sprLeftArrow)/2 + 30)
			
			SetSpriteSize(csc.sprRightArrow, 100*gameScale#, 100*gameScale#)
			SetSpriteMiddleScreenXDispH1(csc.sprRightArrow)
			IncSpriteX(csc.sprRightArrow, w/4-86)
			SetSpriteY(csc.sprRightArrow, GetSpriteY(csc.sprTxtBack)+GetSpriteHeight(csc.sprRightArrow)/2 + 30)
			
			SetSpriteVisible(csc.sprReady, 0)
		endif
	endif
	
	SetVisibleCharacterUI(1, csc)
	
endfunction

// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	if spActive = 1 then spType = STORYMODE
	if spType = STORYMODE then spActive = 1
	
	lineSkipTo = 0
	
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
	
	if spActive and spType = STORYMODE
		//InitStorySelectController(csc2)
	else
		InitCharacterSelectController(csc2)
	endif
	
	LoadSpriteExpress(SPR_MENU_BACK, "ui/mainmenu.png", 140, 140, 0, 0, 3)
	SetSpriteMiddleScreen(SPR_MENU_BACK)
	AddButton(SPR_MENU_BACK)
	
	
	PlayMusicOGGSP(characterMusic, 1)
	PlayMusicOGGSP(fireMusic, 1)
	SetMusicVolumeOGG(fireMusic, 20*volumeM/100)
	
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
		if spActive = 0
			SetTextString(csc.txtCrabName, crabNames[csc.crabSelected+1])
			SetTextString(csc.txtCrabDesc, crabDescs[csc.crabSelected])
			
			space = 12
			for i = Len(GetTextString(csc.txtCrabDesc)) to FindStringReverse(GetTextString(csc.txtCrabDesc), chr(10))-1 step -1
				SetTextCharY(csc.txtCrabDesc, i, GetTextSize(csc.txtCrabDesc)*3*p + space*p - GetTextSize(csc.txtCrabDesc)*f)
			next i
			
		else
			curChapter = csc.crabSelected+1
			SetCrabFromStringChap("", curChapter, 3)
			SetTextString(csc.txtCrabName, chapNames[csc.crabSelected+1])
			SetTextString(csc.txtCrabDesc, crabPause1[crabRefType])
			SetTextString(TXT_CS_CRAB_STATS_2, "Chapter " + str(curChapter))
			SetTextString(TXT_CS_CRAB_NAME_2, chapterTitle[curChapter])
			SetTextString(TXT_CS_CRAB_DESC_2, chapterDesc[curChapter])
			SetSceneImages(0)
			
			//This loads in the crab's images, if they haven't already been loaded in
			if GetSpriteFrameCount(csc.sprCrabs + csc.crabSelected) <> 6
				SetFolder("/media/art")
				SetCrabFromStringChap("", curChapter, 3)
				SetSpriteVisible(csc.sprCrabs + csc.crabSelected, 1)
				for i = 1 to 6
					img = LoadImageR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "select" + Str(i) + ".png")
					if img <> 0
						AddSpriteAnimationFrame(csc.sprCrabs + csc.crabSelected, img)
						trashBag.insert(img)
					
					endif
				next i
				PlaySprite(csc.sprCrabs + csc.crabSelected, 18, 1, 1, 6)
			endif
		endif
		
		space = 12
		for i = 0 to FindString(GetTextString(csc.txtCrabDesc), chr(10))-1
			SetTextCharY(csc.txtCrabDesc, i, -space*p - GetTextSize(csc.txtCrabDesc)*f)
			//SetTextCharColor(csc.txtCrabDesc, i, 255, 100, 100, 255)
		next i
		
		
		
	endif
	
	cNum = csc.crabSelected
	
	//if GetSpriteWidth(csc.sprCrabs+csc.crabSelected) < charWid/2+1 then SetSpriteMiddleScreenX(csc.sprCrabs+csc.crabSelected)
	
	// Glide
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1 + spActive*STORY_CS_BONUS 
		num = spr - csc.sprCrabs
		//SnapbackToX(spr, glideMax - csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, -40*dir*p, 4, 5)	//Andy Version
		//SnapbackToX(spr, csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 * cNum*1000, 30, 10)
		//GlideToX(spr, GetSpriteX(spr) + -1*p*dir*w, 30)
		//Print(GetSPriteX(spr))
		
		
		
		if csc.glideFrame > glideMax/2
			SetSpriteSize(spr, charWid - 45 + (glideMax - csc.glideFrame)/glideMax*90, charHei - 30 + (glideMax - csc.glideFrame)/glideMax*60)
			if dispH then SetSpriteSize(spr, charWid*.8 - 45 + (glideMax - csc.glideFrame)/glideMax*90, charHei*.8 - 30 + (glideMax - csc.glideFrame)/glideMax*60)
			color = (glideMax - csc.glideFrame)/glideMax*110
			SetSpriteColor(spr, 200 + color, 200 + color, 200 + color, GetSpriteColorAlpha(spr))
		endif
		
		
		if dispH = 0
			GlideToX(spr, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, 4)
			if csc.player = 1 then GlideToY(spr, h/2 - GetSpriteHeight(spr)/2 + charVer, 2)
			if csc.player = 2 then GlideToY(spr, h/2 - GetSpriteHeight(spr)/2 - charVer, 2)
		endif
		if dispH
			if csc.player = 1 then GlideToX(spr, w/4 - GetSpriteHeight(split)/4 - GetSpriteWidth(spr)/2 - (cNum-num)*500*p, 4)
			if csc.player = 2 then GlideToX(spr, w*3/4 + GetSpriteHeight(split)/4 - GetSpriteWidth(spr)/2 - (cNum-num)*500*p, 4)
			GlideToY(spr, h/2 - GetSpriteHeight(spr)/2 - 60, 2)
			
			if (cNum-num) <> 0
				//SetSpriteColorAlpha(spr, Max(0, GetSpriteColorAlpha(spr) - 150))
				SetSpriteColorAlpha(spr, Max(0, GetSpriteColorAlpha(spr) - 255/glideMax*10.0))
			else
				//SetSpriteColorAlpha(spr, Min(255, GetSpriteColorAlpha(spr) + 50))
				if csc.glideFrame < glideMax*5/6.0 then SetSpriteColorAlpha(spr, Min(255, GetSpriteColorAlpha(spr) + 255/glideMax*7.0))
			endif
			
		endif
		
	next spr
	dec csc.glideFrame
	
	//Print(cNum)
	//Sleep(500)
	
	// Finish the glide and change the displayed crab
	if csc.glideFrame = 0
		
		if spType = STORYMODE
			if csc.CrabSelected <> 0
				SetSpriteVisible(csc.sprLeftArrow, 1)
			endif
			if csc.CrabSelected <> Min(clearedChapter, finalChapter-1)
				SetSpriteVisible(csc.sprRightArrow, 1)
			endif
			//SetSpriteVisible(csc.sprReady, 1)
		else
			if csc.CrabSelected <> 0
				SetSpriteVisible(csc.sprLeftArrow, 1)
			endif
			if csc.CrabSelected <> NUM_CRABS-1 + spActive*STORY_CS_BONUS
				SetSpriteVisible(csc.sprRightArrow, 1)
			endif
			SetSpriteVisible(csc.sprReady, 1)
		endif
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
	
	//SetSpriteVisible(csc.sprReady, 0)
	SetSpriteVisible(csc.sprLeftArrow, 0)
	SetSpriteVisible(csc.sprRightArrow, 0)
	
	if spType <> STORYMODE then PlayTweenSprite(tweenSprFadeOut, csc.sprReady, 0)
	if spType <> STORYMODE then PlayTweenText(tweenTxtFadeIn, csc.txtReady, 0)
	if spType <> STORYMODE then PlaySprite(csc.sprReady, 12, 1, 1, 6)
	
	
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
	
	//SetSpriteVisible(csc.sprReady, 1)
	
	if csc.crabSelected <> 0 then SetSpriteVisible(csc.sprLeftArrow, 1)
	if csc.crabSelected <> 5 then SetSpriteVisible(csc.sprRightArrow, 1)
	
	StopTweenSprite(tweenSprFadeOut, csc.sprReady)
	StopTweenText(tweenTxtFadeIn, csc.txtReady)
	SetSpriteColorAlpha(csc.sprReady, 255)
	SetTextColorAlpha(csc.txtReady, 0)
	
	PlaySprite(csc.sprReady, 9+csc.player, 1, 7+8*(csc.player-1), 14+8*(csc.player-1))
	
	//Text gets smaller again
	SetTextSize(csc.txtCrabName, GetTextSize(csc.txtCrabName) - 10)
	
	csc.ready = 0
	
endfunction


// Game loop for a single screen
function DoCharacterSelectController(csc ref as CharacterSelectController)

	if not csc.ready
		
		if spActive = 1 and csc.stage = 1
			SetVisibleCharacterUI(2, csc)
			csc.crabSelected = curChapter-2
			ChangeCrabs(csc, 1, 1)
			csc.stage = 2
			ClearMultiTouch()
		endif
		
		//The 6-crab view
		if csc.stage = 1
			for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
				spr = csc.sprCrabs + i
				if ButtonMultitouchEnabled(spr)
					for j = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
						StopTweenSprite(csc.sprCrabs + j, csc.sprCrabs + j)
					next j
					SetVisibleCharacterUI(2, csc)
					csc.crabSelected = i-1
					PlaySoundR(arrowS, 40)
					ChangeCrabs(csc, 1, 1)
					csc.stage = 2
					i = NUM_CRABS + spActive*STORY_CS_BONUS
					ClearMultiTouch()
				endif
			next i
		
		//The 1-crab view
		elseif csc.stage = 2
			// Ready button
			if (Button(csc.sprReady) or (inputSelect and selectTarget = 0 and GetSpriteVisibleR(SPR_SCENE1) = 0)) and GetSpriteVisible(csc.sprReady) 
				PlaySoundR(chooseS, 100)
				SelectCrab(csc)
				//PingColor(GetSpriteMiddleX(csc.sprCrabs+csc.crabSelected), GetSpriteMiddleY(csc.sprCrabs+csc.crabSelected), 400, 255, 100, 100, 50)
			// Scroll left
			elseif (ButtonMultitouchEnabled(csc.sprLeftArrow) or (GetMultitouchPressedTopRight() and csc.player = 2 and dispH = 0) or (GetMultitouchPressedBottomLeft() and csc.player = 1 and dispH = 0)) and csc.crabSelected > 0
				PlaySoundR(arrowS, 100)
				ChangeCrabs(csc, -1, 1)
			// Scroll right
			elseif (ButtonMultitouchEnabled(csc.sprRightArrow) or (GetMultitouchPressedTopLeft() and csc.player = 2 and dispH = 0) or (GetMultitouchPressedBottomRight() and csc.player = 1 and dispH = 0)) and ((csc.crabSelected < NUM_CRABS-1+spActive*STORY_CS_BONUS and spType <> STORYMODE) or (csc.crabSelected < Min(clearedChapter, finalChapter-1) and spType = STORYMODE))
				ChangeCrabs(csc, 1, 1)
				PlaySoundR(arrowS, 100)
			endif
			
			if spType = STORYMODE
				for i = 1 to 4
					spr = SPR_SCENE1 - 1 + i
					if ButtonMultitouchEnabled(spr) and GetSpriteVisible(spr)
						curScene = i
						SelectCrab(csc)
					endif
				next i
			endif
			
			if csc.glideFrame <= 0
				if dispH = 0
					SetSpriteSize(csc.sprCrabs+csc.crabSelected, charWid, charHei)
					SetSpriteX(csc.sprCrabs+csc.crabSelected, w/2 - GetSpriteWidth(csc.sprCrabs+csc.crabSelected)/2)
					if csc.player = 1 then SetSpriteY(csc.sprCrabs+csc.crabSelected, h/2 - GetSpriteHeight(csc.sprCrabs+csc.crabSelected)/2 + charVer)
					if csc.player = 2 then SetSpriteY(csc.sprCrabs+csc.crabSelected, h/2 - GetSpriteHeight(csc.sprCrabs+csc.crabSelected)/2 - charVer)
				endif
				if dispH
					SetSpriteSize(csc.sprCrabs+csc.crabSelected, charWid*.8, charHei*.8)
					if csc.player = 1 then SetSpriteX(csc.sprCrabs+csc.crabSelected, w/4 - GetSpriteHeight(split)/4 - GetSpriteWidth(csc.sprCrabs+csc.crabSelected)/2)
					if csc.player = 2 then SetSpriteX(csc.sprCrabs+csc.crabSelected, w*3/4 + GetSpriteHeight(split)/4 - GetSpriteWidth(csc.sprCrabs+csc.crabSelected)/2)
					SetSpriteY(csc.sprCrabs+csc.crabSelected, h/2 - GetSpriteHeight(csc.sprCrabs+csc.crabSelected)/2 - 60)
				endif
			endif
			
			for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
				spr = csc.sprCrabs + i
				if ButtonMultitouchEnabled(spr) and spActive = 0
					SetVisibleCharacterUI(1, csc)
					for j = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
						PlayTweenSprite(csc.sprCrabs + j, csc.sprCrabs + j, 0)
					next j
					PlaySoundR(arrowS, 100)
					csc.stage = 1
					spr = NUM_CRABS + spActive*STORY_CS_BONUS
				endif
			next i
		endif
	endif
		
	//Slowly lighting the backgrounds
	SetSpriteColorAlpha(csc.sprBG, 205+abs(50*cos(90*csc.player + 80*GetMusicPositionOGG(characterMusic))))
	IncSpriteAngle(csc.sprBGB, 1.8*fpsr#)
	if spActive then IncSpriteAngle(SPR_CS_BG_2, -0.8*fpsr#)
	//IncSpriteAngle(csc.sprBGB, 6*fpsr#)
	
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
		TransitionEnd()
	endif
	state = CHARACTER_SELECT
	
	DoCharacterSelectController(csc1)
	if spActive = 0 then DoCharacterSelectController(csc2)
		
	//Unselects the crab if the screen is touched again (only works on mobile for testing)
	if csc1.ready = 1 and (GetMultitouchPressedBottom() and deviceType = MOBILE)
		UnselectCrab(csc1)
		ClearMultiTouch()
	endif
	if csc2.ready = 1 and (GetMultitouchPressedTop() and deviceType = MOBILE)
		UnselectCrab(csc2)
		ClearMultiTouch()
	endif
	
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
	
	if spActive = 0
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
	endif
	
	//Spinning the main menu button
	IncSpriteAngle(SPR_MENU_BACK, 1*fpsr#)
	
	if ButtonMultitouchEnabled(SPR_MENU_BACK) or inputExit
		state = START
		spActive = 0
		spType = 0
		TransitionStart(Random(1,lastTranType))
	endif
	
	if csc1.ready and csc2.ready
		spActive = 0
		spType = 0
		state = GAME
		SetTextVisible(csc1.txtReady, 0)
		SetTextVisible(csc2.txtReady, 0)
		TransitionStart(Random(1,lastTranType))
	endif
	
	//Going to the story mode!
	if csc1.ready and spActive
		if ButtonMultitouchEnabled(csc1.sprReady) and GetSpriteVisible(csc1.sprReady) then curScene = Mod(highestScene-1, 4)+1
		spActive = 1
		spType = STORYMODE
		state = STORY
		TransitionStart(Random(1,lastTranType))
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
	
	DeleteAnimatedSprite(csc.sprReady)
	DeleteSprite(csc.sprRightArrow)
	DeleteAnimatedSprite(csc.sprLeftArrow)
	DeleteSprite(csc.sprBG)
	DeleteSprite(csc.sprBGB)
	DeleteText(csc.txtCrabName)
	DeleteText(csc.txtCrabDesc)
	DeleteText(csc.txtCrabStats)
	DeleteText(csc.txtReady)
	DeleteSprite(csc.sprTxtBack)
	for spr = csc.sprCrabs to csc.sprCrabs + NUM_CRABS-1 + STORY_CS_BONUS
		if GetSpriteExists(spr) then DeleteSprite(spr)
		if GetTweenExists(spr) then DeleteTween(spr)
	next spr
	
	
endfunction


// Cleanup upon leaving this state
function ExitCharacterSelect()
	
	CleanupCharacterSelectController(csc1)
	if GetSpriteExists(csc2.sprReady) then CleanupCharacterSelectController(csc2)
	if GetTextExists(TXT_CS_CRAB_STATS_2)
		DeleteSprite(SPR_CS_BG_2)
		DeleteText(TXT_CS_CRAB_STATS_2)
		DeleteText(TXT_CS_CRAB_NAME_2)
		DeleteText(TXT_CS_CRAB_DESC_2)
		for i = 1 to 4
			spr = SPR_SCENE1 - 1 + i
			if GetSpriteExists(spr) then DeleteSprite(spr)
			if GetTextExists(spr) then DeleteText(spr)
		next i
		DeleteText(TXT_SCENE)
	endif
	
	DeleteSprite(SPR_MENU_BACK)
	
	if GetMusicPlayingOGGSP(characterMusic) then StopMusicOGGSP(characterMusic)
	if GetMusicPlayingOGGSP(fireMusic) then StopMusicOGGSP(fireMusic)
	
	characterSelectStateInitialized = 0
	
	ClearMultiTouch()
	EmptyTrashBag()
	
endfunction

function SetSceneImages(new)
	SetFolder("/media/text")
	OpenToRead(2, "fights.txt")
	for i = 2 to curChapter
		ReadLine(2)
	next i
	line$ = ReadLine(2)
	CloseFile(2)
	for i = 1 to 4
		spr = SPR_SCENE1 - 1 + i
		if new = 0 then DeleteImage(GetSpriteImageID(spr))
		
		SetCrabFromStringChap(Mid(GetStringToken(line$, " ", i), 1, 2), 0, 3)
		
		SetFolder("/media/art")
		imgStr$ = "crab" + str(crabRefType) + AltStr(crabRefAlt) + "life" + Mid(GetStringToken(line$, " ", i), 3, 1) + ".png"
		if GetFileExists(imgStr$) then img = LoadImage(imgStr$)
		SetSpriteImage(spr, img)
	next i
	
	vis = 1
	if curChapter > clearedChapter then vis = 0
	for i = 1 to 4
		spr = SPR_SCENE1 - 1 + i
		SetSpriteVisible(spr, vis)
		SetTextVisible(spr, vis)
		SetTextVisible(TXT_SCENE, vis)
	next i
	SetSpriteVisible(SPR_CS_READY_1, Mod(vis+1, 2))
	if vis = 0
		//if Mod(highestScene, 4) <> 1 then //TODO: Set sprite image to be continue
	endif
	
endfunction

