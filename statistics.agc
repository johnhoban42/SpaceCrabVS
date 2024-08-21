// File: statistics.agc
// Created: 23-10-03


global statisticsStateInitialized as integer = 0

//#constant ST_TITLE 
//#constant ST_TXT1 
//#constant ST_TXT2 
//#constant ST_TXT3 

global faveCrab = 0
global faveCrab2 = 0
global faveCrab3 = 0

global statsState = 1

// Initialize the story screen
function InitStatistics()
	
	//Created of the sprites/anything else needed goes here
	
	StopGamePlayMusic()
	SaveGame()
	
	CreateSpriteExpressImage(ST_TITLE, bg4I, w*2, w*2, 0, 0, 1000)
	if dispH then SetSpriteSizeSquare(ST_TITLE, h*2)
	SetSpriteMiddleScreen(ST_TITLE)
	FixSpriteToScreen(ST_TITLE, 1)
	
	CreateText(ST_TITLE, "Statistics")
	FixTextToScreen(ST_TITLE, 1)
	
	crabsU = altUnlocked[1]+altUnlocked[2]+altUnlocked[3]+altUnlocked[4]+altUnlocked[5]+altUnlocked[6]
	completed$ = "Completion: " + Mid(Str(0.1* Trunc((1000.0*(highestScene-1+musicUnlocked-7+crabsU+musicBattleUnlock+hardBattleUnlock+speedUnlock+evilUnlock+unlockAIHard))/(1.0*100+14+18+5))),1,4) + "% "
	if dispH then completed$ = chr(10) + completed$
	crabU$ = "Crabs Unlocked: " + Str(6+crabsU) + "/?? "
	if altUnlocked[5] >= 3 then crabU$ = "Crabs Unlocked: " + Str(6+crabsU) + "/24 "
	songU$ = "Songs Unlocked: " + Str(musicUnlocked) + "/21 "
	storyU$ = "Story Finished: " + Str(highestScene-1) + "% "
	mirrS$ = "Best Mirror Score: " + Str(spHighScore) + " "
	classS$ = "Best Classic Score: " + Str(spHighScoreClassic) + " "
	fightTime$ = "Longest Fight: " + GetTimerString(fightSeconds) + " "
	
	if highestScene = 101
		completed$ = Mid(completed$, 1, Len(completed$)-3) + "% {"
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
	
	//crabPlayed[20] = 34
	//crabPlayed[18] = 66
	//crabPlayed[7] = 166
	
	faveCrab = 0
	quan1 = 0	//Quan = Quantity, times that crab was played
	faveCrab2 = 0
	quan2 = 0
	faveCrab3 = 0
	quan3 = 0
	
	for i = 1 to 27
		if crabPlayed[i] > quan1
			quan3 = quan2
			faveCrab3 = faveCrab2
			
			quan2 = quan1
			faveCrab2 = faveCrab
			
			quan1 = crabPlayed[i]
			faveCrab = i
		elseif crabPlayed[i] > quan2
			quan3 = quan2
			faveCrab3 = faveCrab2
			
			quan2 = crabPlayed[i]
			faveCrab2 = i
		elseif crabPlayed[i] > quan3			
			quan3 = crabPlayed[i]
			faveCrab3 = i
		endif
	next i
	
	if faveCrab = 0 then faveCrab = 1
	//totalSecondsPlayed = 1000000
	
	if statsState = 1 then SetViewOffset(0, 0)
	if statsState = 2 then SetViewOffset(w, 0)
	
	timeP$ = "Time Played: " + GetTimerString(totalSecondsPlayed)
	battleG$ = "Total Fights: " + Str(fightTotal)
	mirrorG$ = "Mirror Matches: " + Str(mirrorTotal)
	classG$ = "Classic Games: " + Str(classicTotal)
	metT$ = "Meteors Dodged: " + Str(totalMeteors)
	
	//crab1Type = Mod(faveCrab-1, 6)+1
	//crab1Alt = (faveCrab-1)/6
	//if faveCrab > 24 then crab1Type = faveCrab
	//GetCrabSt
	//SetCrabString(1)
	
	if faveCrab2 = 0
		crabF$ = "Favorite Crab:" + chr(10) + "      " + crabNames[faveCrab]
	else
		crabF$ = "Favorite Crabs:" + chr(10) + "      " + crabNames[faveCrab] + "      " + crabNames[faveCrab2] + "      " + crabNames[faveCrab3]
		//crab1Type = Mod(faveCrab2-1, 6)+1
		//crab1Alt = (faveCrab2-1)/6
		//SetCrabString(1)
		//crabF$ = crabF$ + chr(10) + "      " + crab1Str$
		//crab1Type = Mod(faveCrab3-1, 6)+1
		//crab1Alt = (faveCrab3-1)/6
		//SetCrabString(1)
		//crabF$ = crabF$ + chr(10) + "      " + crab1Str$
	endif
	CreateText(ST_TXT2, timeP$ + chr(10) + battleG$ + chr(10) + mirrorG$ + chr(10) + classG$ + chr(10) + metT$ + chr(10) + crabF$)
		
	//CreateText(ST_TXT3, "Statistics")
	SetFolder("/media/art")
	evil$ = ""
	if faveCrab > 24 then evil$ = "2"
	tempCrab = faveCrab
	if faveCrab = 25 then tempCrab = 1
	if faveCrab = 26 then tempCrab = 19
	if faveCrab = 27 then tempCrab = 22
	LoadSprite(ST_TXT2, "crab" + str(Mod(tempCrab-1, 6)+1) + AltStr((tempCrab-1)/6) + evil$ + "rWin.png")
	SetSpriteColor(ST_TXT2, 165, 165, 165, 255)
	
	LoadSprite(ST_TXT5, "crab" + str(Mod(tempCrab-1, 6)+1) + AltStr((tempCrab-1)/6) + evil$ + "rLose.png")
	SetSpriteColor(ST_TXT5, 165, 165, 165, 255)
	
	SetFolder("/media/ui")
	LoadAnimatedSprite(ST_BACK1, "back", 8)
	SetSpriteFrame(ST_BACK1, 8)
	AddButton(ST_BACK1)
	FixSpriteToScreen(ST_BACK1, 1)
	
	LoadSprite(ST_SWITCH1, "switch.png")
	AddButton(ST_SWITCH1)
	FixSpriteToScreen(ST_SWITCH1, 1)
