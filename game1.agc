#include "myLib.agc"
#include "constants.agc"

function DrawPolar1(spr, rNum, theta#)
	if GetSpriteExists(spr)
		cenX = w/2
		cenY = h*3/4 + GetSpriteHeight(split)/4
		SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
		SetSpriteAngle(spr, theta#+90)
		//if spriteNum >= 111 and spriteNum <= 120 then SetSpriteAngle(spriteNum, theta#+45)
	endif
endfunction

function CreateGame1()
	CreateSprite(planet1, planetIRandStart + Random(1, 8))
	SetSpriteSizeSquare(planet1, planetSize)
	SetSpriteShape(planet1, 1)
	DrawPolar1(planet1, 0, 270)
	
	CreateSprite(crab1, LoadImage("crab0walk1.png"))
	SetSpriteSize(crab1, 64, 40)
	crab1Theta# = 270
	DrawPolar1(crab1, planetSize/2 + GetSpriteHeight(crab1)/3, crab1Theta#)
	AddSpriteAnimationFrame(crab1, crab1start1I)	//1
	AddSpriteAnimationFrame(crab1, crab1start2I)
	AddSpriteAnimationFrame(crab1, crab1walk1I)	//3
	AddSpriteAnimationFrame(crab1, crab1walk2I)
	AddSpriteAnimationFrame(crab1, crab1walk3I)
	AddSpriteAnimationFrame(crab1, crab1walk4I)
	AddSpriteAnimationFrame(crab1, crab1walk5I)
	AddSpriteAnimationFrame(crab1, crab1walk6I)
	AddSpriteAnimationFrame(crab1, crab1walk7I)
	AddSpriteAnimationFrame(crab1, crab1walk8I)
	AddSpriteAnimationFrame(crab1, crab1jump1I)	//11
	AddSpriteAnimationFrame(crab1, crab1jump2I)
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
	// specialButton1 115
	
	CreateSprite(specialButton1, 0)
	SetSpriteSize(specialButton1, 100, 100)
	SetSpritePosition(specialButton1, GetSpriteX(expHolder1) + GetSpriteWidth(expHolder1) + 5, h-20-GetSpriteHeight(meteorButton1))
	SetSpriteDepth(specialButton1, 15)
	SetSpriteColor(specialButton1, 20, 255, 40, 100)
	
	crab1PlanetS[1] = 116
	crab1PlanetS[2] = 117
	crab1PlanetS[3] = 118
	//The planet UI that shows how many lives are left
	for i = 1 to 3
		size = 40
		CreateSpriteExpress(crab1PlanetS[i], size, size, w/2 - size/2 + (i-2)*size*1.5, h/2 + 80, 5)
		
	next i
		
endfunction

function DoGame1()
	
	//The Chrono Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 5
		if specialTimerAgainst1# > chronoCrabTimeMax*9/10
			//The startup
			ratio# = (specialTimerAgainst1#-chronoCrabTimeMax*9/10)/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*(1.0-ratio#)
		elseif specialTimerAgainst1# < chronoCrabTimeMax/10
			//The winddown
			ratio# = specialTimerAgainst1#/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*ratio#
		else
			//The normal
			fpsr# = fpsr# * 1.9
		endif
	endif
	
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if ((GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0 and crab1JumpD# = 0
		if crab1Turning = 0
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
				crab1JumpD# = crab1JumpDMax
				crab1Dir# = crab1Vel#
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
	
	Print(Hover(meteorButton1))
	
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
	
	newMet as meteor
	newMet.cat = 0
	inc met1CD1#, -1 * fpsr#
	inc met2CD1#, -1 * fpsr#
	inc met3CD1#, -1 * fpsr#
	
	if specialTimerAgainst1# > 0 then inc specialTimerAgainst1#, -1*fpsr#
	
	if met1CD1# < 0
		met1CD1# = Random(230 - 5*gameDifficulty1, 330) - 20*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = 600
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
		met2CD1# = Random(300 - 5*gameDifficulty1, 400) - 20*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = 600
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
		met3CD1# = Random(450 - 15*gameDifficulty1, 650) - 25*gameDifficulty1
		newMet.theta = Random(1, 360)
		newMet.r = 5000
		newMet.spr = meteorSprNum
		newMet.cat = 3
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX*1.2, metSizeY*1.2)
		SetSpriteColor(meteorSprNum, 235, 60, 60, 255)
		SetSpriteDepth(meteorSprNum, 20)
		AddMeteorAnimation(meteorSprNum)
		
		CreateSprite(meteorSprNum + 10000, 0)
		SetSpriteSize(meteorSprNum + 10000, 1, 1000)
		SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
		SetSpriteDepth(meteorSprNum + 10000, 30)
		
		inc meteorSprNum, 1
		
		meteorActive1.insert(newMet)
	endif
		
	UpdateMeteor1()
	
	if expTotal1 >= meteorCost1 and (Button(meteorButton1) and GetPointerPressed())
		SendMeteorFrom1()
	endif
	
	if expTotal1 = specialCost1 and (Button(specialButton1) and GetPointerPressed())
		SendSpecial1()
	endif
	
	DrawPolar1(planet1, 0, 270)
	
	//The screen nudging code	
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
	
	//Adjusting the crab angle for the dive, cosmetic
	if crab1JumpD# > 0
		SetSpriteAngle(crab1, GetSpriteAngle(crab1) + crab1JumpD#/crab1JumpDMax*360 * -1 * crab1Dir#)
	endif
	
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
			
			//SC2 code for reference
			//SetSpriteSize(220+i, GetSpriteWidth(120+i)*(10000.0-fMet[i,2])/10000.0, 6000)
			//SetSpriteColorAlpha(220+i, 150*(10000.0-fMet[i,2])/10000.0)
			//DrawPolar(220+i, 3000, fMet[i,3], GetSpriteWidth(220+i), GetSpriteHeight(220+i))
			
		endif
				
		DrawPolar1(spr, meteorActive1[i].r, meteorActive1[i].theta)
		if cat = 2 then IncSpriteAngle(spr, -25)
		if GetSpriteY(spr) > h/2 //+ GetSpriteHeight(spr)/2
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
	newMet.r = 560	//500 nearly immediatly puts it on screen
	newMet.spr = meteorSprNum
	newMet.cat = 1
			
	CreateSprite(meteorSprNum, 0)
	SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
	SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
	SetSpriteDepth(meteorSprNum, 20)
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
			
			CreateSprite(meteorSprNum + 10000, 0)
			SetSpriteSize(meteorSprNum + 10000, 1, 1000)
			SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
			SetSpriteDepth(meteorSprNum + 10000, 30)
			
			inc meteorSprNum, 1
			
			//Reproducable bug by spamming this attack, was in the spr references in ospr in the meteor 3 update
			
			meteorActive2.insert(newMetS)
		next i
		
	elseif crab1Type = 2
		//Ladder Wizard
		
		for j = 1 to 3
		baseTheta = Random(1, 360)
		dir = Random(1, 2)
		if dir = 2 then dir = -1
			for i = 1 to 4
				newMetS.theta = baseTheta + i*18*dir
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
		
	elseif crab1Type = 5
		//Chrono Crab
		specialTimerAgainst2# = chronoCrabTimeMax	
	endif
	
	
	expTotal1 = 0
	UpdateButtons1()
	
endfunction

