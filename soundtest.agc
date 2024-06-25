// File: soundtest.agc
// Created: 23-10-03

global soundtestStateInitialized as integer = 0

global soundPlaying = 0

// Sound Check Banner Sprites
#constant sprBanner0 = 6900
#constant sprBanner1 = 6901
#constant sprBanner2 = 6902
#constant sprBanner3 = 6903
#constant sprBanner4 = 6904
#constant sprBanner5 = 6905
#constant sprBanner6 = 6906
#constant sprBanner7 = 6907
#constant sprBanner8 = 6908
#constant sprBanner9 = 6909
#constant sprBanner10 = 6910
#constant sprBanner11 = 6911
#constant sprBanner12 = 6912
#constant sprBanner13 = 6913
//#constant sprBanner14 = 6914
#constant sprBanner15 = 6915
//#constant sprBanner16 = 6916
//#constant sprBanner17 = 6917
//#constant sprBanner18 = 6918
//#constant sprBanner19 = 6919
//#constant sprBanner20 = 6920
#constant sprBanner21 = 6921
// jump from regular to retro here
#constant sprBanner31 = 6931
#constant sprBanner32 = 6932
#constant sprBanner33 = 6933
#constant sprBanner34 = 6934
#constant sprBanner35 = 6935
#constant sprBanner36 = 6936
#constant sprBanner37 = 6937
#constant sprBanner38 = 6938
#constant sprBanner39 = 6939
#constant sprBanner40 = 6940
#constant sprBanner41 = 6941

// Sound Check Misc Sprites
#constant sprSoundBack = 6950
#constant sprSoundControl = 6951
#constant sprSoundSelectLeft = 6952
#constant sprSoundSelectRight = 6953
#constant sprSoundTitle = 6954
#constant sprSoundCharacter = 6955
#constant sprSoundDisplay = 6956

// Sound Check Tweens
#constant twnSCLeftIn = 6960
#constant twnSCLeftOut = 6961
#constant twnSCRightIn = 6962
#constant twnSCRightOut = 6963

// list of sound IDs to play
global soundList as integer [27] = [ 
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
//14,
15,
//16,
//17,
//18,
//19,
//20,
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
	
	// create the music display sprite with each frame tied to one of the songs in our list
	SetFolder("/media/musicBanners")
	LoadImage(sprBanner0, "banner0.png")
	LoadImage(sprBanner1, "banner1.png")
	LoadImage(sprBanner2, "banner2.png")
	LoadImage(sprBanner3, "banner3.png")
	LoadImage(sprBanner4, "banner4.png")
	LoadImage(sprBanner5, "banner5.png")
	LoadImage(sprBanner6, "banner6.png")
	LoadImage(sprBanner7, "banner7.png")
	LoadImage(sprBanner8, "banner8.png")
	LoadImage(sprBanner9, "banner9.png")
	LoadImage(sprBanner10, "banner10.png")
	LoadImage(sprBanner11, "banner11.png")
	LoadImage(sprBanner12, "banner12.png")
	LoadImage(sprBanner13, "banner13.png")
	//LoadImage(sprBanner14, "banner14.png")
	LoadImage(sprBanner15, "banner15.png")
	//LoadImage(sprBanner16, "banner16.png")
	//LoadImage(sprBanner17, "banner17.png")
	//LoadImage(sprBanner18, "banner18.png")
	//LoadImage(sprBanner19, "banner19.png")
	//LoadImage(sprBanner20, "banner20.png")
	LoadImage(sprBanner21, "banner21.png")
	LoadImage(sprBanner31, "banner31.png")
	LoadImage(sprBanner32, "banner32.png")
	LoadImage(sprBanner33, "banner33.png")
	LoadImage(sprBanner34, "banner34.png")
	LoadImage(sprBanner35, "banner35.png")
	LoadImage(sprBanner36, "banner36.png")
	LoadImage(sprBanner37, "banner37.png")
	LoadImage(sprBanner38, "banner38.png")
	LoadImage(sprBanner39, "banner39.png")
	LoadImage(sprBanner40, "banner40.png")
	LoadImage(sprBanner41, "banner41.png")
	
	CreateSprite(sprSoundDisplay, 0)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner0)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner1)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner2)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner3)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner4)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner5)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner6)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner7)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner8)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner9)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner10)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner11)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner12)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner13)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner14)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner15)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner16)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner17)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner18)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner19)
	//AddSpriteAnimationFrame(sprSoundDisplay, sprBanner20)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner21)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner31)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner32)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner33)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner34)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner35)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner36)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner37)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner38)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner39)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner40)
	AddSpriteAnimationFrame(sprSoundDisplay, sprBanner41)

	SetSpriteExpress(sprSoundDisplay, 386,114, w / 2 - 193, h / 5 - 57, 70)
	
	// create the tweens for moving the display sprite around when switching songs
	CreateTweenSprite(twnSCLeftIn, .5)
	SetTweenSpriteX(twnSCLeftIn, -386, w / 2 - 193, TweenOvershoot())	
	CreateTweenSprite(twnSCLeftOut, .5)
	SetTweenSpriteX(twnSCLeftOut, w / 2 - 193, w + 386, TweenOvershoot())
	CreateTweenSprite(twnSCRightIn, .5)
	SetTweenSpriteX(twnSCRightIn, w + 386, w / 2 - 193, TweenOvershoot())
	CreateTweenSprite(twnSCRightOut, .5)
	SetTweenSpriteX(twnSCRightOut, w / 2 - 193, -386, TweenOvershoot())
	
	soundtestStateInitialized = 1
