// File: settings.agc
// Created: 24-05-09

//Settings range: 801-900

#constant SPR_SETTINGS 801

#constant SPR_VOLUME 802
#constant SPR_VOLUME_SLIDER 803
#constant SPR_VOLUMES 804
#constant SPR_VOLUMES_SLIDER 805

#constant SPRS_CONTROLS 806
#constant SPRS_EXIT 807



#constant SPRS_BG 899
#constant settingDepth 1

global settingsActive = 0

function StartSettings()
	
	settingsActive = 1
	
	if GetSpriteExists(SPRS_BG) = 0
		CreateSpriteExpressImage(SPRS_BG, bg6I, w*2, w*2, 0, 0, settingDepth)
		if dispH then SetSpriteSizeSquare(SPRS_BG, h*2)
		SetSpriteMiddleScreen(SPRS_BG)
		SetSpriteColorAlpha(SPRS_BG, 0)
	endif
	
	SetFolder("/media/ui")
	
	CreateSpriteExpress(SPRS_CONTROLS, 100, 100, 100, 100, settingDepth)
	
	LoadSpriteExpress(SPRS_EXIT, "back8.png", 100, 100, 200, 100, settingDepth)
	SetSpriteMiddleScreen(SPRS_EXIT)
	//IncSprite
	
	
	LoadSpriteExpress(SPR_VOLUME, "volume.png", 300, 87, 0, 0, settingDepth)
	LoadSpriteExpress(SPR_VOLUME_SLIDER, "volumeslider.png", 300, 87, 0, 0, settingDepth)
	AddButton(SPR_VOLUME)
	
	myX = Min(Max(GetPointerX(), 875), 1045)
	SetSpriteX(SPR_VOLUME_SLIDER, (875 + volumeM*(1045.0-875)/100) -87*3)
	
	SetSpriteExpress(SPR_VOLUME, 300, 87, 780, 580, settingDepth)
	SetSpriteExpress(SPR_VOLUME_SLIDER, 300, 87, 780, 580, settingDepth)
	
	PlayTweenSprite(tweenSprFadeIn, SPRS_BG, 0)
	PlayTweenSprite(tweenSprFadeIn, SPRS_CONTROLS, 0)
	PlayTweenSprite(tweenSprFadeIn, SPRS_EXIT, 0)
	
		
	
	
	stayIn = 1	
	while stayIn
		stayIn = LoopSettings()
		SyncG()
	endwhile
	
	EndSettings()
	
endfunction


function LoopSettings()
	stayIn = 1
	
	DoInputs()
	ProcessPopup()
	if ButtonMultitouchEnabled(SPRS_CONTROLS)
		if spType = 0
			Popup(1, -1)
			Popup(2, -1)
		else
			Popup(MIDDLE, -1)
		endif
	endif
	
	
	
	
	//875 to 1045
	if Hover(SPR_VOLUME) and GetPointerState()
		myX = Min(Max(GetPointerX(), 875), 1045)
		SetSpriteX(SPR_VOLUME_SLIDER, myX-87*3)
		
		volumeM = (myX-875)*100/(1045-875)
		SetMusicVolumeOGG(titleMusic, volumeM)
		volumeSE = (myX-875)*100.0/(1045-875)
	endif
	
	if ButtonMultitouchEnabled(SPR_VOLUME) and GetPointerState() = 0
		if volumeM = 0
			volumeM = 100
			volumeSE = 100
			SetSpriteX(SPR_VOLUME_SLIDER, 1045-87*3)
		elseif volumeM < 26
			volumeM = 0
			volumeSE = 0
			SetSpriteX(SPR_VOLUME_SLIDER, 875-87*3)
		elseif volumeM < 51
			volumeM = 25
			volumeSE = 25
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.25 -87*3)
		elseif volumeM < 76
			volumeM = 50
			volumeSE = 50
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.5 -87*3)
		else
			volumeM = 75
			volumeSE = 75
			SetSpriteX(SPR_VOLUME_SLIDER, 875 + (1045-875)*.75 -87*3)
		endif
		SetMusicVolumeOGG(titleMusic, volumeM)
	endif
	
	
	
	if ButtonMultitouchEnabled(SPRS_EXIT) or inputExit
		stayIn = 0
	endif
	
endfunction stayIn

function EndSettings()
	if GetSpriteExists(SPR_POPUP_BG) then DeletePopup1()
	if GetSpriteExists(SPR_POPUP_BG_2) then DeletePopup2()
	
	for i = 802 to 898
		if GetTextExists(i) then DeleteText(i)
		if GetSpriteExists(i) then DeleteSprite(i)
	next i
	
	PlayTweenSprite(tweenSprFadeOutFull, SPRS_BG, 0)
	
	
	
	settingsActive = 0
	
endfunction