#include "myLib.agc"
#include "constants.agc"

function DrawPolar1(spr, rNum, theta#)
	if GetSpriteExists(spr)
		cenX = w/2
		cenY = h*3/4 + GetSpriteHeight(split)/4
		SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
		SetSpriteAngle(spr, theta#+90)
	endif
endfunction

function CreateGame1()
	CreateSprite(planet1, planetIRandStart + Random(1, 8))
	SetSpriteSizeSquare(planet1, planetSize)
	SetSpriteShape(planet1, 1)
	DrawPolar1(planet1, 0, 270)
	SetSpriteDepth(planet1, 8)
	
	CreateSprite(crab1, LoadImage("crab0walk1.png"))
	SetSpriteSize(crab1, 64, 40)
	SetSpriteDepth(crab1, 3)
	SetSpriteShapeCircle(crab1, 0, 0, 24)
	crab1R# = GetCrabDefaultR(crab1)
	
	if GetSpriteExists(bgGame1) = 0 then CreateSprite(bgGame1, 0)
	SetSpriteImage(bgGame1, bg1I)
	SetBGRandomPosition(bgGame1)
	SetSpriteDepth(bgGame1, 100)
	
	crab1Theta# = 270
	DrawPolar1(crab1, crab1R#, crab1Theta#)
	if crab1Type = 1		//Space
		for i = crab1start1I to crab1death2I
			AddSpriteAnimationFrame(crab1, i)
		next i
		
	elseif crab1Type = 2	//Wizard
		for i = crab2start1I to crab2death2I
			AddSpriteAnimationFrame(crab1, i)
		next i
		SetSpriteSize(crab1, 64, 60)
		SetSpriteShapeCircle(crab1, 0, 10, 24)
		
	elseif crab1Type = 6	//Ninja
		for i = crab6start1I to crab6death2I
			AddSpriteAnimationFrame(crab1, i)
		next i
		
	else
		//The debug option, no crab selected
		for i = crab1start1I to crab1death2I
			AddSpriteAnimationFrame(crab1, i)
		next i
	endif

	PlaySprite(crab1, crab1framerate, 1, 3, 10)
	
	CreateSprite(expHolder1, 0)
	SetSpriteSize(expHolder1, w - 230, 40)
	SetSpriteMiddleScreenX(expHolder1)
	SetSpriteY(expHolder1, h-50)
	SetSpriteDepth(expHolder1, 18)
	SetSpriteColor(expHolder1, 150, 150, 150, 200)

	CreateSprite(expBar1, 0)
	SetSpriteSize(expBar1, 0, 26)
	SetSpritePosition(expBar1, GetSpriteX(expHolder1) + 10, GetSpriteY(expHolder1) + 7)
	SetSpriteDepth(expBar1, 18)
	SetSpriteColor(expBar1, 255, 160, 0, 255)
	AddSpriteAnimationFrame(expBar1, expBarI1)
	AddSpriteAnimationFrame(expBar1, expBarI2)
	AddSpriteAnimationFrame(expBar1, expBarI3)
	AddSpriteAnimationFrame(expBar1, expBarI4)
	AddSpriteAnimationFrame(expBar1, expBarI5)
	AddSpriteAnimationFrame(expBar1, expBarI6)
	//Current EXP bar animation is a temp one, this is just the framework
	PlaySprite(expBar1, 20, 1, 1, 6)
	
	CreateSprite(meteorButton1, 0)
	SetSpriteSize(meteorButton1, 90, 90)
	SetSpritePosition(meteorButton1, GetSpriteX(expHolder1)-10-GetSpriteWidth(meteorButton1), h-10-GetSpriteHeight(meteorButton1))
	SetSpriteDepth(meteorButton1, 15)
	SetSpriteColor(meteorButton1, 255, 100, 30, 100)
	//Might want to make the Y based on the sxp bar holder instead of the screen height
	
	CreateSpriteExpress(meteorMarker1, 4, GetSpriteHeight(expHolder1)+4, 0, GetSpriteY(expHolder1)-2, 14)
	//The X is on a seperate line because it is long
	SetSpriteX(meteorMarker1, GetSpriteX(expBar1) + 1.0*(GetSpriteWidth(expHolder1)-20)*meteorCost1/specialCost1 - 4)
	SetSpriteColor(meteorMarker1, 255, 100, 30, 255)
	
	CreateSprite(specialButton1, 0)
	SetSpriteSize(specialButton1, 100, 100)
	SetSpritePosition(specialButton1, GetSpriteX(expHolder1) + GetSpriteWidth(expHolder1) + 7, h-20-GetSpriteHeight(meteorButton1))
	SetSpriteDepth(specialButton1, 15)
	SetSpriteColor(specialButton1, 20, 255, 40, 100)
	
	crab1PlanetS[1] = 116
	crab1PlanetS[2] = 117
	crab1PlanetS[3] = 118
	//The planet UI that shows how many lives are left
	for i = 1 to 3
		CreateSpriteExpress(crab1PlanetS[i], planetIconSize, planetIconSize, w/2 - planetIconSize/2 + (i-2)*planetIconSize*1.5, h/2 + 80, 5)
		
	next i
	
	//Setting gameplay parameters to their proper values
	crab1Deaths = 0
		
endfunction

function DoGame1()
	
	//The Space Crab special (just Space Ned)
	if specialTimerAgainst1# > 0 and crab2Type = 1
		DrawPolar1(special2Ex1, ((specialTimerAgainst1# - 100)^2)/11, 0 + specialTimerAgainst1#)
		SetSpriteAngle(special2Ex1, sin(specialTimerAgainst1#*8)*10)
	endif
	
	//The Top Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 3
		if specialTimerAgainst1# > topCrabTimeMax*3/5
			//Phase 1 and 2
			inc planet1RotSpeed#, planetSpeedUpRate#*fpsr#
			
		elseif specialTimerAgainst1# > topCrabTimeMax*2/5
			//Phase 3
			inc planet1RotSpeed#, -3*planetSpeedUpRate#*fpsr#
			
		elseif specialTimerAgainst1# > topCrabTimeMax/5
			//Phase 4
			inc planet1RotSpeed#, -1*planetSpeedUpRate#*fpsr#
			
		else
			//Phase 5 (end)
			inc planet1RotSpeed#, 2*planetSpeedUpRate#*fpsr#
		endif
		IncSpriteAngle(planet1, planet1RotSpeed#)
		inc crab1Theta#, planet1RotSpeed#
	endif
		
	//The Rave Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 4
		for i = special2Ex1 to special2Ex5
			SetSpriteColorByCycle(i, specialTimerAgainst1#)
		next i
		if specialTimerAgainst1# < raveCrabTimeMax/8
			for i = special2Ex1 to special2Ex5
				SetSpriteColorAlpha(i, specialTimerAgainst1#*255/(raveCrabTimeMax/8))
			next i
			SetMusicVolumeOGG(raveBass2, specialTimerAgainst1#*100/(raveCrabTimeMax/8))
		endif
	endif
	
	//The Chrono Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 5
		if specialTimerAgainst1# > chronoCrabTimeMax*9/10
			//The startup
			ratio# = (specialTimerAgainst1#-chronoCrabTimeMax*9/10)/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*(1.0-ratio#)
			for i = special2Ex1 to special2Ex3
				FadeSpriteIn(i, specialTimerAgainst1#, chronoCrabTimeMax, chronoCrabTimeMax*9/10)
			next i 
		elseif specialTimerAgainst1# < chronoCrabTimeMax/10
			//The winddown
			ratio# = specialTimerAgainst1#/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*ratio#
			for i = special2Ex1 to special2Ex3
				FadeSpriteOut(i, specialTimerAgainst1#, chronoCrabTimeMax/10, 0)
			next i 
		else
			//The normal
			fpsr# = fpsr# * 1.9
		endif
		DrawPolar1(special2Ex1, GetSpriteHeight(special2Ex1)/2, 270 - (specialTimerAgainst1#/chronoCrabTimeMax)*1080*6) //Minute Hand
		DrawPolar1(special2Ex2, GetSpriteHeight(special2Ex2)/2, 270 - (specialTimerAgainst1#/chronoCrabTimeMax)*360*2) //Hour Hand
		//Clock wiggle
		SetSpriteSize(special2Ex3, 150+12*sin(specialTimerAgainst1#*6), 150+12*cos(specialTimerAgainst1#*5))
		DrawPolar1(special2Ex3, 0, 0)
		SetSpriteAngle(special2Ex3, 180 + 5.0*cos(specialTimerAgainst1#*2))
	endif
	
	//The Ninja Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 6
		if specialTimerAgainst1# < ninjaCrabTimeMax and GetSpriteColorAlpha(special2Ex1) = 0
			spr = special2Ex1
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySound(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst1# < ninjaCrabTimeMax*4/5 and GetSpriteColorAlpha(special2Ex2) = 0
			spr = special2Ex2
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySound(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst1# < ninjaCrabTimeMax*3/5 and GetSpriteColorAlpha(special2Ex3) = 0
			spr = special2Ex3
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySound(ninjaStarS, volumeSE)
		endif
		
		for i = special2Ex1 to special2Ex3
			numLoop = i - special2Ex1 + 1
			
			IncSpriteAngle(i, 16*fpsr#)
			IncSpriteYFloat(i, 5.5*fpsr#)
		next i
	endif
	
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if buffer1 or(((GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0 and crab1JumpD# = 0)
		
		buffer1 = 0
		if crab1Turning = 0
			PlaySound(turnS, volumeSE)
			if crab1Dir# > 0
				crab1Turning = -1
			else
				crab1Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab1Turning = -1*crab1Turning
			
			if Abs(crab1Dir#) < crab1Vel#/3
				//The crab leap code
				//crab1Turning = -1*crab1Turning	//Still not sure if you should leap forwards or backwards
				PlaySound(jumpS, volumeSE)
				crab1JumpD# = crab1JumpDMax
				crab1Dir# = crab1Vel#
			else
				//Crab has turned
				PlaySound(turnS, volumeSE)
			endif
		endif
		
	endif
	
	//The jumping movement code
	if crab1JumpD# > 0
		
		if crab1JumpD# > crab1JumpDMax*7/8
			PlaySprite(crab1, 0, 0, 11, 11)	
		else
			PlaySprite(crab1, 0, 0, 12, 12)	
		endif
		
		//Incrementing the crab's movement a tiny bit more when leaping
		inc crab1Theta#, crab1Vel# * 0.95 * crab1Dir# * fpsr#
		//Original velo: 0.85
		
		inc crab1JumpD#, -1*fpsr#
		
		//Resetting the crab back to normal
		if crab1JumpD# < 0
			crab1JumpD# = 0
			if crab1Dir# < 0
				SetSpriteFlip(crab1, 1, 0)
			else
				SetSpriteFlip(crab1, 0, 0)
			endif
			PlaySprite(crab1, crab1framerate, 1, 3, 10)		
		endif
		
	endif
		
	//Enacting the crab turn while activated
	if crab1Turning <> 0 then TurnCrab1(crab1Turning)
	
	//Making sure the crab is using proper rotation numbers
	if crab1Theta# > 360 then inc crab1Theta#, -360
	if crab1Theta# < 0 then inc crab1Theta#, 360
	
	//This cancels out the weird issue where the integer is sometimes infinity
	if crab1Theta# > 10000000 then crab1Theta# = 270
	
	//The visual update code
	DrawPolar1(crab1, planetSize/2 + GetSpriteHeight(crab1)/3, crab1Theta#)
	//Visuals for if the crab is jumping
	if crab1JumpD# > 0
		DrawPolar1(crab1, planetSize/2 + GetSpriteHeight(crab1)/3 + crab1JumpHMax# * (crab1JumpD# - (crab1JumpD#^2)/crab1JumpDMax), crab1Theta#)
	endif
	//Adjusting the crab angle for the dive, cosmetic
	if crab1JumpD# > 0
		SetSpriteAngle(crab1, GetSpriteAngle(crab1) + crab1JumpD#/crab1JumpDMax*360 * -1 * crab1Dir#)
	endif
	
	if specialTimerAgainst1# > 0 then inc specialTimerAgainst1#, -1*fpsr#
	
	//Cleaning up Space Crab's special
	if specialTimerAgainst1# < 0 and crab2Type = 1
		specialTimerAgainst1# = 0
		DeleteSprite(special2Ex1)
		
	endif
	
	//Cleaning up Top Crab's special
	if specialTimerAgainst1# < 0 and crab2Type = 3
		if Mod(GetSpriteAngle(planet1), 360) > 1
			ang# = GlideNumToZero(GetSpriteAngle(planet1), 10)
			SetSpriteAngle(planet1, ang#)
		else
			specialTimerAgainst1# = 0
			SetSpriteAngle(planet1, 0)
		endif
		
	endif
	
	//Cleaning up Rave Crab's special
	if specialTimerAgainst1# <= 0 and crab2Type = 4
		for i = special2Ex1 to special2Ex5
			DeleteSprite(i)
		next i
		StopMusicOGG(raveBass2)
	endif
	
	//Cleaning up Chrono & Ninja Crab's special
	if specialTimerAgainst1# < 0 and (crab2Type = 5 or crab2Type = 6)
		for i = special2Ex1 to special2Ex3
			DeleteSprite(i)
		next i
		specialTimerAgainst1# = 0
	endif
	
	newMet as meteor
	newMet.cat = 0
	inc met1CD1#, -1 * fpsr#
	inc met2CD1#, -1 * fpsr#
	inc met3CD1#, -1 * fpsr#
	
	if met1CD1# < 0
		met1CD1# = Random(met1RNDLow - 5*gameDifficulty1, met1RNDHigh) - 20*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = metStartDistance
		newMet.spr = meteorSprNum
		newMet.cat = 1
				
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
		SetSpriteDepth(meteorSprNum, 20)
		AddMeteorAnimation(meteorSprNum)
		inc meteorSprNum, 1
		meteorActive1.insert(newMet)
	endif
	
	if met2CD1# < 0 and gameTimer# > 800
		met2CD1# = Random(met2RNDLow - 5*gameDifficulty1, met2RNDHigh) - 20*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = metStartDistance
		newMet.spr = meteorSprNum
		newMet.cat = 2
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX*1.1, metSizeY*1.1)
		SetSpriteColor(meteorSprNum, 150, 40, 150, 255)
		SetSpriteDepth(meteorSprNum, 20)
		AddMeteorAnimation(meteorSprNum)
		inc meteorSprNum, 1
		
		meteorActive1.insert(newMet)
	endif
	
	if met3CD1# < 0 and gameTimer# > 1600
		met3CD1# = Random(met3RNDLow - 15*gameDifficulty1, met3RNDHigh) - 25*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = 5000
		newMet.spr = meteorSprNum
		newMet.cat = 3
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX*1.2, metSizeY*1.2)
		SetSpriteColor(meteorSprNum, 235, 60, 60, 255)
		SetSpriteDepth(meteorSprNum, 20)
		AddMeteorAnimation(meteorSprNum)
		
		CreateSprite(meteorSprNum + 10000, meteorTractorI)
		SetSpriteSize(meteorSprNum + 10000, 1, 1000)
		SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
		SetSpriteDepth(meteorSprNum + 10000, 30)
		
		inc meteorSprNum, 1
		
		meteorActive1.insert(newMet)
	endif
		
	UpdateMeteor1()
	
	//DrawPolar1(planet1, 0, 270)
	
	if expTotal1 >= meteorCost1 and (Button(meteorButton1) and GetPointerPressed()) and hit2Timer# <= 0
		SendMeteorFrom1()
	endif
	
	if expTotal1 = specialCost1 and (Button(specialButton1) and GetPointerPressed()) and hit2Timer# <= 0
		SendSpecial1()
	endif
	
	//Death is above so that the screen nudging code activates
	hitSpr = CheckDeath1()
	if hitSpr <> 0
		DeleteSprite(hitSpr)
		//Kill crab
		inc crab1Deaths, 1
		hit1Timer# = hitSceneMax
	endif
	
	NudgeScreen1()
	
	fpsr# = 60.0/ScreenFPS()
	
endfunction state

function TurnCrab1(dir)
	
	//Accelerating the crab in the specified direction
	inc crab1Dir#, dir * crab1Accel# * fpsr#
	
	if crab1Dir# < 0
		SetSpriteFlip(crab1, 1, 0)
	else
		SetSpriteFlip(crab1, 0, 0)
	endif
	
	if Abs(crab1Dir#) > .5
		PlaySprite(crab1, 0, 0, 2, 2)	
	else
		PlaySprite(crab1, 0, 0, 1, 1)
	endif
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab1Dir#) > Abs(dir)
		crab1Dir# = dir
		crab1Turning = 0
		PlaySprite(crab1, crab1framerate, 1, 3, 10)		
	endif
		
endfunction

function UpdateMeteor1()
	
	deleted = 0
	
	for i = 1 to meteorActive1.length
		spr = meteorActive1[i].spr
		cat = meteorActive1[i].cat
		if cat = 1	//Normal meteor
			meteorActive1[i].r = meteorActive1[i].r - 2.5*fpsr#
			
			//The top crab's special
			if specialTimerAgainst1# > 0 and crab2Type = 3
				if specialTimerAgainst1# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst1#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta - 1*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst1# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst1#/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta - 1*fpsr#*ratio#
				else
					//The normal
					meteorActive1[i].theta = meteorActive1[i].theta - 1*fpsr#
				endif
			endif
		
		elseif cat = 2	//Rotating meteor
			meteorActive1[i].r = meteorActive1[i].r - 2*fpsr#
			meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#
			
			//The top crab's special
			if specialTimerAgainst1# > 0 and crab2Type = 3
				if specialTimerAgainst1# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst1#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta + 0.5*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst1# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst1#/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta + 0.5*fpsr#*ratio#
				else
					//The normal
					meteorActive1[i].theta = meteorActive1[i].theta + 0.5*fpsr#
				endif
			endif
			
		elseif cat = 3	//Fast meteor
			meteorActive1[i].r = meteorActive1[i].r - 17*fpsr#
			
			//The top crab's special
			if specialTimerAgainst1# > 0 and crab2Type = 3
				if specialTimerAgainst1# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst1#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst1# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst1#/(topCrabTimeMax/10)
					meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#*ratio#
				else
					//The normal
					meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#
				endif
			endif
			
			ospr = spr + 10000 //Other sprite (is the box)
			
			if meteorActive1[i].r < 5000
				//Only displaying the stuff if the meteor is in range
				SetSpriteSize(ospr, GetSpriteWidth(spr)*(5000-meteorActive1[i].r)/5000.0, GetSpriteHeight(ospr))
				SetSpriteColorAlpha(ospr, 150*(5000-meteorActive1[i].r)/5000.0)
				DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
			else				
				SetSpriteColorAlpha(ospr, 0)
			endif
			
			//The lazy but working way of how the warning light doesn't go too high
			if GetSpriteCollision(ospr, split)
				while GetSpriteCollision(ospr, split)
					SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)-1)
					DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
				endwhile
				SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)+40)
				DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
			endif
			
		endif
				
		DrawPolar1(spr, meteorActive1[i].r, meteorActive1[i].theta)
		if cat = 2 then IncSpriteAngle(spr, -25)
		if GetSpriteY(spr) > h/2 - GetSpriteHeight(spr)/2
			SetSpriteColorAlpha(spr, 255)
		else
			SetSpriteColorAlpha(spr, 0)
		endif
		
	
		if (GetSpriteCollision(spr, planet1) or meteorActive1[i].r < 0) and deleted = 0	
			CreateExp(spr, cat)
			ActivateMeteorParticles(cat, spr, 1)
			DeleteSprite(spr)
			
			//The screen nudging
			inc nudge1R#, 2.5 + cat*2.5
			nudge1Theta# = meteorActive1[i].theta
			
			if meteorActive1[i].cat = 3 then DeleteSprite(spr + 10000)
			//Meteor explosion goes here
			deleted = i
		endif
	
	next i
	
	if deleted > 0
		meteorActive1.remove(deleted)
		inc meteorTotal1, 1
		
		//Updating the difficulty
		if Mod(meteorTotal1, 15) = 0 and gameDifficulty1 < 7
			inc gameDifficulty1, 1
		endif
	endif
	
endfunction

function UpdateButtons1()
	
	if expTotal1 = specialCost1
		//Bar is full
		SetSpriteColor(expBar1, 255, 210, 50, 255)
		PlaySprite(expBar1, 30, 1, 1, 6)
		SetSpriteColor(specialButton1, 20, 255, 40, 255)
	else
		//Bar is not full
		SetSpriteColor(expBar1, 255, 160, 0, 255)
		PlaySprite(expBar1, 20, 1, 1, 6)
		SetSpriteColor(specialButton1, 20, 255, 40, 100)
	endif
	
	if expTotal1 >= meteorCost1
		//Enabling the button
		SetSpriteColor(meteorButton1, 255, 100, 30, 255)
	else
		//Disabling the button
		SetSpriteColor(meteorButton1, 255, 100, 30, 100)
	endif
endfunction

function SendMeteorFrom1()
	newMet as meteor
	
	newMet.theta = Random(1, 360)
	newMet.r = metStartDistance-50
	newMet.spr = meteorSprNum
	newMet.cat = 1
			
	CreateSprite(meteorSprNum, 0)
	SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
	SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
	SetSpriteDepth(meteorSprNum, 20)
	AddMeteorAnimation(meteorSprNum)
	inc meteorSprNum, 1
	meteorActive2.insert(newMet)
	
	
	inc expTotal1, -1*meteorCost1
	UpdateButtons1()
endfunction

function SendSpecial1()
	
	ShowSpecialAnimation(crab1Type)
	
	newMetS as meteor
	
	if crab1Type = 1
		//Space Crab
		specialTimerAgainst2# = spaceCrabTimeMax
		
		if GetSpriteExists(special1Ex1) = 0
			CreateSpriteExpress(special1Ex1, 70, 70, -100, -100, 19)
			SetSpriteImage(special1Ex1, ufoI)
		endif
		
		PlaySound(ufoS, volumeSE)
		
		angles as float[7] = [0, 51.43, 102.86, 154.29, 205.72, 257.15, 308.58]
		angleOff = Random(1, 51)
		for i = 1 to 7
			randomPick = Random(1, 8-i)
			newMetS.theta = angles[randomPick] + angleOff
			angles.remove(randomPick)
			newMetS.r = 5000 + i*500
			newMetS.spr = meteorSprNum
			newMetS.cat = 3
			
			CreateSprite(meteorSprNum, 0)
			SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
			SetSpriteColor(meteorSprNum, 235, 20, 20, 255)
			SetSpriteDepth(meteorSprNum, 20)
			AddMeteorAnimation(meteorSprNum)
			
			CreateSprite(meteorSprNum + 10000, meteorTractorI)
			SetSpriteSize(meteorSprNum + 10000, 1, 1000)
			SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
			SetSpriteDepth(meteorSprNum + 10000, 30)
			
			inc meteorSprNum, 1
			
			//Reproducable bug by spamming this attack, was in the spr references in ospr in the meteor 3 update
			
			meteorActive2.insert(newMetS)
		next i
		
	elseif crab1Type = 2
		//Ladder Wizard
		
		rnd = Random(1, 2)
		if rnd = 1
			PlaySound(wizardSpell1S, volumeSE)
		else
			PlaySound(wizardSpell2S, volumeSE)
		endif
		
		for j = 1 to 3
		baseTheta = Random(1, 360)
		dir = Random(1, 2)
		if dir = 2 then dir = -1
			for i = 1 to 4
				newMetS.theta = baseTheta + i*22*dir
				newMetS.r = 200 + j*400 + i*50
				newMetS.spr = meteorSprNum
				newMetS.cat = 1
						
				CreateSprite(meteorSprNum, 0)
				SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
				SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
				SetSpriteDepth(meteorSprNum, 20)
				AddMeteorAnimation(meteorSprNum)
				inc meteorSprNum, 1
				meteorActive2.insert(newMetS)
			next i
		next j
		
		ActivateMeteorParticles(4, 0, 2)
		
	elseif crab1Type = 3
		//Top Crab
		specialTimerAgainst2# = topCrabTimeMax
		planet2RotSpeed# = 0
		
	elseif crab1Type = 4
		//Rave Crab
		PlayMusicOGG(raveBass1, 1)
		SetMusicVolumeOGG(raveBass1, 100)
		
		specialTimerAgainst2# = raveCrabTimeMax
		if GetSpriteExists(special1Ex1) = 0
			CreateSprite(special1Ex1, boarderI)
			CreateSprite(special1Ex2, boarderI)
			CreateSprite(special1Ex3, boarderI)
			CreateSprite(special1Ex4, boarderI)
			CreateSprite(special1Ex5, 0)
		endif
		
		for i = special1Ex1 to special1Ex4
			SetSpriteDepth(i, 19)
			FixSpriteToScreen(i, 1)
			SetSpriteColorByCycle(i, specialTimerAgainst2#)
		next i
		SetSpriteDepth(special1Ex5, 7)
		
		size = 160
		
		SetSpriteSize(special1Ex1, size, h/2)
		
		SetSpriteSize(special1Ex2, size, h/2)
		SetSpriteFlip(special1Ex2, 1, 0)
		SetSpritePosition(special1Ex2, w-size, 0)
		
		SetSpriteSize(special1Ex3, size, w)
		SetSpritePosition(special1Ex3, w/2-size/2, -w/2+size/2)
		SetSpriteAngle(special1Ex3, 90)
		
		SetSpriteSize(special1Ex4, size, w)
		SetSpritePosition(special1Ex4, w/2-size/2, h/2-w/2-size/2-GetSpriteHeight(split)/2)
		SetSpriteAngle(special1Ex4, 270)
		
		//Extra whitespace so that this matches with the game2 code
		
		
		
		
		SetSpriteSize(special1Ex5, 140, 140)
		DrawPolar2(special1Ex5, 0, 180)
		SetSpriteColorByCycle(special1Ex5, specialTimerAgainst2#)
	
	elseif crab1Type = 5
		//Chrono Crab
		specialTimerAgainst2# = chronoCrabTimeMax
		
		if GetSpriteExists(special1Ex1) = 0
			CreateSpriteExpress(special1Ex1, 12, 80, -100, -100, 6)	//Minute hand
			CreateSpriteExpress(special1Ex2, 20, 60, -100, -100, 6)	//Hour hand
			CreateSpriteExpress(special1Ex3, 100, 100, -200, -200, 7)	//Clock
		endif
		
		SetSpriteColorAlpha(special1Ex1, 0)
		SetSpriteColorAlpha(special1Ex2, 0)
		SetSpriteColor(special1Ex3, 100, 100, 100, 0)
		
		
		DrawPolar2(special1Ex1, GetSpriteHeight(special1Ex1)/2, 90 + (specialTimerAgainst2#/chronoCrabTimeMax)*1080)
		DrawPolar2(special1Ex2, GetSpriteHeight(special1Ex2)/2, 90 + (specialTimerAgainst2#/chronoCrabTimeMax)*360)
		
		//Clock wiggle
		SetSpriteSize(special1Ex3, 150+12*sin(specialTimerAgainst2#*4), 150+12*cos(specialTimerAgainst2#*3))
		DrawPolar2(special1Ex3, 0, 0)
		SetSpriteAngle(special1Ex3, 180 + 5.0*cos(specialTimerAgainst2#*2))
		
	elseif crab1Type = 6
		//Ninja Crab
		specialTimerAgainst2# = ninjaCrabTimeMax
		
		ninjaStarSize = 80
		
		//The 3 throwing stars
		for i = special1Ex1 to special1Ex3
			if GetSpriteExists(i) = 0 then CreateSpriteExpress(i, ninjaStarSize, ninjaStarSize, -200, -200, 4)
			SetSpriteImage(i, ninjaStarI)
			SetSpriteColorAlpha(i, 0)
		next i
		
	endif
	
	expTotal1 = 0
	UpdateButtons1()
	
endfunction

function CheckDeath1()
	isHit = 0
	
	for i = 1 to meteorActive1.length
		spr = meteorActive1[i].spr
		if GetSpriteCollision(crab1, spr)
			isHit = spr
			inc nudge1R#, 20
			nudge1Theta# = crab1Theta#
			cat = meteorActive1[i].cat
			if meteorActive1[i].cat = 3 then DeleteSprite(spr + 10000)
			//ActivateMeteorParticles(cat, spr, 1)
			PlaySprite(crab1, 0, 1, Random(13, 14), -1)
			DeleteHalfExp(1)
			
			//Leaving the loop early
			meteorActive1.remove(i)
			i = meteorActive1.length + 10
		endif
	next
	
	//Collision for their ninja stars
	if crab2Type = 6
		for i = special2Ex1 to special2Ex3
			if GetSpriteExists(i)
				if GetSpriteCollision(crab1, i)
					isHit = i
					inc nudge1R#, 20
					nudge1Theta# = 270
					PlaySprite(crab1, 0, 1, Random(13, 14), -1)
					DeleteHalfExp(1)
				endif
			endif
		next i
	endif
	
	if isHit
		specialTimerAgainst1# = 0
		for i = par1met1 to par1spe1
			//Make the particles invisiable here
			//ResetParticleCount(i)
			//SetParticlesActive(i, 0)
		next i
	endif
	
endfunction isHit

function HitScene1()
	
	state = GAME
	
	inc hit1Timer#, -1*fpsr#
	Print(hit1Timer#)
	
	if crab1Deaths < 3
		//The first and second deaths
		if hit1Timer# > hitSceneMax*3/4
			//Flying off the planet
			inc crab1R#, 12*fpsr#
			SetSpriteDepth(crab1, 11)
			
			NudgeScreen1()
			
			
		elseif hit1Timer# > hitSceneMax/4
			//Flying towards the next planet
			
			//The one time changes:
			if GetSpriteColorAlpha(crab1) = 255
				SetSpriteColorAlpha(crab1, 254)
				SetBGRandomPosition(bgGame1)
			
				//Removing the old remaining meteors
				for i = 1 to meteorActive1.length
					DeleteSprite(meteorActive1[i].spr)
					if meteorActive1[i].cat = 3 then DeleteSprite(meteorActive1[i].spr + 10000)
				next
				for i = 1 to meteorActive1.length
					meteorActive1.remove()
				next
				meteorActive1.length = 0
				for i = special2Ex1 to special2Ex3
					if GetSpriteExists(i) and crab2Type = 6
						DeleteSprite(i)
					endif
				next i
			endif
			
			SetSpriteColorAlpha(planet1, 0)
			SetSpriteImage(planet1, planetIRandStart + Random(1, 8))
			
			crab1R# = -10*(hit1Timer#-hitSceneMax/2)
			
			if hit1Timer# < hitSceneMax/2*3
				SetSpriteColor(crab1PlanetS[crab1Deaths], 100, 100, 100, 255)
				
				if crab1Deaths = 2
					SetSpriteColor(crab1PlanetS[crab1Deaths+1], 255, 100, 100, 255)
					//todo: play warning sound
				endif
				size = planetIconSize + 3 + 7*cos(hit1Timer#*10)*crab1Deaths	//The final multiplier makes it a bigger deal for the last planet
				SetSpriteSize(crab1PlanetS[crab1Deaths+1], size, size)
				SetSpritePosition(crab1PlanetS[crab1Deaths+1], w/2 - size/2 + (crab1Deaths-1)*size*1.5, h/2 + 80)
			endif
			
		elseif hit1Timer# > 0
			//Hitting the new planet
			
			//The one time changes:
			if GetSpriteColorAlpha(crab1) = 254
				SetSpriteColorAlpha(crab1, 255)
				SetSpriteImage(bgGame1, bg1I + crab1Deaths)
				SetBGRandomPosition(bgGame1)
			endif
			
			crab1R# = -1*GetCrabDefaultR(crab1) - 12*hit1Timer#
			
			//Planet adjustment
			DrawPolar1(planet1, 0, 270)
			SetSpriteColorAlpha(planet1, 255)
			
			//Planet icon adjustment
			SetSpriteSize(crab1PlanetS[crab1Deaths+1], planetIconSize, planetIconSize)
			SetSpritePosition(crab1PlanetS[crab1Deaths+1], w/2 - planetIconSize/2 + (crab1Deaths-1)*planetIconSize*1.5, h/2 + 80)
		
		elseif hit1Timer# <= 0
			//Return to normal, this code runs once
						
			//Crab stuff
			crab1JumpD# = crab1JumpDMax*2/3
			PlaySprite(crab1, crab1framerate, 1, 3, 10)
			crab1R# = GetCrabDefaultR(crab1)
			SetSpriteDepth(crab1, 3)
			//Part of the trick that makes the crab hit the other side of the planet
			inc crab1Theta#, 180
			
			//Planet adjustment
			nudge1R# = 60
			nudge1Theta# = crab1Theta#
			
			gameDifficulty1 = Max(gameDifficulty1-2, 1)
			
			hit1Timer# = 0
		endif
		
	else
		//The final death
		
		
		state =  0
	endif
	
	DrawPolar1(crab1, crab1R#, crab1Theta#)
	SetSpriteAngle(crab1, hit1Timer#*30)
	if GetSpriteY(crab1) < h/2 then SetSpriteY(crab1, 9999)	//Correction for if the crab ends up on player 2's screen
	
endfunction state

function NudgeScreen1()
	if crab2Type = 3 and specialTimerAgainst1# > 0
		//Nothing here lol
	else
		if nudge1R# > 0
			IncSpritePosition(crab1, -cos(nudge1Theta#)*nudge1R#, -sin(nudge1Theta#)*nudge1R#)
			DrawPolar1(planet1, 0, 270)	//Resetting the planet so that it can be nudged
			IncSpritePosition(planet1, -cos(nudge1Theta#)*nudge1R#, -sin(nudge1Theta#)*nudge1R#)
			
			//inc nudge1R#, -0.3
			nudge1R# = GlideNumToZero(nudge1R#, 2)
			if nudge1R# < 0.01
				nudge1R# = 0
				DrawPolar1(planet1, 0, 270)	//Resetting the planet so that it can be nudged
			endif
		endif
	endif
endfunction