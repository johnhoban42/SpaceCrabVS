// File: settings.agc
// Created: 24-05-09

//Settings range: 801-900

#constant SPR_CONTROLS 800 //(this one doesn't quite belong here, but it's here for the ride)
#constant SPR_SETTINGS 208

#constant SPR_VOLUME 822
#constant SPR_VOLUME_SLIDER 823
#constant SPR_VOLUMES 824
#constant SPR_VOLUMES_SLIDER 825

#constant SPRS_CONTROLS 806
#constant SPRS_EXIT 807

#constant TXTS_SETTINGS 802

#constant SPRS_FRAMEDOWN 811
#constant SPRS_FRAMEUP 812
#constant TXTS_FRAME 811
#constant TXTS_FRAMECUR 812

#constant SPRS_WINDOWN 816
#constant SPRS_WINUP 817
#constant TXTS_WINDOW 816
#constant TXTS_WINCUR 817

#constant SPRS_BG 899
#constant settingDepth 1

global settingsActive = 0
#constant sliderRange 166
#constant knobOff 260
global fpsChunk as integer[5]
fpsChunk[1] = 15
fpsChunk[2] = 30
fpsChunk[3] = 60
fpsChunk[4] = 144
fpsChunk[5] = 0


function StartSettings()
	
	settingsActive = 1
	
	
	
	if GetSpriteExists(SPRS_BG) = 0
		CreateSpriteExpressImage(SPRS_BG, bg6I, w*2, w*2, 0, 0, settingDepth)
		if dispH then SetSpriteSizeSquare(SPRS_BG, h*2)
		SetSpriteMiddleScreen(SPRS_BG)
		SetSpriteColorAlpha(SPRS_BG, 0)
	endif
	
	CreateTextExpress(TXTS_SETTINGS, "SETTINGS", 130, fontCrabI, 1, w/2, 150, settingDepth)
	SetTextColor(TXTS_SETTINGS, 0, 0, 0, 255)
	SetTextSpacing(TXTS_SETTINGS, -40)
	if dispH then SetTextExpress(TXTS_SETTINGS, "SETTINGS", 100, fontCrabI, 1, w/2, 50, settingDepth, -31)
	
	SetFolder("/media/ui")
		
	LoadSpriteExpress(SPRS_EXIT, "back8.png", 180, 180, w-230, 0, settingDepth)
	SetSpriteMiddleScreenY(SPRS_EXIT)
	IncSpriteY(SPRS_EXIT, 100)
	AddButton(SPRS_EXIT)
	
	//Music volume
	LoadSpriteExpress(SPR_VOLUME, "volume.png", 300, 87, w/2 - 150 - 190, GetTextY(TXTS_SETTINGS)+240-40*dispH, settingDepth)
	LoadSpriteExpress(SPR_VOLUME_SLIDER, "volumeslider.png", 300, 87, GetSpriteX(SPR_VOLUME)+sliderRange*volumeM/100.0-sliderRange, GetSpriteY(SPR_VOLUME), settingDepth)
	AddButton(SPR_VOLUME)
	
	CreateTextExpress(SPR_VOLUME, "Music Volume", 65, fontDescI, 1, GetSpriteMiddleX(SPR_VOLUME), GetSpriteY(SPR_VOLUME)-80, settingDepth)
	SetTextColor(SPR_VOLUME, 0, 0, 0, 255)
	SetTextSpacing(SPR_VOLUME, -20)
	
	//Sound effects volume
	LoadSpriteExpress(SPR_VOLUMES, "volume.png", 300, 87, w/2 - 150 + 190, GetTextY(TXTS_SETTINGS)+240-40*dispH, settingDepth)
	LoadSpriteExpress(SPR_VOLUMES_SLIDER, "volumeslider.png", 300, 87, GetSpriteX(SPR_VOLUMES)+sliderRange*volumeSE/100.0-sliderRange, GetSpriteY(SPR_VOLUMES), settingDepth)
	AddButton(SPR_VOLUMES)
	
	CreateTextExpress(SPR_VOLUMES, "Sound Volume", 65, fontDescI, 1, GetSpriteMiddleX(SPR_VOLUMES), GetSpriteY(SPR_VOLUMES)-80, settingDepth)
	SetTextColor(SPR_VOLUMES, 0, 0, 0, 255)
	SetTextSpacing(SPR_VOLUMES, -20)
	
	if dispH = 0 then IncTextY(TXTS_SETTINGS, -35)

		
	lrSize = 70
	
	fpsChunk[1] = 15
	fpsChunk[2] = 30
	fpsChunk[3] = 60
	fpsChunk[4] = 144
	fpsChunk[5] = 0
	
	LoadAnimatedSprite(SPRS_FRAMEDOWN, "lr", 22)
	SetSpriteExpress(SPRS_FRAMEDOWN, lrSize, lrSize, w/2+10, GetSpriteY(SPR_VOLUME)+170, settingDepth) 
	PlaySprite(SPRS_FRAMEDOWN, 13, 1, 1, 22)
	SetSpriteAngle(SPRS_FRAMEDOWN, 180)
	AddButton(SPRS_FRAMEDOWN)
	
	CreateSpriteExistingAnimation(SPRS_FRAMEUP, SPRS_FRAMEDOWN)
	SetSpriteExpress(SPRS_FRAMEUP, lrSize, lrSize, GetSpriteX(SPRS_FRAMEDOWN) + 200, GetSpriteY(SPRS_FRAMEDOWN), settingDepth) 
	PlaySprite(SPRS_FRAMEUP, 14, 1, 1, 22)
	AddButton(SPRS_FRAMEUP)
	
	CreateTextExpress(TXTS_FRAME, "Frame Rate", 64, fontDescI, 2, GetSpriteX(SPRS_FRAMEDOWN)-40, GetSpriteY(SPRS_FRAMEDOWN)-2, settingDepth)
	SetTextColor(TXTS_FRAME, 0, 0, 0, 255)
	SetTextSpacing(TXTS_FRAME, -19)

	CreateTextExpress(TXTS_FRAMECUR, str(fpsChunk[targetFPS]), 64, fontDescI, 1, (GetSpriteMiddleX(SPRS_FRAMEDOWN)+GetSpriteMiddleX(SPRS_FRAMEUP))/2, GetTextY(TXTS_FRAME), settingDepth)
	SetTextColor(TXTS_FRAMECUR, 0, 0, 0, 255)
	SetTextSpacing(TXTS_FRAMECUR, -18)
	if targetFPS = 5 then SetTextString(TXTS_FRAMECUR, "MAX")
	
	
	CreateSpriteExistingAnimation(SPRS_WINDOWN, SPRS_FRAMEDOWN)
	SetSpriteExpress(SPRS_WINDOWN, lrSize, lrSize, w/2-20, GetSpriteY(SPRS_FRAMEDOWN)+140, settingDepth) 
	PlaySprite(SPRS_WINDOWN, 12, 1, 1, 22)
	SetSpriteAngle(SPRS_WINDOWN, 180)
	AddButton(SPRS_WINDOWN)
	
	CreateSpriteExistingAnimation(SPRS_WINUP, SPRS_FRAMEDOWN)
	SetSpriteExpress(SPRS_WINUP, lrSize, lrSize, GetSpriteX(SPRS_WINDOWN) + 260, GetSpriteY(SPRS_WINDOWN), settingDepth) 
	PlaySprite(SPRS_WINUP, 15, 1, 1, 22)
	AddButton(SPRS_WINUP)
	
	CreateTextExpress(TXTS_WINDOW, "Window Size", 64, fontDescI, 2, GetSpriteX(SPRS_WINDOWN)-40, GetSpriteY(SPRS_WINDOWN)-2, settingDepth)
	SetTextColor(TXTS_WINDOW, 0, 0, 0, 255)
	SetTextSpacing(TXTS_WINDOW, -19)

	CreateTextExpress(TXTS_WINCUR, str(fpsChunk[targetFPS]), 45, fontDescI, 1, (GetSpriteMiddleX(SPRS_WINDOWN)+GetSpriteMiddleX(SPRS_WINUP))/2, GetTextY(SPRS_WINDOWN)+12, settingDepth)
	SetTextColor(TXTS_WINCUR, 0, 0, 0, 255)
	SetTextSpacing(TXTS_WINCUR, -14)
	if windowSize = 1 then SetTextString(TXTS_WINCUR, "720x1280")
	if windowSize = 2 then SetTextString(TXTS_WINCUR, "1920x1080")
	if windowSize = 3 then SetTextString(TXTS_WINCUR, "Full Screen")
	
	
	LoadSpriteExpress(SPRS_CONTROLS, "controls.png", 300, 165, w/2-160, GetSpriteY(SPRS_EXIT)-140, settingDepth)
	AddButton(SPRS_CONTROLS)


	PlayTweenSprite(tweenSprFadeIn, SPRS_BG, 0)
	PlayTweenSprite(tweenSprFadeIn, SPRS_CONTROLS, 0)
	PlayTweenSprite(tweenSprFadeIn, SPRS_EXIT, 0)
	PlayTweenSprite(tweenSprFadeIn, SPR_VOLUME, 0)
	PlayTweenSprite(tweenSprFadeIn, SPR_VOLUME_SLIDER, 0)
	PlayTweenSprite(tweenSprFadeIn, SPR_VOLUMES, 0)
	PlayTweenSprite(tweenSprFadeIn, SPR_VOLUMES_SLIDER, 0)
	PlayTweenText(tweenTxtFadeIn, TXTS_SETTINGS, 0)
	PlayTweenText(tweenTxtFadeIn, SPR_VOLUME, 0)
	PlayTweenText(tweenTxtFadeIn, SPR_VOLUMES, 0)
	
	if onWeb or dispH = 0
		//Increment the size settings by 999
		IncSpriteY(SPRS_WINDOWN, 9999)
		IncSpriteY(SPRS_WINUP, 9999)
		IncTextY(TXTS_WINCUR, 9999)
		IncTextY(TXTS_WINDOW, 9999)
	endif
	if dispH
		IncSpriteY(SPRS_CONTROLS, 9999)
		SetSpriteExpress(SPRS_EXIT, 130, 130, w-180, h-180, settingDepth)
	endif
	
	DeletePopup1()
	DeletePopup2()
	
	for i = SPR_SELECT1 to SPR_SELECT4
		if GetSpriteExists(i)
			DeleteSprite(i)
			DeleteTween(i)
		endif
	next i
	CreateSelectButtons()
	
	stayIn = 1	
	while stayIn
		stayIn = LoopSettings()
		SyncG()
	endwhile
	
	SaveGame()
	
	EndSettings()
	
