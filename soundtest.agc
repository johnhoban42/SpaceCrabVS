// File: soundtest.agc
// Created: 23-10-03

global soundtestStateInitialized as integer = 0

global soundPlaying = 0

// Sound Check Sprites
#constant sprSoundBack = 6900
#constant sprSoundControl = 6901
#constant sprSoundSelectLeft = 6902
#constant sprSoundSelectRight = 6903
#constant sprSoundTitle = 6904
#constant sprSoundCharacter = 6905

// list of sound IDs to play
global soundList as integer [4] = [ titleMusic, characterMusic, resultsMusic, loserMusic ]

// current index of the sound player, modified by pressing the left or right buttons
global soundIndex = 0

// Initialize the sound test screen
function InitSoundTest()
	
	//Creation of the sprites/anything else needed goes here
	
	LoadSpriteExpress(sprSoundBack, "ui/back8.png", 100, 100, w / 2 - 50, h * 4 / 5 - 50, 69)
	AddButton(sprSoundBack)
	
	LoadSpriteExpress(sprSoundSelectLeft, "ui/leftArrow.png", 100, 100, w / 4 - 50, h / 5 - 50, 69)
	AddButton(sprSoundSelectLeft)
	
	LoadSpriteExpress(sprSoundSelectRight, "ui/rightArrow.png", 100, 100, w * 3 / 4 - 50, h / 5 - 50, 69)
	AddButton(sprSoundSelectRight)
	
	LoadSpriteExpress(sprSoundTitle, "ui/mainmenu.png", 100, 100, w / 3 - 50, h * 3 / 5 - 50, 69)
	AddButton(sprSoundTitle)
	
	LoadSpriteExpress(sprSoundCharacter, "ui/crabselect.png", 100, 100, w * 2 / 3 - 50, h * 3 / 5 - 50, 69)
	AddButton(sprSoundCharacter)
																															
	CreateSprite(sprSoundControl, 0)
	AddSpriteAnimationFrame(sprSoundControl, playI)
	AddSpriteAnimationFrame(sprSoundControl, pauseI)
	SetSpriteExpress(sprSoundControl, 100, 100, w / 2 - 50, h * 2 / 5 - 50, 69)
	AddButton(sprSoundControl)
	
	soundtestStateInitialized = 1
endfunction

// Soundtest screen execution loop
// Each time this loop exits, return the next state to enter into
function DoSoundTest()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if soundtestStateInitialized = 0
		InitSoundTest()
	endif
	state = SOUNDTEST
	
	//Do loop for the mode is here
	//check which button the player hit
	// back button
	if ButtonMultiTouchEnabled(sprSoundBack)
		state = START
		if soundPlaying = 1
			soundPlaying = 0
			StopMusicOGGSP(soundList[soundIndex])			
			SetSpriteFrame(sprSoundControl, 1)
		endif
	// play/pause button
	elseif ButtonMultiTouchEnabled(sprSoundControl)
		// start playing song
		if soundPlaying = 0
			soundPlaying = 1
			PlayMusicOGGSP(soundList[soundIndex], 1)
			SetSpriteFrame(sprSoundControl, 2)
		// stop playing song
		else
			soundPlaying = 0
			StopMusicOGGSP(soundList[soundIndex])
			SetSpriteFrame(sprSoundControl, 1)
		endif
	// song scroll left or right
	elseif ButtonMultitouchEnabled(sprSoundSelectLeft) or ButtonMultitouchEnabled(sprSoundSelectRight)
		// stop current music
		if soundPlaying = 1
			soundPlaying = 0
			StopMusicOGG(soundList[soundIndex])
			SetSpriteFrame(sprSoundControl, 1)
		endif
		// scroll left
		if ButtonMultitouchEnabled(sprSoundSelectLeft)
			soundIndex = soundIndex - 1
			if soundIndex = -1
				soundIndex = soundList.length - 1
			endif
		// scroll right
		elseif ButtonMultitouchEnabled(sprSoundSelectRight)
			soundIndex = soundIndex + 1
			if soundIndex = soundList.length
				soundIndex = 0
			endif
		endif
	// set title music
	elseif ButtonMultiTouchEnabled(sprSoundTitle)
		currentTitleMusic = soundList[soundIndex]
		// TODO: maybe gray out this when current song is already set for this menu?
		// add some kind of feedback so the user knows this action was successful before they leave
	elseif ButtonMultiTouchEnabled(sprSoundCharacter)
		currentCharacterMusic = soundList[soundIndex]
		// TODO: maybe gray out this when current song is already set for this menu?
		// add some kind of feedback so the user knows this action was successful before they leave
	endif
		
//~	print(soundList.length)	
//~	print(soundIndex)
//~	print(soundList[soundIndex])
			
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> SOUNDTEST
		ExitSoundTest()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitSoundTest()

	//Deletion of the assets/setting variables correctly to leave is here
	DeleteSprite(sprSoundBack)
	DeleteSprite(sprSoundControl)
	DeleteSprite(sprSoundSelectLeft)
	DeleteSprite(sprSoundSelectRight)
	DeleteSprite(sprSoundTitle)
	DeleteSprite(sprSoundCharacter)

	soundtestStateInitialized = 0
endfunction

// NOTES:
// "state" is checked at the end of every Do-screen iteration
// if state is not equal to SOUNDTEST in our case, main function will start running whatever the new state's "do-screen" 
// LoadSpriteExpress(varID, imgPath, width, height, x, y, z-depth) will be instrumental to setting up images in the window
// varID is a constant tied to a number, just pick a unique multiple of 100 and then start +1'ing it for each name you need
// AddButton(varID) to connect a sprite created via LoadSpriteExpress to convenience code to make the sprite visually pop like other buttons
// in the do loop, have a series of ButtonMultiTouchEnabled(varID) checks to see if a button with the passed varID is being pressed
// if a button is being pressed, run interior code to play or stop the music/sounds that should be tied to the button
// PlayMusicOGGSP(songID, loopYN) takes a songID (IDs specified in constants.agc under "music indexes") and does all the work to get it to start playing, and will loop if loopYN is set to 1
// StopMusicOGGSP(songID) is its counterpart
// CreateTextExpress(varID, str, fontSize, fontImgID, alignment, x, y, depth) is the go-to for text creation
// for testing, set line 177 in main.agc to SOUNDTEST to make the game launch directly to the soundtest screen
// CreateSprite(varID, imgID) is the more rudimentary sprite initializiation function, pass 0 for imgID to initialize an empty sprite
// AddSpriteAnimationFrame(spriteID, imgID) adds a frame to the passed sprite's "animation array" (indexing starting at 1). this IGNORES any image passed in the sprite setup
// so I could AddSpriteAnimationFrame the imgIDs for play and pause buttons at indices 1 and 2 and then set the animation frame to 1 or 2 according to what songs are being started/stopped by the user
// if a sprite is being set up via CreateSprite and AddSpriteAnimationFrame, use SetSpriteExpress to position it, as that takes all the positional infor CreateSpriteExpress does without the initialization code
