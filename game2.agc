#include "myLib.agc"
#include "constants.agc"

function DrawPolar2(spr, rNum, theta#)
	if GetSpriteExists(spr)
		cenX = w/2
		cenY = h/4 - GetSpriteHeight(split)/4
		SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
		SetSpriteAngle(spr, theta#+90)
		//if spriteNum >= 111 and spriteNum <= 120 then SetSpriteAngle(spriteNum, theta#+45)
	endif
endfunction

function CreateGame2()
	CreateSprite(planet2, planetIRandStart + Random(1, 8))
	SetSpriteSizeSquare(planet2, planetSize)
	SetSpriteShape(planet2, 1)
	DrawPolar2(planet2, 0, 270)
	SetSpriteAngle(planet2, 180)
	SetSpriteDepth(planet2, 8)
	
	CreateSprite(crab2, LoadImage("crab0walk1.png"))
	SetSpriteSize(crab2, 64, 40)
	SetSpriteDepth(crab1, 3)
	crab2Theta# = 270
	DrawPolar2(crab2, planetSize/2 + GetSpriteHeight(crab2)/3, crab2Theta#)
endfunction

function DoGame2()

	//The Chrono Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 5
		if specialTimerAgainst2# > chronoCrabTimeMax*9/10
			//The startup
			ratio# = (specialTimerAgainst2#-chronoCrabTimeMax*9/10)/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*(1.0-ratio#)
		elseif specialTimerAgainst2# < chronoCrabTimeMax/10
			//The winddown
			ratio# = specialTimerAgainst2#/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*ratio#
		else
			//The normal
			fpsr# = fpsr# * 1.9
		endif
	endif
	
	//The Rave Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 4
		for i = special1Ex1 to special1Ex5
			SetSpriteColorByCycle(i, specialTimerAgainst2#)
		next i
		if specialTimerAgainst2# < raveCrabTimeMax/8
			for i = special1Ex1 to special1Ex5
				SetSpriteColorAlpha(i, specialTimerAgainst2#*255/(raveCrabTimeMax/8))
			next i
			SetMusicVolumeOGG(raveBass1, specialTimerAgainst2#*100/(raveCrabTimeMax/8))
		endif
	endif
	
		
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab2Theta#, crab2Vel# * crab2Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if buffer2 or ((GetPointerPressed() and (GetPointerY() < GetSpriteY(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(50)))
		buffer2 = 0
		if crab2Turning = 0
			if crab2Dir# > 0
				crab2Turning = -1
			else
				crab2Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab2Turning = -1*crab2Turning
		endif
		
	endif
	
	//Enacting the crab turn while activated
	if crab2Turning <> 0 then TurnCrab2(crab2Turning)
	
	//Making sure the crab is using proper rotation numbers
	if crab2Theta# > 360 then inc crab2Theta#, -360
	if crab2Theta# < 0 then inc crab2Theta#, 360
	
	//This cancels out the weird issue where the integer is sometimes infinity
	if crab2Theta# > 10000000 then crab2Theta# = 270
	
	//The visual update code
	DrawPolar2(crab2, planetSize/2 + GetSpriteHeight(crab2)/3, crab2Theta#)
	
	newMet as meteor
	newMet.cat = 0
	inc met1CD2#, -1 * fpsr#
	inc met2CD2#, -1 * fpsr#
	inc met3CD2#, -1 * fpsr#
	
	if specialTimerAgainst2# > 0 then inc specialTimerAgainst2#, -1*fpsr#
	//Cleaning up Rave Crab's special
	if specialTimerAgainst2# <= 0 and crab1Type = 4
		for i = special1Ex1 to special1Ex5
			DeleteSprite(i)
		next i
		StopMusicOGG(raveBass1)
	endif
	Print(specialTimerAgainst2#)
	
	if met1CD2# < 0
		met1CD2# = Random(250, 350)
		newMet.theta = Random(1, 360)
		newMet.r = 600
		newMet.spr = meteorSprNum
		newMet.cat = 1
				
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
		SetSpriteDepth(meteorSprNum, 20)
		inc meteorSprNum, 1
		meteorActive2.insert(newMet)
	endif
	
	
	if met2CD2# < 0
		met2CD2# = Random(350, 450)
		newMet.theta = Random(1, 360)
		newMet.r = 600
		newMet.spr = meteorSprNum
		newMet.cat = 2
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 150, 40, 150, 255)
		SetSpriteDepth(meteorSprNum, 20)
		inc meteorSprNum, 1
		
		meteorActive2.insert(newMet)
	endif
	
	if met3CD2# < 0
		met3CD2# = Random(450, 650)
		newMet.theta = Random(1, 360)
		newMet.r = 5000
		newMet.spr = meteorSprNum
		newMet.cat = 3
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 235, 20, 20, 255)
		SetSpriteDepth(meteorSprNum, 20)
		
		CreateSprite(meteorSprNum + 10000, meteorTractorI)
		SetSpriteSize(meteorSprNum + 10000, 1, 1000)
		SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
		SetSpriteDepth(meteorSprNum + 10000, 30)
		
		inc meteorSprNum, 1
		
		meteorActive2.insert(newMet)
	endif
		
	UpdateMeteor2()
	
	fpsr# = 60.0/ScreenFPS()
	
endfunction state

function TurnCrab2(dir)
	
	//Accelerating the crab in the specified direction
	inc crab2Dir#, dir * crab2Accel# * fpsr#
	
	if crab2Dir# < 0
		SetSpriteFlip(crab2, 1, 0)
	else
		SetSpriteFlip(crab2, 0, 0)
	endif
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab2Dir#) > Abs(dir)
		crab2Dir# = dir
		crab2Turning = 0
	endif
	
endfunction

function UpdateMeteor2()
	
	deleted = 0
	
	for i = 1 to meteorActive2.length
		spr = meteorActive2[i].spr
		cat = meteorActive2[i].cat
		if cat = 1	//Normal meteor
			meteorActive2[i].r = meteorActive2[i].r - 2.5*fpsr#
			
			//The top crab's special
			if specialTimerAgainst2# > 0 and crab1Type = 3
				if specialTimerAgainst2# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst2#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta - 1*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst2# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst2#/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta - 1*fpsr#*ratio#
				else
					//The normal
					meteorActive2[i].theta = meteorActive2[i].theta - 1*fpsr#
				endif
			endif
			
		elseif cat = 2	//Rotating meteor
			meteorActive2[i].r = meteorActive2[i].r - 2*fpsr#
			meteorActive2[i].theta = meteorActive2[i].theta + 1*fpsr#
			
			//The top crab's special
			if specialTimerAgainst2# > 0 and crab1Type = 3
				if specialTimerAgainst2# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst2#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta + 0.5*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst2# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst2#/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta + 0.5*fpsr#*ratio#
				else
					//The normal
					meteorActive2[i].theta = meteorActive2[i].theta + 0.5*fpsr#
				endif
			endif
			
		elseif cat = 3	//Fast meteor
			meteorActive2[i].r = meteorActive2[i].r - 17*fpsr#
			
			//The top crab's special
			if specialTimerAgainst2# > 0 and crab1Type = 3
				if specialTimerAgainst2# > topCrabTimeMax*9/10
					//The startup
					ratio# = (specialTimerAgainst2#-topCrabTimeMax*9/10)/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta + 1*fpsr#*(1.0-ratio#)
				elseif specialTimerAgainst2# < topCrabTimeMax/10
					//The winddown
					ratio# = specialTimerAgainst2#/(topCrabTimeMax/10)
					meteorActive2[i].theta = meteorActive2[i].theta + 1*fpsr#*ratio#
				else
					//The normal
					meteorActive2[i].theta = meteorActive2[i].theta + 1*fpsr#
				endif
			endif
			
			ospr = spr + 10000 //Other sprite (is the box)
			
			if meteorActive2[i].r < 5000
				//Only displaying the stuff if the meteor is in range
				SetSpriteSize(ospr, GetSpriteWidth(spr)*(5000-meteorActive2[i].r)/5000.0, GetSpriteHeight(ospr))
				SetSpriteColorAlpha(ospr, 150*(5000-meteorActive2[i].r)/5000.0)
				DrawPolar2(ospr, GetSpriteHeight(ospr)/2, meteorActive2[i].theta)
			else				
				SetSpriteColorAlpha(ospr, 0)
			endif
			
			//The lazy but working way of how the warning light doesn't go too high
			if GetSpriteCollision(ospr, split)
				while GetSpriteCollision(ospr, split)
					SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)-1)
					DrawPolar2(ospr, GetSpriteHeight(ospr)/2, meteorActive2[i].theta)
				endwhile
				SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)+40)
				DrawPolar2(ospr, GetSpriteHeight(ospr)/2, meteorActive2[i].theta)
			endif
			
			//SC2 code for reference
			//SetSpriteSize(220+i, GetSpriteWidth(120+i)*(10000.0-fMet[i,2])/10000.0, 6000)
			//SetSpriteColorAlpha(220+i, 150*(10000.0-fMet[i,2])/10000.0)
			//DrawPolar(220+i, 3000, fMet[i,3], GetSpriteWidth(220+i), GetSpriteHeight(220+i))
			
		endif
				
		DrawPolar2(spr, meteorActive2[i].r, meteorActive2[i].theta)
		if GetSpriteY(spr) < h/2 - GetSpriteHeight(spr)/2
			SetSpriteColorAlpha(spr, 255)
		else
			SetSpriteColorAlpha(spr, 0)
		endif
		
	
		if GetSpriteCollision(spr, planet2) and deleted = 0
			DeleteSprite(spr)
			if meteorActive2[i].cat = 3 then DeleteSprite(spr + 10000)
			//Meteor explosion goes here
			deleted = i
		endif
	
	next i
	
	if deleted > 0
		meteorActive2.remove(deleted)
		
	endif
	
endfunction
