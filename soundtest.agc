// File: soundtest.agc
// Created: 23-10-03

global soundtestStateInitialized as integer = 0

global sprBackBtn
global sprPlayBtn
global sprPauseBtn
global sfxLoserSong

// Initialize the sound test screen
function InitSoundTest()
	
	//Created of the sprites/anything else needed goes here
	
	// load images
	SetFolder("media/ui")
	imgBackBtn = LoadImage("back8")
	sprBackBtn = CreateSprite(imgBackBtn)
	imgPlayBtn = LoadImage("play.png")
	sprPlayBtn = CreateSprite(imgPlayBtn)
	imgPauseBtn = LoadImage("pause.png")
	sprPauseBtn = CreateSprite(imgPauseBtn)
	
	// position images
	SetSpritePosition(sprBackBtn, 10, 10)
	SetSpriteMiddleScreenX(sprPlayBtn)
	SetSpriteMiddleScreenY(sprPlayBtn)
	SetSpriteMiddleScreenX(sprPauseBtn)
	SetSpriteMiddleScreenY(sprPauseBtn)
	// deactivate the pause button initially
	SetSpriteActive(sprPauseBtn, 0)
	SetSpriteVisible(sprPauseBtn, 0)
	
	// set the sprites as buttons
	AddButton(sprBackBtn)
	AddButton(sprPlayBtn)
	AddButton(sprPauseBtn)
	
	// load music
	SetFolder("media/music")
	sfxLoserSong = LoadMusicOGG("loser.ogg")
	
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
	// back to main menu
	if Button(sprBackBtn)
		state = START
		// stop whatever music is playing
		StopMusicOGG()
	// start playing sounds
	elseif Button(sprPlayBtn)
		// resume or start the song based on the old play state
		if GetMusicPlayingOGG(sfxLoserSong) = 1
			ResumeMusicOGG(sfxLoserSong)
		else
			PlayMusicOGG(sfxLoserSong)
		endif
		// turn off the play button and turn on the pause button
		SetSpriteActive(sprPlayBtn, 0)
		SetSpriteVisible(sprPlayBtn, 0)
		SetSpriteActive(sprPauseBtn, 1)
		SetSpriteVisible(sprPauseBtn, 1)
	// player pauses sounds or the sounds playing have ended
	elseif Button(sprPauseBtn) or GetMusicPlayingOGG(sfxLoserSong) = 0
		// pause the sounds if the player hit the pause button
		if Button(sprPauseBtn)
			PauseMusicOGG(sfxLoserSong)
		endif
		// turn off the pause button and turn on the play button
		SetSpriteActive(sprPlayBtn, 1)
		SetSpriteVisible(sprPlayBtn, 1)
		SetSpriteActive(sprPauseBtn, 0)
		SetSpriteVisible(sprPauseBtn, 0)
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
	DeleteSprite(sprBackBtn)
	DeleteSprite(sprPlayBtn)
	DeleteSprite(sprPauseBtn)
	DeleteMusicOGG(sfxLoserSong)

	soundtestStateInitialized = 0
endfunction
