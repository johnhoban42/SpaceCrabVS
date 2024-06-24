// File: story.agc
// Created: 23-06-20

global storyStateInitialized as integer = 0
global talk1S
global talkBS
global trashBag as integer[0]

#constant textSideSpacingX 35
#constant textSideSpacingY 22
#constant textLineSpacing -6
// Initialize the story screen
function InitStory()
	
	storyActive = 1
	
	SetSpriteVisible(split, 0)
	
	//Size of the crab drawings
	cSize = 360
	if dispH then cSize = 240
	
	SetFolder("/media/storysprites")
	
	for i = SPR_TEXT_BOX to SPR_TEXT_BOX4
		if dispH
			LoadSpriteExpress(i, "dBox_D.png", w-80 - cSize*2, 190, 0, 0, 15-(i-SPR_TEXT_BOX))
		else
			//TODO - make the image dBox_M
			LoadSpriteExpress(i, "dBox_M.png", w-80, 280, 0, 0, 15-(i-SPR_TEXT_BOX))
		endif
			
		//SetSpriteSize(i, GetSpriteWidth(i), GetSpriteHeight(i) + 30)	//Originally for the bottom one
		SetSpriteMiddleScreenX(i)
		SetSpriteY(i, h/2 + 70 - (i - SPR_TEXT_BOX)*(GetSpriteHeight(i) + 60))
		//if dispH then SetSpriteY(i, h - GetSpriteHeight(i) - 90 - (i - SPR_TEXT_BOX)*(GetSpriteHeight(i) + 30))
		if dispH then SetSpriteY(i, h - GetSpriteHeight(i) - 125 - (i - SPR_TEXT_BOX)*(GetSpriteHeight(i) + 14))
		FixSpriteToScreen(i, 1)
		
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
		CreateTextExpress(i, "", 56, fontDescI, 0, GetSpriteX(SPR_TEXT_BOX)+textSideSpacingX, GetSpriteY(SPR_TEXT_BOX)+textSideSpacingY, 15-(i-storyText))
		if i < storyFitter then SetTextY(i, GetSpriteY(i - storyText + SPR_TEXT_BOX)+textSideSpacingY)
		SetTextSpacing(i, -14)
		SetTextLineSpacing(i, textLineSpacing)
		SetTextColor(i, 0, 0, 0, 255)
		CreateTweenText(i, .3)
		FixTextToScreen(i, 1)
		if i > storyText
			SetTweenTextY(i, GetTextY(i) + (GetSpriteHeight(SPR_TEXT_BOX) + 20), GetTextY(i), TweenEaseOut2())
			SetTextColorAlpha(i, 0)
		endif
		if dispH
			SetTextSize(i, 45)
			SetTextSpacing(i, -12)
		endif
	next i
	
	//SetTweenTextAlpha(storyText, 155, 255, TweenSmooth2())
	
	SetTextColorAlpha(storyFitter, 0)
	
	
	SetTweenSpriteAlpha(SPR_TEXT_BOX4, 255, 0, TweenEaseOut2())
	SetTweenTextAlpha(storyText4, 255, 0, TweenEaseOut2())
	
	//Load the difference faces/bodies as animation frames, then set the frame for different faces
	//Load the costume as it comes, use the body frame number to load the correct costume file string number
	for i = SPR_CRAB1_BODY to SPR_CRAB2_COSTUME
		CreateSpriteExpress(i, cSize, cSize, -cSize*3, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) - 10, 5)
		if dispH then SetSpriteY(i, h - 20 - cSize)
		if i < SPR_CRAB2_BODY then SetSpriteFlip(i, 1, 0)
		//if i <= SPR_CRAB1_COSTUME then Set		
	next i 
	
	CreateTweenSprite(SPR_CRAB1_BODY, .5)
	SetTweenSpriteX(SPR_CRAB1_BODY, -cSize, 20, TweenSmooth1())
	CreateTweenSprite(SPR_CRAB2_BODY, .5)
	SetTweenSpriteX(SPR_CRAB2_BODY, w, w-cSize-20, TweenSmooth1())
	
	SetSpritePosition(SPR_CRAB1_FACE, 20, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) - 10)
	SetSpritePosition(SPR_CRAB2_FACE, w-cSize-20, GetSpriteY(SPR_TEXT_BOX) + GetSpriteHeight(SPR_TEXT_BOX) - 10)
	if dispH
		SetSpriteY(SPR_CRAB1_FACE, h-20-cSize)
		SetSpriteY(SPR_CRAB2_FACE, h-20-cSize)
	endif
	
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
	
	CreateTweenSprite(SPR_CRAB2_COSTUME, .1)
	SetTweenSpriteX(SPR_CRAB2_COSTUME, w-cSize-20, w+200, TweenSmooth2())
	
	CreateTweenSprite(SPR_CRAB1_COSTUME, .3)
	SetTweenSpriteX(SPR_CRAB1_COSTUME, 20, -cSize-200, TweenSmooth2())
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
	
	if GetSpriteExists(bgGame1) then DeleteSprite(bgGame1)
	if dispH = 0 then CreateSpriteExpress(bgGame1, h, h, -h/2, 0, 99)
	if dispH then CreateSpriteExpress(bgGame1, w*1.2, w*1.2, -w*.1, -w*.6, 99)
	FixSpriteToScreen(bgGame1, 1)
	
	storyTimer# = 0
	
	//Creating the buttons
	SetFolder("/media")
	LoadSpriteExpress(SPR_STORY_EXIT, "ui/back8.png", 130, 130, 40, 20, 5)
	FixSpriteToScreen(SPR_STORY_EXIT, 1)
	AddButton(SPR_STORY_EXIT)
	LoadSpriteExpress(SPR_STORY_SKIP, "ui/skip.png", 130, 130, w-130-40, 20, 5)
	FixSpriteToScreen(SPR_STORY_SKIP, 1)
	AddButton(SPR_STORY_SKIP)
	if dispH 
		IncSpriteY(SPR_STORY_EXIT, 9999)
		IncSpriteY(SPR_STORY_SKIP, 9999)
	endif
	
	storyStateInitialized = 1