//~	
//~	altUnlocked[1] = 3
//~	altUnlocked[2] = 3
//~	altUnlocked[3] = 3
//~	altUnlocked[4] = 3
//~	altUnlocked[5] = 3
//~	altUnlocked[6] = 3
//~	evilUnlock = 1
//~	
	crabList$ = "Highest Scores" + chr(10) + chr(10)
	mirrorList$ = "Mirror" + chr(10) + chr(10)
	classicList$ = "Classic" + chr(10) + chr(10)
	//scoreTableClassic[14] = 170
	//scoreTableMirror[17] = 211
	for i = 1 to 27
		exM$ = ""
		exC$ = ""
		if scoreTableMirror[i] >= 200 then exM$ = "{ "
		if scoreTableClassic[i] >= 150 then exC$ = "{ "
		addCrab$ = crabNames[i]
		if i <= 24
			if altUnlocked[Mod(i-1,6)+1] < (i-1)/6 then addCrab$ = "???"
		else
			if evilUnlock = 0 then addCrab$ = "???"
			if altUnlocked[1] < 3 and i = 26 then addCrab$ = "???"
		endif
		crabList$ = crabList$ + addCrab$ + chr(10)
		mirrorList$ = mirrorList$ + exM$ + Str(scoreTableMirror[i]) + chr(10)
		classicList$ = classicList$ + exC$ + Str(scoreTableClassic[i]) + chr(10)

		if i = 14
			crabList$ = crabList$ + "|"	//The | is invisible, just used to split the string up internally
			mirrorList$ = mirrorList$ + "|"
			classicList$ = classicList$ + "|"
		endif
	next i
	
	if dispH
		CreateText(ST_TXT3, GetStringToken(crabList$, "|", 1))
		CreateText(ST_TXT4, GetStringToken(mirrorList$, "|", 1))
		CreateText(ST_TXT5, GetStringToken(classicList$, "|", 1))
		CreateText(ST_TXT6, chr(10) + chr(10) + GetStringToken(crabList$, "|", 2))
		CreateText(ST_TXT7, "Mirror" + chr(10) + chr(10) + GetStringToken(mirrorList$, "|", 2))
		CreateText(ST_TXT8, "Classic" + chr(10) + chr(10) + GetStringToken(classicList$, "|", 2))
	else
		CreateText(ST_TXT3, crabList$)
		CreateText(ST_TXT4, mirrorList$)
		CreateText(ST_TXT5, classicList$)
		CreateText(ST_TXT6, "")
		CreateText(ST_TXT7, "")
		CreateText(ST_TXT8, "")
	endif
	
	
	if dispH
		SetTextExpress(ST_TITLE, GetTextString(ST_TITLE), 120, fontSpecialI, 1, w/2, 10, 5, -30)
		SetTextExpress(ST_TXT1, GetTextString(ST_TXT1), 60, fontDescI, 0, w/9-50, 125, 5, -17)
		SetTextExpress(ST_TXT2, GetTextString(ST_TXT2), 60, fontDescI, 0, w*3/5-50, 125, 5, -17)
		SetSpriteExpress(ST_TXT2, h-100, h-100, 0, h - (h-100), 40)
		SetSpriteMiddleScreenX(ST_TXT2)
		
		//SetSpriteExpress(ST_BACK1, 130, 130, 60, h-155, 5)
		//SetSpriteExpress(ST_SWITCH1, 130, 130, w-130-60, h-155, 5)
		SetSpriteExpress(ST_BACK1, 90, 90, 60, 20, 5)
		SetSpriteExpress(ST_SWITCH1, 90, 90, 180, 20, 5)
		
		SetTextExpress(ST_TXT3, GetTextString(ST_TXT3), 50, fontDescI, 2, 310 + w, 120, 5, -14)
		SetTextLineSpacing(ST_TXT3, -14)
		SetTextExpress(ST_TXT4, GetTextString(ST_TXT4), 50, fontDescI, 2, GetTextX(ST_TXT3) + 150, GetTextY(ST_TXT3), 5, -14)
		SetTextLineSpacing(ST_TXT4, -14)
		SetTextExpress(ST_TXT5, GetTextString(ST_TXT5), 50, fontDescI, 2, GetTextX(ST_TXT3) + 150*2, GetTextY(ST_TXT3), 5, -14)
		SetTextLineSpacing(ST_TXT5, -14)
		
		SetTextExpress(ST_TXT6, GetTextString(ST_TXT6), 50, fontDescI, 2, 950 + w, GetTextY(ST_TXT3), 5, -14)
		SetTextLineSpacing(ST_TXT6, -14)
		SetTextExpress(ST_TXT7, GetTextString(ST_TXT7), 50, fontDescI, 2, GetTextX(ST_TXT6) + 150, GetTextY(ST_TXT3), 5, -14)
		SetTextLineSpacing(ST_TXT7, -14)
		SetTextExpress(ST_TXT8, GetTextString(ST_TXT8), 50, fontDescI, 2, GetTextX(ST_TXT6) + 150*2, GetTextY(ST_TXT3), 5, -14)
		SetTextLineSpacing(ST_TXT8, -14)
		
		SetSpriteExpress(ST_TXT5, h-100, h-100, 0, h - (h-100), 40)
		SetSpriteMiddleScreenX(ST_TXT5)
		IncSpriteX(ST_TXT5, w)
		
	else
		
		SetTextExpress(ST_TITLE, GetTextString(ST_TITLE), 135, fontSpecialI, 1, w/2, 20, 5, -33)
		SetTextExpress(ST_TXT1, GetTextString(ST_TXT1), 80, fontDescI, 0, 20, 170, 5, -24)
		SetTextExpress(ST_TXT2, GetTextString(ST_TXT2), 80, fontDescI, 0, w/5-10, 800, 5, -24)
		
		SetSpriteExpress(ST_TXT2, w-30, w-30, 0, h/2-200, 40)
		SetSpriteMiddleScreenX(ST_TXT2)
		
		//Commented ones are their old positions, at the bottom of the screen
		//SetSpriteExpress(ST_BACK1, 140, 140, 40, h-180, 5)
		//SetSpriteExpress(ST_SWITCH1, 140, 140, w-140-40, h-180, 5)
		SetSpriteExpress(ST_BACK1, 140, 140, 10, 20, 5)
		SetSpriteExpress(ST_SWITCH1, 140, 140, w-140-10, 20, 5)
		
		
		SetTextExpress(ST_TXT3, GetTextString(ST_TXT3), 60, fontDescI, 2, w + 420, 210, 5, -15)
		SetTextLineSpacing(ST_TXT3, -14)
		SetTextExpress(ST_TXT4, GetTextString(ST_TXT4), 60, fontDescI, 2, GetTextX(ST_TXT3) + 180, GetTextY(ST_TXT3), 5, -16)
		SetTextLineSpacing(ST_TXT4, -14)
		SetTextExpress(ST_TXT5, GetTextString(ST_TXT5), 60, fontDescI, 2, GetTextX(ST_TXT3) + 180*2, GetTextY(ST_TXT3), 5, -16)
		SetTextLineSpacing(ST_TXT5, -14)
		
		SetSpriteExpress(ST_TXT5, w-30, w-30, 0, h/2-200, 40)
		SetSpriteMiddleScreenX(ST_TXT5)
		IncSpriteX(ST_TXT5, w)
		
	endif
	
	//Making the 'Highest Score' a nice blue color, and making all of the stars gold
	for i = 0 to 15
		SetTextCharColor(ST_TXT3, i, 74, 244, 131, 255)
	next i
	for i = 1 to Len(GetTextString(ST_TXT4))
		if (Mid(GetTextString(ST_TXT4), i, 1)) = "{" then SetTextCharColorBlue(ST_TXT4, i-1, 0)
	next i
	for i = 1 to Len(GetTextString(ST_TXT5))
		if (Mid(GetTextString(ST_TXT5), i, 1)) = "{" then SetTextCharColorBlue(ST_TXT5, i-1, 0)
	next i
	for i = 1 to Len(GetTextString(ST_TXT7))
		if (Mid(GetTextString(ST_TXT7), i, 1)) = "{" then SetTextCharColorBlue(ST_TXT7, i-1, 0)
	next i
	for i = 1 to Len(GetTextString(ST_TXT8))
		if (Mid(GetTextString(ST_TXT8), i, 1)) = "{" then SetTextCharColorBlue(ST_TXT8, i-1, 0)
	next i
	
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
	
	//Making the title letters move slightly
	for i = 0 to GetTextLength(ST_TITLE)
		SetTextCharY(ST_TITLE, i, 15*cos(300.0*localSeconds# + 36*i))
		SetTextX(ST_TITLE, w/2)
		SetTextCharX(ST_TITLE, i, GetTextCharX(ST_TITLE, i) + 0.3*cos(300.0*localSeconds# + 36*i))
		
	next i
	
	
	//This is copy pasted code from above; the lazy way, I know
	timeP$ = "Time Played: " + GetTimerString(totalSecondsPlayed+round(localSeconds#))
	battleG$ = "Total Fights: " + Str(fightTotal)
	mirrorG$ = "Mirror Matches: " + Str(mirrorTotal)
	classG$ = "Classic Games: " + Str(classicTotal)
	metT$ = "Meteors Dodged: " + Str(totalMeteors)
	if faveCrab2 = 0
		crabF$ = "Favorite Crab:" + chr(10) + "      " + crabNames[faveCrab]
	else
		crabF$ = "Favorite Crabs:" + chr(10) + "      " + crabNames[faveCrab] + chr(10) + "      " + crabNames[faveCrab2] + chr(10) + "      " + crabNames[faveCrab3]
	endif
	SetTextString(ST_TXT2, timeP$ + chr(10) + battleG$ + chr(10) + mirrorG$ + chr(10) + classG$ + chr(10) + metT$ + chr(10) + crabF$)
	
	
	if GetPointerPressed() and not Button(ST_BACK1) and not Button(ST_SWITCH1) 
		PingCrab(GetPointerX(), GetPointerY(), Random (100, 180))
	endif
	
	//Wiggling all of the stars
	starNum = 1
	for i = 1 to Len(GetTextString(ST_TXT1))
		if GetTextCharColorBlue(ST_TXT1, i) = 0
			SetTextCharAngle(ST_TXT1, i, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
			inc starNum, 1
		endif
	next i
	for i = 1 to Len(GetTextString(ST_TXT4))
		if (Mid(GetTextString(ST_TXT4), i, 1)) = "{" then SetTextCharAngle(ST_TXT4, i-1, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
		inc starNum, 1
	next i
	for i = 1 to Len(GetTextString(ST_TXT5))
		if (Mid(GetTextString(ST_TXT5), i, 1)) = "{" then SetTextCharAngle(ST_TXT5, i-1, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
		inc starNum, 1
	next i
	for i = 1 to Len(GetTextString(ST_TXT7))
		if (Mid(GetTextString(ST_TXT7), i, 1)) = "{" then SetTextCharAngle(ST_TXT7, i-1, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
		inc starNum, 1
	next i
	for i = 1 to Len(GetTextString(ST_TXT8))
		if (Mid(GetTextString(ST_TXT8), i, 1)) = "{" then SetTextCharAngle(ST_TXT8, i-1, 25*cos(300.0*localSeconds# + 360.0*(starNum*3)/7))
		inc starNum, 1
	next i
	
	//Animating the back button
	if mod(round(localSeconds#)+1080, 8) = 0 and GetSpritePlaying(ST_BACK1) = 0 then PlaySprite(ST_BACK1, 10, 0, 1, 8)
	
	if ButtonMultitouchEnabled(ST_SWITCH1)
		statsState = Mod(statsState, 2)+1
	endif
	if Abs(GetViewOffsetX()-(w*(statsState-1))) <> 2 then GlideViewOffset(w*(statsState-1), 0, 5, 3)
	
	Print(statsState)
	
	
	
	
	//Do loop for the mode is here
	if ButtonMultitouchEnabled(ST_BACK1) or inputExit
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
	DeleteAnimatedSprite(ST_BACK1)
	DeleteSprite(ST_SWITCH1)
	DeleteText(ST_TITLE)
	DeleteText(ST_TXT1)
	DeleteText(ST_TXT2)
	DeleteSprite(ST_TXT2)
	DeleteText(ST_TXT3)
	DeleteText(ST_TXT4)
	DeleteText(ST_TXT5)
	DeleteText(ST_TXT6)
	DeleteText(ST_TXT7)
	DeleteText(ST_TXT8)
	DeleteSprite(ST_TXT5)
	StopMusicOGGSP(chillMusic)

	SetViewOffset(0, 0)

	statisticsStateInitialized = 0
endfunction