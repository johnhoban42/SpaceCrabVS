// File: statistics.agc
// Created: 23-10-03


global statisticsStateInitialized as integer = 0

//#constant ST_TITLE 
//#constant ST_TXT1 
//#constant ST_TXT2 
//#constant ST_TXT3 

// Initialize the story screen
function InitStatistics()
	
	//Created of the sprites/anything else needed goes here
	
	StopGamePlayMusic()
	SaveGame()
	
	CreateSpriteExpressImage(ST_TITLE, bg4I, w*2, w*2, 0, 0, 1000)
	if dispH then SetSpriteSizeSquare(ST_TITLE, h*2)
	SetSpriteMiddleScreen(ST_TITLE)
	
	
	CreateText(ST_TITLE, "Statistics")
	
	crabsU = altUnlocked[1]+altUnlocked[2]+altUnlocked[3]+altUnlocked[4]+altUnlocked[5]+altUnlocked[6]
	completed$ = "Completion: " + Mid(Str(0.1* Trunc((1000.0*(highestScene-1+musicUnlocked-7+crabsU+musicBattleUnlock+hardBattleUnlock+speedUnlock+evilUnlock+unlockAIHard))/(1.0*100+14+18+5))),1,4) + "% "
	crabU$ = "Crabs Unlocked: " + Str(6+crabsU) + "/?? "
	if altUnlocked[4] >= 3 then crabU$ = "Crabs Unlocked: " + Str(6+crabsU) + "/24 "
	songU$ = "Songs Unlocked: " + Str(musicUnlocked) + "/21 "
	storyU$ = "Story Finished: " + Str(highestScene-1) + "% "
	mirrS$ = "Best Mirror Score: " + Str(spHighScore) + " "
	classS$ = "Best Classic Score: " + Str(spHighScoreClassic) + " "
	fightTime$ = "Longest Fight: " + GetTimerString(fightSeconds) + " "
	
	if highestScene = 101
		completed$ = Mid(completed$, 1, Len(completed$)-2) + "% {"
		storyU$ = storyU$ + "{"
	endif
	if crabsU = 18 then crabU$ = crabU$ + "{"
	if musicUnlocked = 21 then songU$ = songU$ + "{"
	if spHighScore >= 200 then mirrS$ = mirrS$ + "{"
	if spHighScoreClassic >= 150 then classS$ = classS$ + "{"
	if fightSeconds >= 300 then fightTime$ = fightTime$ + "{"
	//The empty space after the strings is very important, it makes the yellow star set correctly)	
	CreateText(ST_TXT1, completed$ + chr(10) + crabU$ + chr(10) + songU$ + chr(10) + storyU$ + chr(10) + mirrS$ + chr(10) + classS$ + chr(10) + fightTime$)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)-1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$) + 1 -1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$)+Len(songU$) + 2 -1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$)+Len(songU$)+Len(storyU$) + 3 -1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$)+Len(songU$)+Len(storyU$)+Len(mirrS$) + 4 -1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$)+Len(songU$)+Len(storyU$)+Len(mirrS$)+Len(classS$) + 5 -1, 0)
	SetTextCharColorBlue(ST_TXT1, Len(completed$)+Len(crabU$)+Len(songU$)+Len(storyU$)+Len(mirrS$)+Len(classS$)+Len(fightTime$) + 6 -1, 0)
	
	inc totalSecondsPlayed, Round(localSeconds#)
	localSeconds# = 0
		
	timeP$ = "Time Played: " + GetTimerString(totalSecondsPlayed)
	battleG$ = "Total Fights: " + Str(fightTotal)
	mirrorG$ = "Mirror Games: " + Str(mirrorTotal)
	classG$ = "Classic Games: " + Str(classicTotal)
	metT$ = "Meteors Dodged: " + Str(totalMeteors)
	CreateText(ST_TXT2, timeP$ + chr(10) + battleG$ + chr(10) + mirrorG$ + chr(10) + classG$ + chr(10) + metT$)
		
	CreateText(ST_TXT3, "Statistics")
	
	SetFolder("/media/ui")
	LoadAnimatedSprite(SPR_MENU_BACK, "back", 8)
	SetSpriteFrame(SPR_MENU_BACK, 8)
	AddButton(SPR_MENU_BACK)
	
	if dispH
		SetTextExpress(ST_TITLE, GetTextString(ST_TITLE), 120, fontSpecialI, 1, w/2, 20, 5, -30)
		SetTextExpress(ST_TXT1, GetTextString(ST_TXT1), 60, fontDescI, 0, w/9, 125, 5, -17)
		SetTextExpress(ST_TXT2, GetTextString(ST_TXT2), 60, fontDescI, 0, w*3/5, 125, 5, -17)
		//SetText
		
		SetSpriteExpress(SPR_MENU_BACK, 130, 130, 30, h-160, 5)
		
	else
		
		SetTextExpress(ST_TITLE, GetTextString(ST_TITLE), 140, fontSpecialI, 1, w/2, 20, 5, -33)
		SetTextExpress(ST_TXT1, GetTextString(ST_TXT1), 80, fontDescI, 0, 20, 170, 5, -24)
		SetTextExpress(ST_TXT2, GetTextString(ST_TXT2), 80, fontDescI, 0, w/5, 800, 5, -24)
		
		SetSpriteExpress(SPR_MENU_BACK, 140, 140, 40, h-180, 5)
		
	endif
	
	PlayMusicOGGSP(chillMusic, 1)
	
	statisticsStateInitialized = 1
endfunction

// Stats screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStatistics()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if statisticsStateInitialized = 0
		InitStatistics()
		TransitionEnd()
	endif
	state = STATISTICS
	
	timeP$ = "Time Played: " + GetTimerString(totalSecondsPlayed+round(localSeconds#))
	battleG$ = "Total Fights: " + Str(fightTotal)
	mirrorG$ = "Mirror Games: " + Str(mirrorTotal)
	classG$ = "Classic Games: " + Str(classicTotal)
	metT$ = "Meteors Dodged: " + Str(totalMeteors)
	SetTextString(ST_TXT2, timeP$ + chr(10) + battleG$ + chr(10) + mirrorG$ + chr(10) + classG$ + chr(10) + metT$)
	
	starNum = 1
	for i = 1 to Len(GetTextString(ST_TXT1))
		if GetTextCharColorBlue(ST_TXT1, i) = 0
			SetTextCharAngle(ST_TXT1, i, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
			inc starNum, 1
		endif
	next i

	if mod(round(localSeconds#)+1080, 8) = 0 and GetSpritePlaying(SPR_MENU_BACK) = 0 then PlaySprite(SPR_MENU_BACK, 10, 0, 1, 8)
	
	if GetPointerPressed() and not Button(SPR_MENU_BACK)
		PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
	endif
	
	//Do loop for the mode is here
	if ButtonMultitouchEnabled(SPR_MENU_BACK) or inputExit
		TransitionStart(lastTranType)
		state = START
	endif
	
	
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> STATISTICS
		ExitStatistics()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStatistics()

	//Deletion of the assets/setting variables correctly to leave is here

	DeleteSprite(ST_TITLE)
	DeleteSprite(SPR_MENU_BACK)
	DeleteText(ST_TITLE)
	DeleteText(ST_TXT1)
	DeleteText(ST_TXT2)
	DeleteText(ST_TXT3)
	StopMusicOGGSP(chillMusic)

	statisticsStateInitialized = 0
endfunction