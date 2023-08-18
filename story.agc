// File: story.agc
// Created: 23-06-20

global storyStateInitialized as integer = 0

// Initialize the story screen
function InitStory()
	
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
	cSize = 400
	for i = SPR_CRAB1_BODY to SPR_CRAB2_COSTUME
		CreateSpriteExpress(i, cSize, cSize, -cSize, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX), 5)
		//if i <= SPR_CRAB1_COSTUME then Set		
	next i 
	
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
		next i
		
	else
		
		DeleteText(storyText)
		DeleteSprite(playButton)
		DeleteSprite(exitButton)
		
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
		SceneFile$ = "chap" + Str((sceneNum-1)/4) + "_" + Str(Mod(sceneNum, 4)) + ".txt"
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
	
	//This whill iterates through the entire text file, one line at a time
	while (CompareString(wholeRow$, "") = 0)		
		
		//TODO: Read enterR, enterL, or exit; assign that crab to the sprites on that side of the screen
		//Revised: The main crab of the chapter will always be on the left
		
		//TODO: Check if there is a colon; this sets which crab is talking, then delete everything before the colon
		newCrabTalk = 0
		if CompareString(":", Mid(wholeRow$, 3, 1)) then newCrabTalk = 1
		
		//Doing any music changes
		if GetStringToken(wholeRow$, " ", 1) = "music"
			PlayMusicOGGSPStr(GetStringToken(wholeRow$, " ", 2), Val(GetStringToken(wholeRow$, " ", 3)))
			wholeRow$ = ReadLine(1)
			inc lineOverall, 1
		endif
				
		//Starting a VS match
		if GetStringToken(wholeRow$, " ", 1) = "fight"
			exit
		endif
		
		//Starting mirror game
		if GetStringToken(wholeRow$, " ", 1) = "fight"
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
		
		//TODO: Posing: Grab everything before a semicolon, formatted like 'b12f5'
		//Set those images for the assiciated crab's sprites
		//Grab the chibi life number for later use, choose which one based on the face used
		//Delete the old images if things changed, can maybe use a variable to store & load the previous images index?
		
		
		//TODO: Delete any spaces before the actual dialouge starts
		
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
		
		hurryUp = 0
		while nextLine = 0

			if GetRawKeyPressed(32)
				hurryUp = 1
			endif
			if hurryUp then UpdateAllTweens(.1)
			if GetRawKeyPressed(32) and GetTweenCharPlaying(storyFitter, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+1, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+2, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+3, storyText, len(displayString$)) = 0 then nextLine = 1
			SyncG()
			Print(boxNum)
		endwhile
		
		inc boxNum, 1
		wholeRow$ = ReadLine(1)	//Reading the new line of the text file.
		inc lineOverall, 1
		
	endwhile
	
	CloseFile(1)
	
endfunction state

function SetStoryCrabSprites()
	
	
	
endfunction

function StartEndScreen()
	for i = 0 to 2
		CreateTextExpress(TXT_RESULT1 + i, "", 80, fontCrabI, 1, w/2, 240 + 85*i, 6)
	next i
	if curScene = 5	//This is set to one higher than 4, because the scene will increment before calling this scene
		SetTextString(TXT_RESULT1, crab1Str$)
		SetTextString(TXT_RESULT2, "STORY")
		SetTextString(TXT_RESULT3, "CLEAR!")
	else
		SetTextString(TXT_RESULT1, "-SCENE-")
		SetTextString(TXT_RESULT2, "-CLEAR-")
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
	PlayTweenText(tweenTxtFadeIn, TXT_RESULT1, 0,)
	PlayTweenText(tweenTxtFadeIn, TXT_RESULT2)
	
	if curScene = 5
		
		SetSpriteMiddleScreen(exitButton)
		IncSpriteY(exitButton, 300)
		
	else
		
		
		PlayTweenSprite(tweenSprFadeIn, playButton, 1)
	endif
	
	DoStoryEndScreen()	
	
endfunction

