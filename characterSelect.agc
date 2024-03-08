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
	"NINJA CRAB",
	"MAD CRAB", //Row 2
	"KING CRAB",
	"TAXI CRAB",
	"#1 FAN CRAB",
	"INIANDA JEFF",
	"TEAM PLAYER",
	"AL LEGAL", //Row 3
	"CRABACUS",
	"SPACE BARC",
	"HAWAIIAN CRAB",
	"ROCK LOBSTER",
	"CRANIME",
	"FUTURE CRAB", //Row 4
	"CRABYSS KNIGHT",
	"SK8R CRAB",
	"HOLY CRAB",
	"CRAB CAKE",
	"KYLE CRAB"]

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
#constant dispHM1 290 //(w/2-GetSpriteHeight(split)/2)/2
#constant dispHM2 990 //(w/2-GetSpriteHeight(split)/2)/2
// Initialize the sprites within a CSC
// "player" -> 1 or 2
function InitCharacterSelectController(csc ref as CharacterSelectController)
	
	p as integer, f as integer, m as integer
	if csc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if csc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
		
	if dispH = 1
		p = 1
		f = 0
		if csc.player = 2 then m = 700 else m = 0 // makes the horizontal offset calculations easier
	endif
	
	csc.stage = 1
	
	SetFolder("/media/ui")
	
	LoadAnimatedSprite(csc.sprReady, "ready", 22)
	PlaySprite(csc.sprReady, 9+csc.player, 1, 7+8*(csc.player-1), 14+8*(csc.player-1))
	SetSpriteSize(csc.sprReady, w/3, h/16)
	SetSpriteMiddleScreenOffset(csc.sprReady, 0, p*7*h/16 + p*32)
	SetSpriteFlip(csc.sprReady, f, f)
	AddButton(csc.sprReady)
	SetSpriteVisible(csc.sprReady, 0)
	
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
	if csc.crabSelected = NUM_CRABS-1 + spActive*STORY_CS_BONUS then SetSpriteVisible(csc.sprRightArrow, 0)
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
	SetFolder("/media/art")
	mysteryI1 = LoadImageResizedR("crab0aselect1.png", .5)
	mysteryI2 = LoadImageResizedR("crab0aselect2.png", .5)
	mysteryI3 = LoadImageResizedR("crab0aselect3.png", .5)
	mysteryI4 = LoadImageResizedR("crab0aselect4.png", .5)
	mysteryI5 = LoadImageResizedR("crab0aselect5.png", .5)
	mysteryI6 = LoadImageResizedR("crab0aselect6.png", .5)
	trashBag.insert(mysteryI1)
	trashBag.insert(mysteryI2)
	trashBag.insert(mysteryI3)
	trashBag.insert(mysteryI4)
	trashBag.insert(mysteryI5)
	trashBag.insert(mysteryI6)

	highAlt = GetHighAlt()
	scale# = 1
	if highAlt = 1 then scale# = .8
	if highAlt = 2 then scale# = .5
	if highAlt = 3 then scale# = .4
	for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS 
		SyncG()
		locked = 0
		if altUnlocked[Mod(i, 6)+1] < (i)/6 then locked = 1
		
		//if i = 0 or i = 1 or i = 3 or i = 5
			CreateSprite(csc.sprCrabs + i, 0)
			if spActive = 0
				
				//Loading images for the crabs in, the first time; however, they will be SMALLER!
				SetFolder("/media/art")
				crabRefType = Mod(i, 6)+1
				crabRefAlt = (i)/6
				//Will eventually put a check here, for if that crab is unlocked
				if locked = 0
					for j = 1 to 6
						if csc.player = 1
							img = LoadImageResizedR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "select" + Str(j) + ".png", .4*scale#)
							if j = 1 then IMG_CS_CRAB[i] = img
						else
							if IMG_CS_CRAB[i] <> 0
								img = IMG_CS_CRAB[i]+j-1		//Re-using the images from player one
							else
								img = 0
							endif
						endif
						if img <> 0
							AddSpriteAnimationFrame(csc.sprCrabs + i, img)
							trashBag.insert(img)
						endif
					next j
					PlaySprite(csc.sprCrabs + i, 18, 1, 1, 6)
				else
					//This red coloration means that the sprite is locked
					SetSpriteGroup(csc.sprCrabs + i, mysteryI1)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI1)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI2)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI3)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI4)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI5)
					AddSpriteAnimationFrame(csc.sprCrabs + i, mysteryI6)
					PlaySprite(csc.sprCrabs + i, 18, 1, 1, 6)
				endif
			else
				SetSpriteVisible(csc.sprCrabs + i, 0)
			
			endif
		
		if i > 6*(1+highAlt) - 1
			//Crab is not in unlocked row
			SetSpriteVisible(csc.sprCrabs + i, 0)
		elseif locked = 0
			//Crab is in unlocked rpw
			AddButton(csc.sprCrabs + i)
		endif
		
		
		//SetSpriteSize(csc.sprCrabs + i, charWid*4/7, charHei*4/7) //Slightly bigger crab size
		//SetSpriteMiddleScreenOffset(csc.sprCrabs + i, p*(i-csc.crabSelected)*w, p*335)	//The old way to position the sprites
		SetSpriteFlip(csc.sprCrabs + i, f, f)
		SetSpriteDepth(csc.sprCrabs, 40)
		
		
		//For below:
		//cSizeW/H is the size of the crab when in the smaller view
		//posX/Y is the X/Y of the crab in the smaller view
		//The tween X/Y is set in the dispH if statement, big size is left on the outside
		
		CreateTweenSprite(csc.sprCrabs + i, selectTweenTime#)
		if dispH = 0
			//Vertical layout: creating the crab layout/tweens
			if highAlt = 0
				cSizeW = charWid*3/5
				cSizeH = charHei*3/5
				posX# = w/2 - cSizeW/2 + p*charHorSmallGap*(Mod(i,3)-1)
				posY# = h/2 - charHei/4 + p*charVerSmall + p*charVerSmallGap*((i)/3)
			elseif highAlt = 1
				cSizeW = charWid*2.4/5
				cSizeH = charHei*2.4/5
				posX# = w/2 - cSizeW/2 + p*charHorSmallGap/2.3*(Mod(i,6)-3) + cSizeW/4*p
				posY# = h/2 - charHei/4 + p*charVerSmall*0.8 + p*charVerSmallGap*((i)/6)*1.1
				if Mod(i, 2) then inc posY#, 130*p
			elseif highAlt = 2
				cSizeW = charWid*2.2/5
				cSizeH = charHei*2.2/5
				posX# = w/2 - cSizeW/2 + p*charHorSmallGap/2.3*(Mod(i,6)-3) + cSizeW/4*p
				posY# = h/2 - charHei/4 + p*charVerSmall*0.8 + p*charVerSmallGap*((i)/6)*0.7
				if Mod(i, 2) then inc posY#, 80*p
			elseif highAlt = 3
				cSizeW = charWid*1.9/5
				cSizeH = charHei*1.9/5
				posX# = w/2 - cSizeW/2 + p*charHorSmallGap/2.3*(Mod(i,6)-3) + cSizeW/4*p
				posY# = h/2 - charHei/4 + p*charVerSmall*0.8 + p*charVerSmallGap*((i)/6)*0.5
				if Mod(i, 2) then inc posY#, 60*p
			endif
			if p = -1 then inc posY#, charHei/8
			
			SetTweenSpriteX(csc.sprCrabs + i, w/2-charWid/2, posX#, TweenOvershoot())
			SetTweenSpriteY(csc.sprCrabs + i, h/2-charHei/2 + p*charVer, posY#, TweenOvershoot())
		else
			//Horizontal layout: creating the crab layout/tweens
			if highAlt = 0
				cSizeW = charWid*4/9
				cSizeH = charHei*4/9
				posX# = dispHM1 - cSizeW/2 + charHorSmallGap/1.4*(Mod(i,3)-1) + m
				posY# = h/2 - charHei/3 + 0.8*charVerSmallGap*((i)/3)
				
			elseif highAlt = 1
				cSizeW = charWid*4/11
				cSizeH = charHei*4/11
				posX# = dispHM1 + charHorSmallGap/2.9*(Mod(i,6)-3) + m - cSizeW/6
				posY# = h/2 - charHei/3 + .9*charVerSmallGap*((i)/6)
				if Mod(i, 2) then inc posY#, 110
				
			elseif highAlt = 2
				cSizeW = charWid*3.4/11
				cSizeH = charHei*3.4/11
				posX# = dispHM1 + charHorSmallGap/2.9*(Mod(i,6)-3) + m - cSizeW/6
				posY# = h/2 - charHei/3 + .6*charVerSmallGap*((i)/6)
				if Mod(i, 2) then inc posY#, 60
				
			else
				cSizeW = charWid*3/11
				cSizeH = charHei*3/11
				posX# = dispHM1 + charHorSmallGap/2.9*(Mod(i,6)-3) + m - cSizeW/6
				posY# = h/2 - charHei/3 + .45*charVerSmallGap*((i)/6)
				if Mod(i, 2) then inc posY#, 40
				
			endif
			
			SetTweenSpriteX(csc.sprCrabs + i, dispHM1 - charWid/2 + m, posX#, TweenOvershoot())
			SetTweenSpriteY(csc.sprCrabs + i, h/2 - charHei/3, posY#, TweenOvershoot())
		endif

		SetSpriteSize(csc.sprCrabs + i, cSizeW, cSizeH)
		SetSpritePosition(csc.sprCrabs + i, posX#, posY#)
		SetTweenSpriteSizeX(csc.sprCrabs + i, charWid, cSizeW, TweenOvershoot())
		SetTweenSpriteSizeY(csc.sprCrabs + i, charHei, cSizeH, TweenOvershoot())
		
		if Mod(i+1, 6) = 1 then crabDescs[i] = "Speed: {{{}} Turn: {{{}}" + chr(10)
		if Mod(i+1, 6) = 2 then crabDescs[i] = "Speed: {{}}} Turn: {{{{}" + chr(10)
		if Mod(i+1, 6) = 3 then crabDescs[i] = "Speed: {{{{{ Turn: {}}}}" + chr(10)
		if Mod(i+1, 6) = 4 then crabDescs[i] = "Speed: {{{{} Turn: {{}}}" + chr(10)
		if Mod(i+1, 6) = 5 then crabDescs[i] = "Speed: {{{}} Turn: {{{}}" + chr(10)
		if Mod(i+1, 6) = 0 then crabDescs[i] = "Speed: {{{}} Turn: {{{{{" + chr(10)
	
	next i
	
	//Descriptions were moved down here to include newline characters
	crabDescs[0] = crabDescs[0] + 	"Known far and wide, he's ready to claim his fame!" + chr(10) +	"Double-tap for his galaxy famous quick-dodge!"
	crabDescs[1] = crabDescs[1] + 	"The most magical being this side of the nebula." + chr(10) + 	"Launch into the skies with a double-tap spell!"
	crabDescs[2] = crabDescs[2] + 	"Grew up at the Rotation Station, and it shows." + chr(10) + 	"Very fast! Double-tap to skid & stop a sec'."
	crabDescs[3] = crabDescs[3] + 	"Always ready to party!! How can you say no?" + chr(10) + 		"He'll stop and mosh when he hears a double-tap."
	crabDescs[4] = crabDescs[4] + 	"A clockwork master! Sends his opponents forward" + chr(10) + 	"in time, and rewinds his clock by double-tapping."
	crabDescs[5] = crabDescs[5] + 	"Quieter than a rising sun, deadlier than a black" + chr(10) + 	"hole! Instantly turns but has no double-tap move."
	crabDescs[6] = crabDescs[6] + 	"It's true that anger can be weaponized-" + chr(10) + 			"just ask this guy! He has no need for meditation."
	crabDescs[7] = crabDescs[7] + 	"'Opulence is dish best served cold.'" + chr(10) + 				"'What do you mean that doesn't make sense??'"
	crabDescs[8] = crabDescs[8] + 	"Having chauffeured half the galaxy," + chr(10) + 				"this crab has learned many attacks & counters."
	crabDescs[10] = crabDescs[10] + 	"(Mis)hearing whisperings of an otherworldy" + chr(10) +			"movie, this young adventurer took the mantle!"
	crabDescs[11] = crabDescs[11] + 	"A quarterback at heart, this Team Player" + chr(10) + 			"has no trouble going solo to beat his opponent."
	crabDescs[12] = crabDescs[12] + 	"The pen is mightier than the sword, yes - but" + chr(10) + 		"will it stand up to a swarm of incoming meteors?"
	crabDescs[13] = crabDescs[13] + 	"It's always been numbers. The angles, velocities," + chr(10) + 	"polar coordinates. This crab figured it all out!"
	crabDescs[21] = crabDescs[21] + 	"An angelic presence, from on high. Will they" + chr(10) + 		"show mercy, or smite us for our wrongdoings?"
	//crabDescs[] = crabDescs[] + "" + chr(10) + 													""
	for i = 0 to NUM_CRABS-1
		crabDescs[i] = crabDescs[i] + chr(10) + "Special Attack: " + GetSpecialName(i+1)
	next i
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(csc.txtCrabName, crabNames[csc.crabSelected+1])
	SetTextSize(csc.txtCrabName, 96)
	SetTextAngle(csc.txtCrabName, f*180)
	SetTextFontImage(csc.txtCrabName, fontCrabI)
	SetTextSpacing(csc.txtCrabName, -22)
	SetTextMiddleScreenOffset(csc.txtCrabName, f, 0, p*130)
	SetTextAlignment(csc.txtCrabName, 1)
	
	CreateText(csc.txtCrabDesc, crabDescs[csc.crabSelected] )
	SetTextSize(csc.txtCrabDesc, 40)
	SetTextAngle(csc.txtCrabDesc, f*180)
	SetTextFontImage(csc.txtCrabDesc, fontDescI)
	SetTextSpacing(csc.txtCrabDesc, -10)
	//SetTextMiddleScreenOffset(csc.txtCrabDesc, f, -w/5, p*3*h/8.5)
	SetTextMiddleScreenOffset(csc.txtCrabDesc, f, 0, p*3*h/8.5)
	SetTextAlignment(csc.txtCrabDesc, 1)
	
	//Mostly depreciated, just used for the story stuff
	CreateText(csc.txtCrabStats, "Speed: {{}}" + chr(10) + "Turn: {{{}" + chr(10) + "Special:" + chr(10) + "Meteor Shower")
	SetTextSize(csc.txtCrabStats, 40)
	SetTextAngle(csc.txtCrabStats, f*180)
	SetTextFontImage(csc.txtCrabStats, fontDescI)
	SetTextSpacing(csc.txtCrabStats, -10)
	SetTextMiddleScreenOffset(csc.txtCrabStats, f, w/2-w/5, p*3*h/8.5)
	SetTextAlignment(csc.txtCrabStats, 1)
	SetTextVisible(csc.txtCrabStats, 0)
	
	
	CreateText(csc.txtReady, "Waiting for your opponent...")
	SetTextSize(csc.txtReady, 86)
	SetTextAngle(csc.txtReady, f*180)
	SetTextFontImage(csc.txtReady, fontDescItalI)
	SetTextSpacing(csc.txtReady, -30)
	SetTextMiddleScreenOffset(csc.txtReady, f, 0, p*7*h/16)
	SetTextColorAlpha(csc.txtReady, 0)
	
	
	
	if dispH
		//Most of these elements are resized in similar ways; just the x's are different
		SetSpriteSizeSquare(csc.sprBG, h*1.1)
		SetSpriteMiddleScreenY(csc.sprBG)
		SetSpriteSizeSquare(csc.sprBGB, h*1.1)
		SetSpriteMiddleScreenY(csc.sprBGB)
		
		SetTextY(csc.txtCrabName, 100)
		SetTextSize(csc.txtCrabName, 82)
		SetTextSpacing(csc.txtCrabName, -23)
		
		SetTextSize(csc.txtCrabDesc, 32)
		SetTextSpacing(csc.txtCrabStats, -10)
		IncTextY(csc.txtCrabDesc, -62)
		SetSpriteSize(csc.sprTxtBack, w/2, 220)
		SetSpriteDepth(csc.sprTxtBack, 50)
		IncSpriteY(csc.sprTxtBack, -70)
		
		SetSpriteSize(csc.sprLeftArrow, 100*gameScale#, 100*gameScale#)
		SetSpriteY(csc.sprLeftArrow, GetSpriteY(csc.sprTxtBack)+GetSpriteHeight(csc.sprLeftArrow)/2 - 90)
		
		SetSpriteSize(csc.sprRightArrow, 100*gameScale#, 100*gameScale#)
		SetSpriteY(csc.sprRightArrow, GetSpriteY(csc.sprTxtBack)+GetSpriteHeight(csc.sprRightArrow)/2 - 90)
				
		SetSpriteSize(csc.sprReady, 214, 80)
		SetSpriteY(csc.sprReady, h - GetSpriteHeight(csc.sprReady) - 20)
		
		SetTextSize(csc.txtReady, 60)
		SetTextSpacing(csc.txtReady, -21)
				
		if csc.player = 1
			//Player 1
			SetSpriteMiddleScreenXDispH1(csc.sprBG)
			SetSpriteMiddleScreenXDispH1(csc.sprBGB)
			SetSpriteMiddleScreenXDispH1(csc.sprTxtBack)
			SetSpriteMiddleScreenXDispH1(csc.sprReady)
			
			SetTextMiddleScreenXDispH1(csc.txtCrabName)
			SetTextMiddleScreenXDispH1(csc.txtCrabDesc)
			SetTextMiddleScreenXDispH1(csc.txtReady)
			
			SetSpriteMiddleScreenXDispH1(csc.sprLeftArrow)
			IncSpriteX(csc.sprLeftArrow, -w/4+86)
			
			SetSpriteMiddleScreenXDispH1(csc.sprRightArrow)
			IncSpriteX(csc.sprRightArrow, w/4-86)
					
		elseif csc.player = 2
			//Player 2
			
			SetSpriteMiddleScreenXDispH2(csc.sprBG)
			SetSpriteMiddleScreenXDispH2(csc.sprBGB)
			SetSpriteMiddleScreenXDispH2(csc.sprTxtBack)
			SetSpriteMiddleScreenXDispH2(csc.sprReady)
			
			SetTextMiddleScreenXDispH2(csc.txtCrabName)
			SetTextMiddleScreenXDispH2(csc.txtCrabDesc)
			SetTextMiddleScreenXDispH2(csc.txtReady)
			
			SetSpriteMiddleScreenXDispH2(csc.sprLeftArrow)
			IncSpriteX(csc.sprLeftArrow, -w/4+86)
			
			SetSpriteMiddleScreenXDispH2(csc.sprRightArrow)
			IncSpriteX(csc.sprRightArrow, w/4-86)
		
		endif
	endif
	
	
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
		
		SetSpriteVisible(csc.sprReady, 1)
		
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
	
	SetVisibleCharacterUI(1, csc)
	
endfunction

// Initialize the character select screen
// Does nothing right now, just a placeholder
function InitCharacterSelect()
	
	if spActive = 1 then spType = STORYMODE
	if spType = STORYMODE then spActive = 1
	
	crab1Alt = 0
	crab2Alt = 0
	
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
	
	SetFolder("/media")
	LoadSpriteExpress(SPR_MENU_BACK, "ui/mainmenu.png", 140, 140, 0, 0, 3)
	SetSpriteMiddleScreen(SPR_MENU_BACK)
	AddButton(SPR_MENU_BACK)
	if dispH then IncSpriteY(SPR_MENU_BACK, -200)
	
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
		
	if dispH
		p = 1
		f = 0
	endif
		
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
		good = 0
		while good = 0
			csc.crabSelected = csc.crabSelected + dir
			if GetSpriteGroup(csc.sprCrabs + csc.crabSelected) = 0 then good = 1 
		endwhile
		
		//Now that we've changed the selected crab, we're going to update the game screen:
		
		//FIRST: Loading in the high def crab images, if they aren't in already
		//Only unfortunate thing is that we can't reuse images from one side into another side; if memory becomes an issue, we'll do this
		if GetSpriteFrameCount(csc.sprCrabs + csc.crabSelected) <> 12 - 6*spActive
			SetFolder("/media/art")
			if spActive
				curChapter = csc.crabSelected+1
				SetCrabFromStringChap("", curChapter, 3)
			else
				crabRefType = Mod(csc.crabSelected, 6)+1
				crabRefAlt = (csc.crabSelected)/6
			endif
			for i = 1 to 6
				img = LoadImageResizedR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "select" + Str(i) + ".png", .8)
				if img <> 0
					AddSpriteAnimationFrame(csc.sprCrabs + csc.crabSelected, img)
					trashBag.insert(img)
				endif
			next i
		endif
		
		//SECOND: The text & crab animation
		if spActive = 0
			SetTextString(csc.txtCrabName, crabNames[csc.crabSelected+1])
			SetTextString(csc.txtCrabDesc, crabDescs[csc.crabSelected])
			
			space = 12
			//for i = Len(GetTextString(csc.txtCrabDesc)) to FindStringReverse(GetTextString(csc.txtCrabDesc), chr(10))-1 step -1
			//	SetTextCharY(csc.txtCrabDesc, i, GetTextSize(csc.txtCrabDesc)*3*p + space*p - GetTextSize(csc.txtCrabDesc)*f)
			//next i
			
			PlaySprite(csc.sprCrabs + csc.crabSelected, 18, 1, 7, 12)
			
		else
			curChapter = csc.crabSelected+1
			SetCrabFromStringChap("", curChapter, 3)
			SetTextString (csc.txtCrabName, chapNames[csc.crabSelected+1])
			SetTextString(csc.txtCrabDesc, crabPause1[crabRefType])
			SetTextString(TXT_CS_CRAB_STATS_2, "Chapter " + str(curChapter))
			SetTextString(TXT_CS_CRAB_NAME_2, chapterTitle[curChapter])
			SetTextString(TXT_CS_CRAB_DESC_2, chapterDesc[curChapter])
			SetSceneImages(0)
			
			//This loads in the crab's images, if they haven't already been loaded in
			/*if GetSpriteFrameCount(csc.sprCrabs + csc.crabSelected) <> 6
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
			endif*/
			
			SetSpriteVisible(csc.sprCrabs + csc.crabSelected, 1)
			PlaySprite(csc.sprCrabs + csc.crabSelected, 18, 1, 1, 6)
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
		//SnapbackToX(spr, glideMax - csc.glideFrame, glideMax, w/2 - GetSpriteWidth(spr)/2 - (cNum-num)*1000*p, -40*dir*p, 4, 5)	//Andy Version (very old)
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
			if csc.player = 2 then GlideToX(spr, w*3/4 + GetSpriteHeight(split)/4 - GetSpriteWidth(spr)/2 - (cNum-num)*500, 4)
			
			//SetSpriteX(csc.sprCrabs+csc.crabSelected, w*3/4 + GetSpriteHeight(split)/4 - GetSpriteWidth(csc.sprCrabs+csc.crabSelected)/2)
			
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
		
		SetArrowVisibility(csc)
		
	endif
	
endfunction

global lastChar = 0

function SetArrowVisibility(csc ref as CharacterSelectController)
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
		
		highA = GetHighAlt()
		endP = 1
		for i = 1 to 6
			if altUnlocked[i] = highA then endP = i 
		next i
		lastChar = endP + highA*6 - 1
		
		if csc.CrabSelected <> lastChar //6*(1+GetHighAlt())-1  //NUM_CRABS-1 +  //+ spActive*STORY_CS_BONUS
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
		crab1Type = Mod(csc.crabSelected, 6) + 1
		crab1Alt = csc.crabSelected/6
	else
		crab2Type = Mod(csc.crabSelected, 6) + 1
		crab2Alt = csc.crabSelected/6
	endif
	
	//SetSpriteVisible(csc.sprReady, 0)
	SetSpriteVisible(csc.sprLeftArrow, 0)
	SetSpriteVisible(csc.sprRightArrow, 0)
	
	if spType <> STORYMODE then PlayTweenSprite(tweenSprFadeOut, csc.sprReady, 0)
	if spType <> STORYMODE then PlayTweenText(tweenTxtFadeIn, csc.txtReady, 0)
	if spType <> STORYMODE then PlaySprite(csc.sprReady, 12, 1, 1, 6)
	
	
	//Text gets bigger to show that a selection has been locked in
	if csc.crabSelected <> 1 then SetTextSize(csc.txtCrabName, GetTextSize(csc.txtCrabName) + 10)
	
	csc.ready = 1
	
endfunction

function UnselectCrab(csc ref as CharacterSelectController)
	
	SetArrowVisibility(csc)
	
	StopTweenSprite(tweenSprFadeOut, csc.sprReady)
	StopTweenText(tweenTxtFadeIn, csc.txtReady)
	SetSpriteColorAlpha(csc.sprReady, 255)
	SetTextColorAlpha(csc.txtReady, 0)
	
	PlaySprite(csc.sprReady, 9+csc.player, 1, 7+8*(csc.player-1), 14+8*(csc.player-1))
	
	//Text gets smaller again
	if csc.crabSelected <> 1 then SetTextSize(csc.txtCrabName, GetTextSize(csc.txtCrabName) - 10)
	
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
				if ButtonMultitouchEnabled(spr) and GetSpriteVisible(spr) and GetSpriteGroup(spr) = 0
					for j = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
						StopTweenSprite(csc.sprCrabs + j, csc.sprCrabs + j)
					next j
					SetVisibleCharacterUI(2, csc)
					csc.crabSelected = i-1
					PlaySoundR(arrowS, 40)
					ChangeCrabs(csc, 1, 1)
					csc.stage = 2
					if csc.player = 1 then TurnOffSelect()
					if csc.player = 2 then TurnOffSelect2()
					i = NUM_CRABS + spActive*STORY_CS_BONUS
					ClearMultiTouch()
					i = NUM_CRABS + spActive*STORY_CS_BONUS
				endif
			next i
		
		//The 1-crab view
		elseif csc.stage = 2
			// Ready button
			if (ButtonMultitouchEnabled(csc.sprReady) or (inputSelect and csc.player = 1 and selectTarget = 0 and GetSpriteVisibleR(SPR_SCENE1) = 0) or (inputSelect2 and csc.player = 2 and selectTarget2 = 0 and GetSpriteVisibleR(SPR_SCENE2) = 0)) and GetSpriteVisible(csc.sprReady) 
				PlaySoundR(chooseS, 100)
				SelectCrab(csc)
				if csc.player = 1 then TurnOffSelect()
				if csc.player = 2 then TurnOffSelect2()
				
				//PingColor(GetSpriteMiddleX(csc.sprCrabs+csc.crabSelected), GetSpriteMiddleY(csc.sprCrabs+csc.crabSelected), 400, 255, 100, 100, 50)
			// Scroll left
			elseif (ButtonMultitouchEnabled(csc.sprLeftArrow) or (GetMultitouchPressedTopRight() and csc.player = 2 and dispH = 0) or (GetMultitouchPressedBottomLeft() and csc.player = 1 and dispH = 0)) and csc.crabSelected > 0
				PlaySoundR(arrowS, 100)
				ChangeCrabs(csc, -1, 1)
			// Scroll right
			elseif (ButtonMultitouchEnabled(csc.sprRightArrow) or (GetMultitouchPressedTopLeft() and csc.player = 2 and dispH = 0) or (GetMultitouchPressedBottomRight() and csc.player = 1 and dispH = 0)) and ((csc.crabSelected < lastChar and spType <> STORYMODE) or (csc.crabSelected < Min(clearedChapter, finalChapter-1) and spType = STORYMODE))
				PlaySoundR(arrowS, 100)
				ChangeCrabs(csc, 1, 1)
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
			
			//for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
				//spr = csc.sprCrabs + i
			if (ButtonMultitouchEnabled(csc.crabSelected+csc.sprCrabs) or (csc.player = 1 and (inputAttack1 or inputSpecial1)) or (csc.player = 2 and (inputAttack2 or inputSpecial2))) and spActive = 0 and csc.glideFrame < 5
				SetVisibleCharacterUI(1, csc)
				for j = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS
					PlayTweenSprite(csc.sprCrabs + j, csc.sprCrabs + j, 0.003*j)
					//if j < unlockedCrab then SetSpriteColorAlpha(csc.sprCrabs + j, 255)
					SetSpriteColorAlpha(csc.sprCrabs + j, 255)
				next j
				PlaySoundR(arrowS, 100)
				csc.stage = 1
				if csc.player = 1 then TurnOffSelect()
				if csc.player = 2 then TurnOffSelect2()
				//i = NUM_CRABS + spActive*STORY_CS_BONUS
			endif
			//next i
		endif
	endif
		
	//Slowly lighting the backgrounds
	SetSpriteColorAlpha(csc.sprBG, 205+abs(50*cos(90*csc.player + 80*GetMusicPositionOGG(characterMusic))))
	IncSpriteAngle(csc.sprBGB, 1.8*fpsr#)
	if spActive then IncSpriteAngle(SPR_CS_BG_2, -0.8*fpsr#)
	//IncSpriteAngle(csc.sprBGB, 6*fpsr#)
	
	// Continue an existing glide
	if csc.glideFrame > 0
		if csc.glideFrame < (24/fpsr#)-1
			ChangeCrabs(csc, csc.glideDirection, 0)
		else
			dec csc.glideFrame
		endif
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
	
	//Unselects the crab if the screen is touched again
	if csc1.ready = 1 and ((GetMultitouchPressedBottom() and deviceType = MOBILE) or (deviceType = DESKTOP and (inputSelect or inputExit or inputAttack1 or inputSpecial1)))
		UnselectCrab(csc1)
		ClearMultiTouch()
		inputSelect = 0
		inputExit = 0
		inputAttack1 = 0
		inputSpecial1 = 0
		//TurnOffSelect()
	endif
	if csc2.ready = 1 and ((GetMultitouchPressedTop() and deviceType = MOBILE) or (deviceType = DESKTOP and (inputSelect2 or inputExit2 or inputAttack2 or inputSpecial2)))
		UnselectCrab(csc2)
		ClearMultiTouch()
		inputSelect2 = 0
		inputExit2 = 0
		inputAttack2 = 0
		inputSpecial2 = 0
		//TurnOffSelect2()
	endif
	
	DoCharacterSelectController(csc1)
	if spActive = 0 then DoCharacterSelectController(csc2)
	
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
			if dispH then SetTextCharY(txt, GetTextLength(txt)-i, 28.0 - 5.0*abs(8*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
		next i		
	endif
	
	if spActive = 0
		if csc2.ready = 0 and doJit
			txt = csc2.txtCrabName
			for i = 0 to GetTextLength(txt)
				SetTextCharY(txt, i, -102 + 102*dispH -1 * (jitterNum + csc2.glideFrame) + Random(0, (jitterNum + csc2.glideFrame)*2))
				if csc2.stage = 1 and i > 12 then SetTextCharY(csc2.txtCrabName, i, -102 + 102*dispH -1 * (jitterNum + csc2.glideFrame) + Random(0, (jitterNum + csc2.glideFrame)*2) - (1-dispH*2)*GetTextSize(txt))
				SetTextCharAngle(txt, i, 180*(1-dispH) - 1*(jitterNum + csc2.glideFrame) + Random(0, jitterNum + csc2.glideFrame)*2)
			next i
		else
			txt = csc2.txtReady
			for i = 0 to GetTextLength(txt)
				SetTextCharY(txt, GetTextLength(txt)-i, -140.0 + 8.0*abs(8*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
				if dispH then SetTextCharY(txt, GetTextLength(txt)-i, 28.0 - 5.0*abs(8*cos(GetMusicPositionOGG(characterMusic)*200+i*10 )))	//Code from SnowTunes
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

