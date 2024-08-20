// File: soundtest.agc
// Created: 23-10-03

global soundtestStateInitialized as integer = 0

global soundPlaying = 0

// Sound Check Misc Sprites
#constant sprSoundBase = 6900
#constant sprSoundBack = 6950
#constant sprSoundControl = 6951
#constant sprSoundSelectLeft = 6952
#constant sprSoundSelectRight = 6953
#constant sprSoundTitle = 6954
#constant sprSoundTitleCurrent = 6955
#constant sprSoundCharacter = 6956
#constant sprSoundCharacterCurrent = 6957
#constant sprSoundDisplay = 6958

// Sound Check Tweens
#constant twnSCLeftIn = 6960
#constant twnSCLeftOut = 6961
#constant twnSCRightIn = 6962
#constant twnSCRightOut = 6963

// list of sound IDs to play
global soundList as integer [33] = [ 
0,
1,
2,
3,
4,
5,
6,
7,
8,
9,
10,
11,
12,
13,
14,
15,
16,
17,
18,
19,
20,
21,
31,
32,
33,
34,
35,
36,
37,
38,
39,
40,
41 ]

// current index of the sound player, modified by pressing the left or right buttons
global soundIndex = 0

// current index of the set title screen music, modified by pressing the set title screen music button
global titleIndex = 0

// current index of the set character selection screen music, modified by pressing the set character selection screen music button
global characterSelectIndex = 0

