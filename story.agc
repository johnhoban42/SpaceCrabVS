// File: story.agc
// Created: 23-06-20

global storyStateInitialized as integer = 0

// Initialize the story screen
function InitStory()
	
	CreateSpriteExpress(SPR_TEXT_BOX, w-80, 280, 0, 0, 10)
	SetSpriteMiddleScreen(SPR_TEXT_BOX)
	
	
	//Loading the text
	
	storyStateInitialized = 1
endfunction

// Story screen execution loop
// Each time this loop exits, return the next state to enter into
function DoStory()
	
	// Initialize if we haven't done so
	// Don't write anything before this!
	if storyStateInitialized = 0
		InitStory()
	endif
	state = STORY
	
	

		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> STORY
		ExitStory()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStory()
	
	resultsStateInitialized = 0
	
endfunction

//The snowtunes code that I'm pulling from
/*
function displayText(tNum)

	//flag[flagNum] = 1

	//The fancy text will always be #1!!!
	
	SetFolder("/media/text")
	
	if tNum = 1
		OpenToRead(1, "beach1.txt")
	elseif tNum = 2
		OpenToRead(1, "beach2.txt")
	elseif tNum = 3
		OpenToRead(1, "beach3.txt")
	elseif tNum = 4
		OpenToRead(1, "beach4.txt")
	else
		OpenToRead(1, "noText.txt")
	endif
	
	
	currentRow$ = ReadLine(1)
	charTalk$ = ""
	talkTo$ = "" 
	textLine$ = ""
	
	CreateText(1, "")
	SetTextSize(1, 40)
	SetTextPosition(1, 100, 100)
	FixTextToScreen(1, 1)
	SetTextFontImage(1, UIFont)
	SetTextSpacing(1, -7)
	
	CreateSprite(32, LoadImage("cowText1.png"))
	SetSpriteSize(32, 600, 300)
	SetSpritePosition(32, 100, 100)
	SetSpriteColor(32, 125, 125, 125, 255)
	FixSpriteToScreen(32, 1)
	
	//Setting the scene
	SetMusicVolumeOGG(rolling, 0)
	SetParticlesFrequency(feet, 0)
	SetParticlesFrequency(feetIce, 0)
	StopSprite(5)
	SetSpriteAngle(5, 0)
	
	//Offsetting the text box
	if worldLevel = 5
		if GetSpriteX(1) > GetSpriteMiddleX(beach1_shop)
			SetSpritePosition(32, 500, 100)
			
		endif
	endif
	
	//Create the textbox with 4 animation frames
	
	//Just to slow the snowman down
	if GetSpriteExists(1)
		while GetSpritePhysicsVelocityX(1) > .2
			SetSpritePhysicsVelocity(1, GetSpritePhysicsVelocityX(1)/2, GetSpritePhysicsVelocityY(1))
		endwhile
		SetSpritePhysicsVelocity(1, 0, GetSpritePhysicsVelocityY(1))
		SetSpritePhysicsAngularVelocity(1, 0)
	endif
	
	//This whill iterates through the entire text file, one line at a time
	while (CompareString(currentRow$, "") = 0)		
		
		newChara = 0
		if CompareString(":", Mid(currentRow$, 3, 1)) then newChara = 1
		
		//For setting up the new character textbox
		if newChara
		//if CompareString("C", charTalk$)
		
			//charTalk$ =  
			textLine$ = Mid(currentRow$, 5, -1)
		
		//Decorate & position the textbox here
		//Maybe have personal ones up top and ones to the snowman be on the bottom
		else
			textLine$ = currentRow$
		endif
		
		SetTextPosition(1, GetSpriteX(32)+60, GetSpriteY(32)+70)
		
		goToNext = 0	//Trigger to go to the next line
		textShown = 0	//Becomes a 1 when every letter is shown
		showPos = 0		//Showing position
		curChar$ = ""	//For use in line splitting and wait time setting
		waitTime# = 5	//The time that the system waits between displaying a new character
		hurry = 0		//Binary, if 1 then system iterates fast to get to end of line
		spaceNum = 1	//Used for splitting up lines, is the number of spaces in a sentence
		spaceSound = cowbell //The sound that plays for every new word
		maxWidth = (GetSpriteWidth(32)-122) 	//For if a particular line is too long
			
		//This while loop iterates through the line
		while goToNext = 0
			SetSpritePosition(2, GetSpriteX(1)+GetSpriteWidth(1)/2-GetSpriteWidth(2)/2, GetSpriteY(1)-GetSpriteHeight(2)+8)
			SetSpritePosition(3, GetSpriteX(2), GetSpriteY(2)-GetSpriteHeight(3)+8)
			SetSpritePosition(5, GetSpriteX(3)+GetSpriteWidth(3)/6-GetSpritePhysicsVelocityX(1)/50, GetSpriteY(3)+GetSpriteHeight(3)-4)
			fpsr# = 60.0/ScreenFPS()
			
			//Get use GetTextWidth
			
			if textShown = 0 then inc waitTime#, -(fpsr#)
			if hurry then waitTime# = 0
			
			//This processes each character once the wait time between characters is up
			if textShown = 0 and waitTime# <= 0
				
				if showPos = Len(textLine$)
					textShown = 1
					
					
						SetTextCharAngle(1, showPos-1, 0)
						SetTextCharAngle(1, showPos, 0)
					
						SetTextCharColorAlpha(1, showPos-1, 255)
						SetTextCharColorAlpha(1, showPos, 255)
					
				else
					hurryCount = 1 + 4*hurry
					//This while loop is only active while hurrying, this block of code just computes what to do with the next char
					while (hurryCount > 0) and showPos <> Len(textLine$)
						//Does the showposition for the next character, and how long it should wait for
						inc showPos, 1
						curChar$ = Mid(textLine$, showPos, 1)
						
						if showPos = 1 then PlayRandomCharSound(20, 1)
						
						if curChar$ = ","
							waitTime# = 5
						elseif curChar$ = "."
							waitTime# = 6
						elseif curChar$ = " "
							//Many things happen on space! Mostly line spitting
							
							inc spaceNum, 1
							
							oldStr$ = GetTextString(1)
							newLine = 0
							SetTextString(1, GetTextString(1) + GetStringToken(textLine$," ",spaceNum))
							if (GetTextTotalWidth(1) > maxWidth) //or GetTextTotalWidth(1) > maxWidth)
								newLine = 1
								SetTextString(1, oldStr$)
								maxWidth = GetTextTotalWidth(1) + 1
							endif
							
							vol = 20
							if hurry then vol = 5
							PlayRandomCharSound(vol, 1)
							
							if newLine
								SetTextString(1, oldStr$ + chr(10))
								curChar$ = ""	//Set this to 0 so the line length stays consistent
							else
								SetTextString(1, oldStr$)
							endif
							
							waitTime# = 1.5
						else
							waitTime# = 1
						endif
						
						SetTextString(1, GetTextString(1) + curChar$)
						
						SetTextCharAngle(1, showPos-2, 0)
						SetTextCharAngle(1, showPos-1, 15)
						SetTextCharAngle(1, showPos, 30)
						
						SetTextCharColorAlpha(1, showPos-2, 255)
						SetTextCharColorAlpha(1, showPos-1, 205)
						SetTextCharColorAlpha(1, showPos, 155)
						
						//SetTextCharY(1, showPos-2, 0)
						//SetTextCharY(1, showPos-1, 3)
						//SetTextCharY(1, showPos, 6)
						
						inc hurryCount, -1
					endwhile
				endif
				
			endif
			
			//What happens on a space bar: either go to next line, or hurry up this onek
			
			goNext = 0
			if GetRawJoystickConnected(1)
				if GetRawJoystickButtonPressed(1, 1) or GetRawJoystickButtonPressed(1, 2) or GetRawJoystickButtonPressed(1, 3) or GetRawJoystickButtonPressed(1, 4) then goNext = 1
			endif
			if (platform = APPLE or platform = ANDROID)
				if GetVirtualButtonPressed(mobJump) then GoNext = 1
			endif
			
			if GetRawKeyPressed(32) or GetRawKeyPressed(38) or GetRawKeyPressed(87) or GoNext
				if textShown
					goToNext = 1
					SetTextString(1, "")					
				else
					//textShown = 1
					hurry = 1
					//showPos = Len(textLine$)
					//SetTextString(1, textLine$)
				endif
			endif
			
			//Characters can have different talking speeds
			
			//Print(textLine$)
			
			
			if debug
				Print(waitTime#)
				Print(fpsr#)
				Print("")
			endif
			//Print(spaceNum)
			//Print(GetStringToken(textLine$," ",spaceNum))
			Sync()
		endwhile
		
		currentRow$ = ReadLine(1)
	endwhile

	
	//Should play the character noise for every space in line
	//Set the right textbox for a character talking
	
	
	CloseFile(1)
	SetFolder("/media")
	DeleteSprite(32)
	DeleteText(1)

endfunction
*/