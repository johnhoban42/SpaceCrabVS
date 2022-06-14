//Core functions that are used in the app, and possible future apps
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

function SetSpriteMiddleScreenY(spr)
	SetSpriteY(spr, h/2-GetSpriteHeight(spr)/2)
endfunction

function SetSpriteMiddleScreenOffset(spr, dx, dy)
	SetSpriteMiddleScreen(spr)
	IncSpritePosition(spr, dx, dy)
endfunction

function SetTextMiddleScreen(txt, flip)
	SetTextPosition(txt, w/2-GetTextTotalWidth(txt)/2 + flip*GetTextTotalWidth(txt), h/2-GetTextTotalHeight(txt)/2 + flip*GetTextTotalHeight(txt))
endfunction

function SetTextMiddleScreenX(txt, flip)
	SetTextX(txt, w/2-GetTextTotalWidth(txt)/2 + flip*GetTextTotalWidth(txt))
endfunction

function SetTextMiddleScreenOffset(txt, flip, dx, dy)
	SetTextMiddleScreen(txt, flip)
	SetTextPosition(txt, GetTextX(txt) + dx, GetTextY(txt) + dy)
endfunction

function SetSpriteSizeSquare(spr, size)
	SetSpriteSize(spr, size, size)
endfunction

function Hover(sprite) 
	if GetSpriteExists(sprite) = 0 then exitfunction 0	//Added in to make sure bad buttons aren't targeted
	returnValue = GetSpriteHitTest(sprite, GetPointerX(), GetPointerY())
endfunction returnValue

function Button(sprite) 
	returnValue = GetPointerPressed() and Hover(sprite)
endfunction returnValue

function CreateSpriteExpress(spr, wid, hei, x, y, depth)
	CreateSprite(spr, 0)
	SetSpriteSize(spr, wid, hei)
	SetSpritePosition(spr, x, y)
	SetSpriteDepth(spr, depth)
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

function GlideTextToSpot(txt, x, y, denom)
	
	SetTextPosition(txt, (((GetTextX(txt)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x, (((GetTextY(txt)-y)*((denom-1)^fpsr#))/(denom)^fpsr#)+y)

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

function SnapbackToX(spr, iCur, iEnd, x, dx, denom)
	
	if (iCur < iEnd*3/4)
		//Moving to the farther position
		SetSpriteX(spr, (((GetSpriteX(spr)-(x+dx))*((denom-1)^fpsr#))/(denom)^fpsr#)+(x+dx))
	else
		//Sliding back
		SetSpriteX(spr, (((GetSpriteX(spr)-x)*((denom-1)^fpsr#))/(denom)^fpsr#)+x)
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
	SetSpriteColor(spr, r, g, b, 255)
	
endfunction