endfunction

function InitResultsRetry()
	CreateTextExpress(storyText, "You were supposed" + chr(10) + "to win that one..." + chr(10) + chr(10) + "Try again?", 102, fontCrabI, 1, w/2, 350, 10)
	SetTextSpacing(storyText, -30)
	SetTextColor(storyText, 0, 0, 0, 255)
	if dispH
		SetTextSize(storyText, 92)
		SetTextY(storyText, 20)
		
	endif
	
	spScore = 0

	if GetSpriteExists(coverS) = 0 then CreateSpriteExpress(coverS, w, h, 0, 0, 15)

	SetSpriteDepth(coverS, 15)

	SetFolder("/media/ui")

	LoadSpriteExpress(playButton, "restart.png", 265, 265, 0, 0, 4)
	if dispH then SetSpriteSizeSquare(playButton, 225)
	SetSpriteMiddleScreen(playButton)
	IncSpriteY(playButton, 160)
	//IncSpriteX(playButton, 180)
	//IncSpriteY(playButton, 280)
	if dispH then IncSpriteY(playButton, 36)
	
	LoadSpriteExpress(exitButton, "crabselect.png", 190, 190, 0, 0, 4)
	if dispH then SetSpriteSizeSquare(exitButton, 150)
	SetSpriteMiddleScreen(exitButton)
	if dispH = 0
		IncSpriteY(exitButton, 570)
		IncSpriteX(exitButton, -210)
	else
		IncSpriteY(exitButton, 250)
		IncSpriteX(exitButton, -450)
	endif
	if spType = CHALLENGEMODE then SetSpriteVisible(exitButton, 0)
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
		state = ShowScene(curChapter, curScene)
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
		
		if ButtonMultitouchEnabled(playButton) or (inputSelect and selectTarget = 0)
			inc lineSkipTo, -2
			if spType <> CHALLENGEMODE
				state = ShowScene(curChapter, curScene)
			else
				SetupChallenge()
				state = GAME
				TransitionStart(Random(1,lastTranType))
			endif
			
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
		if GetSpriteExists(bgGame1) then DeleteSprite(bgGame1)
		ExitStory(1)
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStory(deleteBG)
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
		DeleteSprite(SPR_STORY_EXIT)
		DeleteSprite(SPR_STORY_SKIP)
	else
		
		DeleteText(storyText)
		DeleteSprite(playButton)
		DeleteSprite(exitButton)
		
		if GetMusicPlayingOGGSP(loserMusic) then StopMusicOGGSP(loserMusic)
		
		storyRetry = 0
	endif
	
	if GetSpriteExists(bgGame1) and deleteBG
		DeleteSprite(bgGame1)
	endif
	
	if GetSpriteExists(coverS) then DeleteSprite(coverS)
	
	storyStateInitialized = 0
	
endfunction