endfunction

// Change the selected crab
// dir -> -1 for left, 1 for right
//~function ChangeSongs(dir as integer, startCycle as integer)
//~	PlayTweenSprite(tween1, songSprite, 0)
//~	PlayTweenSprite(tween2, songSprite, .5)
//~	if GetTweenSpritePlaying(tween2, songSprite) 
//~		SetSpriteFrame(songSprite, songImgs[x])
//~	endif
//~endfunction

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
	elseif ButtonMultitouchEnabled(sprSoundSelectLeft) or ButtonMultitouchEnabled(sprSoundSelectRight)
		// stop current music
		if soundPlaying = 1
			soundPlaying = 0
			StopMusicOGG(GetMusicByID(soundList[soundIndex]))
			SetSpriteFrame(sprSoundControl, 1)
		endif
		// scroll left
		if ButtonMultitouchEnabled(sprSoundSelectLeft)
			soundIndex = soundIndex - 1
			if soundIndex = -1
				soundIndex = soundList.length - 1
			elseif soundList[soundIndex] < 31 and soundList[soundIndex] > musicUnlocked
				soundIndex = musicUnlocked
			endif
			PlayTweenSprite(twnSCLeftOut, sprSoundDisplay, 0)
			PlayTweenSprite(twnSCLeftIn, sprSoundDisplay, .5)
		// scroll right
		elseif ButtonMultitouchEnabled(sprSoundSelectRight)
			soundIndex = soundIndex + 1
			if soundIndex = soundList.length
				soundIndex = 0
			elseif soundList[soundIndex] < 31 and soundList[soundIndex] > musicUnlocked
				soundIndex = soundList.length - 11
			endif			
			PlayTweenSprite(twnSCRightOut, sprSoundDisplay, 0)
			PlayTweenSprite(twnSCRightIn, sprSoundDisplay, .5)
		endif
	// set title music
	elseif ButtonMultiTouchEnabled(sprSoundTitle)
		currentTitleMusic = GetMusicByID(soundList[soundIndex])
		// TODO: maybe gray out this when current song is already set for this menu?
		// add some kind of feedback so the user knows this action was successful before they leave
	elseif ButtonMultiTouchEnabled(sprSoundCharacter)
		currentCharacterMusic = GetMusicByID(soundList[soundIndex])
		// TODO: maybe gray out this when current song is already set for this menu?
		// add some kind of feedback so the user knows this action was successful before they leave
	endif
		
//~	print(soundList.length)	
//~	print(soundIndex)
//~	print(soundList[soundIndex])		
		
	// update the display frame when moving the new song in
	if (GetTweenSpritePlaying(twnSCLeftIn, sprSoundDisplay) or GetTweenSpritePlaying(twnSCRightIn, sprSoundDisplay)) and not GetSpriteCurrentFrame(sprSoundDisplay) = soundIndex + 1
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
	DeleteSprite(sprSoundBack)
	DeleteSprite(sprSoundControl)
	DeleteSprite(sprSoundSelectLeft)
	DeleteSprite(sprSoundSelectRight)
	DeleteSprite(sprSoundTitle)
	DeleteSprite(sprSoundCharacter)
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
