//Core functions that are used in the app, and possible future apps
function SyncG()
	PingUpdate()
	ButtonsUpdate()
	UpdateAllTweens(GetFrameTime())
    Sync()
endfunction

function max(num1, num2)
	ret = 0	
	if num1 > num2
		ret = num1
	else
		ret = num2
	endif
endfunction ret

function min(num1, num2)
	ret = 0	
	if num1 < num2
		ret = num1
	else
		ret = num2
	endif
endfunction ret

global imageA as Integer[0]

function LoadAnimatedSprite(spr, imgBase$, frameTotal)
	CreateSprite(spr, 0)
	
	//The image array inserts the sprite ID first, then the amount of frames, then images at the positions afterwards
	imageA.insert(spr)
	imageA.insert(frameTotal)
	for i = 1 to frameTotal
		if GetFileExists(imgBase$ + str(i) + ".png")
			imageA.insert(LoadImage(imgBase$ + str(i) + ".png"))
		else
			imageA.insert(LoadImage(imgBase$ + "0" + str(i) + ".png"))
		endif
		
		AddSpriteAnimationFrame(spr, imageA[imageA.length])
	next i
endfunction

function LoadAnimatedSpriteReversible(spr, imgBase$, frameTotal)
	CreateSprite(spr, 0)
	
	//The image array inserts the sprite ID first, then the amount of frames, then images at the positions afterwards
	imageA.insert(spr)
	imageA.insert(frameTotal*2 - 1)
	for i = 1 to frameTotal
		if GetFileExists(imgBase$ + str(i) + ".png")
			imageA.insert(LoadImage(imgBase$ + str(i) + ".png"))
		else
			imageA.insert(LoadImage(imgBase$ + "0" + str(i) + ".png"))
		endif
		
		AddSpriteAnimationFrame(spr, imageA[imageA.length])
	next i
	
	for i = frameTotal-1 to 1 step -1
		if GetFileExists(imgBase$ + str(i) + ".png")
			imageA.insert(LoadImage(imgBase$ + str(i) + ".png"))
		else
			imageA.insert(LoadImage(imgBase$ + "0" + str(i) + ".png"))
		endif
		
		AddSpriteAnimationFrame(spr, imageA[imageA.length])
	next i
endfunction

function CreateSpriteExistingAnimation(spr, refSpr)
	CreateSprite(spr, 0)
	
	//index = imageA.find(refSpr)
	index = ArrayFind(imageA, refSpr)
	
	for i = 1 to imageA[index+1]
		AddSpriteAnimationFrame(spr, imageA[index+1+i])
	next i
endfunction

function DeleteAnimatedSprite(spr)
	DeleteSprite(spr)
	//index = imageA.find(spr)
	index = ArrayFind(imageA, spr)
	
	//Checking we got a sprite ID and not an imageID
	//if Abs(imageA[index] - imageA[index+1]) < 3 then //Find the next one, IDK
		
	size = imageA[index+1] + 2
	for i = 1 to size
		if i > 1 then DeleteImage(imageA[index])
		imageA.remove(index)
	next i
	
	//Check that the number after the current number is less than 30, to not accidentally find an image ID as an index
endfunction

function GetSpriteMiddleX(spr)
	ret = GetSpriteX(spr) + GetSpriteWidth(spr)/2
endfunction ret

function GetSpriteMiddleY(spr)
	ret = GetSpriteY(spr) + GetSpriteHeight(spr)/2
endfunction ret

function SetSpriteMiddleScreen(spr)
	SetSpritePosition(spr, w/2-GetSpriteWidth(spr)/2, h/2-GetSpriteHeight(spr)/2)
endfunction

function SetSpriteMiddleScreenX(spr)
	SetSpriteX(spr, w/2-GetSpriteWidth(spr)/2)
endfunction

function SetSpriteMiddleScreenXDispH1(spr)
	SetSpriteX(spr, (w/2-GetSpriteHeight(split)/2)/2-GetSpriteWidth(spr)/2)
endfunction
function SetSpriteMiddleScreenXDispH2(spr)
	SetSpriteX(spr, w/2 + (w/2+GetSpriteHeight(split)/2)/2-GetSpriteWidth(spr)/2)
endfunction

function SetTextMiddleScreenXDispH1(txt)
	SetTextX(txt, (w/2-GetSpriteHeight(split)/2)/2)