function ShowScene(chap, scene)
	state = story
	
	storyActive = 1
	TransitionEnd()
	
	SetFolder("/media/text")
	
	if scene = 0
		SceneFile$ = "testScene.txt"
	else
		SceneFile$ = "chap" + Str(chap) + "_" + Str(scene) + ".txt"
	endif
	SetCrabFromChapter(curChapter)
	
	OpenToRead(1, SceneFile$)
	boxNum = 0
		
	wholeRow$ = ReadLine(1)
	lineOverall = 1
	
	//Firstly, loading the background image
	if GetStringToken(wholeRow$, " ", 1) = "bg"
		if GetSpriteExists(bgGame1) then SetSpriteImage(bgGame1, bg1I - 1 + Val(GetStringToken(wholeRow$, " ", 2)))
		wholeRow$ = ReadLine(1)
		//inc lineOverall, 1
	endif
	
	fightDone = 0
	//This returns from a fight, so the correct line is started from.
	for i = 1 to lineSkipTo-1
		fightDone = 1
		wholeRow$ = ReadLine(1)
		inc lineOverall, 1
		if GetSpriteExists(SPR_STORY_EXIT) then SetSpriteVisible(SPR_STORY_EXIT, 0)
	next i
	
	crabLType = 0
	crabLAlt = 0
	crabRType = 0
	crabRAlt = 0
	targetCrab = 0
	
	soundeffect = 0
	
	//This whill iterates through the entire text file, one line at a time
	while (CompareString(wholeRow$, "") = 0) and state = STORY	
		
		//PART 1: Commands, that skip to the next line
		
		//Doing any music changes
		if GetStringToken(wholeRow$, " ", 1) = "music"
			loopM = Val(GetStringToken(wholeRow$, " ", 3))
			if (GetStringToken(wholeRow$, " ", 3)) = "" then loopM = 1
			PlayMusicOGGSPStr(GetStringToken(wholeRow$, " ", 2), loopM)
			wholeRow$ = ReadLine(1)
			inc lineOverall, 1
		endif
		
		//Playing a sound effect
		if GetStringToken(wholeRow$, " ", 1) = "se"
			if GetMusicExistsOgg(soundeffect) then DeleteMusicOgg(soundeffect)
			SetFolder("/media/sounds")
			soundeffect = LoadMusicOGG(GetStringToken(wholeRow$, " ", 2) + ".ogg")
			PlayMusicOGG(soundeffect, 0)
			SetMusicVolumeOGG(soundeffect, volumeSE)
			wholeRow$ = ReadLine(1)
			inc lineOverall, 1
		endif
				
		//Starting a VS match
		if GetStringToken(wholeRow$, " ", 1) = "fight"
			state = GAME
			spActive = 0
			spType = STORYMODE
			ai$ = GetStringToken(wholeRow$, " ", 2)
			if Len(ai$) = 5 then SetAIDifficulty(Val(Mid(ai$, 1, 1))-storyEasy*4, Val(Mid(ai$, 2, 1)), Val(Mid(ai$, 3, 1)), Val(Mid(ai$, 4, 1)), Val(Mid(ai$, 5, 1)))
			knowingAI = Val(Mid(ai$, 5, 1))
			firstFight = 0
			SetCrabFromChapter(curChapter)
			SetFolder("/media/text")
			OpenToRead(2, "fights.txt")
			for i = 2 to curChapter
				ReadLine(2)
			next i
			st$ = Mid(GetStringToken(ReadLine(2), " ", curScene), 1, 2)
			SetCrabFromStringChap(st$, 0, 2)
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
			if GetSpriteExists(SPR_CRAB1_BODY)
				PlayMirrorModeScene()
				Sleep(1000)
			else
				TransitionStart(Random(1,lastTranType))
			endif
			crab2Type = crab1Type
			crab2Alt = crab1Alt
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
			if GetStringToken(wholeRow$, ":", 1) <> "??"
				SetCrabFromStringChap(GetStringToken(wholeRow$, ":", 1), 0, 3)
				dCol = 180
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
						PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_BODY, .1)
						PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_FACE, .1)
						PlayTweenSprite(SPR_CRAB2_BODY, SPR_CRAB2_COSTUME, .1)
					endif
					crabRType = crabRefType
					crabRAlt = crabRefAlt
					crab2Type = crabRefType
					crab2Alt = crabRefAlt
					targetCrab = 2
					
					//Making crab 2 brighter
					SetSpriteColor(SPR_CRAB2_FACE, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB2_BODY, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB2_COSTUME, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB1_FACE, dCol, dCol, dCol, 255)
					SetSpriteColor(SPR_CRAB1_BODY, dCol, dCol, dCol, 255)
					SetSpriteColor(SPR_CRAB1_COSTUME, dCol, dCol, dCol, 255)
					
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
					targetCrab = 1
					
					//Making crab 1 brighter
					SetSpriteColor(SPR_CRAB1_FACE, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB1_BODY, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB1_COSTUME, 255, 255, 255, 255)
					SetSpriteColor(SPR_CRAB2_FACE, dCol, dCol, dCol, 255)
					SetSpriteColor(SPR_CRAB2_BODY, dCol, dCol, dCol, 255)
					SetSpriteColor(SPR_CRAB2_COSTUME, dCol, dCol, dCol, 255)
					
				endif
				wholeRow$ = GetStringToken(wholeRow$, ":", 2)
			else
				targetCrab = 2
			endif
		endif
		
		if FindString(wholeRow$, ";") <> 0
			str$ = GetStringToken(wholeRow$, ";", 1)
			body$ = Mid(str$, FindString(str$, "B")+1, 1)
			face$ = Mid(str$, FindString(str$, "F")+1, -1)
			
			//For Z faces
			z$ = ""
			if body$ = "Z" then z$ = "Z"
			
			//For the shiny eyes
			folderF$ = ""
			if FindString(face$, "1") > 0 then folderF$ = "blueeyes/"
			
			//Make an "if face contains 1, get from other folder" statement (organizing)
			costume$ = body$
			closedEye = 0
			if Mid(face$, 1, 1) = "I" or Mid(face$, 1, 1) = "L" or Mid(face$, 1, 1) = "O" or Mid(face$, 1, 2) = "Af" or Mid(face$, 1, 2) = "Ai" or Mid(face$, 1, 2) = "Md" or (Mid(face$, 1, 1) = "T" and Len(face$) = 2) or Mid(face$, 1, 2) = "Xa" or Mid(face$, 1, 2) = "Xb" or Mid(face$, 1, 2) = "Yg" or Mid(face$, 1, 2) = "Yh"
				body$ = body$ + "r"
				closedEye = 1
			endif
			//For the closed eyes body
			folderB$ = ""
			if FindString(body$, "r") > 0 then folderB$ = "closedeyes/"
			
			hatBonus$ = ""
			if (Mid(face$, 2, 1) = "1" or closedEye) and ((targetCrab = 1 and crab1Type = 2 and crab1Alt = 0) or (targetCrab = 2 and crab2Type = 2 and crab2Alt = 0))
				hatBonus$ = "Alt"
			endif
			phoneBonus$ = ""
			if (body$ = "E" or body$ = "G") and ((targetCrab = 1 and crab1Type = 2 and crab1Alt = 1) or (targetCrab = 2 and crab2Type = 2 and crab2Alt = 1)) then phoneBonus$ = "e"
			if (body$ = "E" or body$ = "G") and ((targetCrab = 1 and crab1Type = 2 and crab1Alt = 0) or (targetCrab = 2 and crab2Type = 2 and crab2Alt = 0)) then phoneBonus$ = "e"
			//Wizard and Cranime will have costumes loaded in based on faces
			
			SetFolder("/media/storysprites")
			//Make a dump image cache, that is deleted when the story is exited
			if targetCrab = 1
				//1st Crab Target
				cosType = GetCrabCostumeType(crab1Type, crab1Alt)
				if cosType = 2 then folderF$ = "speyes/"
				if cosType <> 2 and crab1Type+crab1Alt*6 = 18 or crab1Type+crab1Alt*6 = 20 then folderF$ = "speyes/"
				
				if cosType <> 2 and cosType <> 5
					if z$ <> ""
						SetSpriteImage(SPR_CRAB1_BODY, LoadImageR(folderB$ + "body" + body$ + str(crab1Type+crab1Alt*6) + ".png"))
					else
						SetSpriteImage(SPR_CRAB1_BODY, LoadImageR(folderB$ + "body" + body$ + phoneBonus$ + ".png"))
					endif
					if folderF$ = "speyes/"
						SetSpriteImage(SPR_CRAB1_FACE, LoadImageR("speyes/face" + str(crab1Type+crab1Alt*6) + face$ + ".png"))
					else
						SetSpriteImage(SPR_CRAB1_FACE, LoadImageR(folderF$ + "face" + face$ + ".png"))
					endif
				endif
				if cosType = 1
					//Hat costume
					SetSpriteImage(SPR_CRAB1_COSTUME, LoadImageR("costume/costume" + str(crab1Type) + AltStr(crab1Alt) + z$ + hatBonus$ + ".png"))
				elseif cosType = 2
					//Unique sprite (WIP)
					SetSpriteImage(SPR_CRAB1_COSTUME, LoadImageR("blank.png"))
					SetSpriteImage(SPR_CRAB1_BODY, LoadImageR(folderB$ + "body" + str(crab1Type) + AltStr(crab1Alt) + body$ + phoneBonus$ + ".png"))
					if GetFileExists(folderF$ + "face" + z$ + str(crab1Type+crab1Alt*6) + face$ + ".png")
						SetSpriteImage(SPR_CRAB1_FACE, LoadImageR(folderF$ + "face" + z$ + str(crab1Type+crab1Alt*6) + face$ + ".png"))
					else
						SetSpriteImage(SPR_CRAB2_FACE, LoadImageR("face" + face$ + ".png"))
					endif
				elseif cosType = 4
					//Posed costume
					if GetFileExists("costume/costume" + str(crab1Type) + AltStr(crab1Alt) + costume$ + z$ + ".png") = 0 then costume$ = ""
					SetSpriteImage(SPR_CRAB1_COSTUME, LoadImageR("costume/costume" + str(crab1Type) + AltStr(crab1Alt) + costume$ + z$ + ".png"))
				elseif cosType = 5
					//Taxi Type, unique body AND costume, normal face
					SetSpriteImage(SPR_CRAB1_BODY, LoadImageR(folderB$ + "body" + str(crab1Type) + AltStr(crab1Alt) + body$ + ".png"))
					SetSpriteImage(SPR_CRAB1_FACE, LoadImageR(folderF$ + "face" + face$ + ".png"))
					SetSpriteImage(SPR_CRAB1_COSTUME, LoadImageR("costume/costume" + str(crab1Type) + AltStr(crab1Alt) + costume$ + ".png"))
				else
					//Blank costume
					SetSpriteImage(SPR_CRAB1_COSTUME, LoadImageR("blank.png"))
				endif
				if GetTweenSpritePlaying(SPR_CRAB1_FACE, SPR_CRAB1_FACE) = 0 and GetTweenSpritePlaying(SPR_CRAB1_BODY, SPR_CRAB1_FACE) = 0
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_BODY, 0)
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_FACE, 0)
					PlayTweenSprite(SPR_CRAB1_FACE, SPR_CRAB1_COSTUME, 0)
				endif
				
				for i = SPR_CRAB1_BODY to SPR_CRAB1_COSTUME
					trashBag.insert(GetSpriteImageID(i))
				next i
					
			else
				
				//Finishing the crab transition before loading new images
				//SPR_CRAB2_COSTUME is the tween
				while GetTweenSpritePlaying(SPR_CRAB2_COSTUME, SPR_CRAB2_BODY)
					UpdateAllTweens(GetFrameTime())
					DoInputs()
					if inputSkip or inputSelect or GetPointerPressed() or (dispH = 0 and GetSpriteHitTest(SPR_STORY_SKIP, GetPointerX(), GetPointerY()) and GetPointerState()) then UpdateAllTweens(.1)
					Sync()
				endwhile
				
				//2nd Crab Target
				cosType = GetCrabCostumeType(crab2Type, crab2Alt)
				if cosType = 2 then folderF$ = "speyes/"
				if cosType <> 2 and (crab2Type+crab2Alt*6 = 18 or crab2Type+crab2Alt*6 = 20) then folderF$ = "speyes/"
				
				if cosType <> 2 and cosType <> 5
					if z$ <> ""
						SetSpriteImage(SPR_CRAB2_BODY, LoadImageR(folderB$ + "body" + body$ + str(crab2Type+crab2Alt*6) + ".png"))
						//Print(folderB$ + "body" + body$ + str(crab2Type+crab2Alt*6) + ".png")
						//Sync()
						//Sleep(3000)
					else
						SetSpriteImage(SPR_CRAB2_BODY, LoadImageR(folderB$ + "body" + body$ + phoneBonus$ + ".png"))
					endif
					if folderF$ = "speyes/"
						SetSpriteImage(SPR_CRAB2_FACE, LoadImageR("speyes/face" + str(crab2Type+crab2Alt*6) + face$ + ".png"))
					else
						SetSpriteImage(SPR_CRAB2_FACE, LoadImageR(folderF$ + "face" + face$ + ".png"))
					endif
					
				endif
				if cosType = 1
					//Hat costume
					SetSpriteImage(SPR_CRAB2_COSTUME, LoadImageR("costume/costume" + str(crab2Type) + AltStr(crab2Alt) + z$ + hatBonus$ + ".png"))
				elseif cosType = 2
					//Unique sprite (WIP)
					SetSpriteImage(SPR_CRAB2_COSTUME, LoadImageR("blank.png"))
					SetSpriteImage(SPR_CRAB2_BODY, LoadImageR(folderB$ + "body" + str(crab2Type) + AltStr(crab2Alt) + body$ + phoneBonus$ + ".png"))
					if GetFileExists(folderF$ + "face" + z$ + str(crab2Type+crab2Alt*6) + face$ + ".png")
						SetSpriteImage(SPR_CRAB2_FACE, LoadImageR(folderF$ + "face" + z$ + str(crab2Type+crab2Alt*6) + face$ + ".png"))
					else
						SetSpriteImage(SPR_CRAB2_FACE, LoadImageR("face" + face$ + ".png"))
					endif
				elseif cosType = 4
					//Posed costume
					if GetFileExists("costume/costume" + str(crab2Type) + AltStr(crab2Alt) + costume$ + z$ + ".png") = 0 then costume$ = ""
					SetSpriteImage(SPR_CRAB2_COSTUME, LoadImageR("costume/costume" + str(crab2Type) + AltStr(crab2Alt) + costume$ + z$ + ".png"))
				elseif cosType = 5
					//Taxi Type, unique body AND costume, normal face
					SetSpriteImage(SPR_CRAB2_BODY, LoadImageR(folderB$ + "body" + str(crab2Type) + AltStr(crab2Alt) + body$ + ".png"))
					SetSpriteImage(SPR_CRAB2_FACE, LoadImageR(folderF$ + "face" + face$ + ".png"))
					SetSpriteImage(SPR_CRAB2_COSTUME, LoadImageR("costume/costume" + str(crab2Type) + AltStr(crab2Alt) + costume$ + ".png"))
				else
					//Blank costume
					SetSpriteImage(SPR_CRAB2_COSTUME, LoadImageR("blank.png"))
				endif
				if GetTweenSpritePlaying(SPR_CRAB2_FACE, SPR_CRAB2_FACE) = 0 and GetTweenSpritePlaying(SPR_CRAB2_FACE, SPR_CRAB2_BODY) = 0
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_BODY, 0)
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_FACE, 0)
					PlayTweenSprite(SPR_CRAB2_FACE, SPR_CRAB2_COSTUME, 0)
				endif

				for i = SPR_CRAB2_BODY to SPR_CRAB2_COSTUME
					trashBag.insert(GetSpriteImageID(i))
				next i
				
			endif
			
			wholeRow$ = GetStringToken(wholeRow$, ";", 2)
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
		
		SetSpriteFlip(SPR_TEXT_BOX4, GetSpriteFlippedH(SPR_TEXT_BOX3), 0)
		SetSpriteFlip(SPR_TEXT_BOX3, GetSpriteFlippedH(SPR_TEXT_BOX2), 0)
		SetSpriteFlip(SPR_TEXT_BOX2, GetSpriteFlippedH(SPR_TEXT_BOX), 0)
		SetSpriteFlip(SPR_TEXT_BOX, targetCrab-1, 0)
		
		while curPos <> Len(wholeRow$)
			inc curPos, 1
			curChar$ = Mid(wholeRow$, curPos, 1)
			
			//If the current character is a space, then a linebreak may happen
			if curChar$ = " "
				
				//This checks if the wholeRow, up to the current position, inside of a formatted string, is longer than the textbox width.
				newLine = 0
				SetTextString(storyFitter, Mid(wholeRow$, 1, curPos))
				if (GetTextTotalWidth(storyFitter) > GetSpriteWidth(SPR_TEXT_BOX)-textSideSpacingX*2)
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
		
		PlaySoundR(fwipS, 40)
		PlaySoundR(arrowS, 40)
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
			SetTweenCharY(storyFitter + i, -GetTextSize(storyText) + GetTextSize(storyText)*(i-.7) + i*textLineSpacing, GetTextSize(storyText)*i + i*textLineSpacing, TweenOvershoot())
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
			DoInputs()
			
			if (inputExit or ButtonMultitouchEnabled(SPR_STORY_EXIT)) and fightDone = 0
				state = CHARACTER_SELECT
				TransitionStart(Random(1,lastTranType))
				nextLine = 1
				StopGamePlayMusic()
				exit
			endif
			
			if dispH = 0 and GetSpriteHitTest(SPR_STORY_SKIP, GetPointerX(), GetPointerY()) and GetPointerState() then inputSkip = 1
			if inputSkip
				UpdateAllTweens(.2)
				SetViewOffset(-5 + Random(0, 10), -5 + Random(0, 10))
			else
				SetViewOffset(0, 0)
			endif
			
		    //Print(GetSpriteWidth(SPR_TEXT_BOX))
		    //Print(GetSpriteHeight(SPR_TEXT_BOX))
			
			storyInput = 0
			if GetPointerPressed() or inputSelect or inputSkip then storyInput = 1
			if GetTextCharColorAlpha(storyText, charSounded) = 255 and GetTextCharColorAlpha(storyText, Len(displayString$)-9) = 0
				if Mod(charSounded, 2) then PlaySoundR(talk1S, 40/(hurryUp/2+1))
				inc charSounded, 1
			endif
			if storyInput
				hurryUp = 1
			endif
			if hurryUp then UpdateAllTweens(.1)
			if storyInput and GetTweenCharPlaying(storyFitter, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+1, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+2, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyFitter+3, storyText, len(displayString$)) = 0 then nextLine = 1
			if debug then Print(GetImageMemoryUsage())
			SyncG()
		endwhile
		
		inc boxNum, 1
		wholeRow$ = ReadLine(1)	//Reading the new line of the text file.
		inc lineOverall, 1
		
		if CompareString(wholeRow$, "") = 1
			state = StartEndScreen()
		endif
		
	endwhile
	
	SetViewOffset(0, 0)
	
	EmptyTrashBag()
	if GetMusicExistsOgg(soundeffect) then DeleteMusicOgg(soundeffect)
	
	CloseFile(1)
		
