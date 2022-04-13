#include "myLib.agc"
#include "constants.agc"

function DrawPolar1(spr, rNum, theta#)
	cenX = w/2
	cenY = h*3/4 + GetSpriteHeight(split)/4
	SetSpritePosition(spr, rNum*cos(theta#) + cenX - GetSpriteWidth(spr)/2, rNum*sin(theta#) + cenY - GetSpriteHeight(spr)/2)
	SetSpriteAngle(spr, theta#+90)
	//if spriteNum >= 111 and spriteNum <= 120 then SetSpriteAngle(spriteNum, theta#+45)
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
	SetSpriteSize(expHolder1, w - 60, 40)
	SetSpritePosition(expHolder1, 30, h-50)
	SetSpriteColor(expHolder1, 150, 150, 150, 200)

	CreateSprite(expBar1, 0)
	SetSpriteSize(expBar1, 0, 26)
	SetSpritePosition(expBar1, GetSpriteX(expHolder1) + 10, GetSpriteY(expHolder1) + 7)
	SetSpriteColor(expBar1, 255, 160, 0, 255)
	AddSpriteAnimationFrame(expBar1, expBarI1)
	AddSpriteAnimationFrame(expBar1, expBarI2)
	AddSpriteAnimationFrame(expBar1, expBarI3)
	AddSpriteAnimationFrame(expBar1, expBarI4)
	AddSpriteAnimationFrame(expBar1, expBarI5)
	AddSpriteAnimationFrame(expBar1, expBarI6)
	//Current EXP bar animation is a temp one, this is just the framework
	PlaySprite(expBar1, 20, 1, 1, 6)
	
endfunction

function DoGame1()
	
	//The movement code
	inc crab1Theta#, crab1Vel# * crab1Dir# * fpsr# //Need to figure out why FPSR modifier isn't working
	
	//Activating the crab turn at an input
	if (GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))
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
	
	if met1CD1# < 0
		met1CD1# = Random(250, 350)
		newMet.theta = Random(1, 360)
		newMet.r = 500
		newMet.spr = meteorSprNum
		newMet.cat = 1
				
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 255, 120, 40, 255)
		SetSpriteDepth(meteorSprNum, 20)
		inc meteorSprNum, 1
		meteorActive1.insert(newMet)
	endif
	
	
	if met2CD1# < 0
		met2CD1# = Random(350, 450)
		newMet.theta = Random(1, 360)
		newMet.r = 500
		newMet.spr = meteorSprNum
		newMet.cat = 2
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 150, 40, 150, 255)
		SetSpriteDepth(meteorSprNum, 20)
		inc meteorSprNum, 1
		
		meteorActive1.insert(newMet)
	endif
	
	if met3CD1# < 0
		met3CD1# = Random(450, 650)
		newMet.theta = Random(1, 360)
		newMet.r = 5000
		newMet.spr = meteorSprNum
		newMet.cat = 3
		
		CreateSprite(meteorSprNum, 0)
		SetSpriteSize(meteorSprNum, metSizeX, metSizeY)
		SetSpriteColor(meteorSprNum, 235, 20, 20, 255)
		SetSpriteDepth(meteorSprNum, 20)
		
		CreateSprite(meteorSprNum + 10000, 0)
		SetSpriteSize(meteorSprNum + 10000, 1, 1000)
		SetSpriteColor(meteorSprNum + 10000, 255, 20, 20, 30)
		SetSpriteDepth(meteorSprNum + 10000, 30)
		
		inc meteorSprNum, 1
		
		meteorActive1.insert(newMet)
	endif
		
	UpdateMeteor1()
	
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
		
		elseif cat = 2	//Rotating meteor
			meteorActive1[i].r = meteorActive1[i].r - 2*fpsr#
			meteorActive1[i].theta = meteorActive1[i].theta + 1*fpsr#
			
		elseif cat = 3	//Fast meteor
			meteorActive1[i].r = meteorActive1[i].r - 17*fpsr#
			
			ospr = spr + 10000 //Other sprite (is the box)
			SetSpriteSize(ospr, GetSpriteWidth(spr)*(5000-meteorActive1[i].r)/5000.0, GetSpriteHeight(ospr))
			SetSpriteColorAlpha(ospr, 150*(5000-meteorActive1[i].r)/5000.0)
			DrawPolar1(ospr, GetSpriteHeight(ospr)/2, meteorActive1[i].theta)
			
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
		//This below might be unneccisary
		if GetSpriteY(spr) > h/2
			SetSpriteColorAlpha(spr, 255)
		else
			SetSpriteColorAlpha(spr, 0)
		endif
		
	
		if GetSpriteCollision(spr, planet1) and deleted = 0	
			CreateExp(spr, meteorActive1[i].cat)
			DeleteSprite(spr)
			if meteorActive1[i].cat = 3 then DeleteSprite(spr + 10000)
			//Meteor explosion goes here
			deleted = i
		endif
	
	next i
	
	if deleted > 0
		meteorActive1.remove(deleted)
		
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

				//This is for instant bar size adjustment
				//SetSpriteSize(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 26)

				//Add to the exp bar here
				//Todo: Sound effect
			endif

			GlideToWidth(expBar1, (GetSpriteWidth(expHolder1)-20)*(1.0*expTotal1/specialCost1), 2)

		endif

	next i

	if deleted > 0
		expList.remove(deleted)

	endif

endfunction