function DoStoryEndScreen()
	endDone = 0
	while (endDone = 0)
		
		if ButtonMultitouchEnabled(playButton)
		
		SyncG()		
	endwhile
	
	TransitionStart(Random(1, lastTranType))
	DeleteText(TXT_RESULT1)
	DeleteText(TXT_RESULT2)
	DeleteText(TXT_RESULT3)
	DeleteSprite(playButton)
	DeleteSprite(exitButton)
	
endfunction

function SetCrabFromChapter(chap)
	crabID = 0
	chapterTitle$ = ""
	
	if chap = 1	//Space Crab
		crab1Type = 1
		crab1Alt = 0
		chapterTitle$ = "The Idea"
		
	elseif chap = 2	//Ladder Wizard
		crab1Type = 2
		crab1Alt = 0
		chapterTitle$ = "The Strategy"
		
	elseif chap = 3	//#1 Fan Crab
		crab1Type = 4
		crab1Alt = 1
		chapterTitle$ = ""
		
	elseif chap = 4	//Top Crab
		crab1Type = 3
		crab1Alt = 0
		chapterTitle$ = ""
		
	elseif chap = 5	//King Crab
		crab1Type = 2
		crab1Alt = 1
		chapterTitle$ = "The Political Influence"
		
	elseif chap = 6	//Inianda Jeff
		crab1Type = 5
		crab1Alt = 1
		chapterTitle$ = "The Adventurer"
		
	elseif chap = 7	//Taxi Crab
		crab1Type = 3
		crab1Alt = 1
		chapterTitle$ = "The Transportation Expert"
		
	elseif chap = 8	//Hawaiian Crab
		crab1Type = 4
		crab1Alt = 2
		chapterTitle$ = ""
		
	elseif chap = 9	//Team Player
		crab1Type = 6
		crab1Alt = 1
		chapterTitle$ = ""
		
	elseif chap = 10	//Rock Lobster
		crab1Type = 5
		crab1Alt = 2
		chapterTitle$ = "Mister Music"
		
	elseif chap = 11	//Ninja Crab
		crab1Type = 6
		crab1Alt = 0
		chapterTitle$ = ""
		
	elseif chap = 12	//Crab Cake
		crab1Type = 5
		crab1Alt = 3
		chapterTitle$ = "The Cosmic Cook"
		
	elseif chap = 13	//Cranime
		crab1Type = 6
		crab1Alt = 2
		chapterTitle$ = "Single & Mingling"
		
	elseif chap = 14	//Crabicus
		crab1Type = 2
		crab1Alt = 2
		chapterTitle$ = "The Calculator?"
		
	elseif chap = 15	//Rave Crab
		crab1Type = 4
		crab1Alt = 0
		chapterTitle$ = "The Party...?"
		
	elseif chap = 16	//Mad Crab
		crab1Type = 1
		crab1Alt = 1
		chapterTitle$ = "The Voice of Reason"
		
	elseif chap = 17	//Holy Crab
		crab1Type = 4
		crab1Alt = 3
		chapterTitle$ = "The Divine Eye-in-the-Sky"
		
	elseif chap = 18	//Al Legal
		crab1Type = 1
		crab1Alt = 2
		chapterTitle$ = "The Crab Resources Department"
		
	elseif chap = 19	//Space Barc
		crab1Type = 3
		crab1Alt = 2
		chapterTitle$ = "The Other Side of the Paw"
		
	elseif chap = 20	//Crabyss Knight
		crab1Type = 2
		crab1Alt = 3
		chapterTitle$ = "The Valiant Defender"
		
	elseif chap = 21	//Chrono Crab
		crab1Type = 5
		crab1Alt = 0
		chapterTitle$ = "The Starlight Rival"
		
	elseif chap = 22	//Space Crab 2
		crab1Type = 1
		crab1Alt = 0
		chapterTitle$ = "Fight for the Future!"
		
	elseif chap = 23	//Future Crab
		crab1Type = 1
		crab1Alt = 3
		chapterTitle$ = ""
		
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