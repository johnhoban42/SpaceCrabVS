// File: story.agc
// Created: 23-06-20

global storyStateInitialized as integer = 0
global talk1S
global talkBS

// Initialize the story screen
function InitStory()
	
	SetSpriteVisible(split, 0)
	
	for i = SPR_TEXT_BOX to SPR_TEXT_BOX4
		CreateSpriteExpress(i, w-80, 280, 0, 0, 15-(i-SPR_TEXT_BOX))
		//SetSpriteSize(i, GetSpriteWidth(i), GetSpriteHeight(i) + 30)	//Originally for the bottom one
		SetSpriteMiddleScreenX(i)
		SetSpriteY(i, h/2 + 20 - (i - SPR_TEXT_BOX)*(GetSpriteHeight(i) + 50))
		
		CreateTweenSprite(i, .3)
		if i > SPR_TEXT_BOX
			SetTweenSpriteY(i, GetSpriteY(i) + (GetSpriteHeight(i) + 50), GetSpriteY(i), TweenEaseOut2())
			SetSpriteColorAlpha(i, 0)
			//SetSpriteColorRed(i, 10)
		endif
	next i
	
	SetTweenPulse(SPR_TEXT_BOX, SPR_TEXT_BOX, 1.1)
	SetTweenSpriteAlpha(SPR_TEXT_BOX, 0, 255, TweenEaseOut2())	
	
	for i = storyText to storyFitter
		CreateTextExpress(i, "", 60, fontDescI, 0, GetSpriteX(SPR_TEXT_BOX)+20, GetSpriteY(SPR_TEXT_BOX)+20, 15-(i-storyText))
		if i < storyFitter then SetTextY(i, GetSpriteY(i - storyText + SPR_TEXT_BOX)+20)
		SetTextSpacing(i, -14)
		SetTextColor(i, 0, 0, 0, 255)
		CreateTweenText(i, .3)
		if i > storyText
			SetTweenTextY(i, GetTextY(i) + (GetSpriteHeight(SPR_TEXT_BOX) + 20), GetTextY(i), TweenEaseOut2())
			SetTextColorAlpha(i, 0)
		endif
	next i
	
	//SetTweenTextAlpha(storyText, 155, 255, TweenSmooth2())
	
	SetTextColorAlpha(storyFitter, 0)
	
	
	SetTweenSpriteAlpha(SPR_TEXT_BOX4, 255, 0, TweenEaseOut2())
	SetTweenTextAlpha(storyText4, 255, 0, TweenEaseOut2())
	
	//Load the difference faces/bodies as animation frames, then set the frame for different faces
	//Load the costume as it comes, use the body frame number to load the correct costume file string number
	cSize = 360
	for i = SPR_CRAB1_BODY to SPR_CRAB2_COSTUME
		CreateSpriteExpress(i, cSize, cSize, -cSize, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) + 80, 5)
		//if i <= SPR_CRAB1_COSTUME then Set		
	next i 
	
	CreateTweenSprite(SPR_CRAB1_BODY, .5)
	SetTweenSpriteX(SPR_CRAB1_BODY, -cSize, 20, TweenSmooth1())
	CreateTweenSprite(SPR_CRAB2_BODY, .5)
	SetTweenSpriteX(SPR_CRAB2_BODY, w, w-cSize-20, TweenSmooth1())
	
	SetSpritePosition(SPR_CRAB1_FACE, 20, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) + 80)
	SetSpritePosition(SPR_CRAB2_FACE, w-cSize-20, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) + 80)
	
	impact# = 1.4
	spr = SPR_CRAB1_FACE
	CreateTweenSprite(spr, .3)
	SetTweenSpriteSizeX(spr, GetSpriteWidth(spr)*impact#, GetSpriteWidth(spr), TweenOvershoot())
	SetTweenSpriteSizeY(spr, GetSpriteHeight(spr)*impact#, GetSpriteHeight(spr), TweenOvershoot())
	SetTweenSpriteX(spr, GetSpriteMiddleX(spr)-(GetSpriteWidth(spr)*impact#)/2, GetSpriteX(spr), TweenOvershoot())
	SetTweenSpriteY(spr, GetSpriteMiddleY(spr)-(GetSpriteHeight(spr)*impact#)/2, GetSpriteY(spr), TweenOvershoot())
	MatchSpritePosition(spr, SPR_CRAB1_BODY)
	spr = SPR_CRAB2_FACE
	CreateTweenSprite(spr, .3)
	SetTweenSpriteSizeX(spr, GetSpriteWidth(spr)*impact#, GetSpriteWidth(spr), TweenOvershoot())
	SetTweenSpriteSizeY(spr, GetSpriteHeight(spr)*impact#, GetSpriteHeight(spr), TweenOvershoot())
	SetTweenSpriteX(spr, GetSpriteMiddleX(spr)-(GetSpriteWidth(spr)*impact#)/2, GetSpriteX(spr), TweenOvershoot())
	SetTweenSpriteY(spr, GetSpriteMiddleY(spr)-(GetSpriteHeight(spr)*impact#)/2, GetSpriteY(spr), TweenOvershoot())
	MatchSpritePosition(spr, SPR_CRAB2_BODY)
	
	CreateTweenSprite(SPR_CRAB2_COSTUME, .3)
	SetTweenSpriteX(SPR_CRAB2_COSTUME, w-cSize-20, w+200, TweenSmooth2())
	
	CreateTweenSprite(SPR_CRAB1_COSTUME, .3)
	SetTweenSpriteX(SPR_CRAB1_COSTUME, 20, cSize-200, TweenSmooth2())
	//Just need to test that these tweens work!
	
	
	SetFolder("/media/sounds")
	if GetDeviceBaseName() <> "android"
		talk1S = LoadSoundOGG("talk1.ogg")
		talkBS = LoadSoundOGG("talkB.ogg")
	else
		talk1S = LoadMusicOGG("talk1.ogg")
		talkBS = LoadMusicOGG("talkB.ogg")
	endif
	
	//Loading the text
	
	if GetSpriteExists(coverS) then PlayTweenSprite(tweenSprFadeOutFull, coverS, 0)
	
	storyTimer# = 0
	
	storyStateInitialized = 1
endfunction

function InitResultsRetry()
	CreateTextExpress(storyText, "You were supposed" + chr(10) + "to win that one..." + chr(10) + chr(10) + "Try again?", 102, fontCrabI, 1, w/2, 350, 10)
	SetTextSpacing(storyText, -30)
	SetTextColor(storyText, 0, 0, 0, 255)

	if GetSpriteExists(coverS) = 0 then CreateSpriteExpress(coverS, w, h, 0, 0, 15)

	SetSpriteDepth(coverS, 15)

	SetFolder("/media/ui")

	LoadSpriteExpress(playButton, "restart.png", 265, 265, 0, 0, 4)
	SetSpriteMiddleScreen(playButton)
	IncSpriteY(playButton, 160)
	//IncSpriteX(playButton, 180)
	//IncSpriteY(playButton, 280)
	
	LoadSpriteExpress(exitButton, "crabselect.png", 190, 190, 0, 0, 4)
	SetSpriteMiddleScreen(exitButton)
	IncSpriteY(exitButton, 570)
	IncSpriteX(exitButton, -210)
	//IncSpriteY(exitButton, 280)

	AddButton(playButton)
	AddButton(exitButton)
	
	SetTextColorAlpha(storyText, 0)
	SetSpriteColorAlpha(playButton, 0)
	SetSpriteColorAlpha(exitButton, 0)
	PlayTweenText(tweenTxtFadeIn, storyText, 1)
	PlayTweenSprite(tweenSprFadeIn, playButton, 1)
	PlayTweenSprite(tweenSprFadeIn, exitButton, 1)
	
	SetSpriteVisible(split, 0)

	storyStateInitialized = 1
endfunction

// Story screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStory()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if storyStateInitialized = 0
		if storyRetry = 0
			InitStory()
		else
			InitResultsRetry()
		endif
	endif
	state = STORY
	
	inc storyTimer#, fpsr#
	
	if storyRetry = 0
		//The normal case, showing a story screen
		if curScene = 0 then curScene = 1
		state = ShowScene(curChapter*4+curScene)
	else
		//Do jittery text for the first half of result text
		//Spin the buttons
		
		IncSpriteAngle(playButton, -fpsr#)
		IncSpriteAngle(exitButton, fpsr#/2)
		
		inc TextJitterTimer#, GetFrameTime()
		if TextJitterTimer# >= 1.0/TextJitterFPS
			doJit = 1
			inc TextJitterTimer#, -TextJitterFPS
			if TextJitterTimer# < 0 then TextJitterTimer# = 0
		endif
		txt = storyText
		for i = 0 to 36
			if doJit
				SetTextCharY(txt, i, -1 * (jitterNum) + Random(0, (jitterNum)*2))
				if i > 17 then SetTextCharY(txt, i, -1 * (jitterNum) + Random(0, (jitterNum)*2) + GetTextSize(txt))
				SetTextCharAngle(txt, i, -1 * (jitterNum) + Random(0, jitterNum*2))
			endif
		next i
		
		if ButtonMultitouchEnabled(playButton)
			inc lineSkipTo, -2
			state = ShowScene(curChapter*4+1)
			
		elseif ButtonMultitouchEnabled(exitButton)
			state = CHARACTER_SELECT
			TransitionStart(Random(1,lastTranType))
			
		endif
		
		//Should also have a results state, for either a mission failed, or a successful scene, with only 2 options each
		//Restart/move on, and back to chapter select
	endif
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> STORY
		ExitStory()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStory()
	if storyRetry = 0
		for i = SPR_TEXT_BOX to SPR_TEXT_BOX4
			DeleteSprite(i)
			DeleteTween(i)
		next i
		
		for i = storyText to storyFitter
			DeleteText(i)
			DeleteTween(i)
		next i
		
		for i = SPR_CRAB1_BODY to SPR_CRAB2_COSTUME
			DeleteSprite(i)
			if GetTweenExists(i) then DeleteTween(i)
		next i
		
		if GetDeviceBaseName() <> "android"
			DeleteSound(talk1S)
			DeleteSound(talkBS)
		else
			DeleteMusicOGG(talk1S)
			DeleteMusicOGG(talkBS)
		endif
		
	else
		
		DeleteText(storyText)
		DeleteSprite(playButton)
		DeleteSprite(exitButton)
		lineSkipTo = 0
		
		if GetMusicPlayingOGGSP(loserMusic) then StopMusicOGGSP(loserMusic)
		
		storyRetry = 0
	endif
	
	if GetSpriteExists(coverS) then DeleteSprite(coverS)
	
	storyStateInitialized = 0
	
endfunction

function ShowScene(sceneNum)
	state = story
	
	storyActive = 1
	TransitionEnd()
	
	SetFolder("/media/text")
	
	if sceneNum = 0
		SceneFile$ = "testScene.txt"
	else
		SceneFile$ = "chap" + Str((sceneNum-1)/4) + "_" + Str(Mod(sceneNum-1, 4)+1) + ".txt"
	endif
	SetCrabFromChapter(curChapter)
	
	OpenToRead(1, SceneFile$)
	boxNum = 0
		
	wholeRow$ = ReadLine(1)
	lineOverall = 1
	
	//This returns from a fight, so the correct line is started from.
	for i = 1 to lineSkipTo-1
		wholeRow$ = ReadLine(1)
		inc lineOverall, 1
	next i
	
	crabLType = 0
	crabLAlt = 0
	crabRType = 0
	crabRAlt = 0
	
	//This whill iterates through the entire text file, one line at a time
	while (CompareString(wholeRow$, "") = 0)		
		
		//PART 1: Commands, that skip to the next line
		
		//Doing any music changes
		if GetStringToken(wholeRow$, " ", 1) = "music"
			PlayMusicOGGSPStr(GetStringToken(wholeRow$, " ", 2), Val(GetStringToken(wholeRow$, " ", 3)))
			wholeRow$ = ReadLine(1)
			inc lineOverall, 1
		endif
				
		//Starting a VS match
		if GetStringToken(wholeRow$, " ", 1) = "fight"
			state = GAME
			spActive = 0
			spType = STORYMODE
			aiActive = 1
			firstFight = 0
			SetCrabFromChapter(curChapter)
			SetFolder("/media/text")
			OpenToRead(2, "fights.txt")
			for i = 2 to curChapter
				ReadLine(2)
			next i
			st$ = GetStringToken(ReadLine(2), " ", curScene)
			SetCrabFromString(st$, 2)
			CloseFile(2)
			lineSkipTo = lineOverall+1
			TransitionStart(Random(1,lastTranType))
			//Need to mute music cues, leaving the game
			//Need to add an spType checker after the match is done, so the game comes right back here
			exit
		endif
		
		//Starting mirror game
		if GetStringToken(wholeRow$, " ", 1) = "mirror"
			state = GAME
			spActive = 1
			spType = MIRRORMODE
			storyMinScore = Val(GetStringToken(wholeRow$, " ", 2))
			lineSkipTo = lineOverall+1
			TransitionStart(Random(1,lastTranType))
			exit
		endif
		
		//Starting a classic game
		if GetStringToken(wholeRow$, " ", 1) = "classic"
			state = GAME
			spActive = 1
			spType = CLASSIC
			storyMinScore = Val(GetStringToken(wholeRow$, " ", 2))
			lineSkipTo = lineOverall+1
			TransitionStart(Random(1,lastTranType))
			exit
		endif
		
		//Making a crab leave
		if GetStringToken(wholeRow$, " ", 1) = "exit"
			if Val(GetStringToken(wholeRow$, " ", 2)) = 1
				//Crab 1 leaving
				PlayTweenSprite(SPR_CRAB1_COSTUME, SPR_CRAB1_BODY, 0)
				PlayTweenSprite(SPR_CRAB1_COSTUME, SPR_CRAB1_FACE, 0)
				PlayTweenSprite(SPR_CRAB1_COSTUME, SPR_CRAB1_COSTUME, 0)
				crabLType = 0
				crabLAlt = 0
			else
				//Crab 2 leaving
				PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_BODY, 0)
				PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_FACE, 0)
				PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_COSTUME, 0)
				crabRType = 0
				crabRAlt = 0
			endif
			wholeRow$ = ReadLine(1)
			inc lineOverall, 1
		endif
		
		//PART 2: Stage commands, which move a crab around, and remove themselves after being read
		
		//TODO: Check if there is a colon; this sets which crab is talking, then delete everything before the colon
		newCrabTalk = 0
		if CompareString(":", Mid(wholeRow$, 3, 1))
			newCrabTalk = 1
			SetCrabFromString(GetStringToken(wholeRow$, ":", 1), 3)
			if crabRefType <> crab1Type or crabRefAlt <> crab1Alt
				//Crab 2 is changing
				if crabRType = 0
					//Bringing a new crab from the side, when no crab was there originally
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_BODY, 0)
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_FACE, 0)
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_COSTUME, 0)
				elseif crabRType = crabRefType
					//Switching back to the right side crab
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_BODY, 0)
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_FACE, 0)
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_COSTUME, 0)
				else
					//A different crab is being put in spot 2
					PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_BODY, 0)
					PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_FACE, 0)
					PlayTweenSprite(SPR_CRAB2_COSTUME, SPR_CRAB2_COSTUME, 0)
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_BODY, .3)
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_FACE, .3)
					PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_COSTUME, .3)
				endif
				crabRType = crabRefType
				crabRAlt = crabRefAlt
			else
				//Crab 1 is changing 
				if crabLType = 0
					PlayTweenSprite(SPR_CRAB1_BODY, SPR_CRAB1_BODY, 0)
					PlayTweenSprite(SPR_CRAB1_BODY, SPR_CRAB1_FACE, 0)
					PlayTweenSprite(SPR_CRAB1_BODY, SPR_CRAB1_COSTUME, 0)
				else
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_BODY, 0)
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_FACE, 0)
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_COSTUME, 0)
				endif
				crabLType = crabRefType
				crabLAlt = crabRefAlt
			endif
			wholeRow$ = GetStringToken(wholeRow$, ":", 2)
		endif
		
		
		//TODO: Posing: Grab everything before a semicolon, formatted like 'b12f5'
		//Set those images for the assiciated crab's sprites
		//Grab the chibi life number for later use, choose which one based on the face used
		//Delete the old images if things changed, can maybe use a variable to store & load the previous images index?
		
		
		//TODO: Delete any spaces before the actual dialouge starts
		if CompareString(" ", Mid(wholeRow$, 1, 1)) then wholeRow$ = Mid(wholeRow$, 2, -1)
		
		//The start of the normal dialogue box processing
		wholeRow$ = wholeRow$ + " " //Adding a space to the end of the line for easier processing.
		displayString$ = ""			//The string that is being shown, with line breaks; text moves to here from wholeRow.
		curPos = 0					//The positioning system for the below while loop.
		curChar$ = ""				//The current character at the curPos.
		lastSpacePos = 1				//Keeping track of where the previous space was, so that the line breaks can happen after the overage width is passed.
		
		//Preparing the visuals for the next go-around
		SetTextString(storyText4, GetTextString(storyText3))
		SetTextString(storyText3, GetTextString(storyText2))
		SetTextString(storyText2, GetTextString(storyText))
		
		while curPos <> Len(wholeRow$)
			inc curPos, 1
			curChar$ = Mid(wholeRow$, curPos, 1)
			
			//If the current character is a space, then a linebreak may happen
			if curChar$ = " "
				
				//This checks if the wholeRow, up to the current position, inside of a formatted string, is longer than the textbox width.
				newLine = 0
				SetTextString(storyFitter, Mid(wholeRow$, 1, curPos))
				if (GetTextTotalWidth(storyFitter) > GetSpriteWidth(SPR_TEXT_BOX)-40)
					newLine = 1
				endif
				
				//This takes the current line, up to the word before it went overwidth, and puts it in the display string.
				//The processing line is then shortened, and the position is reset.
				if newLine
					displayString$ = displayString$ + Mid(wholeRow$, 1, lastSpacePos) + chr(10)
					wholeRow$ = Mid(wholeRow$, lastSpacePos+1, len(wholeRow$)-lastSpacePos)
					curPos = 0
				endif
				
				//This takes the position of the previous space character, to be used in line splicing.
				lastSpacePos = curPos
			endif
		endwhile
		displayString$ = displayString$ + wholeRow$  + "        "	//Adding the remainder of the row into the display string.
		
		SetTextString(storyText, displayString$)		//Publicly displaying the edited string.
		
		
		
		//Waiting for the user input before continuing.
		nextLine = 0
		showPos = 1
		lineNum = 0
		
		PlaySoundR(fwipS, volumeSE)
		for i = SPR_TEXT_BOX to SPR_TEXT_BOX4
			if boxNum >= i-SPR_TEXT_BOX then PlayTweenSprite(i, i, 0)
			if boxNum = i-SPR_TEXT_BOX then SetSpriteColorAlpha(i, 255)
		next i
		for i = storyText to storyText4			
			if GetTweenTextExists(i) and boxNum >= i-storyText then PlayTweenText(i, i, 0)
			if boxNum = i-storyText then SetTextColorAlpha(i, 255)
		next i
		
		//Creating seperate tweens for lines 1 through 4
		for i = 0 to 3
			if GetTweenExists(storyFitter + i) then DeleteTween(storyFitter + i)
			CreateTweenChar(storyFitter + i, .05)
			SetTweenCharAlpha(storyFitter + i, 0, 255, TweenSmooth1())
			SetTweenCharY(storyFitter + i, -GetTextSize(storyText) + GetTextSize(storyText)*(i-.7), GetTextSize(storyText)*i, TweenOvershoot())
		next i
		
		//The delay for punctuation
		delay# = 0
		for i = 0 to len(displayString$)
			SetTextCharColorAlpha(storyText, i, 0)
			
			if Mid(displayString$, i+1, 1) = chr(10) and lineNum < 3
				inc lineNum, 1
			endif
			PlayTweenChar(storyFitter+lineNum, storyText, i, .02*i + delay#)
			
			//Adding delays following punctuation
			if Mid(displayString$, i+1, 1) = "." then inc delay#, .1
			if Mid(displayString$, i+1, 1) = "," then inc delay#, .08
			if Mid(displayString$, i+1, 1) = "?" then inc delay#, .12
			if Mid(displayString$, i+1, 1) = "!" then inc delay#, .12
		next i
		
		charSounded = 1
		
		hurryUp = 0
		while nextLine = 0
			storyInput = 0
			if GetPointerPressed() or GetRawKeyPressed(32) then storyInput = 1
			if GetTextCharColorAlpha(storyText, charSounded) = 255 and GetTextCharColorAlpha(storyText, Len(displayString$)-9) = 0
				PlaySoundR(talk1S, volumeSE/(hurryUp/2+1))
				inc charSounded, 1
			endif
			if storyInput
				hurryUp = 1
			endif
			if hurryUp then UpdateAllTweens(.1)
			if storyInput and GetTweenCharPlaying(storyFitter, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+1, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+2, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+3, storyText, len(displayString$)) = 0 then nextLine = 1
			SyncG()
		endwhile
		
		inc boxNum, 1
		wholeRow$ = ReadLine(1)	//Reading the new line of the text file.
		inc lineOverall, 1
		
		if CompareString(wholeRow$, "") = 1
			state = StartEndScreen()
		endif
		
	endwhile
	
	CloseFile(1)
	
endfunction state

function SetStoryCrabSprites()
	
	
	
endfunction

function StartEndScreen()
	state = STORY
	
	inc curScene, 1
	highestScene = Max(highestScene, curChapter*4+curScene)
	lineSkipTo = 0
	
	for i = 0 to 2
		CreateTextExpress(TXT_RESULT1 + i, "", 80, fontCrabI, 1, w/2, 240 + 85*i, 6)
		SetTextColorAlpha(TXT_RESULT1 + i, 254)
	next i
	if curScene = 5	//This is set to one higher than 4, because the scene will increment before calling this scene
		SetTextString(TXT_RESULT1, crab1Str$)
		SetTextString(TXT_RESULT2, "STORY")
		SetTextString(TXT_RESULT3, "CLEAR!")
		for i = TXT_RESULT1 to TXT_RESULT2
			CreateTweenText(i, .3)
			SetTweenTextSize(i, 1, 80, TweenSmooth2())
		next i		
	else
		SetTextString(TXT_RESULT1, "-SCENE-")
		SetTextString(TXT_RESULT2, "-CLEAR-")
		if GetTweenExists(TXT_RESULT1) then DeleteTween(TXT_RESULT1)
		if GetTweenExists(TXT_RESULT2) then DeleteTween(TXT_RESULT2)
		CreateTweenText(TXT_RESULT1, .3)
		CreateTweenText(TXT_RESULT2, .3)
		SetTweenTextX(TXT_RESULT1, -w, w/2 + 20, TweenSmooth2())
		SetTweenTextX(TXT_RESULT2, w*2, w/2 - 20, TweenSmooth2())
		SetTextX(TXT_RESULT1, -w)
		SetTextX(TXT_RESULT2, -w)
	endif
	
	SetFolder("/media/ui")
	
	LoadSpriteExpress(playButton, "rightarrow.png", 265, 265, 0, 0, 4)
	SetSpriteMiddleScreen(playButton)
	IncSpriteY(playButton, 160)
	IncSpriteX(playButton, 60)
	SetSpriteColorAlpha(playButton, 0)
	AddButton(playButton)
	
	LoadSpriteExpress(exitButton, "crabselect.png", 240, 240, 0, 0, 4)
	SetSpriteMiddleScreen(exitButton)
	IncSpriteY(exitButton, 570)
	IncSpriteX(exitButton, -210)
	SetSpriteColorAlpha(exitButton, 0)
	AddButton(exitButton)
	
	//TODO - Play music sting for finishing
	
	PlayTweenSprite(tweenSprFadeIn, exitButton, 1)
	//Make tweens for the text to slide in!
	
	if curScene = 5
		//End of chapter
		SetSpriteMiddleScreen(exitButton)
		IncSpriteY(exitButton, 300)
		
	else
		//End of scene
		
		PlayTweenText(TXT_RESULT1, TXT_RESULT1, 0)
		PlayTweenText(TXT_RESULT2, TXT_RESULT2, .3)
		PlayTweenSprite(tweenSprFadeIn, playButton, 1)
	endif
	
	ExitStory()
	
	state = DoStoryEndScreen()
	
endfunction state

function DoStoryEndScreen()
	state = STORY
	
	endDone = 0
	while (endDone = 0)
		
		if curScene < 5
			if GetTextX(TXT_RESULT1) > w/2 and GetTextColorAlpha(TXT_RESULT1) <> 255
				PlaySoundR(chooseS, volumeSE)
				SetTextColorAlpha(TXT_RESULT1, 255)
			endif
			if GetTextX(TXT_RESULT2) < w/2 and GetTextColorAlpha(TXT_RESULT2) <> 255
				PlaySoundR(chooseS, volumeSE)
				SetTextColorAlpha(TXT_RESULT2, 255)
			endif
		else
			//End of story scene
			for i = TXT_RESULT1 to TXT_RESULT3
				if GetTextSize(i) > 79 and GetTextColorAlpha(i) <> 255
					PlaySoundR(chooseS, volumeSE)
					SetTextColorAlpha(i, 255)
				endif
			next i
		endif
		
		if ButtonMultitouchEnabled(playButton) and GetSpriteColorAlpha(playButton) > 100
			endDone = 1
		elseif ButtonMultitouchEnabled(exitButton) and GetSpriteColorAlpha(exitButton) > 100
			state = CHARACTER_SELECT
			endDone = 1
		endif
		
		SyncG()		
	endwhile
	
	StopGamePlayMusic()
	
	TransitionStart(Random(1, lastTranType))
	for i = TXT_RESULT1 to TXT_RESULT3
		if GetTextExists(i) then DeleteText(i)
		if GetTweenTextExists(i) then DeleteTween(i)
	next i
	DeleteSprite(playButton)
	DeleteSprite(exitButton)
	
	
	
endfunction state

function SetCrabFromChapter(chap)
	crabID = 0
	chapterTitle$ = chapterDesc[chap]
	
	if chap = 1	//Space Crab
		crab1Type = 1
		crab1Alt = 0
		
	elseif chap = 2	//Ladder Wizard
		crab1Type = 2
		crab1Alt = 0
		
	elseif chap = 3	//#1 Fan Crab
		crab1Type = 4
		crab1Alt = 1
		
	elseif chap = 4	//Top Crab
		crab1Type = 3
		crab1Alt = 0
		
	elseif chap = 5	//King Crab
		crab1Type = 2
		crab1Alt = 1
		
	elseif chap = 6	//Inianda Jeff
		crab1Type = 5
		crab1Alt = 1
		
	elseif chap = 7	//Taxi Crab
		crab1Type = 3
		crab1Alt = 1
		
	elseif chap = 8	//Hawaiian Crab
		crab1Type = 4
		crab1Alt = 2
		
	elseif chap = 9	//Team Player
		crab1Type = 6
		crab1Alt = 1
		
	elseif chap = 10	//Rock Lobster
		crab1Type = 5
		crab1Alt = 2
		
	elseif chap = 11	//Ninja Crab
		crab1Type = 6
		crab1Alt = 0
		
	elseif chap = 12	//Crab Cake
		crab1Type = 5
		crab1Alt = 3
		
	elseif chap = 13	//Cranime
		crab1Type = 6
		crab1Alt = 2
		
	elseif chap = 14	//Crabicus
		crab1Type = 2
		crab1Alt = 2
		
	elseif chap = 15	//Rave Crab
		crab1Type = 4
		crab1Alt = 0
		
	elseif chap = 16	//Mad Crab
		crab1Type = 1
		crab1Alt = 1
		
	elseif chap = 17	//Holy Crab
		crab1Type = 4
		crab1Alt = 3
		
	elseif chap = 18	//Al Legal
		crab1Type = 1
		crab1Alt = 2
		
	elseif chap = 19	//Space Barc
		crab1Type = 3
		crab1Alt = 2
		
	elseif chap = 20	//Crabyss Knight
		crab1Type = 2
		crab1Alt = 3
		
	elseif chap = 21	//Chrono Crab
		crab1Type = 5
		crab1Alt = 0
		
	elseif chap = 22	//Space Crab 2
		crab1Type = 1
		crab1Alt = 0
		
	elseif chap = 23	//Future Crab
		crab1Type = 1
		crab1Alt = 3
		
	endif
	SetCrabString(1)
	
endfunction

function SetCrabString(crabNum)
	newStr$ = ""
	myType = 0
	myAlt = 0
	if crabNum = 1
		myType = crab1Type
		myAlt = crab1Alt
	else
		//Crab 2
		myType = crab2Type
		myAlt = crab2Alt
	endif
	
	if myType = 1
		if myAlt = 0 then newStr$ = "Space Crab"
		if myAlt = 1 then newStr$ = "Mad Crab"
		if myAlt = 2 then newStr$ = "Al Legal"
		if myAlt = 3 then newStr$ = "Future Crab"
	elseif myType = 2
		if myAlt = 0 then newStr$ = "Ladder Wizard"
		if myAlt = 1 then newStr$ = "King Crab"
		if myAlt = 2 then newStr$ = "Crabicus"
		if myAlt = 3 then newStr$ = "Crabyss Knight"
	elseif myType = 3
		if myAlt = 0 then newStr$ = "Top Crab"
		if myAlt = 1 then newStr$ = "Taxi Crab"
		if myAlt = 2 then newStr$ = "Space Barc"
	elseif myType = 4
		if myAlt = 0 then newStr$ = "Rave Crab"
		if myAlt = 1 then newStr$ = "#1 Fan Crab"
		if myAlt = 2 then newStr$ = "Hawaiian Crab"
		if myAlt = 3 then newStr$ = "Holy Crab"
	elseif myType = 5
		if myAlt = 0 then newStr$ = "Chrono Crab"
		if myAlt = 1 then newStr$ = "Inianda Jeff"
		if myAlt = 2 then newStr$ = "Rock Lobster"
		if myAlt = 3 then newStr$ = "Crab Cake"
	elseif myType = 6
		if myAlt = 0 then newStr$ = "Ninja Crab"
		if myAlt = 1 then newStr$ = "Team Player"
		if myAlt = 2 then newStr$ = "Cranime"
	endif
	
	if crabNum = 1 then crab1Str$ = newStr$
	if crabNum = 2 then crab2Str$ = newStr$
endfunction

function SetCrabFromString(str$, crabNum)

	myType = 0
	myAlt = 0

	
	if str$ = "SC"	//Space Crab
		mType = 1
		mAlt = 0
		
	elseif str$ = "LW" //Ladder Wizard
		mType = 2
		mAlt = 0
		
	elseif str$ = "FC"	//#1 Fan Crab
		mType = 4
		mAlt = 1
		
	elseif str$ = "TC"	//Top Crab
		mType = 3
		mAlt = 0
		
	elseif str$ = "KC"	//King Crab
		mType = 2
		mAlt = 1
		
	elseif str$ = "IJ"	//Inianda Jeff
		mType = 5
		mAlt = 1
		
	elseif str$ = "TX"	//Taxi Crab
		mType = 3
		mAlt = 1
		
	elseif str$ = "HC"	//Hawaiian Crab
		mType = 4
		mAlt = 2
		
	elseif str$ = "TP"	//Team Player
		mType = 6
		mAlt = 1
		
	elseif str$ = "RL"	//Rock Lobster
		mType = 5
		mAlt = 2
		
	elseif str$ = "NC"	//Ninja Crab
		mType = 6
		mAlt = 0
		
	elseif str$ = "CE"	//Crab Cake
		mType = 5
		mAlt = 3
		
	elseif str$ = "CR"	//Cranime
		mType = 6
		mAlt = 2
		
	elseif str$ = "CB"	//Crabicus
		mType = 2
		mAlt = 2
		
	elseif str$ = "RC"	//Rave Crab
		mType = 4
		mAlt = 0
		
	elseif str$ = "MC"	//Mad Crab
		mType = 1
		mAlt = 1
		
	elseif str$ = "HO"	//Holy Crab
		mType = 4
		mAlt = 3
		
	elseif str$ = "AL"	//Al Legal
		mType = 1
		mAlt = 2
		
	elseif str$ = "SB"	//Space Barc
		mType = 3
		mAlt = 2
		
	elseif str$ = "CK"	//Crabyss Knight
		mType = 2
		mAlt = 3
		
	elseif str$ = "SC"	//Chrono Crab
		mType = 5
		mAlt = 0
		
	elseif str$ = "FU"	//Future Crab
		mType = 1
		mAlt = 3
		
	endif
	
	if crabNum = 1
		crab1Type = mType
		crab1Alt = mAlt
	elseif crabNum = 2
		crab2Type = mType
		crab2Alt = mAlt
	else
		crabRefType = mType
		crabRefAlt = mAlt
	endif
	SetCrabString(crabNum)
	
endfunction
	