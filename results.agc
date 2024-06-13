#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global resultsStateInitialized as integer = 0
global resultsWinner as integer = 0

global rc1 as ResultsController
global rc2 as ResultsController

global winText as string[27]
global loseText as string[27]

global FRAMES_WIN_MSG# = 17
global FRAMES_SHOW_UI# = 185

// Controller that holds state data for each screen
type ResultsController
	
	// Player ID (1 or 2)
	player as integer
	
	// Game state
	isWinner as integer // 0 if false, 1 if true
	frame as float // frame data for animations
	
	// Sprites
	txtCrabMsg as integer
	txtWinMsg as integer
	sprCrabWin as integer
	sprCrabLose as integer
	
	// Tweens
	twnWinMsg as integer
	twnMyCrab as integer
	
endtype

function InitResultsController(rc ref as ResultsController)
	
	p as integer, f as integer
	if rc.player = 1 then p = 1 else p = -1 // makes the position calculations easier
	if rc.player = 1 then f = 0 else f = 1 // makes the flip calculations easier
	if spType = AIBATTLE then f = 0
	if dispH
		p = 1
		f = 0
	endif
	// Determine which crab type won and lost
	if resultsWinner = 1
		winnerCrab = crab1Type
		winnerAlt = crab1Alt
		winnerEvil = crab1Evil
		loserCrab = crab2Type
		loserAlt = crab2Alt
		loserEvil = crab2Evil
	else
		winnerCrab = crab2Type
		winnerAlt = crab2Alt
		winnerEvil = crab2Evil
		loserCrab = crab1Type
		loserAlt = crab1Alt
		loserEvil = crab1Evil
	endif
	
	rc.frame = 0
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	if rc.isWinner
		winID = winnerCrab+winnerAlt*6 - 1
		if winnerEvil and winnerCrab = 1 and winnerAlt = 0 then winID = 24
		if winnerEvil and winnerCrab = 1 and winnerAlt = 3 then winID = 25
		if winnerEvil and winnerCrab = 4 and winnerAlt = 3 then winID = 26
		CreateText(rc.txtCrabMsg, winText[winID])
	else
		loseID = loserCrab+loserAlt*6 - 1
		if loserEvil and loserCrab = 1 and loserAlt = 0 then loseID = 24
		if loserEvil and loserCrab = 1 and loserAlt = 3 then loseID = 25
		if loserEvil and loserCrab = 4 and loserAlt = 3 then loseID = 26
		CreateText(rc.txtCrabMsg, loseText[loseID])
	endif
	SetTextSize(rc.txtCrabMsg, 48)
	SetTextAngle(rc.txtCrabMsg, f*180)
	SetTextFontImage(rc.txtCrabMsg, fontCrabI)
	SetTextSpacing(rc.txtCrabMsg, -15)
	SetTextMiddleScreenOffset(rc.txtCrabMsg, f, 0, p*190)
	SetTextAlignment(rc.txtCrabMsg, 1)
	SetTextVisible(rc.txtCrabMsg, 0)
	
	winMsg as string
	if rc.isWinner
		winMsg = "Crampion!"
	else
		winMsg = "Loser XD"
	endif
	CreateText(rc.txtWinMsg, winMsg)
	SetTextSize(rc.txtWinMsg, 120)
	SetTextAngle(rc.txtWinMsg, f*180)
	SetTextFontImage(rc.txtWinMsg, fontCrabI)
	SetTextSpacing(rc.txtWinMsg, -28)
	SetTextMiddleScreenOffset(rc.txtWinMsg, f, 0, p*400)
	SetTextAlignment(rc.txtWinMsg, 1)
	SetTextColorAlpha(rc.txtWinMsg, 0)
	
	CreateTweenText(rc.twnWinMsg, 1.5)
	SetTweenTextSize(rc.twnWinMsg, 120, 96, TweenSmooth2())
	SetTweenTextSpacing(rc.twnWinMsg, -28, -22, TweenSmooth2())
	SetTweenTextY(rc.twnWinMsg, GetTextY(rc.txtWinMsg), GetTextY(rc.txtWinMsg) + p*325, TweenSmooth2())
	
	evilMod$ = ""
	if loserEvil then evilMod$ = "2"
	if loserCrab = 6 and loserAlt = 3 then evilMod$ = ""
	sprCrabLose$ = "/media/art/crab" + Str(loserCrab) + AltStr(loserAlt) + evilMod$ + "rLose.png"
	if GetFileExists(sprCrabLose$)
		LoadSprite(rc.sprCrabLose, sprCrabLose$)
	else
		CreateSprite(rc.sprCrabLose, 0)
	endif
	SetSpriteSize(rc.sprCrabLose, 195, 195)
	SetSpriteMiddleScreenOffset(rc.sprCrabLose, p*-1*w/4, p*375)
	SetSpriteFlip(rc.sprCrabLose, f, f)
	SetSpriteVisible(rc.sprCrabLose, 0)
	
	evilMod$ = ""
	if winnerEvil then evilMod$ = "2"
	if winnerCrab = 6 and winnerAlt = 3 then evilMod$ = ""
	sprCrabWin$ = "/media/art/crab" + Str(winnerCrab) + AltStr(winnerAlt) + evilMod$ + "rWin.png"
	if GetFileExists(sprCrabWin$)
		LoadSprite(rc.sprCrabWin, sprCrabWin$)
	else
		CreateSprite(rc.sprCrabWin, 0)
	endif
	SetSpriteSize(rc.sprCrabWin, 425, 425)
	SetSpriteMiddleScreenOffset(rc.sprCrabWin, p*w/8, p*450)
	SetSpriteFlip(rc.sprCrabWin, f, f)
	SetSpriteVisible(rc.sprCrabWin, 0)
	
	//Making the crab that isn't yours a bit darker
	if (rc.player = 1 and resultsWinner = 1) or (rc.player = 2 and resultsWinner = 2)
		SetSpriteColor(rc.sprCrabLose, 160, 160, 160, 255)
		rc.twnMyCrab = rc.sprCrabWin
	else
		SetSpriteColor(rc.sprCrabWin, 160, 160, 160, 255)
		rc.twnMyCrab = rc.sprCrabLose
	endif
	
	CreateTweenSprite(rc.twnMyCrab, 1)
	SetTweenSpriteSizeX(rc.twnMyCrab, GetSpriteWidth(rc.twnMyCrab)/1.4, GetSpriteWidth(rc.twnMyCrab), TweenOvershoot())
	SetTweenSpriteSizeY(rc.twnMyCrab, GetSpriteHeight(rc.twnMyCrab)/1.4, GetSpriteHeight(rc.twnMyCrab), TweenOvershoot())
	SetTweenSpriteX(rc.twnMyCrab, GetSpriteMiddleX(rc.twnMyCrab)-(GetSpriteWidth(rc.twnMyCrab)/1.4)/2, GetSpriteX(rc.twnMyCrab), TweenOvershoot())
	SetTweenSpriteY(rc.twnMyCrab, GetSpriteMiddleY(rc.twnMyCrab)-(GetSpriteHeight(rc.twnMyCrab)/1.4)/2, GetSpriteY(rc.twnMyCrab), TweenOvershoot())
	
	// Kick off the controller's tweens
	PlayTweenText(rc.twnWinMsg, rc.txtWinMsg, .8)
	
	cenOff = 30
	if dispH 
		
		SetTextY(rc.txtWinMsg, h/2-60)
		
		SetTweenTextSize(rc.twnWinMsg, 120, 96, TweenSmooth2())
		SetTweenTextSpacing(rc.twnWinMsg, -28, -22, TweenSmooth2())
		SetTweenTextY(rc.twnWinMsg, GetTextY(rc.txtWinMsg), GetTextY(rc.txtWinMsg) + 160, TweenSmooth2())
		
		SetTextY(rc.txtCrabMsg, 40)
		SetTextSize(rc.txtCrabMsg, 40)
		SetTextSpacing(rc.txtCrabMsg, -12)
			
		SetSpriteColor(rc.sprCrabLose, 230, 230, 230, 255)
		SetSpriteColor(rc.sprCrabWin, 255, 255, 255, 255)
		
		if rc.player = 1
			SetTextMiddleScreenXDispH1(rc.txtWinMsg)
			IncTextX(rc.txtWinMsg, cenOff)
			SetTextMiddleScreenXDispH1(rc.txtCrabMsg)
			IncTextX(rc.txtCrabMsg, cenOff)
			
			SetSpriteSizeSquare(rc.sprCrabWin, 325)
			SetSpriteSizeSquare(rc.sprCrabLose, 325)
			
			SetSpriteY(rc.sprCrabWin, h/2-210)
			SetSpriteY(rc.sprCrabLose, h/2-210)
			if resultsWinner = 1
				SetSpriteMiddleScreenXDispH1(rc.sprCrabWin)
				IncSpriteX(rc.sprCrabWin, cenOff)
				
				SetSpriteMiddleScreenXDispH2(rc.sprCrabLose)
				IncSpriteX(rc.sprCrabLose, -cenOff)
			else
				SetSpriteMiddleScreenXDispH2(rc.sprCrabWin)
				IncSpriteX(rc.sprCrabWin, -cenOff)
				
				SetSpriteMiddleScreenXDispH1(rc.sprCrabLose)
				IncSpriteX(rc.sprCrabLose, cenOff)
			endif
			
			//SetSpriteMiddleScreenOffset(rc.sprCrabWin, 50, 40)
			//SetSpriteMiddleScreenOffset(rc.sprCrabLose, -60, -100)
		else
			SetTextMiddleScreenXDispH2(rc.txtWinMsg)
			IncTextX(rc.txtWinMsg, -cenOff)
			SetTextMiddleScreenXDispH2(rc.txtCrabMsg)
			IncTextX(rc.txtCrabMsg, -cenOff)
			
			//Dumping all of the P2 stuff out
			IncSpriteX(rc.sprCrabWin, 9999)
			IncSpriteX(rc.sprCrabLose, 9999)
		endif
		
		DeleteTween(rc.twnMyCrab)
		CreateTweenSprite(rc.sprCrabWin, 1)
		SetTweenSpriteSizeX(rc.sprCrabWin, GetSpriteWidth(rc.sprCrabWin)/1.4, GetSpriteWidth(rc.sprCrabWin), TweenOvershoot())
		SetTweenSpriteSizeY(rc.sprCrabWin, GetSpriteHeight(rc.sprCrabWin)/1.4, GetSpriteHeight(rc.sprCrabWin), TweenOvershoot())
		SetTweenSpriteX(rc.sprCrabWin, GetSpriteMiddleX(rc.sprCrabWin)-(GetSpriteWidth(rc.sprCrabWin)/1.4)/2, GetSpriteX(rc.sprCrabWin), TweenOvershoot())
		SetTweenSpriteY(rc.sprCrabWin, GetSpriteMiddleY(rc.sprCrabWin)-(GetSpriteHeight(rc.sprCrabWin)/1.4)/2, GetSpriteY(rc.sprCrabWin), TweenOvershoot())
		
		CreateTweenSprite(rc.sprCrabLose, 1)
		SetTweenSpriteSizeX(rc.sprCrabLose, GetSpriteWidth(rc.sprCrabLose)/1.4, GetSpriteWidth(rc.sprCrabLose), TweenOvershoot())
		SetTweenSpriteSizeY(rc.sprCrabLose, GetSpriteHeight(rc.sprCrabLose)/1.4, GetSpriteHeight(rc.sprCrabLose), TweenOvershoot())
		SetTweenSpriteX(rc.sprCrabLose, GetSpriteMiddleX(rc.sprCrabLose)-(GetSpriteWidth(rc.sprCrabLose)/1.4)/2, GetSpriteX(rc.sprCrabLose), TweenOvershoot())
		SetTweenSpriteY(rc.sprCrabLose, GetSpriteMiddleY(rc.sprCrabLose)-(GetSpriteHeight(rc.sprCrabLose)/1.4)/2, GetSpriteY(rc.sprCrabLose), TweenOvershoot())
		
	endif
	
