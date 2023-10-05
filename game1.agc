#include "myLib.agc"
#include "constants.agc"

function DrawPolar1(spr, rNum, theta#)
	if GetSpriteExists(spr)
		if dispH = 0
			cenX = w/2
			cenY = h*3/4 + GetSpriteHeight(split)/4
			if spType = CLASSIC then cenY = h/2
		else
			cenX = w/4 - GetSpriteHeight(split)/4
			cenY = h/2
			if spType = CLASSIC then cenX = w/2
			//Placeholder line for extra theta offset
		endif
		SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
		SetSpriteAngle(spr, theta#+90)
	endif
endfunction

function CreateGame1()
	crab1Deaths = 0
	CreateSprite(planet1, planetVarI[Random(1, 23)])
	SetSpriteSizeSquare(planet1, planetSize*gameScale#)
	SetSpriteShape(planet1, 1)
	DrawPolar1(planet1, 0, 270)
	SetSpriteDepth(planet1, 8)
	
	CreateSprite(crab1, 0)
	//SetSpriteSize(crab1, 64, 40)
	SetSpriteSize(crab1, 119*gameScale#, 67*gameScale#)
	SetSpriteDepth(crab1, 3)
	SetSpriteShapeCircle(crab1, 0, GetSpriteHeight(crab1)/5, 16*gameScale#)
	crab1R# = GetCrabDefaultR(crab1)
	
	if GetSpriteExists(bgGame1) = 0 then CreateSprite(bgGame1, 0)
	SetSpriteImage(bgGame1, bg1I)
	SetBGRandomPosition(bgGame1)
	SetSpriteDepth(bgGame1, 100)
	
	crab1Theta# = 270
	DrawPolar1(crab1, crab1R#, crab1Theta#)
	for i = crab1start1I to crab1skid3I
		AddSpriteAnimationFrame(crab1, i)
	next i
	if crab1Type = 1		//Space
		//for i = crab1start1I to crab1skid3I
			//AddSpriteAnimationFrame(crab1, i)
		//next i
		crab1framerate = frameratecrab1
		specialCost1 = specialPrice1
		crab1Vel# = 1.28
		crab1Accel# = .1
		crab1JumpHMax# = 5
		crab1JumpSpeed# = 1.216
		crab1JumpDMax = 28
		
	elseif crab1Type = 2	//Wizard
		
		crab1framerate = frameratecrab2
		specialCost1 = specialPrice2
		crab1Vel# = 1.08
		crab1Accel# = .13
		crab1JumpHMax# = 10.5
		crab1JumpSpeed# = 1.516
		crab1JumpDMax = 40
		
	elseif crab1Type = 3	//Top
		//for i = crab3start1I to crab3skid3I
			//AddSpriteAnimationFrame(crab1, i)
		//next i
		crab1framerate = frameratecrab3
		specialCost1 = specialPrice3
		crab1Vel# = 2.48
		crab1Accel# = .03
		crab1JumpHMax# = 8
		crab1JumpSpeed# = -3 //-2 //-3.4 //-2
		crab1JumpDMax = 32
		
	elseif crab1Type = 4	//Rave
		//for i = crab4start1I to crab4skid3I
			//AddSpriteAnimationFrame(crab1, i)
		//next i
		crab1framerate = frameratecrab4
		specialCost1 = specialPrice4
		crab1Vel# = 1.59
		crab1Accel# = .08
		crab1JumpHMax# = 10
		crab1JumpSpeed# = -1.28
		crab1JumpDMax = 43
		
	elseif crab1Type = 5	//Chrono
		//for i = crab5start1I to crab5skid3I
			//AddSpriteAnimationFrame(crab1, i)
		//next i
		crab1framerate = frameratecrab5
		specialCost1 = specialPrice5
		crab1Vel# = 1.38
		crab1Accel# = .1
		crab1JumpHMax# = 5
		crab1JumpSpeed# = -3.216
		crab1JumpDMax = 28
		
	elseif crab1Type = 6	//Ninja
		//for i = crab6start1I to crab6skid3I
			//AddSpriteAnimationFrame(crab1, i)
		//next i
		crab1framerate = frameratecrab6
		specialCost1 = specialPrice6
		crab1Vel# = 1.5
		crab1Accel# = .1
		crab1JumpHMax# = 6
		crab1JumpSpeed# = .816
		crab1JumpDMax = 26
		
	else
		//The debug option, no crab selected
		for i = crab1start1I to crab1death2I
			//AddSpriteAnimationFrame(crab1, i)
		next i
		specialCost1 = 1
	endif
	crab1JumpHMax# = crab1JumpHMax#*gameScale#

	PlaySprite(crab1, crab1framerate, 1, 3, 10)
	
	SetFolder("/media/ui")
	LoadAnimatedSprite(expHolder1, "expbar", 12)
	SetSpriteSize(expHolder1, w - 130, 40)
	SetSpriteMiddleScreenX(expHolder1)
	SetSpriteY(expHolder1, h-50)
	SetSpriteDepth(expHolder1, 18)
	PlaySprite(expHolder1, 20, 0, 1, 1)
	//Placeholder for game 2 angle
	if dispH
		SetSpriteSize(expHolder1, w/2 - 130, 28)
		SetSpriteMiddleScreenXDispH1(expHolder1)
		//Placeholder for game 2 Y
	endif

	LoadAnimatedSprite(expBar1, "expflame", 6)
	SetSpriteSize(expBar1, GetSpriteWidth(expHolder1), GetSpriteHeight(expHolder1))
	SetSpritePosition(expBar1, GetSpriteX(expHolder1), GetSpriteY(expHolder1))
	SetSpriteDepth(expBar1, 18)
	PlaySprite(expBar1, 20, 1, 1, 6)
	//Placeholder for game 2 angle
	
	LoadAnimatedSprite(meteorButton1, "attacke", 5)
	PlaySprite(meteorButton1, 0, 0, 5, 5)
	SetSpriteSize(meteorButton1, 90-25*dispH, 90-25*dispH)
	SetSpritePosition(meteorButton1, GetSpriteX(expHolder1)-10-GetSpriteWidth(meteorButton1) + 50, h-10-GetSpriteHeight(meteorButton1))
	SetSpriteDepth(meteorButton1, 15)
	SetSpriteColor(meteorButton1, 100, 100, 100, 255)
	//Placeholder for game 2 angle
	//Might want to make the Y based on the sxp bar holder instead of the screen height

	LoadSpriteExpress(meteorMarker1, "meteormark.png", 8, GetSpriteHeight(expHolder1)+4, 0, GetSpriteY(expHolder1)-2, 14)
	//The X is on a seperate line because it is long
	SetSpriteX(meteorMarker1, GetSpriteX(expHolder1) + 1.0*(GetSpriteWidth(expHolder1)-20)*meteorCost1/specialCost1 - 4 + .116*GetSpriteWidth(expHolder1))
	//Placeholder for game 2 X
	SetSpriteColor(meteorMarker1, 30, 100, 255, 255)
	//Placeholder for game 2 angle
	
	LoadAnimatedSprite(specialButton1, "crab" + str(crab1Type)+ "special", 5)
	SetSpriteFrame(specialButton1, 5)
	SetSpriteSize(specialButton1, 100-25*dispH, 100-25*dispH)
	SetSpritePosition(specialButton1, GetSpriteX(expHolder1) + GetSpriteWidth(expHolder1) + 7 - 50, h-20-GetSpriteHeight(meteorButton1))
	SetSpriteDepth(specialButton1, 15)
	SetSpriteColor(specialButton1, 100, 100, 100, 255)
	//Placeholder for game 2 angle
	
	
	
	
	
	
	crab1PlanetS[1] = 116
	crab1PlanetS[2] = 117
	crab1PlanetS[3] = 118
	//The planet UI that shows how many lives are left
	for i = 1 to 3
		CreateSpriteExpress(crab1PlanetS[i], planetIconSize, planetIconSize, w/2 - planetIconSize/2 + (i-2)*planetIconSize*1.5, h/2 + 80, 5)
		SetSpriteImage(crab1PlanetS[i], crab1life1I - 1 + i)
		if i > 1 then SetSpriteSize(crab1PlanetS[i], planetIconSize/4, planetIconSize/4)
		DrawPolar1(crab1PlanetS[i], 300, 270 + (i-2)*20)
		SetSpriteAngle(crab1PlanetS[i], 0)
	next i
	
	//Setting gameplay parameters to their proper values
	crab1Deaths = 0
	special1Used = 0
		
	if spActive
		for i = 1 to 3
			SetSpriteVisible(crab1PlanetS[i], 0)
		next i
		SetSpriteVisible(expHolder1, 0)
		SetSpriteVisible(expBar1, 0)
		SetSpriteVisible(meteorButton1, 0)
		SetSpriteVisible(meteorMarker1, 0)
		SetSpriteVisible(specialButton1, 0)
		//Extra line for crab2theta
					
		CreateTextExpress(TXT_SP_SCORE, "Score: 0", spScoreMinSize, fontScoreI, 0, 0, 0, 3)
		SetTextMiddleScreen(TXT_SP_SCORE, 0)
		SetTextAlignment(TXT_SP_SCORE, 0)
		SetTextColor(TXT_SP_SCORE, 255, 255, 255, 255)
		SetTextSpacing(TXT_SP_SCORE, -13)
		IncTextX(TXT_SP_SCORE, -364)
		IncTextY(TXT_SP_SCORE, -4)
		
		CreateTextExpress(TXT_SP_DANGER, "Danger: " + str(gameDifficulty1), spScoreMinSize, fontScoreI, 0, 0, 0, 3)
		SetTextMiddleScreen(TXT_SP_DANGER, 0)
		SetTextAlignment(TXT_SP_DANGER, 1)
		SetTextColor(TXT_SP_DANGER, 255, 255, 255, 255)
		SetTextSpacing(TXT_SP_DANGER, -13)
		IncTextX(TXT_SP_DANGER, 227)
		IncTextY(TXT_SP_DANGER, -4)
		
	endif
		
	if dispH
		CreateTextExpress(meteorButton1, "Z", 40, fontScoreI, 1, GetSpriteMiddleX(meteorButton1) - 2, GetSpriteY(meteorButton1) - 40, 10)
		CreateTextExpress(specialButton1, "X", 40, fontScoreI, 1, GetSpriteMiddleX(specialButton1) - 2, GetSpriteY(specialButton1) - 40, 10)
		SetTextColor(meteorButton1, 100, 100, 100, 255)
		SetTextColor(specialButton1, 100, 100, 100, 255)
	endif
		
endfunction

function DoGame1()
	
	//The Space Crab special (just Space Ned)
	if specialTimerAgainst1# > 0 and crab2Type = 1
		DrawPolar1(special2Ex1, 180 + ((specialTimerAgainst1# - 100)^2)/11, 180 + specialTimerAgainst1#)
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
		SetSpriteColor(special2Ex5, (GetSpriteColorRed(special2Ex5)+510)/3, (GetSpriteColorGreen(special2Ex5)+510)/3, (GetSpriteColorBlue(special2Ex5)+510)/3, 255)
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
		DrawPolar1(special2Ex1, 0, 270 - (specialTimerAgainst1#/chronoCrabTimeMax)*1080*6) //Minute Hand
		DrawPolar1(special2Ex2, 0, 270 - (specialTimerAgainst1#/chronoCrabTimeMax)*360*2) //Hour Hand
		//Clock wiggle
		SetSpriteSize(special2Ex3, (150+12*sin(specialTimerAgainst1#*6))*gameScale#, (150+12*cos(specialTimerAgainst1#*5))*gameScale#)
		DrawPolar1(special2Ex3, 0, 0)
		SetSpriteAngle(special2Ex3, 180 + 5.0*cos(specialTimerAgainst1#*2))
	endif
	
	//The Ninja Crab special
	if specialTimerAgainst1# > 0 and crab2Type = 6
		if specialTimerAgainst1# < ninjaCrabTimeMax and GetSpriteColorAlpha(special2Ex1) = 0
			spr = special2Ex1
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst1# < ninjaCrabTimeMax*4/5 and GetSpriteColorAlpha(special2Ex2) = 0
			spr = special2Ex2
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		if specialTimerAgainst1# < ninjaCrabTimeMax*3/5 and GetSpriteColorAlpha(special2Ex3) = 0
			spr = special2Ex3
			SetSpriteColorAlpha(spr, 255)
			SetSpritePosition(spr, GetSpriteMiddleX(crab2)-GetSpriteWidth(spr)/2, GetSpriteMiddleY(crab2)-GetSpriteHeight(spr)/2)
			PlaySoundR(ninjaStarS, volumeSE)
		endif
		
		for i = special2Ex1 to special2Ex3
			numLoop = i - special2Ex1 + 1
			
			IncSpriteAngle(i, 16*fpsr#)
			if dispH = 0 then IncSpriteYFloat(i, 5.5*fpsr#)
			if dispH then IncSpriteXFloat(i, -4.6*fpsr#)
		next i
	endif
	
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	true1 = 0
	//if (deviceType = DESKTOP and ((GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0) then true1 = 1
	if dispH and (inputTurn1 or (GetPointerPressed() and (GetPointerX() < w/2) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0 and Hover(pauseButton) = 0)) then true1 = 1
	true2 = 0
	if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton1) = 0 and GetMulitouchPressedButton(specialButton1) = 0 and GetMultitouchPressedBottom() and deviceType = MOBILE) then true2 = 1
	true3 = 0
	if spActive = 1 and (GetMultitouchPressedTop() or GetMultitouchPressedBottom()) and deviceType = MOBILE and not ButtonMultitouchEnabled(pauseButton) and not ButtonMultitouchEnabled(phantomPauseButton) then true3 = 1
	//Activating the crab turn at an input
	
	//Space left for the AI stuff in game 2
		
	//More space
	
	if (true2 or buffer1 or true1 or true3) and crab1JumpD# = 0
		
		buffer1 = 0
		if crab1Turning = 0 and crab1Type <> 6
			PlaySoundR(turnS, volumeSE)
			if crab1Dir# > 0
				crab1Turning = -1
			else
				crab1Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab1Turning = -1*crab1Turning
			
			//This checks that either the crab1Dir is small enough, or that it is right at the start of the process
			if Abs(crab1Dir#) < .7 or (crab1Turning * crab1Dir# > 0) or (Abs(crab1Dir#) < 1 and specialTimerAgainst1# > 0 and crab2Type = 5) or crab1Type = 6
				//The crab leap code
				//crab1Turning = -1*crab1Turning	//Still not sure if you should leap forwards or backwards
				PlayMusicOGG(jump1S, 0)
				crab1JumpD# = crab1JumpDMax
				if crab1Type <> 6
					crab1Dir# = crab1Vel#*crab1Turning
				else
					//Ninja code!
					crab1Dir# = -1*crab1Dir#
					crab1Turning = 0
				endif
				ActivateJumpParticles(1)
			else
				//Crab has turned
				PlaySoundR(turnS, volumeSE)
			endif
		endif
		
	endif
	
	//The jumping movement code
	if crab1JumpD# > 0
		//if true1 or true2 or true3 and crab1JumpD# < crab1JumpDMax/5.0 then buffer1 = 1
		
		if crab1JumpD# > crab1JumpDMax*7/8
			PlaySprite(crab1, 0, 0, 11, 11)	
		else
			PlaySprite(crab1, 0, 0, 12, 12)	
		endif
		
		//Incrementing the crab's movement a tiny bit more when leaping
		inc crab1Theta#, crab1jumpSpeed# * crab1Dir# * fpsr#
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
	
	//The visual crab update code
	DrawPolar1(crab1, GetCrabDefaultR(crab1), crab1Theta#)
	
	//Visuals for if the crab is jumping
	if crab1JumpD# > 0
		DrawPolar1(crab1, GetCrabDefaultR(crab1) + crab1JumpHMax# * (crab1JumpD# - (crab1JumpD#^2)/crab1JumpDMax), crab1Theta#)
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
		StopMusicOGGSP(raveBass2)
	endif
	
	//Cleaning up Chrono & Ninja Crab's special
	if specialTimerAgainst1# < 0 and (crab2Type = 5 or crab2Type = 6)
		for i = special2Ex1 to special2Ex3
			DeleteSprite(i)
		next i
		specialTimerAgainst1# = 0
	endif
	
	inc met1CD1#, -1 * fpsr#
	inc met2CD1#, -1 * fpsr#
	inc met3CD1#, -1 * fpsr#
	
	if met1CD1# < 0
		met1CD1# = Random(met1RNDLow - 5*gameDifficulty1, met1RNDHigh) - 20*gameDifficulty1
		if gameTimer# < gameTimeGate1 then dec met1CD1#, 40
		if gameTimer# < gameTimeGate2 then dec met1CD1#, 30
		
		CreateMeteor(1, 1, 0)
	endif
	
	if met2CD1# < 0 and gameTimer# > gameTimeGate1
		met2CD1# = Random(met2RNDLow - 5*gameDifficulty1, met2RNDHigh) - 20*gameDifficulty1
		if gameTimer# < gameTimeGate2 then dec met2CD1#, 40
		
		CreateMeteor(1, 2, 0)
	endif
	
	if met3CD1# < 0 and gameTimer# > gameTimeGate2
		met3CD1# = Random(met3RNDLow - 15*gameDifficulty1, met3RNDHigh) - 25*gameDifficulty1
		
		CreateMeteor(1, 3, 0)
	endif
		
	UpdateMeteor1()
	
	//DrawPolar1(planet1, 0, 270)
	
	if expTotal1 >= meteorCost1 and (ButtonMultitouchEnabled(meteorButton1) or inputAttack1) and hit2Timer# <= 0
		SendMeteorFrom1()
	endif
	
	if expTotal1 = specialCost1 and (ButtonMultitouchEnabled(specialButton1) or inputSpecial1) and hit2Timer# <= 0
		SendSpecial1()
	endif
	
	//Death is above so that the screen nudging code activates
	hitSpr = CheckDeath1()
	if GetRawKeyPressed(75) and debug then crab1Deaths = 2
	if hitSpr <> 0 or (GetRawKeyPressed(75) and debug)
		DeleteSprite(hitSpr)
		if getSpriteExists(hitSpr+glowS) then DeleteSprite(hitSpr + glowS)
		//Kill crab
		inc crab1Deaths, 1
		hit1Timer# = hitSceneMax
		if crab1Deaths = 3 then hit1Timer# = hitSceneMax/3
		
		for i = special2Ex1 to special2Ex5
			if GetSpriteExists(i)
				DeleteSprite(i)
			endif
		next i
		
	endif
	
	NudgeScreen1()
	
	fpsr# = 60.0/ScreenFPS()
	
endfunction state

function TurnCrab1(dir)
	
	//Accelerating the crab in the specified direction
	inc crab1Dir#, dir * crab1Accel# * fpsr#
	
	lastFourth = 0
	if crab1Dir# > dir/2.0 and dir > 0 then lastFourth = 1
	if crab1Dir# < dir/2.0 and dir < 0 then lastFourth = 1
		
	if lastFourth
		PlaySprite(crab1, 0, 0, 17, 17)
	elseif Abs(crab1Dir#) > .5
		PlaySprite(crab1, 0, 0, 15, 15)
	else
		PlaySprite(crab1, 0, 0, 16, 16)
	endif
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab1Dir#) > Abs(dir)
		crab1Dir# = dir
		crab1Turning = 0
		if crab1Dir# < 0
			SetSpriteFlip(crab1, 1, 0)
		else
			SetSpriteFlip(crab1, 0, 0)
		endif
		PlaySprite(crab1, crab1framerate, 1, 3, 10)
	endif
		
endfunction

function UpdateMeteor1()
	
	deleted = 0
	nonSpecMet = 0
	
	for i = 1 to meteorActive1.length
		spr = meteorActive1[i].spr
		cat = meteorActive1[i].cat
		if cat = 1	//Normal meteor
			meteorActive1[i].r = meteorActive1[i].r - met1speed*(1 + (gameDifficulty1-1)*diffMetMod)*fpsr#
			
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
			else
				//Slowing the meteors at certain angles
				if (Abs(Mod(meteorActive1[i].theta+slowMetWidth, 90)-slowMetWidth) < slowMetWidth) then meteorActive1[i].r = meteorActive1[i].r + 1.0*met1speed/slowMetSpeedDen
				if spType = CLASSIC and (Abs(Mod(meteorActive1[i].theta+slowMetWidth + 90, 180)-slowMetWidth) < slowMetWidth) then meteorActive1[i].r = meteorActive1[i].r - 1.8*met1speed/slowMetSpeedDen	//Extra classic mode trickery
			endif
		
		elseif cat = 2	//Rotating meteor
			meteorActive1[i].r = meteorActive1[i].r - met2speed*(1 + (gameDifficulty1-1)*diffMetMod)*fpsr#
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
			meteorActive1[i].r = meteorActive1[i].r - met3speed*(1 + (gameDifficulty1-1)*diffMetMod)*fpsr#
			
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
			if GetSpriteCollision(ospr, split) and spType <> CLASSIC
				while GetSpriteCollision(ospr, split)
					SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)-1)
					DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
				endwhile
				SetSpriteSize(ospr, GetSpriteWidth(ospr), GetSpriteHeight(ospr)+40)
				DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
			endif
			
		endif
				
		DrawPolar1(spr, meteorActive1[i].r, meteorActive1[i].theta)
		DrawPolar1(spr+glowS, meteorActive1[i].r, meteorActive1[i].theta)		//For the glow
		SetSpriteColorAlpha(spr+glowS, 215 + cos(gameTimer#*8)*40)
		
		if cat = 2 then IncSpriteAngle(spr, -25)
		if cat = 2 then IncSpriteAngle(spr+glowS, -25)
		if (GetSpriteY(spr) > h/2 - GetSpriteHeight(spr)/2 and dispH = 0) or (GetSpriteX(spr) < w/2 - GetSpriteHeight(spr)/2 and dispH)
			SetSpriteVisible(spr, 1)
			SetSpriteVisible(spr+glowS, 1)
		elseif spType <> CLASSIC
			SetSpriteVisible(spr, 0)
			SetSpriteVisible(spr+glowS, 0)
		endif
		
	`
		if (GetSpriteCollision(spr, planet1) or meteorActive1[i].r < 0) and deleted = 0	
			if hit1Timer# <= 0
				//Only doing the special extras when the crab isn't dead
				if GetSpriteColorAlpha(spr) = 255
					minusOne = 0
					if specialTimerAgainst1# > 0 and crab2Type = 5 then minusOne = 1
					if spActive = 0 then CreateExp(spr, cat, crab1Deaths+1 - minusOne)		//Only non-special meteors give EXP
					nonSpecMet = 1
				endif
				ActivateMeteorParticles(cat, spr, 1)
				
				//The screen nudging
				inc nudge1R#, 2.5 + cat*2.5
				nudge1Theta# = meteorActive1[i].theta
			endif
			
			if spActive
				inc spScore, 1
				UpdateSPScore(1)
			endif
			
			DeleteSprite(spr)
			if getSpriteExists(spr+glowS) then DeleteSprite(spr + glowS)
			if fruitMode = 0 then PlaySoundR(explodeS, volumeSE)
			if fruitMode = 1 then PlaySoundR(fruitS, volumeSE)
			
			if meteorActive1[i].cat = 3 then DeleteSprite(spr + 10000)
			//Meteor explosion goes here
			deleted = i
		endif
	
	next i
	
	if deleted > 0
		meteorActive1.remove(deleted)
		if nonSpecMet = 1 then inc meteorTotal1, 1	//Only want real meteors to increase the difficulty
		
		//Updating the difficulty
		if Mod(meteorTotal1, difficultyBar) = 0 and gameDifficulty1 < difficultyMax
			inc gameDifficulty1, 1
		endif
	endif
	
endfunction

function UpdateButtons1()
	
	if expTotal1 = specialCost1
		//Bar is full
		if GetSpriteColorRed(specialButton1) < 255 and hit2Timer# = 0 then PingColor(GetSpriteMiddleX(specialButton1), GetSpriteMiddleY(specialButton1), 250, 20, 255, 40, GetSpriteDepth(specialButton1)+1)
		SetSpriteColor(specialButton1, 255, 255, 255, 255)
		if GetSpriteCurrentFrame(specialButton1) = 5 then PlaySprite(specialButton1, 15, 1, 1, 4)
		if GetSpritePlaying(expHolder1) = 0 then PlaySprite(expHolder1, 20, 1, 1, 12)
		if GetTextExists(specialButton1) then SetTextColor(specialButton1, 255, 255, 255, 255)
	else
		//Bar is not full
		SetSpriteColor(specialButton1, 100, 100, 100, 255)
		PlaySprite(specialButton1, 0, 0, 5, 5)
		PlaySprite(expHolder1, 20, 0, 1, 1)
		StopSprite(expHolder1)
		if GetTextExists(specialButton1) then SetTextColor(specialButton1, 100, 100, 100, 255)
	endif
	
	if expTotal1 >= meteorCost1
		//Enabling the button
		if GetSpriteColorRed(meteorButton1) < 255 and hit2Timer# = 0 then PingColor(GetSpriteMiddleX(meteorButton1), GetSpriteMiddleY(meteorButton1), 370, 30, 100, 255, GetSpriteDepth(meteorButton1)+1)
		SetSpriteColor(meteorButton1, 255, 255, 255, 255)
		if GetSpriteCurrentFrame(meteorButton1) = 5 then PlaySprite(meteorButton1, 15, 1, 1, 4)
		if GetTextExists(meteorButton1) then SetTextColor(meteorButton1, 255, 255, 255, 255)
	else
		//Disabling the button
		SetSpriteColor(meteorButton1, 100, 100, 100, 255)
		PlaySprite(meteorButton1, 0, 0, 5, 5)
		StopSprite(meteorButton1)
		if GetTextExists(meteorButton1) then SetTextColor(meteorButton1, 100, 100, 100, 255)
	endif
	
	//Placeholder lines for the AI active button-darkening logic
	
	
	
	
	SetSpriteX(meteorMarker1, Min(GetSpriteX(expHolder1) + 1.0*(GetSpriteWidth(expHolder1)-20)*meteorCost1/specialCost1 - 4 + .116*GetSpriteWidth(expHolder1), GetSpriteX(specialButton1)-10))
	
endfunction

function SendMeteorFrom1()
	PlaySoundR(arrowS, 100)
	
	CreateMeteor(2, 4, 0)
	inc expTotal1, -1*meteorCost1
	
	meteorCost1 = meteorCost1*meteorMult#
	if meteorCost1> specialCost1-1 then meteorCost1 = specialCost1-1
	
	SetParticlesDirection(parAttack, 0, -1)
	//Placeholder for game 2
	SetParticlesPosition(parAttack, GetSpriteMiddleX(meteorButton1), GetSpriteMiddleY(meteorButton1))
	SetParticlesImage (parAttack, attackPartI)
	//Placeholder for game 2
	ResetParticleCount(parAttack)
	
	SetSpriteX(expBar1, GetSpriteX(expHolder1))
	
	UpdateButtons1()
endfunction

function SendSpecial1()
	
	ShowSpecialAnimation(crab1Type, crab1Alt, 1, special1Used)
	special1Used = 1
	
	newMetS as meteor
	
	if crab1Type = 1
		//Space Crab
		specialTimerAgainst2# = spaceCrabTimeMax
		
		if GetSpriteExists(special1Ex1) = 0
			CreateSpriteExpress(special1Ex1, 70, 70, -100, -100, 19)
			SetSpriteImage(special1Ex1, ufoI)
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
			
			meteorActive2.insert(newMetS)
		next i
		
	elseif crab1Type = 2
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
		PlayMusicOGGSP(raveBass1, 1)
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
		//Placeholder for Game 2 repositioning
		
		SetSpriteSize(special1Ex2, size, h/2)
		SetSpriteFlip(special1Ex2, 1, 0)
		SetSpritePosition(special1Ex2, w-size, 0)
		
		SetSpriteSize(special1Ex3, size, w)
		SetSpritePosition(special1Ex3, w/2-size/2, -w/2+size/2)
		SetSpriteAngle(special1Ex3, 90)
		
		SetSpriteSize(special1Ex4, size, w)
		SetSpritePosition(special1Ex4, w/2-size/2, h/2-w/2-size/2-GetSpriteHeight(split)/2+40)
		SetSpriteAngle(special1Ex4, 270)
		
		//Extra whitespace so that this matches with the game2 code
		//(On the other screen, this is just to position the rave lights on the bottom screen)
		
		
		
		if dispH
			SetSpriteExpress(special1Ex1, size, h, -size/8 + w/2+size/4, 0, 19)
			SetSpriteExpress(special1Ex2, size, h, w/2-size-GetSpriteHeight(split)/4 + w/2+size/4, 0, 19)
			SetSpriteExpress(special1Ex3, size, w/2, 0, -h/2+size*3/4, 19)
			SetSpriteMiddleScreenXDispH2(special1Ex3)
			SetSpriteExpress(special1Ex4, size, w/2, 0, h/2, 19)
			SetSpriteMiddleScreenXDispH2(special1Ex4)
		endif
		
		SetSpriteSizeSquare(special1Ex5, 220*gameScale#)
		DrawPolar2(special1Ex5, 0, 90)
		//SetSpriteColorByCycle(special1Ex5, specialTimerAgainst2#)
		for i = special4s1 to special4s8
			AddSpriteAnimationFrame(special1Ex5, i)
		next i
		PlaySprite(special1Ex5, 20, 1, 1, 8)
	
	elseif crab1Type = 5
		//Chrono Crab
		specialTimerAgainst2# = chronoCrabTimeMax
		
		if GetSpriteExists(special1Ex1) = 0
			SetFolder("/media/ui")
			LoadSpriteExpress(special1Ex1, "clockhand2b.png", 100*gameScale#, 100*gameScale#, -100, -100, 6)	//Minute hand
			LoadSpriteExpress(special1Ex2, "clockhand1b.png", 100*gameScale#, 100*gameScale#, -100, -100, 6)	//Hour hand
			LoadSpriteExpress(special1Ex3, "clock.png", 100*gameScale#, 100*gameScale#, -200, -200, 7)	//Clock
		endif
		
		SetSpriteColorAlpha(special1Ex1, 0)
		SetSpriteColorAlpha(special1Ex2, 0)
		SetSpriteColorAlpha(special1Ex3, 0)
		
		DrawPolar2(special1Ex1, 0, 90 + (specialTimerAgainst2#/chronoCrabTimeMax)*1080)
		DrawPolar2(special1Ex2, 0, 90 + (specialTimerAgainst2#/chronoCrabTimeMax)*360)
		
		//Clock wiggle
		SetSpriteSize(special1Ex3, 150+12*sin(specialTimerAgainst2#*4)*gameScale#, 150+12*cos(specialTimerAgainst2#*3)*gameScale#)
		DrawPolar2(special1Ex3, 0, 0)
		SetSpriteAngle(special1Ex3, 180 + 5.0*cos(specialTimerAgainst2#*2))
		
	elseif crab1Type = 6
		//Ninja Crab
		specialTimerAgainst2# = ninjaCrabTimeMax
		
		ninjaStarSize = 80*gameScale#
		
		//The 3 throwing stars
		for i = special1Ex1 to special1Ex3
			if GetSpriteExists(i) = 0 then CreateSpriteExpress(i, ninjaStarSize, ninjaStarSize, -200, -200, 4)
			SetSpriteImage(i, ninjaStarI)
			SetSpriteColorAlpha(i, 0)
			//SetSpriteShapeCircle(i, 0, 0, ninjaStarSize*2.2/7, 0)
		next i
		
	endif
	
	expTotal1 = 0
	specialCost1 = specialCost1 * specialMult#
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
	//Print(hit1Timer#)
	if GetMusicPlayingOGGSP(raveBass2) then StopMusicOGGSP(raveBass2)
	
	if crab1Deaths < 3
		//The first and second deaths
		if hit1Timer# > hitSceneMax*3/4
			
			if hit1Timer# = hitSceneMax-1*fpsr#
				//Running the first time
				PlaySoundR(crackS, 100)
				PlaySoundR(explodeS, 100)
				inc crab1R#, -20*gameScale#
				SetFolder("/media")
				LoadSprite(bgHit1, "envi/bg0.png")
				SetSpriteSizeSquare(bgHit1, w)
				if dispH then SetSpriteSizeSquare(bgHit1, h)
				DrawPolar1(bgHit1, 0, crab1Theta#)
				SetSpriteColorAlpha(bgGame1, 80)
				for i = 1 to meteorActive1.length
					StopSprite(meteorActive1[i].spr)
				next i
				PlayDangerMusic(0)
			endif
			
			//Accounting for the Smash Bros Freeze
			if hit1Timer# < hitSceneMax*8/9
				if GetSoundPlayingR(launchS) = 0
					PlaySoundR(launchS, 100)
					PlayDangerMusic(1)
				endif
				
				for i = 1 to meteorActive1.length
					ResumeSprite(meteorActive1[i].spr)
				next i
				UpdateMeteor1()
				
				//Flying off the planet
				inc crab1R#, 25*fpsr#
				SetSpriteDepth(crab1, 11)
				
				if GetSpriteExists(bgHit1) then DeleteSprite(bgHit1)
				SetSpriteColorAlpha(bgGame1, 255)
				
				NudgeScreen1()
			endif
			
		elseif hit1Timer# > hitSceneMax/4
			//Flying towards the next planet
			
			//The one time changes:
			if GetSpriteColorAlpha(crab1) = 255
				
				PlaySoundR(flyingS,100)
				SetSpriteColorAlpha(crab1, 254)
				SetBGRandomPosition(bgGame1)
			
				//Removing the old remaining meteors
				for i = 1 to meteorActive1.length
					DeleteSprite(meteorActive1[i].spr)
					DeleteSprite(meteorActive1[i].spr+glowS)
					if meteorActive1[i].cat = 3 then DeleteSprite(meteorActive1[i].spr + 10000)
				next
				for i = 1 to meteorActive1.length
					meteorActive1.remove()
				next
				meteorActive1.length = 0
			endif
			
			SetSpriteColorAlpha(planet1, 0)
			if random(1, 500) <> 280
				SetSpriteImage(planet1, planetVarI[Random(1, planetIMax)])
			else
				//LEGENDARY PLANET
				SetSpriteImage(planet1, planetVarI[Random(planetIMax+1, planetITotalMax)])
			endif
			
			crab1R# = -10*(hit1Timer#-hitSceneMax/2)
			
			if hit1Timer# < hitSceneMax/2*3
				SetSpriteColor(crab1PlanetS[crab1Deaths], 80, 80, 80, 255)
				
				if crab1Deaths = 2
					SetSpriteColor(crab1PlanetS[crab1Deaths+1], 255, 100, 100, 255)
					//todo: play warning sound
				endif
				size = planetIconSize + 3 + 7*cos(hit1Timer#*10)*crab1Deaths	//The final multiplier makes it a bigger deal for the last planet
				SetSpriteSize(crab1PlanetS[crab1Deaths+1], size, size)
				//SetSpritePosition(crab1PlanetS[crab1Deaths+1], w/2 - size/2 + (crab1Deaths-1)*size*1.5, h/2 + 80)
				DrawPolar1(crab1PlanetS[crab1Deaths+1], 300, 270 + (crab1Deaths-1)*20)
				SetSpriteAngle(crab1PlanetS[crab1Deaths+1], 0)
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
			//SetSpritePosition(crab1PlanetS[crab1Deaths+1], w/2 - planetIconSize/2 + (crab1Deaths-1)*planetIconSize*1.5, h/2 + 80)
			DrawPolar1(crab1PlanetS[crab1Deaths+1], 300, 270 + (crab1Deaths-1)*20)
			SetSpriteAngle(crab1PlanetS[crab1Deaths+1], 0)
		
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
			
			EnableAttackButtons()
			
			gameDifficulty1 = Max(gameDifficulty1-1, 1)
			
			PlaySoundR(landingS, 100)
			
			hit1Timer# = 0
		endif
			
	else
		//The final death
		state = RESULTS
	endif
	
	//The visual update code, based on what is happening above
	DrawPolar1(crab1, crab1R#, crab1Theta#)

	if hit1Timer# > hitSceneMax*11/12
		//The Smash Bros Freeze
		range = 20-(hitSceneMax-hit1Timer#)
		IncSpritePosition(crab1, Random(-range, range), Random(-range, range))			
	elseif hit1Timer# < hitSceneMax*8/9
		SetSpriteAngle(crab1, hit1Timer#*30)
	endif
	
	if GetSpriteY(crab1) < h/2 and dispH = 0 then SetSpriteY(crab1, 9999)	//Correction for if the crab ends up on player 2's screen
	if GetSpriteMiddleX(crab1) > w/2 and dispH then SetSpriteY(crab1, 9999)	//Correction for if the crab ends up on player 2's screen
	
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