endfunction
function SetTextMiddleScreenXDispH2(txt)
	SetTextX(txt, w/2 + (w/2+GetSpriteHeight(split)/2)/2)
endfunction

function SetSpriteMiddleScreenY(spr)
	SetSpriteY(spr, h/2-GetSpriteHeight(spr)/2)
endfunction

function SetSpriteMiddleScreenOffset(spr, dx, dy)
	SetSpriteMiddleScreen(spr)
	IncSpritePosition(spr, dx, dy)
endfunction

function SetTextMiddleScreen(txt, flip)
	//SetTextPosition(txt, w/2-GetTextTotalWidth(txt)/2 + flip*GetTextTotalWidth(txt), h/2-GetTextTotalHeight(txt)/2 + flip*GetTextTotalHeight(txt))
	SetTextAlignment(txt, 1)
	SetTextPosition(txt, w/2, h/2-GetTextTotalHeight(txt)/2 + flip*GetTextTotalHeight(txt)) //If the alignment is in the middle, we dont need the X offset
endfunction

function SetTextMiddleScreenX(txt, flip)
	//SetTextX(txt, w/2-GetTextTotalWidth(txt)/2 + flip*GetTextTotalWidth(txt))
	SetTextAlignment(txt, 1)
	SetTextX(txt, w/2)		//If the alignment is in the middle, we dont need the X offset
endfunction

function SetTextMiddleScreenOffset(txt, flip, dx, dy)
	SetTextMiddleScreen(txt, flip)
	SetTextPosition(txt, GetTextX(txt) + dx, GetTextY(txt) + dy)
endfunction

function SetSpriteSizeSquare(spr, size)
	SetSpriteSize(spr, size, size)
endfunction

function MatchSpriteSize(spr, sprOrigin)
	SetSpriteSize(spr, GetSpriteWidth(sprOrigin), GetSpriteHeight(sprOrigin))
endfunction

function MatchSpritePosition(spr, sprOrigin)
	SetSpritePosition(spr, GetSpriteX(sprOrigin), GetSpriteY(sprOrigin))
endfunction

function Hover(sprite) 
	if GetSpriteExists(sprite) = 0 then exitfunction 0	//Added in to make sure bad buttons aren't targeted
	returnValue = GetSpriteHitTest(sprite, GetPointerX(), GetPointerY())
endfunction returnValue

function Button(sprite) 
	returnValue = GetPointerPressed() and Hover(sprite)
	if selectTarget = sprite and inputSelect then returnValue = 1
	if selectTarget2 = sprite and inputSelect2 then returnValue = 1
endfunction returnValue

function GetSpriteVisibleR(sprite)
	returnValue = 0
	if GetSpriteExists(sprite) then returnValue = GetSpriteVisible(sprite)
endfunction returnValue

function CreateSpriteExpress(spr, wid, hei, x, y, depth)
	CreateSprite(spr, 0)
	SetSpriteSize(spr, wid, hei)
	SetSpritePosition(spr, x, y)
	SetSpriteDepth(spr, depth)
endfunction

function CreateSpriteExpressImage(spr, img, wid, hei, x, y, depth)
	CreateSprite(spr, img)
	SetSpriteSize(spr, wid, hei)
	SetSpritePosition(spr, x, y)
	SetSpriteDepth(spr, depth)
endfunction

function LoadSpriteExpress(spr, file$, wid, hei, x, y, depth)
	LoadSprite(spr, file$)
	SetSpriteSize(spr, wid, hei)
	SetSpritePosition(spr, x, y)
	SetSpriteDepth(spr, depth)
endfunction

function SetSpriteExpress(spr, wid, hei, x, y, depth)
	SetSpriteSize(spr, wid, hei)
	SetSpritePosition(spr, x, y)
	SetSpriteDepth(spr, depth)
endfunction

function CreateTextExpress(txt, content$, size, fontI, alignment, x, y, depth)
	CreateText(txt, content$)
	SetTextSize(txt, size)
	SetTextFontImage(txt, fontI)
	SetTextAlignment(txt, alignment)
	SetTextPosition(txt, x, y)
	SetTextDepth(txt, depth)
endfunction