endfunction state

function EmptyTrashBag()
	endI = trashBag.length
	for i = 1 to endI
		if GetImageExists(trashBag[0]) then DeleteImage(trashBag[0])
		trashBag.remove(0)
	next i
endfunction

function StartEndScreen()
	state = STORY
	
	inc curScene, 1
	highestScene = Max(highestScene, (curChapter-1)*4+curScene)
	lineSkipTo = 0
	
	for i = 0 to 2
		CreateTextExpress(TXT_RESULT1 + i, "", 110, fontCrabI, 1, w/2, 240 + 85*i, 6)
		if dispH then SetTextY(TXT_RESULT1 + i, 130 + 95*i)
		SetTextColorAlpha(TXT_RESULT1 + i, 254)
		SetTextSpacing(TXT_RESULT1 + i, -20)
		if dispH = 0
			SetTextSize(TXT_RESULT1 + i, 120)
			SetTextSpacing(TXT_RESULT1 + i, -26)
			IncTextY(TXT_RESULT1 + i, 30 + 30*i)
		endif
	next i
	if curScene = 5	//This is set to one higher than 4, because the scene will increment before calling this scene
		SetTextString(TXT_RESULT1, crab1Str$)
		SetTextString(TXT_RESULT2, "STORY")
		SetTextString(TXT_RESULT3, "CLEAR!")
		
		for i = TXT_RESULT1 to TXT_RESULT3
			if GetTweenExists(i) then DeleteTween(i)
			CreateTweenText(i, .8)
			SetTweenTextSize(i, 10, 110, TweenOvershoot())
		next i
		
		//The unlocking stuff
		SetCrabFromChapter(curChapter)
		if crab1Alt <> 0
			if altUnlocked[crab1Type] < crab1Alt then UnlockCrab(crab1Type, crab1Alt, 1)
		else
			
		endif
		//UnlockSong(1, 1)
	else
		SetTextString(TXT_RESULT1, "-SCENE-")
		SetTextString(TXT_RESULT2, "-CLEAR-")
		if GetTweenExists(TXT_RESULT1) then DeleteTween(TXT_RESULT1)
		if GetTweenExists(TXT_RESULT2) then DeleteTween(TXT_RESULT2)
		CreateTweenText(TXT_RESULT1, .3)
		CreateTweenText(TXT_RESULT2, .3)
		SetTweenTextX(TXT_RESULT1, -w, w/2, TweenLinear())
		SetTweenTextX(TXT_RESULT2, w*2, w/2, TweenLinear())
		SetTextX(TXT_RESULT1, -w)
		SetTextX(TXT_RESULT2, -w)
	endif
	
	SetFolder("/media/ui")
	
	LoadSpriteExpress(playButton, "storycontinue.png", 842/2.1, 317/2.1, 0, 0, 4)
	if dispH = 0 then SetSpriteSize(playButton, 842/1.6, 317/1.6)
	SetSpriteMiddleScreen(playButton)
	IncSpriteY(playButton, 80)
	if dispH = 0 then IncSpriteY(playButton, -40)
	//if dispH = 0 then IncSpriteX(playButton, 60)
	SetSpriteColorAlpha(playButton, 0)
	AddButton(playButton)
	
	if curScene = 5 and curChapter = finalChapter
		LoadSpriteExpress(exitButton, "mainmenu.png", 240, 240, 0, 0, 4)
	else
		LoadSpriteExpress(exitButton, "crabselect.png", 240, 240, 0, 0, 4)
	endif
	if dispH then SetSpriteSizeSquare(exitButton, 180)
	SetSpriteMiddleScreen(exitButton)
	IncSpriteY(exitButton, 570)
	if dispH = 0 then IncSpriteY(exitButton, -60)
	if dispH then IncSpriteY(exitButton, -350)
	IncSpriteX(exitButton, -210)
	if dispH then IncSpriteX(exitButton, -170)
	SetSpriteColorAlpha(exitButton, 0)
	AddButton(exitButton)
	
	
	
	//TODO - Play music sting for finishing
	
	PlayTweenSprite(tweenSprFadeIn, exitButton, 1)
	//Make tweens for the text to slide in!
	
	if curScene = 5
		//End of chapter
		SetSpriteVisible(playButton, 0)
		SetSpriteMiddleScreen(exitButton)
		IncSpriteY(exitButton, 300)
		if dispH then IncSpriteY(exitButton, -110)
		clearedChapter = Max(clearedChapter, curChapter)
		
		PlayTweenText(TXT_RESULT1, TXT_RESULT1, 0)
		PlayTweenText(TXT_RESULT2, TXT_RESULT2, 0)
		PlayTweenText(TXT_RESULT3, TXT_RESULT3, 0)
	else
		//End of scene
		
		PlayTweenText(TXT_RESULT1, TXT_RESULT1, 0)
		PlayTweenText(TXT_RESULT2, TXT_RESULT2, .3)
		PlayTweenSprite(tweenSprFadeIn, playButton, 1)
	endif
	
	SaveGame()
	
	ExitStory(0)
	
	state = DoStoryEndScreen()
	