endfunction

// Initialize the results screen
function InitResults()
	
	//PlayMusicOGGSP(resultsMusic, 1)
	
	// Initialize the win/loss text
	// AGK doesn't allow string concatenation in the global namespace (?!)
	winText[0] = "Space Crab once again has earned his" + chr(10) + "place as the one and only SPACE CRAB!"
	winText[1] = "Ladder Wizard, calm and calculated," + chr(10) + "smote his combatant! Alakazam!"
	winText[2] = "Top Crab's dizzying, dazzling display" + chr(10) + "ran circles around the competition!"
	winText[3] = "Rave Crab moshed and never let up," + chr(10) + "and barely noticed that he won!"
	winText[4] = "Chrono Crab bent time and the results" + chr(10) + "of the battle to his favor!"
	winText[5] = "As swift as a nighttime breeze, Ninja" + chr(10) + "Crab has downed his worthless foe."
	winText[6] = "Mad Crab is angry about this" + chr(10) + "win, as he should be."
	winText[7] = "Truly, was there ever any doubt?" + chr(10) + "Of COURSE King Crab is the winner!"
	winText[8] = "Taxi Crab collects his cab fare," + chr(10) + "as well as his win!"
	winText[9] = "Number One! Number One! This" + chr(10) + "Fan Crab is NUMBER ONE!"
	winText[10] = "Inianda Jeff has secured the" + chr(10) + "treasure, and a win, too!"
	winText[11] = "Team Player has secured" + chr(10) + "his solo victory!"
	winText[12] = "The gavel of justice declares" + chr(10) + "Al Legal the winner!"
	winText[13] = "Crabacus' win was calculated" + chr(10) + "from the very start!"
	winText[14] = "Space Barc finally reached that" + chr(10) + "itchy spot behind his ear!"
	winText[15] = "Hawaiian Crab has packed his" + chr(10) + "bags for the winner's circle!"
	winText[16] = "Rock Lobster's win was as" + chr(10) + "awesome as his hit single!"
	winText[17] = "Cranime's been renewed for" + chr(10) + "another two seasons! Sugoi!"
	winText[18] = "Future Crab has earned the right" + chr(10) + "to stay in this time- for now..."
	winText[19] = "Crabyss Knight has slain his evil" + chr(10) + "opponent, bringing peace to the galaxy!"
	winText[20] = "Rockin' up CTV, it's Sk8r Crab!" + chr(10) + "Now he's a superstar!"
	winText[21] = "Holy Crab ascends to the winner's" + chr(10) + "circle, purifing all who witness it!"
	winText[22] = "Cake slices for everyone at" + chr(10) + "Crab Cake's victory party!"
	winText[23] = "The wrath of the transformer!" + chr(10) + "Chimera Crab is victorious!"
	winText[24] = "Crixel took his bit of the lead" + chr(10) + "and crushed the competition!"
	winText[25] = "Beta Crab is as cheerful as ever" + chr(10) + "ever about this win."
	winText[26] = "Devil Crab escaped the underworld" + chr(10) + "and is coming straight for YOU!"
	
	loseText[0] = "Space Crab's orbital ordnance was" + chr(10) + "overpowered by a mightier opponent..."
	loseText[1] = "Ladder Wizard was vexed, hexed," + chr(10) + "and wrecked in this battle..."
	loseText[2] = "Top Crab was toppled by" + chr(10) + "a far more balanced opponent..."
	loseText[3] = "Rave Crab partied too hard" + chr(10) + "and paid the price..."
	loseText[4] = "Chrono Crab must accept that" + chr(10) + "time has passed him by..."
	loseText[5] = "Ninja Crab has been sent back" + chr(10) + "to the shadows in shame..."
	loseText[6] = "Mad Crab won't let his anger" + chr(10) + "show for such an embarrasing event..."
	loseText[7] = "Greed has overtaken King Crab," + chr(10) + "stuck in the grasp of Midas' touch..."
	loseText[8] = "A broken down car is nothing" + chr(10) + "compared to his broken down spirit..."
	loseText[9] = "#1 Fan Crab can no longer show" + chr(10) + "his face in the Cosmic Corner Store..."
	loseText[10] = "In the search for treasure and" + chr(10) + "victory, Inianda Jeff is empty handed..."
	loseText[11] = "Team Player needed team" + chr(10) + "support after all..."
	loseText[12] = "Al Legal should have spent" + chr(10) + "more time building a case..."
	loseText[13] = "Crabacus couldn't calculate" + chr(10) + "a win this time..."
	loseText[14] = "Space Barc has barked his" + chr(10) + "last bark, for now..."
	loseText[15] = "Another vacation ruined." + chr(10) + "It's all your fault."
	loseText[16] = "Equipment issues ruined Rock" + chr(10) + "Lobster's big show..."
	loseText[17] = "Cranime should have stayed" + chr(10) + "as just a manga..."
	loseText[18] = "This lonely, bitter old man will" + chr(10) + "remain this way for the rest of time..."
	loseText[19] = "The once proud knight has" + chr(10) + "discarded his gear, and his legacy..."
	loseText[20] = "Ouch! That's gotta hurt..." + chr(10) + "At least you were wearing protection."
	loseText[21] = "Holy Crab subcummed to the" + chr(10) + "devil on their sholder..."
	loseText[22] = "Don't cry over spilled cake." + chr(10) + "Crab Cake will do that for you."
	loseText[23] = "Chimera Crab is just a puppeted" + chr(10) + "freak, after all..."
	loseText[24] = "Crixel torn to bits" + chr(10) + "over this harsh loss..."
	loseText[25] = "Beta Crab is feeling awful about" + chr(10) + "the loss - I'm sure of it."
	loseText[26] = "Devil Crab is locked away, until" + chr(10) + "another fool makes a deal with him..."
	
	// Determine the winner
	if crab1Deaths = 3
		resultsWinner = 2
		rc1.isWinner = 0
		rc2.isWinner = 1
	else
		resultsWinner = 1
		rc1.isWinner = 1
		rc2.isWinner = 0
	endif
		
	// Init controllers
	rc1.player = 1
	rc1.txtCrabMsg = TXT_R_CRAB_MSG_1
	rc1.txtWinMsg = TXT_R_WIN_MSG_1
	rc1.sprCrabWin = SPR_R_CRAB_WIN_1
	rc1.sprCrabLose = SPR_R_CRAB_LOSE_1
	rc1.twnWinMsg = TWN_R_WIN_MSG_1
	
	rc2.player = 2
	rc2.txtCrabMsg = TXT_R_CRAB_MSG_2
	rc2.txtWinMsg = TXT_R_WIN_MSG_2
	rc2.sprCrabWin = SPR_R_CRAB_WIN_2
	rc2.sprCrabLose = SPR_R_CRAB_LOSE_2
	rc2.twnWinMsg = TWN_R_WIN_MSG_2
	
	InitResultsController(rc1)
	InitResultsController(rc2)
	
	// Create mid-screen buttons
	SetFolder("/media/ui")
	LoadSprite(SPR_R_REMATCH, "restart.png")
	SetSpriteSize(SPR_R_REMATCH, 210, 210)
	SetSpriteMiddleScreen(SPR_R_REMATCH)
	SetSpriteVisible(SPR_R_REMATCH, 0)
	
	LoadSprite(SPR_R_CRAB_SELECT, "crabselect.png")
	SetSpriteSize(SPR_R_CRAB_SELECT, 175, 175)
	SetSpriteMiddleScreenOffset(SPR_R_CRAB_SELECT, -1*w/3, 0)
	SetSpriteVisible(SPR_R_CRAB_SELECT, 0)
	
	LoadSprite(SPR_R_MAIN_MENU, "mainmenu.png")
	SetSpriteSize(SPR_R_MAIN_MENU, 160, 160)
	SetSpriteMiddleScreenOffset(SPR_R_MAIN_MENU, w/3, 0)
	SetSpriteVisible(SPR_R_MAIN_MENU, 0)
	
	if dispH
		SetSpriteVisible(split, 0)
		SetSpriteScale(SPR_R_REMATCH, .7, .7)
		SetSpriteScale(SPR_R_CRAB_SELECT, .7, .7)
		SetSpriteScale(SPR_R_MAIN_MENU, .7, .7)
		
		SetSpriteMiddleScreen(SPR_R_REMATCH)
		SetSpriteMiddleScreenOffset(SPR_R_CRAB_SELECT, -1*w/7, 0)
		SetSpriteMiddleScreenOffset(SPR_R_MAIN_MENU, w/7, 0)
		
		IncSpriteY(SPR_R_REMATCH, 250)
		IncSpriteY(SPR_R_CRAB_SELECT, 250)
		IncSpriteY(SPR_R_MAIN_MENU, 250)
	endif
	
	AddButton(SPR_R_REMATCH)
	AddButton(SPR_R_CRAB_SELECT)
	AddButton(SPR_R_MAIN_MENU)
	
	// Background
	SetFolder("/media/envi")
	LoadSprite(SPR_R_BACKGROUND, "bg3.png")
	SetSpriteSize(SPR_R_BACKGROUND, h, h)
	if dispH then SetSpriteSize(SPR_R_BACKGROUND, w, w)
	SetSpriteDepth(SPR_R_BACKGROUND, 1000)
	SetSpriteMiddleScreen(SPR_R_BACKGROUND)
	SetFolder("/media/art")
	
	if GetMusicPlayingOGGSP(resultsMusic) = 0 then PlayMusicOGGSP(resultsMusic, 1)
	
	FRAMES_WIN_MSG# = 20 //* fpsr#
	FRAMES_SHOW_UI# = 100 //*60/75.0 * fpsr#
	
	resultsStateInitialized = 1
	
