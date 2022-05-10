#include "constants.agc"
#include "game1.agc"
#include "game2.agc"


// This module's purpose is to abstract away game1.agc and game2.agc into a single
// state, GAME, that gets executed from the main game loop.


// Whether this state has been initialized
global gameStateInitialized as integer = 0


// Initialize the game
function InitGame()
	
	CreateGame1()
	CreateGame2()
	gameTimer# = 0
	gameDifficulty1 = 1
	gameDifficulty2 = 1
	meteorTotal1 = 0
	meteorTotal2 = 0
	
	gameStateInitialized = 1
	
endfunction


// Game execution loop
// Each time this loop exits, return the next state to enter into
function DoGame()

	// Initialize if we haven't done so
	// Don't write anything before this!
	if gameStateInitialized = 0
		initGame()
	endif
	state = GAME
	
	// Game execution loops
	state1 = DoGame1()
	state2 = DoGame2()
	UpdateExp()
	inc gameTimer#, fpsr#

	
	// Check for state updates (pausing, losing). Sorry Player 2, Player 1 gets checked first.
	if state1 <> GAME
		state = state1
	elseif state2 <> GAME
		state = state2
	endif
	
	// If we are leaving the state, exit appropriately
	// Don't write anything after this!
	if state <> GAME
		ExitGame()
	endif
	
endfunction state


// Cleanup upon leaving this state
function ExitGame()
	
	// Whatever we do for something like ExitGame1() and ExitGame2() will go here
	gameStateInitialized = 0
	
endfunction

//Functions that are used by both games are down below

function AddMeteorAnimation(spr)
	AddSpriteAnimationFrame(spr, meteorI1)
	AddSpriteAnimationFrame(spr, meteorI2)
	AddSpriteAnimationFrame(spr, meteorI3)
	AddSpriteAnimationFrame(spr, meteorI4)
	PlaySprite(spr, 15, 1, 1, 4)
	
	if Random(1, 2) = 2 then SetSpriteFlip(spr, 1, 0)
	
	SetSpriteShapeCircle(spr, 0, GetSpriteHeight(spr)/8, GetSpriteWidth(spr)/2.8)
endfunction

function CreateExp(metSpr, metType)
	iEnd = 3 //The default experience amount, for regular meteors
	if metType = 2 then iEnd = 4
	if metType = 3 then iEnd = 5

	for i = 1 to iEnd
		CreateSprite(expSprNum, expOrbI)
		SetSpriteSize(expSprNum, 16, 16)
		SetSpritePosition(expSprNum, GetSpriteMiddleX(metSpr) - GetSpriteWidth(expSprNum)/2, GetSpriteMiddleY(metSpr) - GetSpriteHeight(expSprNum)/2)
		SetSpriteColor(expSprNum, 255, 255, 0, 5)
		SetSpriteAngle(expSprNum, Random(1, 360))

		expList.insert(expSprNum)
		inc expSprNum
	next i

endfunction

function UpdateExp()

	deleted = 0

	for i = 1 to expList.Length
		spr = expList[i]

		IncSpriteAngle(spr, 20*fpsr#)

		alpha = GetSpriteColorAlpha(spr)
		if alpha < 255
			IncSpritePosition(spr, (255-alpha)/18*fpsr#*cos(GetSpriteAngle(spr)), (255-alpha)/18*fpsr#*sin(GetSpriteAngle(spr)))

			SetSpriteColorAlpha(spr, GetSpriteColorAlpha(spr) + 10)
		endif

		//Collision for the first crab, second crab will go in another if statement
		dis1 = GetSpriteDistance(spr, crab1)
		if GetSpriteDistance(spr, crab1) < 40
			IncSpritePosition(spr, -(0-(GetSpriteMiddleX(crab1)-GetSpriteX(spr)))/4.0*fpsr#, -(0-(GetSpriteMiddleY(crab1)-GetSpriteY(spr)))/4.0*fpsr#)
			//GlideToSpot(spr, GetSpriteMiddleX(crab1), GetSpriteMiddleY(crab1), 5)
			//Either gliding method above works, I like the way the one on top looks more

			//Visual Indicator
			if GetSpriteColorGreen(spr) > 90
				SetSpriteColorGreen(spr, GetSpriteColorGreen(spr) - 40*fpsr#)
			endif

			//This is only for the bottom crab
			if GetSpriteCollision(spr, crab1) and deleted = 0
				deleted = i
				DeleteSprite(spr)

				if expTotal1 < specialCost1
					inc expTotal1, 1
					if expTotal1 = specialCost1
						SetSpriteColor(expBar1, 255, 210, 50, 255)
						PlaySprite(expBar1, 30, 1, 1, 6)	//Faster than when it's not filled
						//Base color: SetSpriteColor(expBar1, 255, 160, 0, 255)
					endif
				endif
				
				UpdateButtons1()				

				//This is for instant bar size adjustment
				//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)

				//Add to the exp bar here
				//Todo: Sound effect
			endif


		endif

	next i

	GlideToWidth(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 2)


	if deleted > 0
		expList.remove(deleted)

	endif

endfunction

function ShowSpecialAnimation(crabType)
	
	fpsr# = 60.0/ScreenFPS()
	
	//Pausing the current animations
	StopSprite(crab1)
	StopSprite(crab2)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		StopSprite(meteorActive2[i].spr)
	next i
	
	CreateSprite(specialBG, 0)
	SetSpriteColor(specialBG, 0, 0, 0, 80)
	SetSpriteSizeSquare(specialBG, h*3)
	SetSpriteMiddleScreen(specialBG)
	SetSpriteDepth(specialBG, 3)
	
	wid = 400
	hei = 400
	for i = specialSprFront1 to specialSprBack2
		CreateSprite(i, 0)
		SetSpriteSize(i, 400, 400)
		if Mod(i, 2) = 0
			//Back Sprites
			SetSpriteDepth(i, 2)
			SetSpriteColor(i, 150, 150, 150, 255)
		else
			//Front Sprites
			SetSpriteDepth(i, 1)
		endif
	next i
	
	//Goes from right to left on bottom
	SetSpritePosition(specialSprFront1, w + 100, h - 500)
	//Goes from left to right on bottom
	SetSpritePosition(specialSprBack1, -100 - wid, h - 650)
	
	//Goes from right to left on bottom
	SetSpritePosition(specialSprFront2, -100 - wid, 100)
	//Goes from left to right on top
	SetSpritePosition(specialSprBack2, w + 100, 250)
	
	iEnd = 120/fpsr#
	for i = 1 to iEnd
		//Setting the speed of the images based on the progress through the loop
		if i <= iEnd*1/9
			speed = 25*fpsr#*75/60
		elseif i <= iEnd*6/9
			speed = 3*fpsr#*75/60
		else
			speed = 5+(i-iEnd*6/9)*fpsr#*75/60
		endif
		
		
		IncSpriteXFloat(specialSprFront1, -1.2*speed)
		IncSpriteXFloat(specialSprBack1, 1*speed)
		IncSpriteXFloat(specialSprFront2, 1.2*speed)
		IncSpriteXFloat(specialSprBack2, -1*speed)
		
		Sync()
	next i
	

	
	
	for i = specialBG to specialSprBack2
		DeleteSprite(i)
	next i
	
	//Resuming the current animations
	PlaySprite(crab1)
	PlaySprite(crab2)
	for i = 1 to meteorActive1.length
		PlaySprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		PlaySprite(meteorActive2[i].spr)
	next i
	
endfunction