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
	InitParticles()
	gameTimer# = 0
	gameDifficulty1 = 1
	gameDifficulty2 = 1
	meteorTotal1 = 0
	meteorTotal2 = 0
	
	PlayMusicOGG(fightAMusic, 1)	//Todo: put in a music randomizer
	
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
	if hit1Timer# > 0
		//This is the case for getting hit
		state1 = HitScene1()
	else
		//This is the case for normal gameplay
		state1 = DoGame1()
	endif
	if hit2Timer# > 0
		//This is the case for getting hit
		state2 = HitScene2()
	else
		//This is the case for normal gameplay
		state2 = DoGame2()
	endif
	UpdateExp()
	inc gameTimer#, fpsr#
	
	if hit1Timer# > 0 or hit2Timer# > 0
		DisableAttackButtons()
	endif
	
	//Stops the game from crashing if this number gets too high (proper range is 1000 to 2000).
	if meteorSprNum > 1900
		meteorSprNum = 1050
	endif
	
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
	
	for i = fightAMusic to fightJMusic
		if GetMusicExistsOGG(i)
			if GetMusicPlayingOGG(i) then StopMusicOGG(i)
		endif
	next i
	
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

function CreateExp(metSpr, metType, planetNum)
	iEnd = 1 + planetNum //The default experience amount, for regular meteors
	if metType = 2 then iEnd = 2 + planetNum
	if metType = 3 then iEnd = 3 + planetNum

	for i = 1 to iEnd
		CreateSprite(expSprNum, expOrbI)
		SetSpriteSize(expSprNum, 16, 16)
		SetSpritePosition(expSprNum, GetSpriteMiddleX(metSpr) - GetSpriteWidth(expSprNum)/2, GetSpriteMiddleY(metSpr) - GetSpriteHeight(expSprNum)/2)
		SetSpriteColor(expSprNum, 255, 255, 0, 5)
		SetSpriteAngle(expSprNum, Random(1, 360))
		SetSpriteDepth(expSprNum, 7)

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

		//Collision for the first/bottom crab
		//dis1 = GetSpriteDistance(spr, crab1)
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
				
				//For second crab, have a different kind pf exp sound
				rnd = Random(0, 4)
				PlaySoundR(exp1S + rnd, volumeSE)

				//This is for instant bar size adjustment
				//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)

				//Add to the exp bar here
				//Todo: Sound effect
			endif


		endif
		
		//Collision for the second/top crab
		//dis1 = GetSpriteDistance(spr, crab2)
		if deleted = 0
			if GetSpriteDistance(spr, crab2) < 40
				IncSpritePosition(spr, -(0-(GetSpriteMiddleX(crab2)-GetSpriteX(spr)))/4.0*fpsr#, -(0-(GetSpriteMiddleY(crab2)-GetSpriteY(spr)))/4.0*fpsr#)
				//GlideToSpot(spr, GetSpriteMiddleX(crab2), GetSpriteMiddleY(crab2), 5)
				//Either gliding method above works, I like the way the one on top looks more
	
				//Visual Indicator
				if GetSpriteColorGreen(spr) > 90
					SetSpriteColorGreen(spr, GetSpriteColorGreen(spr) - 40*fpsr#)
				endif
	
				//This is only for the top crab
				if GetSpriteCollision(spr, crab2) and deleted = 0
					deleted = i
					DeleteSprite(spr)
	
					if expTotal2 < specialCost2
						inc expTotal2, 1
						if expTotal2 = specialCost2
							SetSpriteColor(expBar2, 255, 210, 50, 255)
							PlaySprite(expBar2, 30, 1, 1, 6)	//Faster than when it's not filled
							//Base color: SetSpriteColor(expBar1, 255, 160, 0, 255)
						endif
					endif
					
					UpdateButtons2()	
					
					//For second crab, have a different kind pf exp sound??
					rnd = Random(0, 4)
					PlaySoundR(exp1S + rnd, volumeSE)
	
					//This is for instant bar size adjustment
					//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)
	
					//Add to the exp bar here
					//Todo: Sound effect
				endif
	
	
			endif
		endif

	next i

	GlideToWidth(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 2)
	GlideToWidth(expBar2, (GetSpriteWidth(expHolder2)-20)*(1.0*expTotal2/specialCost2), 2)
	SetSpriteX(expBar2, GetSpriteX(expHolder2) + GetSpriteWidth(expHolder2) - GetSpriteWidth(expBar2)-10)

	if deleted > 0
		expList.remove(deleted)

	endif

endfunction

//This deletes all experience on half of the board
function DeleteHalfExp(gameNum)
	badLeave = 1
	while badLeave = 1
		
		badLeave = 0
		deleted = 0
		
		for i = 1 to expList.Length
			
			spr = expList[i]
			if gameNum = 1
				//This is only for the bottom crab
				if GetSpriteY(spr) > h/2 and deleted = 0
					deleted = i
					DeleteSprite(spr)
					badLeave = 1
				endif
			endif
			
			if gameNum = 2
				//This is only for the top crab
				if GetSpriteY(spr) < h/2 and deleted = 0
					deleted = i
					DeleteSprite(spr)
					badLeave = 1
				endif
			endif
			
		next i
		
		if deleted > 0
			expList.remove(deleted)
		endif
	endwhile
endfunction

function ShowSpecialAnimation(crabType)
	
	fpsr# = 60.0/ScreenFPS()
	
	PlaySoundR(specialS, volumeSE)
	
	//Pausing the current animations
	StopSprite(crab1)
	StopSprite(crab2)
	for i = 1 to meteorActive1.length
		StopSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		StopSprite(meteorActive2[i].spr)
	next i
	for i = par1met1 to par2spe1
		SetParticlesActive(i, 0)
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
		SetSpriteSizeSquare(i, 400)
		if Mod(i, 2) = 0
			//Back Sprites
			SetSpriteDepth(i, 2)
			SetSpriteColor(i, 220, 220, 220, 255)
			SetSpriteSizeSquare(i, 300)	//Smaller at Brad's request
			if crabType = 1 or crabType = 2 or crabType = 6
				//This if statement is only here while not every image is in the game
				SetSpriteImage(i, crab1attack2I - 1 + crabType)
			endif
		else
			//Front Sprites
			SetSpriteDepth(i, 1)
			if crabType = 1 or crabType = 2 or crabType = 6
				//This if statement is only here while not every image is in the game
				SetSpriteImage(i, crab1attack1I - 1 + crabType)
			endif
		endif
		
		if i >= specialSprFront2 then SetSpriteAngle(i, 180)
		
	next i
	
	offsetY = 30
	
	//Goes from right to left on bottom
	//SetSpritePosition(specialSprFront1, w + 100, h - 500 - offsetY)
	//Goes from left to right on bottom
	//SetSpritePosition(specialSprBack1, -100 - wid, h - 650 - offsetY)
	
	//Goes from right to left on top
	//SetSpritePosition(specialSprFront2, -100 - wid, 100 + offsetY)
	//Goes from left to right on top
	//SetSpritePosition(specialSprBack2, w + 100, 250 + offsetY)
	
	//For Wizard crab only (actually, this is now for every crab!)
	//if crabType = 2
		//Goes from right to left on bottom
		SetSpritePosition(specialSprFront1, -100 - wid, h - 500 - offsetY)
		//Goes from left to right on bottom
		SetSpritePosition(specialSprBack1, w + 100, h - 650 - offsetY)
		
		//Goes from right to left on top
		SetSpritePosition(specialSprFront2, w + 100, 100 + offsetY)
		//Goes from left to right on top
		SetSpritePosition(specialSprBack2, -100 - wid, 250 + offsetY)
	//endif
	
	//The text for the special
	
	tDir = 1
	
	for i = specialSprFront1 to specialSprFront2 step 2
		CreateText(i, "")
		SetTextFontImage(i, fontSpecialI)
		SetTextAlignment(i, 1)
		SetTextSize(i, 106)
		SetTextPosition(i, 2000*tDir, 1440)
		if i = specialSprFront2
			SetTextX(i, -2000*tDir)
			SetTextY(i, h - 1440 )
			SetTextAngle(i, 180)
		endif
		SetTextDepth(i, 1)
		SetTextSpacing(i, -20)
		if crabType = 1 then SetTextString(i, "METEOR SHOWER")
		if crabType = 2 then SetTextString(i, "CONJURE COMETS")
		if crabType = 3 then SetTextString(i, "ORBITAL NIGHTMARE")
		if crabType = 4 then SetTextString(i, "PARTY TIME!")
		if crabType = 5 then SetTextString(i, "FAST FOWARD")
		if crabType = 6 then SetTextString(i, "SHURI-KRUSTACEAN")
	next i
	
	iEnd = 120/fpsr#
	for i = 1 to iEnd
		
		if i <= iEnd*1/4 and i > 2
			if GetPointerPressed() and GetPointerY() > h/2 then buffer1 = 1
			if GetPointerPressed() and GetPointerY() < h/2 then buffer2 = 1
		endif
		
		//Setting the speed of the images based on the progress through the loop
		if i <= iEnd*1/9
			speed = 25*fpsr#*75/60
		elseif i <= iEnd*6/9
			speed = 3*fpsr#*75/60
		else
			speed = 5+(i-iEnd*6/9)*fpsr#*75/60
		endif
		
		if i = iEnd*2/3 then PlaySoundR(specialExitS, volumeSE)
		
		/*
		if crabType <> 2
			IncSpriteXFloat(specialSprFront1, -1.2*speed)
			IncSpriteXFloat(specialSprBack1, 1*speed)
			IncSpriteXFloat(specialSprFront2, 1.2*speed)
			IncSpriteXFloat(specialSprBack2, -1*speed)
		else */
			//For wizard crab's positioning
			IncSpriteXFloat(specialSprFront1, 1.3*speed)
			IncSpriteXFloat(specialSprBack1, -1.1*speed)
			IncSpriteXFloat(specialSprFront2, -1.3*speed)
			IncSpriteXFloat(specialSprBack2, 1.1*speed)
		//endif
		
		if i < iEnd*5/7
			GlideTextToX(specialSprFront1, w/2, 6)
			GlideTextToX(specialSprFront2, w/2, 6)
		else
			GlideTextToX(specialSprFront1, -2000*tDir, 30)
			GlideTextToX(specialSprFront2, 2000*tDir, 30)
		endif
		
		Sync()
	next i
	

	
	
	for i = specialBG to specialSprBack2
		DeleteSprite(i)
	next i
	
	//Resuming the current animations
	ResumeSprite(crab1)
	//ResumeSprite(crab2)
	for i = 1 to meteorActive1.length
		ResumeSprite(meteorActive1[i].spr)
	next i
	for i = 1 to meteorActive2.length
		//ResumeSprite(meteorActive2[i].spr)
	next i
	for i = par1met1 to par2spe1
		SetParticlesActive(i, 1)
	next i
	for i = specialSprFront1 to specialSprFront2 step 2
		DeleteText(i)
	next i
	
endfunction

function InitParticles()
	//This makes sure the particles are only created once
	if GetParticlesExists(par1met1) = 0
		
		img = LoadImage("envi/explode.png")
		lifeEnd# = 2.2
		
		for i = par1met1 to par2spe1
			CreateParticles(i, 2000, 2000)	//This is out of range so that
    		SetParticlesImage (i, img)
			SetParticlesFrequency(i, 300)
			SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
			SetParticlesSize(i, 20)
			SetParticlesStartZone(i, -5, -5, 5, 5) //The box that the particles can start from
    		SetParticlesDirection(i, 30, 20)
    		SetParticlesAngle(i, 360)
    		SetParticlesVelocityRange (i, 0.8, 2.5 )
    		SetParticlesMax (i, 100)
    		SetParticlesDepth(i, 25)
    		
    		 if Mod(i, 4) = 1
				AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 0 )
				AddParticlesColorKeyFrame (i, 0.01, 255, 255, 0, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			elseif Mod(i, 4) = 2
				AddParticlesColorKeyFrame (i, 0.0, 0, 0, 0, 0 )
				AddParticlesColorKeyFrame (i, 0.01, 239, 0, 239, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 30, 50, 180, 0 )
			elseif Mod(i, 4) = 3
				AddParticlesColorKeyFrame (i, 0.0, 255, 0, 0, 0 )
				AddParticlesColorKeyFrame (i, 0.01, 255, 100, 100, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 255, 0, 0, 0 )
			elseif Mod(i, 4) = 0
				//For the special wizard sparkles
				SetParticlesImage (i, expOrbI)
				SetParticlesPosition (i, w/2, h*3/4 - h/2*(i/4-1))	//Places them on different screen centers
				SetParticlesFrequency(i, 60)
	    		SetParticlesMax(i, 0)
				SetParticlesLife(i, lifeEnd#)	//Time in seconds that the particles stick around
				SetParticlesSize(i, 8)
				SetParticlesStartZone(i, -w/2, -h/4, w/2, h/4) //The box that the particles can start from
	    		SetParticlesDirection(i, 0, 5)
	    		SetParticlesAngle(i, 360)
	    		SetParticlesVelocityRange (i, .1, .6)
	    		SetParticlesDepth(i, 5)
	    		
	    		AddParticlesColorKeyFrame (i, 0.0, 255, 255, 100, 0 )
				AddParticlesColorKeyFrame (i, .6, 255, 255, 100, 255 )
				AddParticlesColorKeyFrame (i, lifeEnd#, 205, 205, 50, 0 )
    		endif
		next i
	
	endif
endfunction

function ActivateMeteorParticles(mType, spr, gameNum)

	par = mType + (gameNum-1)*4
	if mType <> 4
		//For general meteors
		SetParticlesPosition (par, GetSpriteMiddleX(spr), GetSpriteMiddleY(spr))
		ResetParticleCount (par)
	else
		//For wizard sparkles
	    SetParticlesActive(par, 1)
		ResetParticleCount(par)
		SetParticlesMax(par, 480)
	endif    
 
endfunction

function SetSpriteColorByCycle(spr, numOf360)
	//Make sure the cycleLength is divisible by 6!
	cycleLength = 360
	colorTime = Mod(numOf360*3, 360)
	phaseLen = cycleLength/6
	
	tmpSpr = CreateSprite(0)
	
	//Each colorphase will last for one phaseLen
	if colorTime <= phaseLen	//Red -> O
		t = colorTime
		SetSpriteColor(tmpSpr, 255, (t*127.0)/phaseLen, 0, 255)
		
	elseif colorTime <= phaseLen*2	//Orange -> Y
		t = colorTime-phaseLen
		SetSpriteColor(tmpSpr, 255, 128+(t*127.0)/phaseLen, 0, 255)
		
	elseif colorTime <= phaseLen*3	//Yellow -> G
		t = colorTime-phaseLen*2
		SetSpriteColor(tmpSpr, 255-(t*255.0/phaseLen), 255, 0, 255)
		
	elseif colorTime <= phaseLen*4	//Green -> B
		t = colorTime-phaseLen*3
		SetSpriteColor(tmpSpr, 0, 255-(t*255.0/phaseLen), (t*255.0/phaseLen), 255)
		
	elseif colorTime <= phaseLen*5	//Blue -> P
		t = colorTime-phaseLen*4
		SetSpriteColor(tmpSpr, (t*139.0/phaseLen), 0, 255, 255)
		
	else 	//Purple -> R
		t = colorTime-phaseLen*5
		SetSpriteColor(tmpSpr, 139+(t*116.0/phaseLen), 0, 255-(t*255.0/phaseLen), 255)
		
	endif
	//The -255 is a remnant from SPA, to keep the color changing the same, this can be removed if desired
	r = 255-GetSpriteColorRed(tmpSpr)
	g = 255-GetSpriteColorGreen(tmpSpr)
	b = 255-GetSpriteColorBlue(tmpSpr)
	SetSpriteColor(spr, r, g, b, GetSpriteColorAlpha(spr))
	
	DeleteSprite(tmpSpr)
endfunction

function GetCrabDefaultR(spr)
	//Returns the normal height that a crab will be at
	r# = planetSize/2 + GetSpriteHeight(spr)/3
endfunction r#

function SetBGRandomPosition(spr)
	//Sets the background to a random angle/spot
	SetSpriteSizeSquare(spr, w*2)
	if spr = bgGame1 or spr = SPR_CS_BG_1 then SetSpritePosition(spr, -1*w + Random(0, w), h/2)
	if spr = bgGame2 or spr = SPR_CS_BG_2 then SetSpritePosition(spr, -1*w + Random(0, w), h/2-GetSpriteHeight(spr))
	SetSpriteAngle(spr, 90*Random(1, 4))
	
	if appState = CHARACTER_SELECT
		SetSpriteSizeSquare(spr, w)
		if spr = SPR_CS_BG_1
			SetSpriteAngle(spr, 0)
			SetSpritePosition(spr, 0, h/2)
		endif
		if spr = SPR_CS_BG_2
			SetSpritePosition(spr, 0, h/2-GetSpriteHeight(spr))
			SetSpriteAngle(spr, 180)
		endif
		//For the character selection
	endif
	
endfunction

function DisableAttackButtons()
	SetSpriteColorAlpha(meteorButton1, 100)
	SetSpriteColorAlpha(specialButton1, 100)
	SetSpriteColorAlpha(meteorButton2, 100)
	SetSpriteColorAlpha(specialButton2, 100)
endfunction

function EnableAttackButtons()
	UpdateButtons1()
	UpdateButtons2()
endfunction