// Initialize the sound test screen
function InitSoundTest()
	
	//Creation of the sprites/anything else needed goes here

	// create the play/pause button
	CreateSprite(sprSoundControl, 0)
	//AddSpriteAnimationFrame(sprSoundControl, playI)
	//AddSpriteAnimationFrame(sprSoundControl, pauseI)
	// create the music display sprite with each frame tied to one of the songs in our list
	CreateSprite(sprSoundDisplay, 0)
	for i = 0 to 41
		if GetFileExists("musicBanners/banner" + Str(i) + ".png")
			AddSpriteAnimationFrame(sprSoundDisplay, banner1I+i)
		endif
	next i
			
	// create the tweens for the song display banners to move on/off-screen via
	CreateTweenSprite(twnSCLeftIn, .5)
	CreateTweenSprite(twnSCLeftOut, .5)
	CreateTweenSprite(twnSCRightIn, .5)
	CreateTweenSprite(twnSCRightOut, .5)
	// position items based on device type
	if dispH = 1
		// create and position the jukebox base
		LoadSpriteExpress(sprSoundBase, "ui/jukeboxdesktoptest.png", w, h, 0, 0, 70)
		// create & position the simple buttons
		LoadSpriteExpress(sprSoundBack, "ui/back8.png", 160, 160, w / 2 - 80, h * 4 / 5 - 80, 69)
		LoadSpriteExpress(sprSoundSelectLeft, "ui/leftArrow.png", 160, 160, w / 7 - 80, h / 4 - 80, 69)
		LoadSpriteExpress(sprSoundSelectRight, "ui/rightArrow.png", 160, 160, w * 6 / 7 - 80, h / 4 - 80, 69)
		LoadSpriteExpress(sprSoundTitle, "ui/mainmenu.png", 160, 160, w / 7 - 80, h * 2 / 3 - 80, 69)
		LoadSpriteExpress(sprSoundCharacter, "ui/crabselect.png", 160, 160, w * 6 / 7 - 80, h * 2 / 3 - 80, 69)
		// position play/pause button
		SetSpriteExpress(sprSoundControl, 160, 160, w / 2 - 80, h / 2 - 80, 69)
		// position the song display
		SetSpriteExpress(sprSoundDisplay, 640, 160, w / 2 - 320, h / 4 - 80, 71)
		// create the tweens for moving the song display sprite around when switching songs
		SetTweenSpriteX(twnSCLeftIn, -640, w / 2 - 320, TweenOvershoot())	
		SetTweenSpriteX(twnSCLeftOut, w / 2 - 320, w + 640, TweenOvershoot())
		SetTweenSpriteX(twnSCRightIn, w + 640, w / 2 - 320, TweenOvershoot())
		SetTweenSpriteX(twnSCRightOut, w / 2 - 320, -640, TweenOvershoot())	
		// create the current title music display sprite with each frame tied to one of the songs in our list
		CreateSprite(sprSoundTitleCurrent, 0)
		for i = 0 to 41
			if GetFileExists("musicBanners/banner" + Str(i) + ".png")
				AddSpriteAnimationFrame(sprSoundTitleCurrent, banner1I+i)
			endif
		next i
		// position the current title song display
		SetSpriteExpress(sprSoundTitleCurrent, 320, 80, w / 7 - 160, h * 7 / 8 - 40, 69)
		// set the current title music sprite frame to the correct value
		SetSpriteFrame(sprSoundTitleCurrent, titleIndex + 1)		
		// create the character selection music display sprite with each frame tied to one of the songs in our list
		CreateSprite(sprSoundCharacterCurrent, 0)
		for i = 0 to 41
			if GetFileExists("musicBanners/banner" + Str(i) + ".png")
				AddSpriteAnimationFrame(sprSoundCharacterCurrent, banner1I+i)
			endif
		next i		
		// position the current title song display
		SetSpriteExpress(sprSoundCharacterCurrent, 320, 80, w * 6 / 7 - 160, h * 7 / 8 - 40, 69)
		// set the current character select music sprite frame to the correct value
		SetSpriteFrame(sprSoundCharacterCurrent, characterSelectIndex + 1)		
	else
		// create and position the jukebox base
		LoadSpriteExpress(sprSoundBase, "ui/jukeboxmobiletest.png", w, h, 0, 0, 70)
		// create & position the simple buttons
		LoadSpriteExpress(sprSoundBack, "ui/back8.png", 250, 250, w / 2 - 125, h * 8 / 9 - 125, 69)
		LoadSpriteExpress(sprSoundSelectLeft, "ui/leftArrow.png", 250, 250, w / 4 - 125, h * 3 / 8 - 125, 69)
		LoadSpriteExpress(sprSoundSelectRight, "ui/rightArrow.png", 250, 250, w * 3 / 4 - 125, h * 3 / 8 - 125, 69)
		LoadSpriteExpress(sprSoundTitle, "ui/mainmenu.png", 250, 250, w / 4 - 125, h * 5 / 7 - 125, 69)
		LoadSpriteExpress(sprSoundCharacter, "ui/crabselect.png", 250, 250, w * 3 / 4 - 125, h * 5 / 7 - 125, 69)
		// position play/pause button
		SetSpriteExpress(sprSoundControl, 250, 250, w / 2 - 125, h * 5 / 9 - 125, 69)
		// position the song display
		SetSpriteExpress(sprSoundDisplay, 640,160, w / 2 - 320, h / 5 - 80, 71)
		// create the tweens for moving the song display sprite around when switching songs
		SetTweenSpriteX(twnSCLeftIn, -640, w / 2 - 320, TweenOvershoot())	
		SetTweenSpriteX(twnSCLeftOut, w / 2 - 320, w + 640, TweenOvershoot())
		SetTweenSpriteX(twnSCRightIn, w + 640, w / 2 - 320, TweenOvershoot())
		SetTweenSpriteX(twnSCRightOut, w / 2 - 320, -640, TweenOvershoot())			
	endif
	
	// add button animations/functionality to the buttons of our screen
	AddButton(sprSoundBack)
	AddButton(sprSoundSelectLeft)
	AddButton(sprSoundSelectRight)
	AddButton(sprSoundTitle)
	AddButton(sprSoundCharacter)
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
		TransitionEnd()
	endif
	state = SOUNDTEST
	
	//Do loop for the mode is here
	//check which button the player hit
	// back button
	if ButtonMultiTouchEnabled(sprSoundBack)
		state = START
		if soundPlaying = 1
			soundPlaying = 0
			StopMusicOGGSP(GetMusicByID(soundList[soundIndex]))			
			SetSpriteFrame(sprSoundControl, 1)
		endif
	// play/pause button
	elseif ButtonMultiTouchEnabled(sprSoundControl)
		// start playing song
		if soundPlaying = 0
			soundPlaying = 1
			PlayMusicOGGSP(GetMusicByID(soundList[soundIndex]), 1)
			SetSpriteFrame(sprSoundControl, 2)
		// stop playing song
		else
			soundPlaying = 0
			StopMusicOGGSP(GetMusicByID(soundList[soundIndex]))
			SetSpriteFrame(sprSoundControl, 1)
		endif
	// song scroll left or right
	elseif (ButtonMultitouchEnabled(sprSoundSelectLeft) or ButtonMultitouchEnabled(sprSoundSelectRight)) and GetSpriteX(sprSoundDisplay) = w / 2 - GetSpriteWidth(sprSoundDisplay) / 2
		// stop current music
		if soundPlaying = 1
			soundPlaying = 0
			StopMusicOGG(GetMusicByID(soundList[soundIndex]))
			SetSpriteFrame(sprSoundControl, 1)
		endif
		// scroll left
		if ButtonMultitouchEnabled(sprSoundSelectLeft)
			// decrement sound index
			soundIndex = soundIndex - 1
			// handle wrap around
			if soundIndex = -1
				soundIndex = soundList.length - 1
			// jump indices to skip locked songs
			elseif soundList[soundIndex] < 31 and soundList[soundIndex] > musicUnlocked
				soundIndex = musicUnlocked
			endif
			// animate old banner frame out and new banner frame in
			PlayTweenSprite(twnSCLeftOut, sprSoundDisplay, 0)
			PlayTweenSprite(twnSCLeftIn, sprSoundDisplay, .5)
		// scroll right
		elseif ButtonMultitouchEnabled(sprSoundSelectRight)
			// increment sound index
			soundIndex = soundIndex + 1
			// handle wrap around
			if soundIndex = soundList.length
				soundIndex = 0
			// jump indices to skip locked songs
			elseif soundList[soundIndex] < 31 and soundList[soundIndex] > musicUnlocked
				soundIndex = soundList.length - 11
			endif
			// animate old banner frame out and new banner frame in
			PlayTweenSprite(twnSCRightOut, sprSoundDisplay, 0)
			PlayTweenSprite(twnSCRightIn, sprSoundDisplay, .5)
		endif
	// set title music
	elseif ButtonMultiTouchEnabled(sprSoundTitle)
		currentTitleMusic = GetMusicByID(soundList[soundIndex])
		titleIndex = soundIndex
		SetSpriteFrame(sprSoundTitleCurrent, titleIndex + 1)
	elseif ButtonMultiTouchEnabled(sprSoundCharacter)
		currentCharacterMusic = GetMusicByID(soundList[soundIndex])
		characterSelectIndex = soundIndex
		SetSpriteFrame(sprSoundCharacterCurrent, characterSelectIndex + 1)		
	endif
		
