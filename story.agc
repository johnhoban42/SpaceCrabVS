// File: story.agc
// Created: 23-06-20

global storyStateInitialized as integer = 0

// Initialize the story screen
function InitStory()
	
	CreateSpriteExpress(SPR_TEXT_BOX, w-80, 280, 0, 0, 10)
	SetSpriteMiddleScreen(SPR_TEXT_BOX)
	
	for i = storyText to storyFitter
		CreateTextExpress(i, "", 60, fontDescI, 0, GetSpriteX(SPR_TEXT_BOX)+20, GetSpriteY(SPR_TEXT_BOX)+20, 8)
		SetTextSpacing(i, -14)
		SetTextColor(i, 0, 0, 0, 255)
	next i
	
	SetTextColorAlpha(storyFitter, 0)
	
	
	
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
	
	ShowScene(0)
	
		
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> STORY
		ExitStory()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitStory()
	
	DeleteSprite(SPR_TEXT_BOX)
	for i = storyText to storyFitter
		DeleteText(i)
	next i
	
	resultsStateInitialized = 0
	
endfunction

function ShowScene(sceneNum)
	
	SetFolder("/media/text")
	
	if sceneNum = 0
		SceneFile$ = "testScene.txt"
	else
		SceneFile$ = "scene" + Str(1 + (sceneNum-1)/4) + "_" + Str(Mod(sceneNum, 4)) + ".txt"
	endif
	
	OpenToRead(1, SceneFile$)
	
	wholeRow$ = ReadLine(1)
		
	//TODO: Read the music file as the first line
	
	//This whill iterates through the entire text file, one line at a time
	while (CompareString(wholeRow$, "") = 0)		
		
		//TODO: Read enterR, enterL, or exit; assign that crab to the sprites on that side of the screen
		
		//TODO: Check if there is a colon; this sets which crab is talking, then delete everything before the colon
		newCrabTalk = 0
		if CompareString(":", Mid(wholeRow$, 3, 1)) then newCrabTalk = 1
		
		
		//TODO: Posing: Grab everything before a semicolon, formatted like 'b12f5'
		//Set those images for the assiciated crab's sprites
		//Grab the chibi life number for later use, choose which one based on the face used
		//Delete the old images if things changed, can maybe use a variable to store & load the previous images index?
		
		
		//TODO: Delete any spaces before the actual dialouge starts
		
		
		wholeRow$ = wholeRow$ + " " //Adding a space to the end of the line for easier processing.
		displayString$ = ""			//The string that is being shown, with line breaks; text moves to here from wholeRow.
		curPos = 0					//The positioning system for the below while loop.
		curChar$ = ""				//The current character at the curPos.
		lastSpacePos = 1				//Keeping track of where the previous space was, so that the line breaks can happen after the overage width is passed.
		
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
		displayString$ = displayString$ + wholeRow$	//Adding the remainder of the row into the display string.
		
		SetTextString(storyText, displayString$)		//Publicly displaying the edited string.
		
		wholeRow$ = ReadLine(1)	//Reading the new line of the text file.
		
		
		//Waiting for the user input before continuing.
		nextLine = 0
		showPos = 1
		lineNum = 0
		
		//Creating seperate tweens for lines 1 through 4
		for i = 0 to 3
			if GetTweenExists(storyText + i) then DeleteTween(storyText + i)
			CreateTweenChar(storyText + i, .05)
			SetTweenCharAlpha(storyText + i, 0, 255, TweenSmooth1())
			SetTweenCharY(storyText + i, -GetTextSize(storyText) + GetTextSize(storyText)*(i-.7), GetTextSize(storyText)*i, TweenOvershoot())
		next i
		
		for i = 0 to len(displayString$)
			SetTextCharColorAlpha(storyText, i, 0)
			
			if Mid(displayString$, i+1, 1) = chr(10) and lineNum < 3
				inc lineNum, 1
			endif
			PlayTweenChar(storyText+lineNum, storyText, i, .02*i)
		next i
		
		hurryUp = 0
		while nextLine = 0

			if GetRawKeyPressed(32)
				hurryUp = 1
			endif
			if hurryUp then UpdateAllTweens(.1)
			if GetRawKeyPressed(32) and GetTweenCharPlaying(storyText, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyText2, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyText3, storyText, len(displayString$)) = 0 and GetTweenCharPlaying(storyText4, storyText, len(displayString$)) = 0 then nextLine = 1
			SyncG()
		endwhile
		
		
	endwhile
	
endfunction

function SetStoryCrabSprites()
	
	
	
endfunction

//The snowtunes code that I'm pulling from
/*
function displayText(tNum)
	
	currentRow$ = ReadLine(1)
	charTalk$ = ""
	talkTo$ = "" 
	textLine$ = ""
	

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