endfunction


// Results loop for a single screen
function DoResultsController(rc ref as ResultsController)
	
	// Win message fade in
	// Max alpha = 255
	if rc.frame <= FRAMES_WIN_MSG#
		SetTextColorAlpha(rc.txtWinMsg, rc.frame * (255 / FRAMES_WIN_MSG#)) 
		if GetSpriteExists(coverS) then SetSpriteColorAlpha(coverS, 255 - rc.frame * (255 / FRAMES_WIN_MSG#))
	endif
	//print(rc.frame)
	
	// Make the rest of the UI appear in sync with the song
	if GetMusicPositionOGG(resultsMusic) >= 3.117 and GetSpriteVisible(rc.sprCrabWin) = 0 //rc.frame => FRAMES_SHOW_UI# 
		SetSpriteVisible(rc.sprCrabWin, 1)
		SetSpriteVisible(rc.sprCrabLose, 1)
		SetTextVisible(rc.txtCrabMsg, 1)
		if dispH = 0
			PlayTweenSprite(rc.twnMyCrab, rc.twnMyCrab, 0)
		elseif rc.player = 1
			PlayTweenSprite(rc.sprCrabWin, rc.sprCrabWin, 0)
			PlayTweenSprite(rc.sprCrabLose, rc.sprCrabLose, 0)
		endif
		PlaySoundR(chooseS, 40)
		if GetSpriteExists(coverS) then DeleteSprite(coverS)
	endif
		
	// Increment the frame
	rc.frame = rc.frame + fpsr#

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
	
	DoResultsController(rc1)
	DoResultsController(rc2)
	
	// Show and animate mid-screen buttons
	if GetMusicPositionOGG(resultsMusic) >= 3.117 and GetSpriteVisible(SPR_R_MAIN_MENU) = 0
		SetSpriteVisible(SPR_R_MAIN_MENU, 1)
		SetSpriteVisible(SPR_R_CRAB_SELECT, 1)
		SetSpriteVisible(SPR_R_REMATCH, 1)
	endif
	if GetMusicPositionOGG(resultsMusic) >= 3.117
		IncSpriteAngle(SPR_R_MAIN_MENU, -fpsr#)
		IncSpriteAngle(SPR_R_CRAB_SELECT, -fpsr#)
		IncSpriteAngle(SPR_R_REMATCH, fpsr#)
	endif
	
	// Check mid-screen buttons for activity
	if ButtonMultitouchEnabled(SPR_R_REMATCH)
		state = GAME
		TransitionStart(Random(1,lastTranType))
	elseif ButtonMultitouchEnabled(SPR_R_CRAB_SELECT)
		state = CHARACTER_SELECT
		TransitionStart(Random(1,lastTranType))
	elseif ButtonMultitouchEnabled(SPR_R_MAIN_MENU)
		state = START
		TransitionStart(Random(1,lastTranType))
	endif
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> RESULTS
		ExitResults()
	endif
	
endfunction state

// Dispose of assets from a single controller
function CleanupResultsController(rc ref as ResultsController)
	
	DeleteText(rc.txtCrabMsg)
	DeleteText(rc.txtWinMsg)
	DeleteSprite(rc.sprCrabWin)
	DeleteSprite(rc.sprCrabLose)
	DeleteTween(rc.twnWinMsg)
	DeleteTween(rc.twnMyCrab)
	
	if dispH
		DeleteTween(rc.sprCrabWin)
		DeleteTween(rc.sprCrabLose)
	else
		DeleteTween(rc.twnMyCrab)
	endif
	
endfunction


// Cleanup upon leaving this state
function ExitResults()
	
	if GetMusicPlayingOggSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
	CleanupResultsController(rc1)
	CleanupResultsController(rc2)
	
	DeleteSprite(SPR_R_REMATCH)
	DeleteSprite(SPR_R_CRAB_SELECT)
	DeleteSprite(SPR_R_MAIN_MENU)
	DeleteSprite(SPR_R_BACKGROUND)
	
	resultsStateInitialized = 0
	
endfunction
