#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global resultsStateInitialized as integer = 0
global resultsWinner as integer = 0

global rc1 as ResultsController
global rc2 as ResultsController

global winText as string[NUM_CRABS]
global loseText as string[NUM_CRABS]

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
	
	// Determine which crab type won and lost
	if resultsWinner = 1
		winnerCrab = crab1Type
		loserCrab = crab2Type
	else
		winnerCrab = crab2Type
		loserCrab = crab1Type
	endif
	
	rc.frame = 0
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	if rc.isWinner
		CreateText(rc.txtCrabMsg, winText[winnerCrab - 1])
	else
		CreateText(rc.txtCrabMsg, loseText[loserCrab - 1])
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
		winMsg = "Winning boy!"
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
	
	sprCrabLose$ = "/media/art/crab" + Str(loserCrab) + "rLose.png"
	LoadSprite(rc.sprCrabLose, sprCrabLose$)
	SetSpriteSize(rc.sprCrabLose, 195, 195)
	SetSpriteMiddleScreenOffset(rc.sprCrabLose, p*-1*w/4, p*375)
	SetSpriteFlip(rc.sprCrabLose, f, f)
	SetSpriteVisible(rc.sprCrabLose, 0)
	
	sprCrabWin$ = "/media/art/crab" + Str(winnerCrab) + "rWin.png"
	LoadSprite(rc.sprCrabWin, sprCrabWin$)
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
	winText[5] = "As swift as a nightime breeze, Ninja" + chr(10) + "Crab has downed his worthless foe."
	
	loseText[0] = "Space Crab's orbital ordnance was" + chr(10) + "overpowered by a mightier opponent..."
	loseText[1] = "Ladder Wizard was vexed, hexed," + chr(10) + "and wrecked in this battle..."
	loseText[2] = "Top Crab was toppled by" + chr(10) + "a far more balanced opponent..."
	loseText[3] = "Rave Crab partied too hard" + chr(10) + "and paid the price..."
	loseText[4] = "Chrono Crab must accept that" + chr(10) + "time has passed him by..."
	loseText[5] = "Ninja Crab has been sent back" + chr(10) + "to the shadows in shame..."
	
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
	
	AddButton(SPR_R_REMATCH)
	AddButton(SPR_R_CRAB_SELECT)
	AddButton(SPR_R_MAIN_MENU)
	
	// Background
	SetFolder("/media/envi")
	LoadSprite(SPR_R_BACKGROUND, "bg3.png")
	SetSpriteSize(SPR_R_BACKGROUND, w, h)
	SetSpriteDepth(SPR_R_BACKGROUND, 1000)
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
		SetSpriteColorAlpha(coverS, 255 - rc.frame * (255 / FRAMES_WIN_MSG#))
	endif
	print(rc.frame)
	
	// Make the rest of the UI appear in sync with the song
	if GetMusicPositionOGG(resultsMusic) >= 3.117 and GetSpriteVisible(rc.sprCrabWin) = 0 //rc.frame => FRAMES_SHOW_UI# 
		SetSpriteVisible(rc.sprCrabWin, 1)
		SetSpriteVisible(rc.sprCrabLose, 1)
		SetTextVisible(rc.txtCrabMsg, 1)
		PlayTweenSprite(rc.twnMyCrab, rc.twnMyCrab, 0)
		PlaySoundR(chooseS, volumeSE)
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
		SetSpriteAngle(SPR_R_MAIN_MENU, GetSpriteAngle(SPR_R_MAIN_MENU) - fpsr#)
		SetSpriteAngle(SPR_R_CRAB_SELECT, GetSpriteAngle(SPR_R_CRAB_SELECT) - fpsr#)
		SetSpriteAngle(SPR_R_REMATCH, GetSpriteAngle(SPR_R_REMATCH) + fpsr#)
	endif
	
	// Check mid-screen buttons for activity
	if Button(SPR_R_REMATCH)
		state = GAME
		TransitionStart(Random(1,2))
	elseif Button(SPR_R_CRAB_SELECT)
		state = CHARACTER_SELECT
		TransitionStart(Random(1,2))
	elseif Button(SPR_R_MAIN_MENU)
		state = START
		TransitionStart(Random(1,2))
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