//~	print(soundList.length)	
//~	print(soundIndex)
//~	print(soundList[soundIndex])		
		
	// update the display frame when moving the new song in
	if not GetTweenSpritePlaying(twnSCLeftOut, sprSoundDisplay) and not GetTweenSpritePlaying(twnSCRightOut, sprSoundDisplay) and not GetSpriteCurrentFrame(sprSoundDisplay) = soundIndex + 1
		SetSpriteFrame(sprSoundDisplay, soundIndex + 1)
	endif
			
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> SOUNDTEST
		ExitSoundTest()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitSoundTest()

	//Deletion of the assets/setting variables correctly to leave is here
	DeleteSprite(sprSoundBase)
	DeleteSprite(sprSoundBack)
	DeleteSprite(sprSoundControl)
	DeleteSprite(sprSoundSelectLeft)
	DeleteSprite(sprSoundSelectRight)
	DeleteSprite(sprSoundTitle)
	DeleteSprite(sprSoundTitleCurrent)
	DeleteSprite(sprSoundCharacter)
	DeleteSprite(sprSoundCharacterCurrent)
	DeleteSprite(sprSoundDisplay)
	DeleteTween(twnSCLeftIn)
	DeleteTween(twnSCLeftOut)
	DeleteTween(twnSCRightIn)
	DeleteTween(twnSCRightOut)

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
	
// CreateTweenSprite(tweenID, duration)
// SetTweenSpriteX(tweenID, startX, endX, TweenInterpolationType())
// PlayTweenSprite(tweenID