function SetTextExpress(txt, content$, size, fontI, alignment, x, y, depth, spacing)
	SetTextString(txt, content$)
	SetTextSize(txt, size)
	SetTextFontImage(txt, fontI)
	SetTextAlignment(txt, alignment)
	SetTextPosition(txt, x, y)
	SetTextDepth(txt, depth)
	SetTextSpacing(txt, spacing)
endfunction

function IncSpriteX(spr, amt)
	SetSpriteX(spr, GetSpriteX(spr)+amt)
endfunction

function IncSpriteY(spr, amt)
	SetSpriteY(spr, GetSpriteY(spr)+amt)
endfunction

function IncSpriteXFloat(spr, amt#)
	SetSpriteX(spr, GetSpriteX(spr)+amt#)
endfunction

function IncSpriteYFloat(spr, amt#)
	SetSpriteY(spr, GetSpriteY(spr)+amt#)
endfunction

function IncSpritePosition(spr, amtX#, amtY#)
	SetSpritePosition(spr, GetSpriteX(spr)+amtX#, GetSpriteY(spr)+amtY#)
endfunction

function IncSpriteAngle(spr, amt#)
	SetSpriteAngle(spr, GetSpriteAngle(spr) + amt#)
endfunction


function IncSpriteSizeCentered(spr, amt#)
	//The regular amt is for X
	amtY# = amt# * GetSpriteHeight(spr)/GetSpriteWidth(spr)
	SetSpritePosition(spr, GetSpriteX(spr)-amt#/2, GetSpriteY(spr)-amtY#/2)
	SetSpriteSize(spr, GetSpriteWidth(spr)+amt#, GetSpriteHeight(spr)+amtY#)
endfunction

function IncSpriteSizeCenteredMult(spr, ratio#)
	amt# = ratio#
	SetSpritePosition(spr, GetSpriteMiddleX(spr)-(GetSpriteWidth(spr)*amt#)/2, GetSpriteMiddleY(spr)-(GetSpriteHeight(spr)*amt#)/2)
	SetSpriteSize(spr, GetSpriteWidth(spr)*amt#, GetSpriteHeight(spr)*amt#)
endfunction

function IncTextX(txt, amt)
	SetTextX(txt, GetTextX(txt) + amt)
endfunction

function IncTextY(txt, amt)
	SetTextY(txt, GetTextY(txt) + amt)
endfunction

function SetSpriteSizeCentered(spr, newWid, newHei)
	SetSpritePosition(spr, GetSpriteMiddleX(spr) - newWid, GetSpriteMiddleY(spr) - newHei)
	SetSpriteSize(spr, newWid, newHei)
endfunction

function GlideToSpot(spr, x, y, denom)
	SetSpritePosition(spr, (((GetSpriteX(spr)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x, (((GetSpriteY(spr)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)
endfunction

function GlideToX(spr, x, denom)
	SetSpriteX(spr, (((GetSpriteX(spr)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x)
endfunction

function GlideToY(spr, y, denom)
	SetSpriteY(spr, (((GetSpriteY(spr)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)
endfunction

function GlideToWidth(spr, wid, denom)
	SetSpriteSize(spr, (((GetSpriteWidth(spr)-wid)*((denom-1)^fpsr#))/(denom)^fpsr#)+wid, GetSpriteHeight(spr))
endfunction

function GlideToScissorX_L(spr, cutX, denom)
	SetSpriteScissor(spr, (((cutX)*((denom-1)^fpsr#))/(denom)^fpsr#), 0, w, h)
endfunction

function GlideToScissorX_R(spr, cutX, denom)
	SetSpriteScissor(spr, 0, 0, (((cutX)*((denom-1)^fpsr#))/(denom)^fpsr#), h)
endfunction

function GlideTextToSpot(txt, x, y, denom)
	
	SetTextPosition(txt, (((GetTextX(txt)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x, (((GetTextY(txt)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)

endfunction

function GlideTextToX(txt, x, denom)
	SetTextX(txt, (((GetTextX(txt)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x)
endfunction

function GlideViewOffset(x, y, denomX, denomY)
	
	SetViewOffset((((GetViewOffsetX()-x)*((denomX-1)^fpsr#))/(denomX)^fpsr#)+x, (((GetViewOffsetY()-y)*((denomY-1)^fpsr#))/(denomY)^fpsr#)+y)

endfunction

function GlideNumToZero(oldNum#, denom)
	newVal# =  (((oldNum#)*((denom-1)^fpsr#))/(denom)^fpsr#)
endfunction newVal#

function SnapbackToSpot(spr, iCur, iEnd, x, y, dx, dy, denom)
	
	if (iCur < iEnd*3/4)
		//Moving to the farther position
		SetSpritePosition(spr, (((GetSpriteX(spr)-(x+dx))*((denom-1)^fpsr#))/(denom)^fpsr#)+(x+dx), (((GetSpriteY(spr)-(y+dy))*((denom-1)^fpsr#))/(denom)^fpsr#)+(y+dy))
	else
		//Sliding back
		SetSpritePosition(spr, (((GetSpriteX(spr)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x, (((GetSpriteY(spr)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)
	endif
	
endfunction

function SnapbackToX(spr, iCur, iEnd, x, dx, denom, ratio)
	
	if (iCur < iEnd*(ratio-1)/ratio)
		//Moving to the farther position
		SetSpriteX(spr, (((GetSpriteX(spr)-(x+dx))*((denom-1)^fpsr#))/(denom)^fpsr#)+(x+dx))
	else
		//Sliding back
		SetSpriteX(spr, (((GetSpriteX(spr)-x)*((denom-2)^fpsr#))/(denom-1)^fpsr#)+x)
	endif
	
endfunction

function SnapbackToY(spr, iCur, iEnd, y, dy, denom)
	
	if (iCur < iEnd*3/4)
		//Moving to the farther position
		SetSpriteY(spr, (((GetSpriteY(spr)-(y+dy))*((denom-1)^fpsr#))/(denom)^fpsr#)+(y+dy))
	else
		//Sliding back
		SetSpriteY(spr, (((GetSpriteY(spr)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)
	endif
	
endfunction

//Fades a sprite in over a given time
function FadeSpriteIn(spr, curT#, startT#, endT#)
	if curT# < endT#
		SetSpriteColorAlpha(spr, 255.0 - 255.0*(curT#-startT#)/(endT#-startT#))
	elseif curT# > endT#
		SetSpriteColorAlpha(spr, 255.0*(curT#-startT#)/(endT#-startT#))
	else
		SetSpriteColorAlpha(spr, 255)
	endif
	
endfunction

function FadeSpriteOut(spr, curT#, startT#, endT#)
	if curT# < endT#
		SetSpriteColorAlpha(spr, 255.0*(curT#-startT#)/(endT#-startT#))
	elseif curT# > endT#
		SetSpriteColorAlpha(spr, 255.0 - 255.0*(curT#-startT#)/(endT#-startT#))
	else
		SetSpriteColorAlpha(spr, 0)
	endif
	
endfunction
	//SetSpriteColorAlpha(i, (specialTimerAgainst2#/(chronoCrabTimeMax/10))*255.0)
	
function IncSpriteColorAlpha(spr, incNum)
	SetSpriteColorAlpha(spr, GetSpriteColorAlpha(spr) + incNum)
endfunction

//The touch variables
global oldTouch as Integer[20]
global newTouch as Integer[20]
global currentTouch as Integer[1]
global oldY as Integer[20]

function ProcessMultitouch()
	
	//Clearing the currentTouch array to reset it for this frame
	for i = 1 to currentTouch.length
		currentTouch.remove()
	next
	currentTouch.length = 0
	
	//Populating the newTouch array with all current touches
	newTouch[1] = GetRawFirstTouchEvent(1)
	for i = 2 to 20
		newTouch[i] = GetRawNextTouchEvent()
	next i
	
	//This is here incase we need to test multitouch logic
//~	for i = 1 to 20
//~		Print(newTouch[i])
//~	next i
//~	Print(9)
//~	for i = 1 to 20
//~		Print(oldTouch[i])
//~	next i
	
	//Checking the newTouch array for any touches that weren't in the previous frame, and acting on those touches
	for i = 1 to 20
		if newTouch[i] <> 0 and oldTouch.find(newTouch[i]) = -1
			//This is a new touch! This touch ID is added to the list of current touches.
			currentTouch.insert(newTouch[i])			
		
		//Checking if there was a touch by the other player at the same time as a release
		elseif oldTouch[i] <> 0 and oldY[i] > 1 and GetRawTouchCurrentY(oldTouch[i]) > 1 and ((GetRawTouchCurrentY(oldTouch[i]) > h/2 and oldY[i] < h/2) or (GetRawTouchCurrentY(oldTouch[i]) < h/2 and oldY[i] > h/2))
			currentTouch.insert(oldTouch[i])	
			//Print(GetRawTouchCurrentY(oldTouch[i]))
			//Print(0)
			//Print(oldY[i])
			//Sync()
			//Sleep(500)
			//If there are problems with the multitouch, they are probably here
		endif
				
	next i
	
	//Setting the oldTouch array to the contents of the current newTouch array
	for i = 1 to 20
		oldTouch[i] = newTouch[i]
	next i
	oldTouch.sort()
	
	for i = 1 to 20
		oldY[i] = GetRawTouchCurrentY(oldTouch[i])
	next i
	
endfunction

function GetMulitouchPressedButton(spr)
	result = 0
	
	for i = 1 to currentTouch.length
		x = GetRawTouchCurrentX(currentTouch[i])
		y = GetRawTouchCurrentY(currentTouch[i])		
		if GetSpriteHitTest(spr, x, y) then result = 1
	next i
	
endfunction result

//These top and bottom functions are probably used more for this project only, but they can stay
function GetMultitouchPressedTop()
	result = 0
	
	for i = 1 to currentTouch.length
		y = GetRawTouchCurrentY(currentTouch[i])		
		if y < h/2 then result = 1
	next i
	
	if deviceType = DESKTOP and GetPointerPressed() and GetPointerY() < h/2 then result = 1
	
endfunction result

function GetMultitouchPressedBottom()
	result = 0
	
	for i = 1 to currentTouch.length
		y = GetRawTouchCurrentY(currentTouch[i])		
		if y > h/2 then result = 1
	next i
	
	if deviceType = DESKTOP and GetPointerPressed() and GetPointerY() > h/2 then result = 1
	
	
endfunction result

//For the character selection
function GetMultitouchPressedTopLeft()
	result = 0
	
	for i = 1 to currentTouch.length
		x = GetRawTouchCurrentX(currentTouch[i])	
		y = GetRawTouchCurrentY(currentTouch[i])		
		if x < w/4 and y < h/2 then result = 1
	next i
	
endfunction result

//For the character selection
function GetMultitouchPressedTopRight()
	result = 0
	
	for i = 1 to currentTouch.length
		x = GetRawTouchCurrentX(currentTouch[i])	
		y = GetRawTouchCurrentY(currentTouch[i])		
		if x > w*3/4 and y < h/2 then result = 1
	next i
	
endfunction result

//For the character selection
function GetMultitouchPressedBottomLeft()
	result = 0
	
	for i = 1 to currentTouch.length
		x = GetRawTouchCurrentX(currentTouch[i])	
		y = GetRawTouchCurrentY(currentTouch[i])		
		if x < w/4 and y > h/2 then result = 1
	next i
	
endfunction result

//For the character selection
function GetMultitouchPressedBottomRight()
	result = 0
	
	for i = 1 to currentTouch.length
		x = GetRawTouchCurrentX(currentTouch[i])	
		y = GetRawTouchCurrentY(currentTouch[i])		
		if x > w*3/4 and y > h/2 then result = 1
	next i
	
endfunction result

function ButtonMultitouchEnabled(spr)
	if GetSpriteExists(spr)
	    if (Button(spr) and (GetPointerPressed() or inputSelect or inputSelect2) and deviceType = DESKTOP) or (GetMulitouchPressedButton(spr) and deviceType = MOBILE)
	        returnValue = 1
	        if GetTextExists(TXT_POPUP)
	        	if GetTextString(TXT_POPUP) <> "" then ClearPopup1()
	        endif
	        if GetTextExists(TXT_POPUP_2)
	        	if GetTextString(TXT_POPUP_2) <> "" then ClearPopup2()
	        endif
	    else
	        returnValue = 0
	    endif
	else
		returnValue = 0
	endif
endfunction returnValue

function ClearMultiTouch()
	//Clearing the currentTouch array to reset it for this frame
	for j = 1 to 2
		for i = 1 to currentTouch.length
			currentTouch.remove()
		next
		currentTouch.length = 0
		
		SyncG()
		ProcessMultitouch()
	next j
endfunction

function PlaySoundR(sound, vol)
	if GetSoundExists(sound) or GetMusicExistsOGG(sound)
		if GetDeviceBaseName() <> "android"
			//The normal case, for normal devices
			PlaySound(sound, vol*volumeSE/100.0)
		else
			//The strange case for WEIRD and PSYCHO android devices
			PlayMusicOGG(sound, 0)
			SetMusicVolumeOGG(sound, volumeSE)
		endif
	endif
	
endfunction

function GetSoundPlayingR(sound)
	result = 0
	
	if GetSoundExists(sound) or GetMusicExistsOGG(sound)
		if GetDeviceBaseName() <> "android"
			//The normal case, for normal devices
			result = GetSoundInstances(sound)
		else
			//The strange case for WEIRD and PSYCHO android devices
			result = GetMusicPlayingOGGSP(sound)
		endif
	endif
	
endfunction result

function GetMusicPlayingOGGSP(songID)
	exist = 0
	exist = GetMusicExistsOGG(songID)
	if exist
		exist = GetMusicPlayingOGG(songID)
	endif
endfunction exist

function StopMusicOGGSP(songID)

	if GetMusicExistsOGG(songID)
		StopMusicOGG(songID)
		DeleteMusicOGG(songID)
	endif

endfunction

function ArrayFind(array as integer[], var)
	index = -1
	for i = 0 to array.length
		if array[i] = var then index = i
	next i
endfunction index

function LoadImageR(txt$)
	img = 0
	if GetFileExists(txt$) then img = LoadImage(txt$)
endfunction img

function LoadImageResizedR(txt$, scale#)
	img = 0
	if GetFileExists(txt$) then img = LoadImageResized(txt$, scale#, scale#, 0)
endfunction img

function LoadImageR2(index, txt$)
	if GetFileExists(txt$) then index = LoadImage(txt$)
endfunction

function SetSpriteColorRandomBright(spr)
	//Recoloring!
	r = 0
	g = 0
	b = 0
	r1 = Random(1, 3)
	r2 = Random(1, 2)
	r3 = Random(0, 255)
	if r1 = 1	//Red based
		r =  255
		if r2 = 1 then g = r3
		if r2 = 2 then b = r3
	elseif r1 = 2	//Blue based
		b =  255
		if r2 = 1 then r = r3
		if r2 = 2 then g = r3
	else	//Green based
		g =  255
		if r2 = 1 then r = r3
		if r2 = 2 then b = r3
	endif
	SetSpriteColorRed(spr, r)
	SetSpriteColorGreen(spr, g)
	SetSpriteColorBlue(spr, b)
	
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

function SetTextColorByCycle(txt, numOf360)
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
	SetTextColor(txt, r, g, b, GetTextColorAlpha(txt))
	
	DeleteSprite(tmpSpr)
endfunction

function GetColorByCycle(numOf360, rgb$)
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
	
	result = 0
	//The -255 is a remnant from SPA, to keep the color changing the same, this can be removed if desired
	if rgb$ = "r" then result = 255-GetSpriteColorRed(tmpSpr)
	if rgb$ = "g" then result = 255-GetSpriteColorGreen(tmpSpr)
	if rgb$ = "b" then result = 255-GetSpriteColorBlue(tmpSpr)
	DeleteSprite(tmpSpr)
endfunction result

function SetSpriteColorByCycleA(spr, numOf360)
	//Make sure the cycleLength is divisible by 6!
	cycleLength = 360
	colorTime = Mod(numOf360*3, 360)
	phaseLen = cycleLength/2
	
	tmpSpr = CreateSprite(0)
	
	//Each colorphase will last for one phaseLen
	if colorTime <= phaseLen	//Red -> Black
		t = colorTime
		SetSpriteColor(tmpSpr, (t*255.0)/phaseLen, 0, 0, 255)
		
	else //Black -> Red
		t = colorTime-phaseLen
		SetSpriteColor(tmpSpr, 255-(t*255.0)/phaseLen, 0, 0, 255)
	endif
	
	r = GetSpriteColorRed(tmpSpr)
	SetSpriteColor(spr, r, 0, 0, GetSpriteColorAlpha(spr))
	
	DeleteSprite(tmpSpr)
endfunction

function SetSpriteColorByCycleB(spr, numOf360)
	//Make sure the cycleLength is divisible by 6!
	cycleLength = 360
	colorTime = Mod(numOf360*3, 360)
	phaseLen = cycleLength/2
	
	tmpSpr = CreateSprite(0)
	
	//Each colorphase will last for one phaseLen
	if colorTime <= phaseLen	//Cyan -> Blue
		t = colorTime
		SetSpriteColor(tmpSpr, 0, (t*255.0)/phaseLen, 255, 255)
		
	else //Blue -> Cyan
		t = colorTime-phaseLen
		SetSpriteColor(tmpSpr, 0, 255-(t*255.0)/phaseLen, 255, 255)
	endif
	
	g = GetSpriteColorGreen(tmpSpr)
	SetSpriteColor(spr, 0, g, 255, GetSpriteColorAlpha(spr))
	
	DeleteSprite(tmpSpr)
endfunction

function SetSpriteColorByCycleC(spr, numOf360)
	//Make sure the cycleLength is divisible by 6!
	cycleLength = 360
	colorTime = Mod(numOf360*3, 360)
	phaseLen = cycleLength/2
	
	tmpSpr = CreateSprite(0)
	
	//Each colorphase will last for one phaseLen
	if colorTime <= phaseLen	//White -> Yelow
		t = colorTime
		SetSpriteColor(tmpSpr, 255, 255, (t*255.0)/phaseLen, 255)
		
	else //Yellow -> White
		t = colorTime-phaseLen
		SetSpriteColor(tmpSpr, 255, 255, 255-(t*255.0)/phaseLen, 255)
	endif
	
	b = GetSpriteColorBlue(tmpSpr)
	SetSpriteColor(spr, 255, 255, b, GetSpriteColorAlpha(spr))
	
	DeleteSprite(tmpSpr)
endfunction



global pingList as Integer[0]
global pingNum = 701
#constant pingStart 701
#constant pingEnd 750
//Ping sprites - 501 through 550

function Ping(x, y, size)
	spr = 0
	for i = pingStart to pingEnd
		if GetSpriteExists(i) = 0
			spr = i
			i = pingEnd + 1
		endif
	next i

	if spr <> 0
		CreateSprite(spr, meteorGlowI)
		SetSpriteSizeSquare(spr, size)
		SetSpritePosition(spr, x - GetSpriteWidth(spr)/2, y - GetSpriteHeight(spr)/2)
		SetSpriteDepth(spr, 50)
	endif

endfunction

function PingColor(x, y, size, red, green, blue, depth)
	spr = 0
	for i = pingStart to pingEnd
		if GetSpriteExists(i) = 0
			spr = i
			i = pingEnd + 1
		endif
	next i

	if spr <> 0
		CreateSprite(spr, meteorGlowI)
		SetSpriteSizeSquare(spr, size)
		SetSpritePosition(spr, x - GetSpriteWidth(spr)/2, y - GetSpriteHeight(spr)/2)
		SetSpriteColor(spr, red, green, blue, 255)
		SetSpriteDepth(spr, depth)
	endif

endfunction

function PingCrab(x, y, size)
	spr = 0
	for i = pingStart to pingEnd
		if GetSpriteExists(i) = 0
			spr = i
			i = pingEnd + 1
		endif
	next i

	if spr <> 0
		CreateSprite(spr, crabpingI)
		SetSpriteSizeSquare(spr, size)
		SetSpriteAngle(spr, Random(1, 360))
		SetSpritePosition(spr, x - GetSpriteWidth(spr)/2, y - GetSpriteHeight(spr)/2)
		SetSpriteDepth(spr, 50)
	endif
	
	rnd = Random(0, 4)
	PlaySoundR(exp1S + rnd, 40/10)

endfunction

function PingFF()
	
	SetFolder("/media")
	
	spr = 0
	for i = pingStart to pingEnd
		if GetSpriteExists(i) = 0
			spr = i
			i = pingEnd + 1
		endif
	next i

	if spr <> 0
		LoadSprite(spr, "ff.png")
		SetSpriteSizeSquare(spr, 150)
		SetSpriteMiddleScreenX(spr)
		SetSpriteY(spr, h*3/4 - GetSpriteHeight(spr)/2)
		if dispH then SetSpriteMiddleScreenY(spr)
		SetSpriteDepth(spr, 1)
		SetSpriteColorAlpha(spr, 180)
	endif
	
	//For the top screen
	if dispH = 0
		spr = 0
		for i = pingStart to pingEnd
			if GetSpriteExists(i) = 0
				spr = i
				i = pingEnd + 1
			endif
		next i
	
		if spr <> 0
			LoadSprite(spr, "ff.png")
			SetSpriteSizeSquare(spr, 150)
			SetSpriteMiddleScreenX(spr)
			SetSpriteY(spr, h/4 - GetSpriteHeight(spr)/2)
			SetSpriteAngle(spr, 180)
			SetSpriteDepth(spr, 1)
			SetSpriteColorAlpha(spr, 180)
		endif
	endif
	
	rnd = Random(0, 4)
	PlaySoundR(exp1S + rnd, 40/10)

endfunction

function PingUpdate()
	speed# = 6
	for i = pingStart to pingEnd
		if GetSpriteExists(i)
			IncSpriteColorAlpha(i, -speed#*fpsr#)
			if GetSpriteColorAlpha(i) <= 10 then DeleteSprite(i)
		endif
	next i

endfunction

global buttons as Integer[0]
global tweenButton = 15
global tweenButtonOld = 16
//tweenButton lasts until 35
function ButtonsUpdate()
	for i = 0 to buttons.length
		if GetSpriteExists(buttons[i])
			spr = buttons[i]
			if (GetMulitouchPressedButton(spr) or Button(spr)) and GetSpriteVisible(spr) and spr < SPR_CS_CRABS_1
				
				//Skips the current tween on an existing sprite, if still playing
				skip = 0
				for i = 15 to 35
					if GetTweenSpritePlaying(i, spr) then skip = 1
					if spr >= SPR_CS_CRABS_1 then skip = 1
				next i
				
				if settingsActive = 0 or (spr >= 802 and spr <= 900)
					//The case for playing the tween
					//The sound logic makes sure that
					if skip = 0
						if GetTweenExists(tweenButton) = 0 then CreateTweenSprite(tweenButton, .3)
						//GetTween
						impact# = 1.2
						SetTweenSpriteSizeX(tweenButton, GetSpriteWidth(spr)*impact#, GetSpriteWidth(spr), TweenOvershoot())
						SetTweenSpriteSizeY(tweenButton, GetSpriteHeight(spr)*impact#, GetSpriteHeight(spr), TweenOvershoot())
						SetTweenSpriteX(tweenButton, GetSpriteMiddleX(spr)-(GetSpriteWidth(spr)*impact#)/2, GetSpriteX(spr), TweenOvershoot())
						SetTweenSpriteY(tweenButton, GetSpriteMiddleY(spr)-(GetSpriteHeight(spr)*impact#)/2, GetSpriteY(spr), TweenOvershoot())
						PlayTweenSprite(tweenButton, spr, 0)
						
						tweenButtonOld = tweenButton
						inc tweenButton, 1
						if tweenButton > 35 then tweenButton = 15
						
						//if appState <> CHARACTER_SELECT then PlaySoundR(buttonSound, 100)
						PlaySoundR(buttonSound, 100)
					else
						//if GetSoundPlayingR(buttonSound) = 0 and appState <> CHARACTER_SELECT then PlaySoundR(buttonSound, 100)
						if GetSoundPlayingR(buttonSound) = 0 then PlaySoundR(buttonSound, 100)
					endif
				endif
				
			endif
			
		endif
	next i
endfunction

function AddButton(spr)
	//buttons.sort()
	index = buttons.find(spr)
	if index = -1
		buttons.insertsorted(spr)
	endif
	
endfunction

function RemoveButton(spr)
buttons.sort()
	index = buttons.find(spr)
	if index <> -1
		buttons.remove(index)
	endif
	
endfunction

function SetTweenPulse(twn, spr, impact#)
	SetTweenSpriteSizeX(twn, GetSpriteWidth(spr)*impact#, GetSpriteWidth(spr), TweenOvershoot())
	SetTweenSpriteSizeY(twn, GetSpriteHeight(spr)*impact#, GetSpriteHeight(spr), TweenOvershoot())
	SetTweenSpriteX(twn, GetSpriteMiddleX(spr)-(GetSpriteWidth(spr)*impact#)/2, GetSpriteX(spr), TweenOvershoot())
	SetTweenSpriteY(twn, GetSpriteMiddleY(spr)-(GetSpriteHeight(spr)*impact#)/2, GetSpriteY(spr), TweenOvershoot())
	
endfunction
