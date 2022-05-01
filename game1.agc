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
	
endfunction

function DoGame1()
	
	//fpsr# = fpsr#*1.5
	
	// Start the game loop in the GAME state
	state = GAME
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if ((GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0
		if crab1Turning = 0
			if crab1Dir# > 0
				crab1Turning = -1
			else
				crab1Turning = 1
			endif
		else
			//Changing the direction in case it's already turning
			crab1Turning = -1*crab1Turning
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
	
	fpsr# = 60.0/ScreenFPS()
	
endfunction state

function AddMeteorAnimation(spr)
	AddSpriteAnimationFrame(spr, meteorI1)
	AddSpriteAnimationFrame(spr, meteorI2)
	AddSpriteAnimationFrame(spr, meteorI3)
	AddSpriteAnimationFrame(spr, meteorI4)
	PlaySprite(spr, 15, 1, 1, 4)
	
	if Random(1, 2) = 2 then SetSpriteFlip(spr, 1, 0)
	
	SetSpriteShapeCircle(spr, 0, GetSpriteHeight(spr)/8, GetSpriteWidth(spr)/2.8)
endfunction

function TurnCrab1(dir)
	
	//Accelerating the crab in the specified direction
	inc crab1Dir#, dir * crab1Accel# * fpsr#
	
	if crab1Dir# < 0
		SetSpriteFlip(crab1, 1, 0)
	else
		SetSpriteFlip(crab1, 0, 0)
	endif
	
	//Checking if the crab is at it's maximum velocity, stopping and capping if it is
	if Abs(crab1Dir#) > Abs(dir)
		crab1Dir# = dir
		crab1Turning = 0
	endif
		
endfunction

function UpdateMeteor1()
	
	deleted = 0
	
	for i = 1 to meteorActive1.length
		spr = meteorActive1[i].spr
		cat = meteorActive1[i].cat
		if cat = 1	//Normal meteor
			meteorActive1[i].r = meteorActive1[i].r - 2.5*fpsr#
			//meteorActive1[i].theta = meteorActive1[i].theta - 1*fpsr#
		
		elseif cat = 2	//Rotating meteor
			meteorActive1[i].r = meteorActive1[i].r - 2*fpsr#
			meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#
			
		elseif cat = 3	//Fast meteor
			meteorActive1[i].r = meteorActive1[i].r - 17*fpsr#
			//meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#
			
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
		
	elseif crab1Type = 3
		//Top Crab
		specialTimerAgainst2# = 10000
		
		
	endif
	
	
	expTotal1 = 0
	UpdateButtons1()
	
endfunction

function ShowSpecialAnimation(crabType)
	
	fpsr# = 60.0/ScreenFPS()
	
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
	
endfunction