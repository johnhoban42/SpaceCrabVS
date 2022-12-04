#include "constants.agc"
#include "myLib.agc"


// Whether this state has been initialized
global resultsStateInitialized as integer = 0
global resultsWinner as integer = 0

global rc1 as ResultsController
global rc2 as ResultsController


// Controller that holds state data for each screen
type ResultsController
	
	// Player ID (1 or 2)
	player as integer
	
	// Game state
	isWinner as integer // 0 if false, 1 if true
	
	// Sprites
	txtCrabMsg as integer
	txtWinMsg as integer
	sprCrabWin as integer
	sprCrabLose as integer
	
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
	
	// The offset mumbo-jumbo with f-coefficients is because AGK's text rendering is awful
	CreateText(rc.txtCrabMsg, "Unique crab message")
	SetTextSize(rc.txtCrabMsg, 48)
	SetTextAngle(rc.txtCrabMsg, f*180)
	SetTextFontImage(rc.txtCrabMsg, fontCrabI)
	SetTextSpacing(rc.txtCrabMsg, -15)
	SetTextMiddleScreenOffset(rc.txtCrabMsg, f, 0, p*150)
	SetTextAlignment(rc.txtCrabMsg, 1)
	
	winMsg as string
	if rc.isWinner
		winMsg = "Winning boy!"
	else
		winMsg = "Loser XD"
	endif
	CreateText(rc.txtWinMsg, winMsg)
	SetTextSize(rc.txtWinMsg, 96)
	SetTextAngle(rc.txtWinMsg, f*180)
	SetTextFontImage(rc.txtWinMsg, fontCrabI)
	SetTextSpacing(rc.txtWinMsg, -22)
	SetTextMiddleScreenOffset(rc.txtWinMsg, f, 0, p*725)
	SetTextAlignment(rc.txtWinMsg, 1)
	
	sprCrabLose$ = "/media/art/crab" + Str(loserCrab) + "attack1.png"
	LoadSprite(rc.sprCrabLose, sprCrabLose$)
	SetSpriteSize(rc.sprCrabLose, 195, 195)
	SetSpriteMiddleScreenOffset(rc.sprCrabLose, p*-1*w/4, p*375)
	SetSpriteFlip(rc.sprCrabLose, f, f)
	
	sprCrabWin$ = "/media/art/crab" + Str(winnerCrab) + "select1.png"
	LoadSprite(rc.sprCrabWin, sprCrabWin$)
	SetSpriteSize(rc.sprCrabWin, 425, 425)
	SetSpriteMiddleScreenOffset(rc.sprCrabWin, p*w/8, p*450)
	SetSpriteFlip(rc.sprCrabWin, f, f)
	
endfunction

// Initialize the results screen
function InitResults()
	
	PlayMusicOGGSP(resultsMusic, 1)
	
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
	
	rc2.player = 2
	rc2.txtCrabMsg = TXT_R_CRAB_MSG_2
	rc2.txtWinMsg = TXT_R_WIN_MSG_2
	rc2.sprCrabWin = SPR_R_CRAB_WIN_2
	rc2.sprCrabLose = SPR_R_CRAB_LOSE_2
	
	InitResultsController(rc1)
	InitResultsController(rc2)
	
	// Create mid-screen buttons
	LoadSprite(SPR_R_REMATCH, "rematchButton.png")
	SetSpriteSize(SPR_R_REMATCH, 210, 210)
	SetSpriteMiddleScreen(SPR_R_REMATCH)
	
	LoadSprite(SPR_R_CRAB_SELECT, "crabSelectButton.png")
	SetSpriteSize(SPR_R_CRAB_SELECT, 175, 175)
	SetSpriteMiddleScreenOffset(SPR_R_CRAB_SELECT, -1*w/3, 0)
	
	LoadSprite(SPR_R_MAIN_MENU, "mainMenuButton.png")
	SetSpriteSize(SPR_R_MAIN_MENU, 160, 160)
	SetSpriteMiddleScreenOffset(SPR_R_MAIN_MENU, w/3, 0)
	
	PlayMusicOGG(resultsMusic, 1)
	
	resultsStateInitialized = 1
	
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
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> RESULTS
		ExitResults()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitResults()
	
	if GetMusicPlayingOggSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
	resultsStateInitialized = 0
	
endfunction