endfunction state

function DoStoryEndScreen()
	state = STORY
	
	if curScene = 5
		//End of chapter
	else
		//End of scene
		
		PlayTweenText(TXT_RESULT1, TXT_RESULT1, 0)
		PlayTweenText(TXT_RESULT2, TXT_RESULT2, .3)
		PlayTweenSprite(tweenSprFadeIn, playButton, 1)
	endif
	
	endDone = 0
	while (endDone = 0)
		
		ProcessMultitouch()
		DoInputs()
		ProcessPopup()
		if inputLeft or inputRight or inputUp or inputDown then MoveSelect()
		
		if curScene < 5
			if GetTextX(TXT_RESULT1) > w/2-10 and GetTextColorAlpha(TXT_RESULT1) <> 255
				PlaySoundR(chooseS, 40)
				SetTextColorAlpha(TXT_RESULT1, 255)
			endif
			if GetTextX(TXT_RESULT2) < w/2+10 and GetTextColorAlpha(TXT_RESULT2) <> 255
				PlaySoundR(chooseS, 40)
				SetTextColorAlpha(TXT_RESULT2, 255)
			endif
		else
			//End of story scene
			for i = TXT_RESULT1 to TXT_RESULT3
				if GetTextSize(i) > 79 and GetTextColorAlpha(i) <> 255
					PlaySoundR(chooseS, 40)
					SetTextColorAlpha(i, 255)
				endif
			next i
			
			inc TextJitterTimer#, GetFrameTime()
			if TextJitterTimer# >= 1.0/TextJitterFPS
				doJit = 1
				inc TextJitterTimer#, -TextJitterFPS
				if TextJitterTimer# < 0 then TextJitterTimer# = 0
			endif
			txt = TXT_RESULT2
			txt2 = TXT_RESULT3
			for i = 0 to len(GetTextString(txt))
				if doJit
					SetTextCharY(txt, i, -1 * (jitterNum) + Random(0, (jitterNum)*2))
					SetTextCharAngle(txt, i, -1 * (jitterNum) + Random(0, jitterNum*2))
					SetTextCharY(txt2, i, -1 * (jitterNum) + Random(0, (jitterNum)*2))
					SetTextCharAngle(txt2, i, -1 * (jitterNum) + Random(0, jitterNum*2))
				endif
			next i
			
			
		endif
		
		inc startTimer#, 60.0/ScreenFPS()
		SetSpriteAngle(playButton, 4*sin(TextJitterTimer#*3))
		IncSpriteAngle(exitButton, 60.0/ScreenFPS())
		
		if ((inputSelect and curScene < 5 and selectTarget = 0) or (ButtonMultitouchEnabled(playButton))) and GetSpriteColorAlpha(playButton) > 100
			endDone = 1
		elseif ((inputSelect and curScene = 5 and selectTarget = 0) or (ButtonMultitouchEnabled(exitButton))) and GetSpriteColorAlpha(exitButton) > 100
			if curChapter = finalChapter //highestScene = finalChapter*4 + 1
				state = START
				spActive = 0
				spType = 0
			else
				state = CHARACTER_SELECT
			endif
			
			if curScene = 5 then curChapter = Min(curChapter + 1, finalChapter)
			endDone = 1
		endif
		
		if debug
			Print(GetTextX(TXT_RESULT1))
			Print(GetTweenSpriteTime(TXT_RESULT1, TXT_RESULT1))
			Print(GetTweenSpritePlaying(TXT_RESULT1, TXT_RESULT1))
		endif
		
		SyncG()		
	endwhile
	
	StopGamePlayMusic()
	if GetMusicPlayingOGGSP(resultsMusic) then StopMusicOGGSP(resultsMusic)
	
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
		
	elseif chap = 14	//Crabacus
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
		
	elseif chap = 23	//Sk8r Crab
		crab1Type = 3
		crab1Alt = 3
		
	elseif chap = 24	//Chimera Crab
		crab1Type = 6
		crab1Alt = 3
		
	elseif chap = 25	//Future Crab
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
		if myAlt = 2 then newStr$ = "Crabacus"
		if myAlt = 3 then newStr$ = "Crabyss Knight"
	elseif myType = 3
		if myAlt = 0 then newStr$ = "Top Crab"
		if myAlt = 1 then newStr$ = "Taxi Crab"
		if myAlt = 2 then newStr$ = "Space Barc"
		if myAlt = 3 then newStr$ = "Sk8r Crab"
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
		if myAlt = 3 then newStr$ = "Chimera Crab"
	endif
	
	if crabNum = 1 then crab1Str$ = newStr$
	if crabNum = 2 then crab2Str$ = newStr$
endfunction

function GetCrabCostumeType(cT, cA)
	cosType = 0
	if (cT = 2 and cA = 0) or (cT = 4 and cA = 3)
		//Hat type
		cosType = 1
	elseif (cT = 2 and cA = 2) or (cT = 3 and cA = 0) or (cT = 3 and cA = 2) or (cT = 5 and cA = 3) or (cT = 6 and cA = 3)
		//Unique sprite type
		cosType = 2
	elseif (cT = 1 and cA = 0) or (cT = 6 and cA = 2)
		//Blank costume type
		cosType = 3
	elseif (cT = 3 and cA = 1)
		//Unique body AND costume (taxi crab)
		cosType = 5
	else
		//Full body type (costume has gloves/sleeves, AKA most crabs)
		cosType = 4
	endif
		
endfunction cosType

function SetCrabFromStringChap(str$, chapNum, crabNum)
	//This will either use 
	myType = 0
	myAlt = 0

	
	if str$ = "SC" or chapNum = 1  or chapNum = 22	//Space Crab
		mType = 1
		mAlt = 0
		
	elseif str$ = "LW" or chapNum = 2 //Ladder Wizard
		mType = 2
		mAlt = 0
		
	elseif str$ = "1F" or chapNum = 3	//#1 Fan Crab
		mType = 4
		mAlt = 1
		
	elseif str$ = "TC" or chapNum = 4	//Top Crab
		mType = 3
		mAlt = 0
		
	elseif str$ = "KC" or chapNum = 5	//King Crab
		mType = 2
		mAlt = 1
		
	elseif str$ = "IJ" or chapNum = 6	//Inianda Jeff
		mType = 5
		mAlt = 1
		
	elseif str$ = "TX" or chapNum = 7	//Taxi Crab
		mType = 3
		mAlt = 1
		
	elseif str$ = "HC" or chapNum = 8	//Hawaiian Crab
		mType = 4
		mAlt = 2
		
	elseif str$ = "TP" or chapNum = 9	//Team Player
		mType = 6
		mAlt = 1
		
	elseif str$ = "RL" or chapNum = 10	//Rock Lobster
		mType = 5
		mAlt = 2
		
	elseif str$ = "NC" or chapNum = 11	//Ninja Crab
		mType = 6
		mAlt = 0
		
	elseif str$ = "CK" or chapNum = 12	//Crab Cake
		mType = 5
		mAlt = 3
		
	elseif str$ = "CN" or chapNum = 13	//Cranime
		mType = 6
		mAlt = 2
		
	elseif str$ = "CB" or chapNum = 14	//Crabacus
		mType = 2
		mAlt = 2
		
	elseif str$ = "RC" or chapNum = 15	//Rave Crab
		mType = 4
		mAlt = 0
		
	elseif str$ = "MC" or chapNum = 16	//Mad Crab
		mType = 1
		mAlt = 1
		
	elseif str$ = "HO" or chapNum = 17	//Holy Crab
		mType = 4
		mAlt = 3
		
	elseif str$ = "AL" or chapNum = 18	//Al Legal
		mType = 1
		mAlt = 2
		
	elseif str$ = "SB" or chapNum = 19	//Space Barc
		mType = 3
		mAlt = 2
		
	elseif str$ = "KN" or chapNum = 20	//Crabyss Knight
		mType = 2
		mAlt = 3
		
	elseif str$ = "CC" or chapNum = 21	//Chrono Crab
		mType = 5
		mAlt = 0
		
	elseif str$ = "S8" or chapNum = 23	//Sk8r Crab
		mType = 3
		mAlt = 3
		
	elseif str$ = "CM" or chapNum = 24	//Chimera Crab
		mType = 6
		mAlt = 3
		
	elseif str$ = "FC" or chapNum = 25	//Future Crab
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
	