endfunction


function LoopSettings()
	stayIn = 1
	
	
	ProcessMultitouch()
	DoInputs()
	if inputLeft or inputRight or inputUp or inputDown then MoveSelect()
	ProcessPopup()
	if ButtonMultitouchEnabled(SPRS_CONTROLS)
		if dispH = 0
			Popup(1, -1)
		elseif spType = 0 and appState <> START
			Popup(1, -1)
			Popup(2, -1)
		else
			Popup(MIDDLE, -1)
		endif
	endif
	
	//Music volume
	if Hover(SPR_VOLUME) and GetPointerState()
		//myX = Min(Max(GetPointerX(), 875), 1045)
		myX = Min(Max(GetPointerX(), GetSpriteX(SPR_VOLUME)-sliderRange + knobOff), GetSpriteX(SPR_VOLUME) + knobOff)
		SetSpriteX(SPR_VOLUME_SLIDER, myX-knobOff)
		
		volumeM = (myX-(GetSpriteX(SPR_VOLUME)-sliderRange + knobOff))*100/(sliderRange*1.0)
		for i = 101 to 300
			if GetMusicPlayingOGGSP(i) then SetMusicVolumeOGG(i, volumeM)
		next i
	endif
	
	if ButtonMultitouchEnabled(SPR_VOLUME) and GetPointerState() = 0
		if volumeM = 0
			volumeM = 100
			SetSpriteX(SPR_VOLUME_SLIDER, GetSpriteX(SPR_VOLUME))
		elseif volumeM < 26
			volumeM = 0
			SetSpriteX(SPR_VOLUME_SLIDER, GetSpriteX(SPR_VOLUME)-sliderRange)//875-87*3)
		elseif volumeM < 51
			volumeM = 25
			SetSpriteX(SPR_VOLUME_SLIDER, GetSpriteX(SPR_VOLUME)-sliderRange*3/4)
		elseif volumeM < 76
			volumeM = 50
			SetSpriteX(SPR_VOLUME_SLIDER, GetSpriteX(SPR_VOLUME)-sliderRange/2)
		else
			volumeM = 75
			SetSpriteX(SPR_VOLUME_SLIDER, GetSpriteX(SPR_VOLUME)-sliderRange/4)
		endif
		for i = 101 to 300
			if GetMusicPlayingOGGSP(i) then SetMusicVolumeOGG(i, volumeM)
		next i
	endif
	
	
	//Sound effects volume
	if Hover(SPR_VOLUMES) and GetPointerState()
		myX = Min(Max(GetPointerX(), GetSpriteX(SPR_VOLUMES)-sliderRange + knobOff), GetSpriteX(SPR_VOLUMES) + knobOff)
		SetSpriteX(SPR_VOLUMES_SLIDER, myX-knobOff)		
		volumeSE = (myX-(GetSpriteX(SPR_VOLUMES)-sliderRange + knobOff))*100/(sliderRange*1.0)
		
	endif
	if GetPointerReleased() and Hover(SPR_VOLUMES) then PlaySoundR(turnS, 100)
	
	
	if ButtonMultitouchEnabled(SPR_VOLUMES) and GetPointerState() = 0
		if volumeSE = 0
			volumeSE = 100
			SetSpriteX(SPR_VOLUMES_SLIDER, GetSpriteX(SPR_VOLUMES))
		elseif volumeSE < 26
			volumeSE = 0
			SetSpriteX(SPR_VOLUMES_SLIDER, GetSpriteX(SPR_VOLUMES)-sliderRange)
		elseif volumeSE < 51
			volumeSE = 25
			SetSpriteX(SPR_VOLUMES_SLIDER, GetSpriteX(SPR_VOLUMES)-sliderRange*3/4)
		elseif volumeSE < 76
			volumeSE = 50
			SetSpriteX(SPR_VOLUMES_SLIDER, GetSpriteX(SPR_VOLUMES)-sliderRange/2)
		else
			volumeSE = 75
			SetSpriteX(SPR_VOLUMES_SLIDER, GetSpriteX(SPR_VOLUMES)-sliderRange/4)
		endif
		PlaySoundR(turnS, 100)
	endif
	
	
	if ButtonMultitouchEnabled(SPRS_FRAMEDOWN) then targetFPS = Max(1, targetFPS-1)
	if ButtonMultitouchEnabled(SPRS_FRAMEUP) then targetFPS = Min(5, targetFPS+1)
	
	if ButtonMultitouchEnabled(SPRS_FRAMEUP) or ButtonMultitouchEnabled(SPRS_FRAMEDOWN)
		SetTextString(TXTS_FRAMECUR, Str(fpsChunk[targetFPS]))
		if GetSoundPlayingR(buttonSound) = 0 then PlaySoundR(buttonSound, 100)
		
		if targetFPS = 5
			SetTextString(TXTS_FRAMECUR, "MAX")
			SetVSync(1)
		else
			SetVSync(0)
			SetSyncRate(fpsChunk[targetFPS], 0)
		endif
	endif
	
	
	if ButtonMultitouchEnabled(SPRS_WINDOWN) then windowSize = Max(1, windowSize-1)
	if ButtonMultitouchEnabled(SPRS_WINUP) then windowSize = Min(3, windowSize+1)
	
	if ButtonMultitouchEnabled(SPRS_WINDOWN) or ButtonMultitouchEnabled(SPRS_WINUP)
		if windowSize = 1 then SetTextString(TXTS_WINCUR, "720x1280")
		if windowSize = 2 then SetTextString(TXTS_WINCUR, "1920x1080")
		if windowSize = 3 then SetTextString(TXTS_WINCUR, "Full Screen")
		SetWindowChunkSize(windowSize)
	endif
	
	
	if ButtonMultitouchEnabled(SPRS_EXIT) or inputExit
		inputSelect = 0
		PlaySoundR(fwipS, 100)
		ClearMultiTouch()
		stayIn = 0
	endif
	
endfunction stayIn

function EndSettings()
	if GetSpriteExists(SPR_POPUP_BG) then DeletePopup1()
	if GetSpriteExists(SPR_POPUP_BG_2) then DeletePopup2()
	
	DeleteAnimatedSprite(SPRS_FRAMEDOWN)
	for i = 802 to 898
		if GetTextExists(i) then DeleteText(i)
		if GetSpriteExists(i) then DeleteSprite(i)
	next i
	
	PlayTweenSprite(tweenSprFadeOutFull, SPRS_BG, 0)
	
	TurnOffSelect()
	SaveGame()
	settingsActive = 0
	
endfunction

function SetWindowChunkSize(num)
	if num = 1
		SetWindowSize(1280, 720, 0)
	elseif num = 2
		SetWindowSize(1920, 1080, 0)
	else
		SetWindowSize(1280, 720, 1)
	endif
endfunction