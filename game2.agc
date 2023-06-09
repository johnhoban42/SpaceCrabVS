#include "myLib.agc"
#include "constants.agc"

function DrawPolar2(spr, rNum, theta#)
	if GetSpriteExists(spr)
		cenX = w/2
		cenY = h/4 - GetSpriteHeight(split)/4
		SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
		SetSpriteAngle(spr, theta#+90)
	endif
endfunction

function CreateGame2()
	crab2Deaths = 0
	CreateSprite(planet2, planetVarI[Random(1, 23)])
	SetSpriteSizeSquare(planet2, planetSize)
	SetSpriteShape(planet2, 1)
	DrawPolar2(planet2, 0, 90)
	SetSpriteDepth(planet2, 8)
	
	CreateSprite(crab2, 0)
	//SetSpriteSize(crab2, 64, 40)
	SetSpriteSize(crab2, 119, 67)
	SetSpriteDepth(crab2, 3)
	SetSpriteShapeCircle(crab2, 0, GetSpriteHeight(crab2)/5, 16)
	crab2R# = GetCrabDefaultR(crab2)
	
	if GetSpriteExists(bgGame2) = 0 then CreateSprite(bgGame2, 0)
	SetSpriteImage(bgGame2, bg1I)
	SetBGRandomPosition(bgGame2)
	SetSpriteDepth(bgGame2, 100)
	
	crab2Theta# = 90
	DrawPolar2(crab2, crab2R#, crab2Theta#)
	if crab2Type = 1		//Space
		for i = crab1start1I to crab1skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab1
		specialCost2 = specialPrice1
		crab2Vel# = 1.28
		crab2Accel# = .1
		crab2JumpHMax# = 5
		crab2JumpSpeed# = 1.216
		crab2JumpDMax = 28
		
	elseif crab2Type = 2	//Wizard
		for i = crab2start1I to crab2skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab2
		specialCost2 = specialPrice2
		crab2Vel# = 1.08
		crab2Accel# = .13
		crab2JumpHMax# = 10.5
		crab2JumpSpeed# = 1.516
		crab2JumpDMax = 40
		
	elseif crab2Type = 3	//Top
		for i = crab3start1I to crab3skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab3
		specialCost2 = specialPrice3
		crab2Vel# = 2.48
		crab2Accel# = .03
		crab2JumpHMax# = 8
		crab2JumpSpeed# = -3
		crab2JumpDMax = 32
		
	elseif crab2Type = 4	//Rave
		for i = crab4start1I to crab4skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab4
		specialCost2 = specialPrice4
		crab2Vel# = 1.59
		crab2Accel# = .08
		crab2JumpHMax# = 10
		crab2JumpSpeed# = -1.28
		crab2JumpDMax = 43
		
	elseif crab2Type = 5	//Chrono
		for i = crab5start1I to crab5skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab5
		specialCost2 = specialPrice5
		crab2Vel# = 1.38
		crab2Accel# = .1
		crab2JumpHMax# = 5
		crab2JumpSpeed# = -3.216
		crab2JumpDMax = 28
		
	elseif crab2Type = 6	//Ninja
		for i = crab6start1I to crab6skid3I
			AddSpriteAnimationFrame(crab2, i)
		next i
		crab2framerate = frameratecrab6
		specialCost2 = specialPrice6
		crab2Vel# = 1.5
		crab2Accel# = .1
		crab2JumpHMax# = 6
		crab2JumpSpeed# = .816
		crab2JumpDMax = 26
		
	else
		//The debug option, no crab selected
		for i = crab1start1I to crab1death2I
			AddSpriteAnimationFrame(crab2, i)
		next i
		specialCost2 = 1
	endif
	
	PlaySprite(crab2, crab2framerate, 1, 3, 10)
	
	SetFolder("/media/ui")
	CreateSpriteExistingAnimation(expHolder2, expHolder1)
	SetSpriteSize(expHolder2, w - 130, 40)
	SetSpriteMiddleScreenX(expHolder2)
	SetSpriteY(expHolder2, 10)
	SetSpriteDepth(expHolder2, 18)
	PlaySprite(expHolder2, 20, 1, 1, 12)
	SetSpriteAngle(expHolder2, 180)

	CreateSpriteExistingAnimation(expbar2, expBar1)
	SetSpriteSize(expbar2, GetSpriteWidth(expHolder2), GetSpriteHeight(expHolder2))
	SetSpritePosition(expbar2, GetSpriteX(expHolder2), GetSpriteY(expHolder2))
	SetSpriteDepth(expBar2, 18)
	PlaySprite(expBar2, 20, 1, 1, 6)
	SetSpriteAngle(expBar2, 180)
	
	LoadAnimatedSprite(meteorButton2, "attacke", 5)
	PlaySprite(meteorButton2, 0, 0, 5, 5)
	SetSpriteSize(meteorButton2, 90, 90)
	SetSpritePosition(meteorButton2, GetSpriteX(expHolder2) + GetSpriteWidth(expHolder2) + 13 - 50, 10)
	SetSpriteDepth(meteorButton2, 15)
	SetSpriteColor(meteorButton2, 100, 100, 100, 255)
	SetSpriteAngle(meteorButton2, 180)
	//Might want to make the Y based on the sxp bar holder instead of the screen height
	
	CreateSpriteExpress(meteorMarker2, 4, GetSpriteHeight(expHolder2)+4, 0, GetSpriteY(expHolder2)-2, 14)
	//The X is on a seperate line because it is long
	SetSpriteX(meteorMarker2, GetSpriteX(expHolder2) + GetSpriteWidth(expHolder2) - 1.0*(GetSpriteWidth(expHolder2)-20)*meteorCost2/specialCost2 + 4 + .116*GetSpriteWidth(expHolder1))
	SetSpriteColor(meteorMarker2, 30, 100, 255, 255)
	
	LoadAnimatedSprite(specialButton2, "crab" + str(crab2Type)+ "special", 5)
	SetSpriteFrame(specialButton2, 5)
	SetSpriteSize(specialButton2, 100, 100)
	SetSpritePosition(specialButton2, GetSpriteX(expHolder2)-10-GetSpriteWidth(specialButton2)+2 + 50, 10)
	SetSpriteDepth(specialButton2, 15)
	SetSpriteColor(specialButton2, 100, 100, 100, 255)
	SetSpriteAngle(specialButton2, 180)
	
	crab2PlanetS[1] = 126
	crab2PlanetS[2] = 127
	crab2PlanetS[3] = 128
	//The planet UI that shows how many lives are left
	for i = 1 to 3 //The 4 minus below makes the planet sprites go in the correct order for the top
		CreateSpriteExpress(crab2PlanetS[i], planetIconSize, planetIconSize, w/2 - planetIconSize/2 + (i-2)*planetIconSize*1.5, h/2 - 80 - planetIconSize, 5)
		SetSpriteImage(crab2PlanetS[i], crab1life1I - 1 + (crab2Type-1)*3 + i)
		if i > 1 then SetSpriteSize(crab2PlanetS[i], planetIconSize/4, planetIconSize/4)
		DrawPolar2(crab2PlanetS[i], 300, 90 + (i-2)*20)
		SetSpriteAngle(crab2PlanetS[i], 180)
	next i
	
	//Setting gameplay parameters to their proper values
	crab2Deaths = 0
	
	if spActive
		for i = 1 to 3
			SetSpriteVisible(crab2PlanetS[i], 0)
		next i
		SetSpriteVisible(expHolder2, 0)
		SetSpriteVisible(expBar2, 0)
		SetSpriteVisible(meteorButton2, 0)
		SetSpriteVisible(meteorMarker2, 0)
		SetSpriteVisible(specialButton2, 0)
		crab2theta# = 270
	
	
	
		//Empty space to line up with single player graphics (text and text-holding sprite
	
	
	
	
	endif
	
endfunction

function DoGame2()

	//The Space Crab special (just Space Ned)
	if specialTimerAgainst2# > 0 and crab1Type = 1
		DrawPolar2(special1Ex1, 180 + ((specialTimerAgainst2# - 100)^2)/11, 0 + specialTimerAgainst2#)
		SetSpriteAngle(special1Ex1, 180 + sin(specialTimerAgainst2#*8)*10)
	endif

	//The Top Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 3
		if specialTimerAgainst2# > topCrabTimeMax*3/5
			//Phase 1 and 2
			inc planet2RotSpeed#, planetSpeedUpRate#*fpsr#
			
		elseif specialTimerAgainst2# > topCrabTimeMax*2/5
			//Phase 3
			inc planet2RotSpeed#, -3*planetSpeedUpRate#*fpsr#
			
		elseif specialTimerAgainst2# > topCrabTimeMax/5
			//Phase 4
			inc planet2RotSpeed#, -1*planetSpeedUpRate#*fpsr#
			
		else
			//Phase 5 (end)
			inc planet2RotSpeed#, 2*planetSpeedUpRate#*fpsr#
		endif
		IncSpriteAngle(planet2, planet2RotSpeed#)
		inc crab2Theta#, planet2RotSpeed#
	endif
		
	//The Rave Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 4
		for i = special1Ex1 to special1Ex5
			SetSpriteColorByCycle(i, specialTimerAgainst2#)
		next i
		SetSpriteColor(special1Ex5, (GetSpriteColorRed(special1Ex5)+510)/3, (GetSpriteColorGreen(special1Ex5)+510)/3, (GetSpriteColorBlue(special1Ex5)+510)/3, 255)
		if specialTimerAgainst2# < raveCrabTimeMax/8
			for i = special1Ex1 to special1Ex5
				SetSpriteColorAlpha(i, specialTimerAgainst2#*255/(raveCrabTimeMax/8))
			next i
			SetMusicVolumeOGG(raveBass1, specialTimerAgainst2#*100/(raveCrabTimeMax/8))
		endif
	endif
	
	//The Chrono Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 5
		if specialTimerAgainst2# > chronoCrabTimeMax*9/10
			//The startup
			ratio# = (specialTimerAgainst2#-chronoCrabTimeMax*9/10)/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*(1.0-ratio#)
			for i = special1Ex1 to special1Ex3
				FadeSpriteIn(i, specialTimerAgainst2#, chronoCrabTimeMax, chronoCrabTimeMax*9/10)
			next i 
		elseif specialTimerAgainst2# < chronoCrabTimeMax/10
			//The winddown
			ratio# = specialTimerAgainst2#/(chronoCrabTimeMax/10)
			fpsr# = fpsr# * 1 + 0.9*ratio#
			for i = special1Ex1 to special1Ex3
				FadeSpriteOut(i, specialTimerAgainst2#, chronoCrabTimeMax/10, 0)
			next i 
		else
			//The normal
			fpsr# = fpsr# * 1.9
		endif
		DrawPolar2(special1Ex1, 0, 90 - (specialTimerAgainst2#/chronoCrabTimeMax)*1080*6) //Minute Hand
		DrawPolar2(special1Ex2, 0, 90 - (specialTimerAgainst2#/chronoCrabTimeMax)*360*2) //Hour Hand
		//Clock wiggle
		SetSpriteSize(special1Ex3, 150+12*sin(specialTimerAgainst2#*6), 150+12*cos(specialTimerAgainst2#*5))
		DrawPolar2(special1Ex3, 0, 0)
		SetSpriteAngle(special1Ex3, 0 + 5.0*cos(specialTimerAgainst2#*2))
	endif
	
	//The Ninja Crab special
	if specialTimerAgainst2# > 0 and crab1Type = 6
		if specialTimerAgainst2# < ninjaCrabTimeMax and GetSpriteColorAlpha(special1Ex1) = 0
			spr = special1Ex1
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab1)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab1)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst2# < ninjaCrabTimeMax*4/5 and GetSpriteColorAlpha(special1Ex2) = 0
			spr = special1Ex2
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab1)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab1)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst2# < ninjaCrabTimeMax*3/5 and GetSpriteColorAlpha(special1Ex3) = 0
			spr = special1Ex3
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab1)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab1)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		
		for i = special1Ex1 to special1Ex3
			numLoop = i - special1Ex1 + 1
			
			IncSpriteAngle(i, 16*fpsr#)
			IncSpriteYFloat(i, -5.5*fpsr#)
		next i
	endif
		
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab2Theta#, crab2Vel# * crab2Dir# * fpsr#
	
	true1 = 0
	if (deviceType = DESKTOP and ((GetPointerPressed() and (GetPointerY() < GetSpriteY(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(50))) and Hover(meteorButton2) = 0 and Hover(specialButton2) = 0) then true1 = 1
	true2 = 0
	if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton2) = 0 and GetMulitouchPressedButton(specialButton2) = 0 and GetMultitouchPressedTop() and deviceType = MOBILE) then true2 = 1
	true3 = 0
	if spActive = 1 and (GetMultitouchPressedTop() or GetMultitouchPressedBottom()) and deviceType = MOBILE and not ButtonMultitouchEnabled(pauseButton) then true3 = 1
	//Activating the crab turn at an input
	
	aiTrue = 0
	if aiActive = 1 then aiTrue = AITurn()
	
	if (((true2 or buffer2 or true1 or true3) and aiActive = 0) or aiTrue = 1) and crab2JumpD# = 0
		
		buffer2 = 0
		if crab2Turning = 0 and crab2Type <> 6
			if spActive = 0 then PlaySoundR(turnS, volumeSE)
			if crab2Dir# > 0
				crab2Turning = -1
			else
				crab2Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab2Turning = -1*crab2Turning
			
			//This checks that either the crab1Dir is small enough, or that it is right at the start of the process
			if Abs(crab2Dir#) < .7 or (crab2Turning * crab2Dir# > 0) or (Abs(crab2Dir#) < 1 and specialTimerAgainst2# > 0 and crab1Type = 5) or crab2Type = 6
				//The crab leap code
				//crab1Turning = -1*crab1Turning	//Still not sure if you should leap forwards or backwards
				if spActive = 0 then PlayMusicOGG(jump2S, 0)
				crab2JumpD# = crab2JumpDMax
				if crab2Type <> 6
					crab2Dir# = crab2Vel#*crab2Turning
				else
					//Ninja code!
					crab2Dir# = -1*crab2Dir#
					crab2Turning = 0
				endif
				ActivateJumpParticles(2)
			else
				//Crab has turned
				if spActive = 0 then PlaySoundR(turnS, volumeSE)
			endif
		endif
		
	endif
	
	//The jumping movement code
	if crab2JumpD# > 0
		//if true1 or true2 or true3 and crab2JumpD# < crab2JumpDMax/5.0 then buffer2 = 1
		
		if crab2JumpD# > crab2JumpDMax*7/8
			PlaySprite(crab2, 0, 0, 11, 11)	
		else
			PlaySprite(crab2, 0, 0, 12, 12)	
		endif
		
		//Incrementing the crab's movement a tiny bit more when leaping
		inc crab2Theta#, crab2jumpSpeed# * crab2Dir# * fpsr#
		//Original velo: 0.85
		
		inc crab2JumpD#, -1*fpsr#
		
		//Resetting the crab back to normal
		if crab2JumpD# < 0
			crab2JumpD# = 0
			if crab2Dir# < 0
				SetSpriteFlip(crab2, 1, 0)
			else
				SetSpriteFlip(crab2, 0, 0)
			endif
			PlaySprite(crab2, crab2framerate, 1, 3, 10)		
		endif
		
	endif
	
	//Enacting the crab turn while activated
	if crab2Turning <> 0 then TurnCrab2(crab2Turning)
	
	//Making sure the crab is using proper rotation numbers
	if crab2Theta# > 360 then inc crab2Theta#, -360
	if crab2Theta# < 0 then inc crab2Theta#, 360
	
	//This cancels out the weird issue where the integer is sometimes infinity
	if crab2Theta# > 10000000 then crab2Theta# = 90
	
	//The visual crab update code
	DrawPolar2(crab2, planetSize/2 + GetSpriteHeight(crab2)/3, crab2Theta#)
	
	//Visuals for if the crab is jumping
	if crab2JumpD# > 0
		DrawPolar2(crab2, planetSize/2 + GetSpriteHeight(crab2)/3 + crab2JumpHMax# * (crab2JumpD# - (crab2JumpD#^2)/crab2JumpDMax), crab2Theta#)
	endif
	//Adjusting the crab angle for the dive, cosmetic
	if crab2JumpD# > 0
		SetSpriteAngle(crab2, GetSpriteAngle(crab2) + crab2JumpD#/crab2JumpDMax*360 * -1 * crab2Dir#)
	endif
	
	if specialTimerAgainst2# > 0 then inc specialTimerAgainst2#, -1*fpsr#
	
	//Cleaning up Space Crab's special
	if specialTimerAgainst2# < 0 and crab1Type = 1
		specialTimerAgainst2# = 0
		DeleteSprite(special1Ex1)
		
	endif
	
	//Cleaning up Top Crab's special
	if specialTimerAgainst2# < 0 and crab1Type = 3
		if Abs(GetSpriteAngle(planet2)-180) > 1
			ang# = GlideNumToZero(GetSpriteAngle(planet2)-180, 10)
			SetSpriteAngle(planet2, ang#+180)
		else
			specialTimerAgainst2# = 0
			SetSpriteAngle(planet2, 180)
		endif
		
	endif
	
	//Cleaning up Rave Crab's special
	if specialTimerAgainst2# <= 0 and crab1Type = 4
		for i = special1Ex1 to special1Ex5
			DeleteSprite(i)
		next i
		StopMusicOGGSP(raveBass1)
	endif
	
	//Cleaning up Chrono & Ninja Crab's special
	if specialTimerAgainst2# < 0 and (crab1Type = 5 or crab1Type = 6)
		for i = special1Ex1 to special1Ex3
			DeleteSprite(i)
		next i
		specialTimerAgainst2# = 0
	endif
	
	inc met1CD2#, -1 * fpsr#
	inc met2CD2#, -1 * fpsr#
	inc met3CD2#, -1 * fpsr#
	
	if met1CD2# < 0
		met1CD2# = Random(met1RNDLow - 5*gameDifficulty2, met1RNDHigh) - 20*gameDifficulty2
		if gameTimer# < gameTimeGate1 then dec met1CD2#, 40
		if gameTimer# < gameTimeGate2 then dec met1CD2#, 30
		
		CreateMeteor(2, 1, 0)
	endif
	
	if met2CD2# < 0 and gameTimer# > gameTimeGate1
		met2CD2# = Random(met2RNDLow - 5*gameDifficulty2, met2RNDHigh) - 20*gameDifficulty2
		if gameTimer# < gameTimeGate2 then dec met2CD2#, 40
		
		CreateMeteor(2, 2, 0)
	endif
	
	if met3CD2# < 0 and gameTimer# > gameTimeGate2
		met3CD2# = Random(met3RNDLow - 15*gameDifficulty2, met3RNDHigh) - 25*gameDifficulty2
		
		CreateMeteor(2, 3, 0)
	endif
		
	UpdateMeteor2()
	
	//DrawPolar2(planet2, 0, 270)
	
	if expTotal2 >= meteorCost2 and ButtonMultitouchEnabled(meteorButton2) and hit1Timer# <= 0
		SendMeteorFrom2()
	endif
	
	if expTotal2 = specialCost2 and ButtonMultitouchEnabled(specialButton2) and hit1Timer# <= 0
		SendSpecial2()
	endif
	
	//Death is above so that the screen nudging code activates
	hitSpr = CheckDeath2()
	if hitSpr <> 0
		DeleteSprite(hitSpr)
		if getSpriteExists(hitSpr+glowS) then DeleteSprite(hitSpr + glowS)
		//Kill crab
		inc crab2Deaths, 1
		hit2Timer# = hitSceneMax
		if crab2Deaths = 3 then hit2Timer# = hitSceneMax/3
		
		for i = special1Ex1 to special1Ex5
			if GetSpriteExists(i)
				DeleteSprite(i)
			endif
		next i
		
	endif
	
	NudgeScreen2()
	
	fpsr# = 60.0/ScreenFPS()
	
endfunction state

function TurnCrab2(dir)
	
	//Accelerating the crab in the specified direction
	inc crab2Dir#, dir * crab2Accel# * fpsr#
	
	lastFourth = 0
	if crab2Dir# > dir/2.0 and dir > 0 then lastFourth = 1
	if crab2Dir# < dir/2.0 and dir < 0 then lastFourth = 1
	
	if lastFourth
		PlaySprite(crab2, 0, 0, 17, 17)	
	elseif Abs(crab2Dir#) > .5
		PlaySprite(crab2, 0, 0, 15, 15)	
	else
		PlaySprite(crab2, 0, 0, 16, 16)
	endif
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab2Dir#) > Abs(dir)
		crab2Dir# = dir
		crab2Turning = 0
		if crab2Dir# < 0
			SetSpriteFlip(crab2, 1, 0)
		else
			SetSpriteFlip(crab2, 0, 0)
		endif
		PlaySprite(crab2, crab2framerate, 1, 3, 10)		
	endif
	
endfunction

function UpdateMeteor2()
	
	deleted = 0
	nonSpecMet = 0
	
	for i = 1 to meteorActive2.length
		spr = meteorActive2[i].spr
		cat = meteorActive2[i].cat
		if cat = 1	//Normal meteor
			meteorActive2[i].r = meteorActive2[i].r - met1speed*(1 + (gameDifficulty2-1)*diffMetMod)*fpsr#
			
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
			else
				//Slowing the meteors at certain angles
				if (Abs(Mod(meteorActive2[i].theta+slowMetWidth, 90)-slowMetWidth) < slowMetWidth) then meteorActive2[i].r = meteorActive2[i].r + 1.0*met1speed/slowMetSpeedDen
			
			endif
			
		elseif cat = 2	//Rotating meteor
			meteorActive2[i].r = meteorActive2[i].r - met2speed*(1 + (gameDifficulty2-1)*diffMetMod)*fpsr#
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
			meteorActive2[i].r = meteorActive2[i].r - met3speed*(1 + (gameDifficulty2-1)*diffMetMod)*fpsr#
			
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
			
		endif
				
		DrawPolar2(spr, meteorActive2[i].r, meteorActive2[i].theta)
		DrawPolar2(spr+glowS, meteorActive2[i].r, meteorActive2[i].theta)		//For the glow
		SetSpriteColorAlpha(spr+glowS, 215 + cos(gameTimer#*8)*40)
		
		if cat = 2 then IncSpriteAngle(spr, -25)
		if cat = 2 then IncSpriteAngle(spr+glowS, -25)
		if GetSpriteY(spr) < h/2 - GetSpriteHeight(spr)/2
			SetSpriteVisible(spr, 1)
			SetSpriteVisible(spr+glowS, 1)
		else
			SetSpriteVisible(spr, 0)
			SetSpriteVisible(spr+glowS, 0)
		endif
		
	
		if (GetSpriteCollision(spr, planet2) or meteorActive2[i].r < 0) and deleted = 0	
			if hit2Timer# <= 0
				//Only doing the special extras when the crab isn't dead
				if GetSpriteColorAlpha(spr) = 255
					if spActive = 0 then CreateExp(spr, cat, crab2Deaths + 1)	//Only non-special meteors give EXP
					nonSpecMet = 1
				endif
				ActivateMeteorParticles(cat, spr, 2)
			
				//The screen nudging
				inc nudge2R#, 2.5 + cat*2.5
				nudge2Theta# = meteorActive2[i].theta
			endif
			
			if spActive
				inc spScore, 1
				UpdateSPScore(2)
			endif
			
			DeleteSprite(spr)
			if getSpriteExists(spr+glowS) then DeleteSprite(spr + glowS)
			PlaySoundR(explodeS, volumeSE)
			
			if meteorActive2[i].cat = 3 then DeleteSprite(spr + 10000)
			//Meteor explosion goes here
			deleted = i
		endif
	
	next i
	
	if deleted > 0
		meteorActive2.remove(deleted)
		inc meteorTotal2, 1
		
		//Updating the difficulty
		if Mod(meteorTotal2, difficultyBar) = 0 and gameDifficulty2 < 7
			inc gameDifficulty2, 1
		endif
	endif
	
endfunction

function UpdateButtons2()
	
	if expTotal2 = specialCost2
		//Bar is full
		if GetSpriteColorRed(specialButton2) < 255 and hit1Timer# = 0 then PingColor(GetSpriteMiddleX(specialButton2), GetSpriteMiddleY(specialButton2), 250, 20, 255, 40, GetSpriteDepth(specialButton2)+1)
		SetSpriteColor(specialButton2, 255, 255, 255, 255)
		if GetSpriteCurrentFrame(specialButton2) = 5 then PlaySprite(specialButton2, 15, 1, 1, 4)
		if GetSpritePlaying(expHolder2) = 0 then PlaySprite(expHolder2, 20, 1, 1, 12)
	else
		//Bar is not full
		SetSpriteColor(specialButton2, 100, 100, 100, 255)
		PlaySprite(specialButton2, 0, 0, 5, 5)
		PlaySprite(expHolder2, 20, 0, 1, 1)
		StopSprite(expHolder2)
	endif
	
	if expTotal2 >= meteorCost2
		//Enabling the button
		if GetSpriteColorRed(meteorButton2) < 255 and hit1Timer# = 0 then PingColor(GetSpriteMiddleX(meteorButton2), GetSpriteMiddleY(meteorButton2), 370, 30, 100, 255, GetSpriteDepth(meteorButton2)+1)
		SetSpriteColor(meteorButton2, 255, 255, 255, 255)
		if GetSpriteCurrentFrame(meteorButton2) = 5 then PlaySprite(meteorButton2, 15, 1, 1, 4)
	else
		//Disabling the button
		SetSpriteColor(meteorButton2, 100, 100, 100, 255)
		PlaySprite(meteorButton2, 0, 0, 5, 5)
		StopSprite(meteorButton2)
	endif
	
	SetSpriteX(meteorMarker2, GetSpriteX(expHolder2) + GetSpriteWidth(expHolder2) - 1.0*(GetSpriteWidth(expHolder2)-20)*meteorCost2/specialCost2 + 4 - .116*GetSpriteWidth(expHolder1))
endfunction

function SendMeteorFrom2()
	PlaySoundR(arrowS, 100)
	
	CreateMeteor(1, 4, 0)
	inc expTotal2, -1*meteorCost2
	
	meteorCost2 = meteorCost2*meteorMult#
	if meteorCost2 > specialCost2-1 then meteorCost2 = specialCost2-1
	
	UpdateButtons2()
endfunction

function SendSpecial2()
	
	ShowSpecialAnimation(crab2Type)
	
	newMetS as meteor
	
	if crab2Type = 1
		//Space Crab
		specialTimerAgainst1# = spaceCrabTimeMax
		
		if GetSpriteExists(special2Ex1) = 0
			CreateSpriteExpress(special2Ex1, 70, 70, -100, -100, 19)
			SetSpriteImage(special2Ex1, ufoI)
		endif
		
		PlaySoundR(ufoS, volumeSE)
		
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
			SetSpriteColor(meteorSprNum, 235, 20, 20, 254)
			SetSpriteDepth(meteorSprNum, 20)
			AddMeteorAnimation(meteorSprNum)
			
			CreateSprite(meteorSprNum + 10000, meteorTractorI)
			SetSpriteSize(meteorSprNum + 10000, 1, 1000)
			SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
			SetSpriteDepth(meteorSprNum + 10000, 30)
			
			CreateMeteorGlow(meteorSprNum)
			
			inc meteorSprNum, 1
			
			//Reproducable bug by spamming this attack, was in the spr references in ospr in the meteor 3 update
			
			meteorActive1.insert(newMetS)
		next i
		
	elseif crab2Type = 2
		//Ladder Wizard
		
		rnd = Random(1, 2)
		if rnd = 1
			PlaySoundR(wizardSpell1S, volumeSE)
		else
			PlaySoundR(wizardSpell2S, volumeSE)
		endif
		
		for j = 1 to 3
		baseTheta = Random(1, 360)
		dir = Random(1, 2)
		if dir = 2 then dir = -1
			for i = 1 to 4
				newMetS.theta = baseTheta + i*38*dir
				newMetS.r = 200 + j*400 + i*50
				newMetS.spr = meteorSprNum
				newMetS.cat = 1
						
				CreateSprite(meteorSprNum, 0)
				SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
				SetSpriteColor(meteorSprNum, 255, 120, 40, 254)
				SetSpriteDepth(meteorSprNum, 20)
				SetSpriteColorRandomBright(meteorSprNum)
				AddMeteorAnimation(meteorSprNum)
				CreateMeteorGlow(meteorSprNum)
				inc meteorSprNum, 1
				meteorActive1.insert(newMetS)
			next i
		next j
		
		ActivateMeteorParticles(4, 0, 1)
		
	elseif crab2Type = 3
		//Top Crab
		specialTimerAgainst1# = topCrabTimeMax
		planet1RotSpeed# = 0
		
	elseif crab2Type = 4
		//Rave Crab
		PlayMusicOGGSP(raveBass2, 1)
		SetMusicVolumeOGG(raveBass2, 100)
		
		specialTimerAgainst1# = raveCrabTimeMax
		if GetSpriteExists(special2Ex1) = 0
			CreateSprite(special2Ex1, boarderI)
			CreateSprite(special2Ex2, boarderI)
			CreateSprite(special2Ex3, boarderI)
			CreateSprite(special2Ex4, boarderI)
			CreateSprite(special2Ex5, 0)
		endif
		
		for i = special2Ex1 to special2Ex4
			SetSpriteDepth(i, 19)
			FixSpriteToScreen(i, 1)
			SetSpriteColorByCycle(i, specialTimerAgainst1#)
		next i
		SetSpriteDepth(special2Ex5, 7)
		
		size = 160
		
		SetSpriteSize(special2Ex1, size, h/2)
		
		SetSpriteSize(special2Ex2, size, h/2)
		SetSpriteFlip(special2Ex2, 1, 0)
		SetSpritePosition(special2Ex2, w-size, 0)
		
		SetSpriteSize(special2Ex3, size, w)
		SetSpritePosition(special2Ex3, w/2-size/2, -w/2+size*3/4)
		SetSpriteAngle(special2Ex3, 90)
		
		SetSpriteSize(special2Ex4, size, w)
		SetSpritePosition(special2Ex4, w/2-size/2, h/2-w/2-size/2-GetSpriteHeight(split)/2+60)
		SetSpriteAngle(special2Ex4, 270)
		
		//The lazy way to set it to the bottom screen
		for i = special2Ex1 to special2Ex4
			IncSpriteY(i, h/2)
		next i
		
		SetSpriteSizeSquare(special2Ex5, 220)
		DrawPolar1(special2Ex5, 0, 270)
		//SetSpriteColorByCycle(special2Ex5, specialTimerAgainst1#)
		for i = special4s1 to special4s8
			AddSpriteAnimationFrame(special2Ex5, i)
		next i
		PlaySprite(special2Ex5, 20, 1, 1, 8)
	
	elseif crab2Type = 5
		//Chrono Crab
		specialTimerAgainst1# = chronoCrabTimeMax
		
		if GetSpriteExists(special2Ex1) = 0
			SetFolder("/media/ui")
			LoadSpriteExpress(special2Ex1, "clockhand2b.png", 100, 100, -100, -100, 6)	//Minute hand
			LoadSpriteExpress(special2Ex2, "clockhand1b.png", 100, 100, -100, -100, 6)	//Hour hand
			LoadSpriteExpress(special2Ex3, "clock.png", 100, 100, -200, -200, 7)	//Clock
		endif
		
		SetSpriteColorAlpha(special2Ex1, 0)
		SetSpriteColorAlpha(special2Ex2, 0)
		SetSpriteColorAlpha(special2Ex3, 0)
		
		DrawPolar1(special2Ex1, 0, 270 + (specialTimerAgainst1#/chronoCrabTimeMax)*1080)
		DrawPolar1(special2Ex2, 0, 270 + (specialTimerAgainst1#/chronoCrabTimeMax)*360)
		
		//Clock wiggle
		SetSpriteSize(special2Ex3, 150+12*sin(specialTimerAgainst1#*4), 150+12*cos(specialTimerAgainst1#*3))
		DrawPolar1(special2Ex3, 0, 0)
		SetSpriteAngle(special2Ex3, 0 + 5.0*cos(specialTimerAgainst1#*2))
		
	elseif crab2Type = 6
		//Ninja Crab
		specialTimerAgainst1# = ninjaCrabTimeMax
		
		ninjaStarSize = 80
		
		//The 3 throwing stars
		for i = special2Ex1 to special2Ex3
			if GetSpriteExists(i) = 0 then CreateSpriteExpress(i, ninjaStarSize, ninjaStarSize, -200, -200, 4)
			SetSpriteImage(i, ninjaStarI)
			SetSpriteColorAlpha(i, 0)
			SetSpriteShapeCircle(i, 0, 0, ninjaStarSize*2.2/7, 0)
		next i
		
	endif
	
	expTotal2 = 0
	specialCost2 = specialCost2 * specialMult#
	UpdateButtons2()
	
endfunction

function CheckDeath2()
	isHit = 0
	
	for i = 1 to meteorActive2.length
		spr = meteorActive2[i].spr
		if GetSpriteCollision(crab2, spr)
			isHit = spr
			inc nudge2R#, 20
			nudge2Theta# = crab2Theta#
			cat = meteorActive2[i].cat
			if meteorActive2[i].cat = 3 then DeleteSprite(spr + 10000)
			//ActivateMeteorParticles(cat, spr, 1)
			PlaySprite(crab2, 0, 1, Random(13, 14), -1)
			DeleteHalfExp(2)
			
			//Leaving the loop early
			meteorActive2.remove(i)
			i = meteorActive2.length + 10
		endif
	next
	
	//Collision for their ninja stars
	if crab1Type = 6
		for i = special1Ex1 to special1Ex3
			if GetSpriteExists(i)
				if GetSpriteCollision(crab2, i)
					isHit = i
					inc nudge2R#, 20
					nudge2Theta# = 270
					PlaySprite(crab2, 0, 1, Random(13, 14), -1)
					DeleteHalfExp(2)
				endif
			endif
		next i
	endif
	
	if isHit
		specialTimerAgainst2# = 0
		for i = par2met1 to par2spe1
			//Make the particles invisiable here
			//ResetParticleCount(i)
			//SetParticlesActive(i, 0)
		next i
	endif
	
endfunction isHit

function HitScene2()
	
	state = GAME
	
	inc hit2Timer#, -1*fpsr#
	Print(hit2Timer#)
	if GetMusicPlayingOGGSP(raveBass1) then StopMusicOGGSP(raveBass1)
	
	if crab2Deaths < 3
		//The first and second deaths
		if hit2Timer# > hitSceneMax*3/4
			
			if hit2Timer# = hitSceneMax-1*fpsr#
				//Running the first time
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				inc crab2R#, -20
				SetFolder("/media")
				LoadSprite(bgHit2, "envi/bg0.png")
				SetSpriteSizeSquare(bgHit2, w)
				DrawPolar2(bgHit2, 0, crab2Theta#)
				SetSpriteColorAlpha(bgGame2, 80)
				for i = 1 to meteorActive2.length
					StopSprite(meteorActive2[i].spr)
				next i
			endif
			
			//Accounting for the Smash Bros Freeze
			if hit2Timer# < hitSceneMax*8/9
				if GetSoundPlayingR(launchS) = 0 then PlaySoundR(launchS, 100)
				
				for i = 1 to meteorActive2.length
					ResumeSprite(meteorActive2[i].spr)
				next i
				UpdateMeteor2()
				
				//Flying off the planet
				inc crab2R#, 25*fpsr#
				SetSpriteDepth(crab2, 11)
				
				if GetSpriteExists(bgHit2) then DeleteSprite(bgHit2)
				SetSpriteColorAlpha(bgGame2, 255)
				
				NudgeScreen2()
			endif			
			
		elseif hit2Timer# > hitSceneMax/4
			//Flying towards the next planet
			
			//The one time changes:
			if GetSpriteColorAlpha(crab2) = 255
				
				PlaySoundR(flyingS,100)
				SetSpriteColorAlpha(crab2, 254)
				SetBGRandomPosition(bgGame2)
			
				//Removing the old remaining meteors
				for i = 1 to meteorActive2.length
					DeleteSprite(meteorActive2[i].spr)
					DeleteSprite(meteorActive2[i].spr+glowS)
					if meteorActive2[i].cat = 3 then DeleteSprite(meteorActive2[i].spr + 10000)
				next
				for i = 1 to meteorActive2.length
					meteorActive2.remove()
				next
				meteorActive2.length = 0
			endif
			
			SetSpriteColorAlpha(planet2, 0)
			if random(1, 500) <> 280
				SetSpriteImage(planet2, planetVarI[Random(1, planetIMax)])
			else
				//LEGENDARY PLANET
				SetSpriteImage(planet2, planetVarI[Random(planetIMax+1, planetITotalMax)])
			endif
			
			crab2R# = -10*(hit2Timer#-hitSceneMax/2)
			
			if hit2Timer# < hitSceneMax/2*3
				SetSpriteColor(crab2PlanetS[crab2Deaths], 80, 80, 80, 255)
				
				if crab2Deaths = 2
					SetSpriteColor(crab2PlanetS[crab2Deaths+1], 255, 100, 100, 255)
					//todo: play warning sound
				endif
				size = planetIconSize + 3 + 7*cos(hit2Timer#*10)*crab2Deaths	//The final multiplier makes it a bigger deal for the last planet
				SetSpriteSize(crab2PlanetS[crab2Deaths+1], size, size)
				//SetSpritePosition(crab2PlanetS[crab2Deaths+1], w/2 - size/2 + (4-(crab2Deaths-1))*size*1.5, h/2 - 80 - planetIconSize)
				DrawPolar2(crab2PlanetS[crab2Deaths+1], 300, 90 + (crab2Deaths-1)*20)
				SetSpriteAngle(crab2PlanetS[crab2Deaths+1], 180)
			endif
			
		elseif hit2Timer# > 0
			//Hitting the new planet
			
			//The one time changes:
			if GetSpriteColorAlpha(crab2) = 254
				SetSpriteColorAlpha(crab2, 255)
				SetSpriteImage(bgGame2, bg1I + crab2Deaths)
				SetBGRandomPosition(bgGame2)
			endif
			
			crab2R# = -1*GetCrabDefaultR(crab2) - 12*hit2Timer#
			
			//Planet adjustment
			DrawPolar2(planet2, 0, 90)
			SetSpriteColorAlpha(planet2, 255)
			
			//Planet icon adjustment
			SetSpriteSize(crab2PlanetS[crab2Deaths+1], planetIconSize, planetIconSize)
			//SetSpritePosition(crab2PlanetS[crab2Deaths+1], w/2 - planetIconSize/2 + (4-(crab2Deaths-1))*planetIconSize*1.5, h/2 - 80 - planetIconSize)
			DrawPolar2(crab2PlanetS[crab2Deaths+1], 300, 90 + (crab2Deaths-1)*20)
			SetSpriteAngle(crab2PlanetS[crab2Deaths+1], 180)
			
		elseif hit2Timer# <= 0
			//Return to normal, this code runs once
						
			//Crab stuff
			crab2JumpD# = crab2JumpDMax*2/3
			PlaySprite(crab2, crab2framerate, 1, 3, 10)
			crab2R# = GetCrabDefaultR(crab2)
			SetSpriteDepth(crab2, 3)
			//Part of the trick that makes the crab hit the other side of the planet
			inc crab2Theta#, 180
			
			//Planet adjustment
			nudge2R# = 60
			nudge2Theta# = crab2Theta#
			
			EnableAttackButtons()
			
			gameDifficulty2 = Max(gameDifficulty2-1, 1)
			
			PlaySoundR(landingS, 100)
			
			hit2Timer# = 0
		endif
		
	else
		//The final death
		state = RESULTS
	endif
	
	//The visual update code, based on what is happening above
	DrawPolar2(crab2, crab2R#, crab2Theta#)
	
	if hit2Timer# > hitSceneMax*11/12
		//The Smash Bros Freeze
		range = 20-(hitSceneMax-hit2Timer#)
		IncSpritePosition(crab2, Random(-range, range), Random(-range, range))			
	elseif hit2Timer# < hitSceneMax*8/9
		SetSpriteAngle(crab2, hit2Timer#*30)
	endif
	
	if GetSpriteY(crab2) > h/2 then SetSpriteY(crab2, -9999)	//Correction for if the crab ends up on player 1's screen
	
endfunction state

function NudgeScreen2()
	if crab1Type = 3 and specialTimerAgainst2# > 0
		//Nothing here lol
	else
		if nudge2R# > 0
			IncSpritePosition(crab2, -cos(nudge2Theta#)*nudge2R#, -sin(nudge2Theta#)*nudge2R#)
			DrawPolar2(planet2, 0, 90)	//Resetting the planet so that it can be nudged
			IncSpritePosition(planet2, -cos(nudge2Theta#)*nudge2R#, -sin(nudge2Theta#)*nudge2R#)
			
			//inc nudge2R#, -0.3
			nudge2R# = GlideNumToZero(nudge2R#, 2)
			if nudge2R# < 0.01
				nudge2R# = 0
				DrawPolar2(planet2, 0, 90)	//Resetting the planet so that it can be nudged
			endif
		endif
	endif
endfunction
