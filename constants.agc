// File: constants.agc
// Created: 22-03-04


/*
Notes:

split - The middle screen bar
crab1 - The bottom crab, independent of it's costume
crab2 - The top crab, independent of it's costume

Depth List:

Pause Screen buttons - 2
Crab - 3
Ninja stars - 4
Planets for Lives - 5
Clock Hands - 6
Clock - 7
EXP - 7
Planets - 8
Pause button - 9
Asteroid belt - 10
Crab during death - 11
Rave Crab Text Sprite - 12
Meteor Marker -14
Exp Bar - 16
Exp Bar Holder - 18
Rave Crab Boarders - 19
Space Ned (during Special) - 19
Meteors - 20
Particle Dust Clouds - 25
Behind image for fast meteors - 30
Background image - 100

Crab types (internal):
1 - Space Crab
2 - Ladder Wizard
3 - Top Crab
4 - Rave Crab
5 - Chrono Crab
6 - Ninja Crab

*/

global inputSelect = 0
global inputExit = 0
global inputLeft = 0
global inputRight = 0
global inputUp = 0
global inputDown = 0
global inputAttack1 = 0
global inputSpecial1 = 0
global inputTurn1 = 0
global inputAttack2 = 0
global inputSpecial2 = 0
global inputTurn2 = 0

//The timer for the starting screen
global startTimer# = 0

//Number of crabs in the game - made a constant in case we add/remove crabs
#constant NUM_CRABS 6

//Gameplay constants & variables
#constant planetSize 220
global metSizeX = 58
global metSizeY = 80

#constant spaceCrabTimeMax 200	//This is just for moving the UFO
#constant topCrabTimeMax 1200
#constant raveCrabTimeMax 900
#constant chronoCrabTimeMax 1900	//Is longer because the timer goes down faster
#constant ninjaCrabTimeMax 500	

#constant specialPrice1 20
#constant specialPrice2 20
#constant specialPrice3 25
#constant specialPrice4 23
#constant specialPrice5 30
#constant specialPrice6 18

#constant frameratecrab1 10
#constant frameratecrab2 13
#constant frameratecrab3 10
#constant frameratecrab4 18
#constant frameratecrab5 10
#constant frameratecrab6 15

#constant lastTranType 2

#constant hitSceneMax 240
global hit1Timer# = 0
global hit2Timer# = 0

global firstFight = 1
global gameTimer# = 0

global gameScale# = 1

global crab1R# = 1
global crab1Rdefault# = 1
global crab1Theta# = 270
global crab1framerate = 10
global crab1Dir# = 1		//Crab dir is a float that goes from 1 to -1, it multiplies the speed
global crab1Vel# = 1.28
global crab1Accel# = .1	//Is .1 because it takes 2 to reach full reversal, and original game timer was 20
global crab1Turning = 0 	//Is zero for when the crab isn't turning, and 1 or -1 depending on the direction it is CHANGING TO
global crab1Type = 2
global crab1Alt = 0
global crab1Str$ = ""
global crab1JumpD# = 0
global crab1JumpHMax# = 5
global crab1JumpSpeed# = 1.216
global crab1JumpDMax = 28	//This variable used to be in degrees, now it's in ticks
//Original jump values: 3.5, 38
//Original jump values: 3.5, 38

global crab1Deaths = 0
global crab1PlanetS as Integer[3]
#constant planetIconSize 60

//For the screen nudging whenever a meteor hits
global nudge1R# = 0
global nudge1Theta# = 0

global crab2R# = 1	//Same constants for crab 2
global crab2Rdefault# = 1
global crab2Theta# = 270
global crab2framerate = 10
global crab2Dir# = 1
global crab2Vel# = 1.28
global crab2Accel# = .1
global crab2Turning = 0
global crab2Type = 1
global crab2Alt = 0
global crab2Str$ = ""
global crab2JumpD# = 0
global crab2JumpHMax# = 5
global crab2JumpSpeed# = 1.216
global crab2JumpDMax = 28	//This variable used to be in degrees, now it's in ticks

global crab2Deaths = 0
global crab2PlanetS as Integer[3]

global nudge2R# = 0
global nudge2Theta# = 0

global crabRefType = 0
global crabRefAlt = 0

global gameDifficulty1 = 1
global gameDifficulty2 = 1
global difficultyBar = 10	//The amount of meteors it takes to make the difficulty go up
global difficultyMax = 7

global meteorTotal1 = 0
global meteorTotal2 = 0

global planet1RotSpeed# = 0
global planet2RotSpeed# = 0
#constant planetSpeedUpRate# = .0032

//global meteorQueue1 as meteor[0]
//global meteorQueue2 as meteor[0]
global meteorActive1 as meteor[0]
global meteorActive2 as meteor[0]

global expTotal1 = 0
global meteorCost1 = 8 //10
global specialCost1 = 20 //40
global specialTimerAgainst2# = 0

global expTotal2 = 0
global meteorCost2 = 8
global specialCost2 = 20
global specialTimerAgainst1# = 0

#constant meteorMult# 1.3
#constant specialMult# 1.8

//The in game check to see if a special has been used once that game
global special1Used = 0
global special2Used = 0

global spScore = 0
global spHighScore = 0
global spHighCrab$ = ""
global spHighScoreClassic = 0
global spHighCrabClassic$ = ""
#constant spScoreMinSize = 70

global p1Ready = 0
global p2Ready = 0

//Input buffers
global buffer1 = 0
global buffer2 = 0

global meteorSprNum = 1001
global expSprNum = 2001
global expList as Integer[0]

//Meteor type, countdown, game screen
global met1CD1# = 50 //300
global met2CD1# = 0 //400
global met3CD1# = 0 //400

global met1CD2# = 50 //300
global met2CD2# = 0 //400
global met3CD2# = 0 //400

#constant gameTimeGate1 600		//Ticks until rotation meteors
#constant gameTimeGate2 1200		//Ticks until fast meteors

#constant met1RNDLow 180		//OG: 230
#constant met1RNDHigh 290	//OG: 330
#constant met2RNDLow 290
#constant met2RNDHigh 390
#constant met3RNDLow 440
#constant met3RNDHigh 640
	
#constant metStartDistance 700

#constant met1speed 3.6	//SC2: 4
#constant met2speed 2.7 //SC2: 3
#constant met3speed 18.0 //SC2: 20
#constant diffMetMod .1 //How fast the meteors will speed up on each difficulty increase
#constant slowMetWidth 25
#constant slowMetSpeedDen 8

//Text Indexes
#constant pauseTitle1 6
#constant pauseTitle2 7
#constant pauseDesc1 8
#constant pauseDesc2 9

#constant storyText 10001
#constant storyText2 10002
#constant storyText3 10003
#constant storyText4 10004
#constant storyFitter 10005


//Sprite Indexes
#constant crab1 1
#constant crab2 2
#constant split 3

#constant bgGame1 4
#constant bgGame2 5
#constant bgHit1 6
#constant bgHit2 7

#constant pauseButton 8
#constant playButton 9
#constant exitButton 10
#constant mainmenuButton 14
#constant phantomPauseButton 15
#constant phantomExitButton 16

//Just a sheet for when things need to be covered up
#constant coverS 11
#constant curtain 12
#constant curtainB 13

#constant SPR_SELECT1 21
#constant SPR_SELECT2 22
#constant SPR_SELECT3 23
#constant SPR_SELECT4 24

#constant planet1 101
#constant planet2 102

#constant expBar1 111
#constant expHolder1 112
#constant meteorButton1 113
#constant meteorMarker1 114
#constant specialButton1 115

//crab1PlanetS[1] = 116
//crab1PlanetS[2] = 117
//crab1PlanetS[3] = 118

#constant expBar2 121
#constant expHolder2 122
#constant meteorButton2 123
#constant meteorMarker2 124
#constant specialButton2 125

//crab2PlanetS[1] = 126
//crab2PlanetS[2] = 127
//crab2PlanetS[3] = 128

#constant specialBG 130
#constant specialSprFront1 131
#constant specialSprBack1 132
#constant specialSprBacker1 135 //Only for Top and Chrono
#constant specialSprFront2 133
#constant specialSprBack2 134
#constant specialSprBacker2 136 //Only for Top and Chrono

//The sprite indexes of extra sprites needed for specials
#constant special1Ex1 141
#constant special1Ex2 142
#constant special1Ex3 143
#constant special1Ex4 144
#constant special1Ex5 145

#constant special2Ex1 146
#constant special2Ex2 147
#constant special2Ex3 148
#constant special2Ex4 149
#constant special2Ex5 150

#constant SPR_SP_SCORE 151
#constant TXT_SP_SCORE 151
#constant TXT_SP_DANGER 154

#constant TXT_INTRO1 152
#constant TXT_INTRO2 153

//Image Indexes

#constant fontSpecialI 1
#constant fontDescI 2	//Tahoma
#constant fontDescItalI 4	//Tahoma (Italicized)
#constant fontCrabI 3	//Somerset Barnyard
#constant fontScoreI 1001	//SnowTunes UI Font

#constant starParticleI 11

//The indexs are reserved, but no constants are needed
#constant crab1select1I 301
#constant crab1select2I 302
#constant crab1select3I 303
#constant crab1select4I 304
#constant crab1select5I 305
#constant crab1select6I 306

#constant crab2select1I 311
#constant crab2select2I 312
#constant crab2select3I 313
#constant crab2select4I 314
#constant crab2select5I 315
#constant crab2select6I 316

#constant crab6select1I 351
#constant crab6select2I 352
#constant crab6select3I 353
#constant crab6select4I 354
#constant crab6select5I 355
#constant crab6select6I 356

#constant crab1life1I 371
#constant crab1life2I 372
#constant crab1life3I 373

#constant crab2life1I 374
#constant crab2life2I 375
#constant crab2life3I 376

#constant crab1attack1I 21
#constant crab2attack1I 22

#constant crab1attack2I 31
#constant crab2attack2I 32

#constant crab1attack3I 41
#constant crab2attack3I 41

#constant expOrbI 60
#constant expBarI1 61
#constant expBarI2 62
#constant expBarI3 63
#constant expBarI4 64
#constant expBarI5 65
#constant expBarI6 66

#constant meteorI1 67
#constant meteorI2 68
#constant meteorI3 69
#constant meteorI4 70
#constant meteorTractorI 71

#constant boarderI 72
#constant ufoI 73
#constant clockI 74
#constant clockMinI 75
#constant clockHourI 76
#constant ninjaStarI 77

#constant bg1I 81
#constant bg2I 82
#constant bg3I 83
#constant bg4I 84
#constant bg5I 85
#constant bgPI 87 	//Pause foreground
#constant bgRainSwipeI 88

#constant meteorGlowI 86

global loadedCrabSprites as Integer[0]

#constant crab1start1I 101
#constant crab1start2I 102
#constant crab1walk1I 103
#constant crab1walk2I 104
#constant crab1walk3I 105
#constant crab1walk4I 106
#constant crab1walk5I 107
#constant crab1walk6I 108
#constant crab1walk7I 109
#constant crab1walk8I 110
#constant crab1jump1I 111
#constant crab1jump2I 112
#constant crab1death1I 113
#constant crab1death2I 114
#constant crab1skid1I 115
#constant crab1skid2I 116
#constant crab1skid3I 117

#constant crab2start1I 121
#constant crab2start2I 122
#constant crab2walk1I 123
#constant crab2walk2I 124
#constant crab2walk3I 125
#constant crab2walk4I 126
#constant crab2walk5I 127
#constant crab2walk6I 128
#constant crab2walk7I 129
#constant crab2walk8I 130
#constant crab2jump1I 131
#constant crab2jump2I 132
#constant crab2death1I 133
#constant crab2death2I 134
#constant crab2skid1I 135
#constant crab2skid2I 136
#constant crab2skid3I 137

#constant special4s1 225
#constant special4s2 226
#constant special4s3 227
#constant special4s4 228
#constant special4s5 229
#constant special4s6 230
#constant special4s7 231
#constant special4s8 232

#constant crabpingI 400

//Planets images are 401 to 430
#constant planetIMax 23
#constant planetITotalMax 29
global planetVarI as Integer[planetITotalMax]

#constant warpI1 431
#constant warpI2 432
#constant warpI3 433
#constant warpI4 434
#constant warpI5 435
#constant warpI6 436
#constant warpI7 437
#constant warpI8 438
#constant warpI9 439
#constant warpI10 440
#constant warpI11 441
#constant warpI12 442
#constant warpI13 443
#constant warpI14 444
#constant warpI15 445
#constant warpI16 446

#constant jumpPartI1 447 //447 - 452
global jumpPartI as Integer[6]

#constant attackPartI 453
#constant attackPartInvertI 454

//FRUITALITY Images
#constant fruit1I 461
#constant fruit2I 462
#constant fruit3I 463
#constant fruit4I 464
#constant fruit5I 465
#constant fruit6I 466
#constant flameI1 467
#constant flameI2 468
#constant flameI3 469
#constant flameI4 470

#constant logoI 471
#constant logoDemoI 472
#constant logoFruitI 473

//#constant planetVar1I 51
//#constant planetVar2I 52
//#constant planetVar3I 53
//#constant planetVar4I 54
//#constant planetVar5I 55
//#constant planetVar6I 56
//#constant planetVar7I 57
//#constant planetVar8I 58

//Particle Indexes
#constant par1met1 1
#constant par1met2 2
#constant par1met3 3
#constant par1spe1 4

#constant par2met1 5
#constant par2met2 6
#constant par2met3 7
#constant par2spe1 8

#constant par1jump 9
#constant par2jump 10

#constant parStar1 11
#constant parStar2 12
#constant parStar3 13

#constant parAttack 21

//Sound Indexes
#constant turnS 1
#constant jump1S 2
#constant jump2S 3
#constant specialS 4
#constant specialExitS 5
#constant explodeS 6
#constant launchS 7
#constant crackS 8
#constant flyingS 9
#constant landingS 10
#constant arrowS 11
#constant chooseS 12
#constant gongS 13
#constant buttonSound 14

#constant exp1S 16
#constant exp2S 17
#constant exp3S 18
#constant exp4S 19
#constant exp5S 20

#constant ufoS 21
#constant wizardSpell1S 22
#constant wizardSpell2S 23
#constant ninjaStarS 24

#constant mirrorBreakS 25
#constant rainbowSweepS 26
#constant fruitS 27
#constant fwipS 28



//Music Indexes
#constant titleMusic 101
#constant characterMusic 102
#constant resultsMusic 103
#constant loserMusic 109

#constant fightAMusic 104	//Andy's fight song
#constant fightBMusic 105	//Brad's fight song
#constant fightJMusic 106	//John's fight song
#constant tutorialMusic 107	//The tutorial song
#constant spMusic 108		//Mirror Music 

#constant dangerAMusic 111
#constant dangerBMusic 112
#constant dangerJMusic 113
#constant dangerCMusic 114

#constant raveBass1 121
#constant raveBass2 122
#constant fireMusic 123

#constant retro1M 131
#constant retro2M 132
#constant retro3M 133
#constant retro4M 134
#constant retro5M 135
#constant retro6M 136
#constant retro7M 137
#constant retro8M 138

global oldSong = 0

//Volume for music and sound effects
global volumeM = 100
global volumeSE = 40

SetMusicSystemVolumeOGG(volumeM)

//Start screen sprites 
#constant SPR_TITLE 200 
#constant SPR_START1 201
#constant SPR_START2 203
#constant SPR_BG_START 202
#constant SPR_START1P 204
#constant TXT_WAIT1 201
#constant TXT_WAIT2 202
#constant TXT_HIGHSCORE 203
#constant TXT_SP_DESC 204
#constant SPR_STARTAI 212
#constant SPR_LOGO_HORIZ 213
#constant SPR_LEADERBOARD 214
#constant SPR_CLASSIC 215
#constant SPR_STORY_START 216
#constant TXT_ALONE 216


//Different Crab buttons for the single player mode
#constant SPR_SP_C1 205
#constant SPR_SP_C2 206
#constant SPR_SP_C3 207
#constant SPR_SP_C4 208
#constant SPR_SP_C5 209
#constant SPR_SP_C6 210
 
//Character select screen sprites - player 1 
#constant SPR_CS_READY_1 300 
#constant SPR_CS_ARROW_L_1 301 
#constant SPR_CS_ARROW_R_1 302 
#constant SPR_CS_BG_1 306
#constant SPR_CS_BG_1B 307
#constant TXT_CS_CRAB_NAME_1 303
#constant TXT_CS_CRAB_DESC_1 304 
#constant TXT_CS_CRAB_STATS_1 306
#constant TXT_CS_READY_1 305 
#constant SPR_CS_CRABS_1 390
#constant SPR_CS_TXT_BACK_1 389

#constant SPR_SCENE1 321 
#constant SPR_SCENE2 322 
#constant SPR_SCENE3 323 
#constant SPR_SCENE4 324 
#constant TXT_SCENE 325

#constant SPR_MENU_BACK 399
 
//Character select screen sprites - player 2
#constant SPR_CS_READY_2 400
#constant SPR_CS_ARROW_L_2 401
#constant SPR_CS_ARROW_R_2 402 
#constant SPR_CS_BG_2 406
#constant SPR_CS_BG_2B 407
#constant TXT_CS_CRAB_NAME_2 403
#constant TXT_CS_CRAB_DESC_2 404 
#constant TXT_CS_CRAB_STATS_2 406
#constant TXT_CS_READY_2 405
#constant SPR_CS_CRABS_2 490 
#constant SPR_CS_TXT_BACK_2 489

//Story Sprites/Text and variable
#constant SPR_TEXT_BOX 601
#constant SPR_TEXT_BOX2 602
#constant SPR_TEXT_BOX3 603
#constant SPR_TEXT_BOX4 604

#constant TXT_LINE 601
#constant TXT_LINE2 602
#constant TXT_LINE3 603
#constant TXT_LINE4 604

#constant TXT_RESULT1 621
#constant TXT_RESULT2 622
#constant TXT_RESULT3 623

#constant SPR_CRAB1_BODY 611
#constant SPR_CRAB1_FACE 612
#constant SPR_CRAB1_COSTUME 613

#constant SPR_CRAB2_BODY 614
#constant SPR_CRAB2_FACE 615
#constant SPR_CRAB2_COSTUME 616



global curChapter = 1
global curScene = 0
global highestScene = 0
global clearedChapter = 0
#constant finalChapter 2
global lineSkipTo = 0
global storyActive = 0
global storyMinScore = 0
global storyRetry = 0
global storyTimer# = 0

//Ping sprites - 701 through 750

//Tweens
#constant selectTweenTime# .4 //In seconds
#constant tweenOffP1 1
#constant tweenOnP1 2
#constant tweenOffP2 3
#constant tweenOnP2 4

//global tweenButton = 5
//tweenButton lasts until 25

#constant tweenFadeLen# .2
#constant tweenSprFadeIn 101
//CreateTweenSprite(tweenSprFadeIn, tweenFadeLen#)
//SetTweenSpriteAlpha(tweenSprFadeIn, 140, 255, TweenSmooth2())
#constant tweenSprFadeOut 102
#constant tweenSprFadeOutFull 105
//CreateTweenSprite(tweenSprFadeOut, tweenFadeLen#)
//SetTweenSpriteAlpha(tweenSprFadeOut, 255, 140, TweenSmooth2())
#constant tweenTxtFadeIn 103
//CreateTweenText(tweenTxtFadeIn, tweenFadeLen#)
//SetTweenTextAlpha(tweenTxtFadeIn, 0, 255, TweenSmooth2())
//#constant tweenTxtFadeOut 104
//CreateTweenText(tweenTxtFadeOut, tweenFadeLen#)
//SetTweenTextAlpha(tweenTxtFadeOut, 255, 0, TweenSmooth2())

// Results screen sprites - player 1
#constant TXT_R_CRAB_MSG_1 = 500
#constant TXT_R_WIN_MSG_1 = 501
#constant SPR_R_CRAB_WIN_1 = 502
#constant SPR_R_CRAB_LOSE_1 = 503

#constant TWN_R_WIN_MSG_1 = 550

#constant SPR_R_REMATCH = 590
#constant SPR_R_CRAB_SELECT = 591
#constant SPR_R_MAIN_MENU = 592
#constant SPR_R_BACKGROUND = 593

// Results screen sprites - player 2
#constant TXT_R_CRAB_MSG_2 = 600
#constant TXT_R_WIN_MSG_2 = 601
#constant SPR_R_CRAB_WIN_2 = 602
#constant SPR_R_CRAB_LOSE_2 = 603

#constant TWN_R_WIN_MSG_2 = 650

// Game states
#constant START 0
#constant CHARACTER_SELECT 1
#constant GAME 2
#constant PAUSE 3
#constant RESULTS 4
#constant STORY 5
#constant SOUNDTEST 6
#constant STATISTICS 7
global spActive = 0 //Single Player active
global aiActive = 0 //VS AI active
global paused = 0	//Game is currently paused
global pauseTimer# = 0
global spType = 0
global fruitMode = 0
#constant MIRRORMODE 1
#constant CLASSIC 2
#constant STORYMODE 3

global fruitUnlock# = -300

#constant glowS 20000
type meteor
	
	spr as integer
	//Backup sprite is this + 10000
	//Glow is this + 20000
	
	cat as integer
	//Category 1 is normal
	//Category 2 is turning
	//Category 3 is fast
	
	//Changing variables
	r as float
	theta as float
	
endtype

function LoadBaseSounds()
	SetFolder("/media/sounds")
	
	if GetDeviceBaseName() <> "android"
		LoadSoundOGG(turnS, "turn.ogg")
		//LoadSoundOGG(jumpS, "jump.ogg")
		LoadSoundOGG(specialS, "special.ogg")
		LoadSoundOGG(specialExitS, "specialExit.ogg")
		LoadSoundOGG(explodeS, "explode.ogg")
		LoadSoundOGG(launchS, "launch.ogg")
		LoadSoundOGG(crackS, "crack.ogg")
		LoadSoundOGG(flyingS, "flying.ogg")
		LoadSoundOGG(landingS, "landing.ogg")
		LoadSoundOGG(arrowS, "arrow.ogg")
		LoadSoundOGG(chooseS, "choose.ogg")
		LoadSoundOGG(gongS, "gong.ogg")
		LoadSoundOGG(buttonSound, "select.ogg")
		LoadSoundOGG(mirrorBreakS, "mirrorBreak.ogg")
		LoadSoundOGG(rainbowSweepS, "rainbowSweep.ogg")
		LoadSoundOGG(fruitS, "fruit.ogg")
		LoadSoundOGG(fwipS, "fwip.ogg")
		
		
		LoadSoundOGG(exp1S, "exp1.ogg")
		LoadSoundOGG(exp2S, "exp2.ogg")
		LoadSoundOGG(exp3S, "exp3.ogg")
		LoadSoundOGG(exp4S, "exp4.ogg")
		LoadSoundOGG(exp5S, "exp5.ogg")
		
		LoadSoundOGG(ufoS, "ufo.ogg")
		LoadSoundOGG(wizardSpell1S, "wizardSpell1.ogg")
		LoadSoundOGG(wizardSpell2S, "wizardSpell2.ogg")
		LoadSoundOGG(ninjaStarS, "ninjaStar.ogg")
	endif
	
	
	//Have to load them all in AGAIN as music, thanks dumb android sound threads ):<
	if GetDeviceBaseName() = "android"
		LoadMusicOGG(turnS, "turn.ogg")
		LoadMusicOGG(specialS, "special.ogg")
		LoadMusicOGG(specialExitS, "specialExit.ogg")
		LoadMusicOGG(explodeS, "explode.ogg")
		LoadMusicOGG(launchS, "launch.ogg")
		LoadMusicOGG(crackS, "crack.ogg")
		LoadMusicOGG(flyingS, "flying.ogg")
		LoadMusicOGG(landingS, "landing.ogg")		
		LoadMusicOGG(arrowS, "arrow.ogg")
		LoadMusicOGG(chooseS, "choose.ogg")
		LoadMusicOGG(gongS, "gong.ogg")
		LoadMusicOGG(buttonSound, "select.ogg")
		LoadMusicOGG(mirrorBreakS, "mirrorBreak.ogg")
		LoadMusicOGG(rainbowSweepS, "rainbowSweep.ogg")
		LoadMusicOGG(fruitS, "fruit.ogg")
		LoadMusicOGG(fwipS, "fwip.ogg")
		
		LoadMusicOGG(exp1S, "exp1.ogg")
		LoadMusicOGG(exp2S, "exp2.ogg")
		LoadMusicOGG(exp3S, "exp3.ogg")
		LoadMusicOGG(exp4S, "exp4.ogg")
		LoadMusicOGG(exp5S, "exp5.ogg")
		
		LoadMusicOGG(ufoS, "ufo.ogg")
		LoadMusicOGG(wizardSpell1S, "wizardSpell1.ogg")
		LoadMusicOGG(wizardSpell2S, "wizardSpell2.ogg")
		LoadMusicOGG(ninjaStarS, "ninjaStar.ogg")
	endif
			
	SetFolder("/media")
	
endfunction

/*
function LoadBaseMusic()
	SetFolder("/media/music")
	
	LoadMusicOGG(fightAMusic, "fightA.ogg")
	SetMusicLoopTimesOGG(fightAMusic, 28.235, -1)
	LoadMusicOGG(characterMusic, "character.ogg")
	LoadMusicOGG(resultsMusic, "results.ogg")
	SetMusicLoopTimesOGG(resultsMusic, 14.22, -1)
	
	LoadMusicOGG(raveBass1, "raveBass.ogg")
	LoadMusicOGG(raveBass2, "raveBass2.ogg")
	LoadMusicOGG(fireMusic, "fire.ogg")
	
	LoadMusicOGG(retro1M, "retro1.ogg")
	LoadMusicOGG(retro2M, "retro2.ogg")
	LoadMusicOGG(retro3M, "retro3.ogg")
	LoadMusicOGG(retro4M, "retro4.ogg")
	LoadMusicOGG(retro5M, "retro5.ogg")
	LoadMusicOGG(retro6M, "retro6.ogg")
	LoadMusicOGG(retro7M, "retro7.ogg")
	LoadMusicOGG(retro8M, "retro8.ogg")
		
	SetFolder("/media")
	
	SetMusicSystemVolumeOGG(volumeM)
	
endfunction
*/

function PlayMusicOGGSP(songID, loopYN)
	
	oldFolder$ = GetFolder()
	SetFolder("/media/music")
	
	if GetMusicExistsOGG(songID) = 0
		
		if songID = titleMusic then LoadMusicOGG(titleMusic, "title.ogg")
	
		if songID = fightAMusic
			LoadMusicOGG(fightAMusic, "fightA.ogg")
			SetMusicLoopTimesOGG(fightAMusic, 28.235, -1)
		endif
		if songID = fightBMusic then LoadMusicOGG(fightBMusic, "fightB.ogg")
		if songID = fightJMusic
			LoadMusicOGG(fightJMusic, "fightJ.ogg")
			SetMusicLoopTimesOGG(fightJMusic, 6.0, -1)
		endif
		if songID = tutorialMusic then LoadMusicOGG(tutorialMusic, "fightD.ogg")
		if songID = characterMusic
			LoadMusicOGG(characterMusic, "character.ogg")
			SetMusicLoopTimesOGG(characterMusic, 2.581, -1)
		endif
		if songID = resultsMusic
			LoadMusicOGG(resultsMusic, "results.ogg")
			SetMusicLoopTimesOGG(resultsMusic, 14.22, -1)
		endif
		if songID = loserMusic then LoadMusicOGG(loserMusic, "loser.ogg")
		if songID = spMusic
			LoadMusicOGG(spMusic, "spMusic.ogg")
			
			SetMusicLoopTimesOGG(spMusic, 6.932, -1)
			if appState = START then SetMusicLoopTimesOGG(spMusic, .769, 25.384)
			
		endif
		if songID = dangerAMusic then LoadMusicOGG(dangerAMusic, "dangerA.ogg")
		if songID = dangerBMusic then LoadMusicOGG(dangerBMusic, "dangerB.ogg")
		if songID = dangerJMusic then LoadMusicOGG(dangerJMusic, "dangerJ.ogg")
		if songID = dangerCMusic then LoadMusicOGG(dangerCMusic, "dangerC.ogg")
		
		if songID = raveBass1 then LoadMusicOGG(raveBass1, "raveBass.ogg")
		if songID = raveBass2 then LoadMusicOGG(raveBass2, "raveBass2.ogg")
		if songID = fireMusic then LoadMusicOGG(fireMusic, "fire.ogg")
		
		if songID = retro1M then LoadMusicOGG(retro1M, "retro1.ogg")
		if songID = retro2M then LoadMusicOGG(retro2M, "retro2.ogg")
		if songID = retro3M then LoadMusicOGG(retro3M, "retro3.ogg")
		if songID = retro4M then LoadMusicOGG(retro4M, "retro4.ogg")
		if songID = retro5M then LoadMusicOGG(retro5M, "retro5.ogg")
		if songID = retro6M then LoadMusicOGG(retro6M, "retro6.ogg")
		if songID = retro7M then LoadMusicOGG(retro7M, "retro7.ogg")
		if songID = retro8M then LoadMusicOGG(retro8M, "retro8.ogg")
	
	endif
		
	PlayMusicOGG(songID, loopYN)
	SetMusicVolumeOGG(songID, volumeM)
	SetFolder("/" + oldFolder$)
endfunction

function PlayMusicOGGSPStr(str$, loopYN)
	id = 0
	
	if str$ = "title" then id = titleMusic
	if str$ = "fightA" then id = fightAMusic
	if str$ = "fightB" then id = fightBMusic
	if str$ = "fightJ" then id = fightJMusic
	if str$ = "fightD" then id = tutorialMusic
	if str$ = "characterSelect" then id = characterMusic
	if str$ = "results" then id = resultsMusic
	if str$ = "loserXD" then id = loserMusic
	if str$ = "chromecoast" then id = spMusic
	if str$ = "dangerA" then id = dangerAMusic
	if str$ = "dangerB" then id = dangerBMusic
	if str$ = "dangerJ" then id = dangerJMusic
	if str$ = "dangerC" then id = dangerCMusic
	if str$ = "rave1" then id = raveBass1
	if str$ = "rave2" then id = raveBass2
	
	if str$ = "retro1" then id = retro1M
	if str$ = "retro2" then id = retro2M
	if str$ = "retro3" then id = retro3M
	if str$ = "retro4" then id = retro4M
	if str$ = "retro5" then id = retro5M
	if str$ = "retro6" then id = retro6M
	if str$ = "retro7" then id = retro7M
	if str$ = "retro8" then id = retro8M
	
	if id <> 0 and GetMusicPlayingOGGSP(id) = 0
		StopGamePlayMusic()
		PlayMusicOGGSP(id, loopYN)
	endif
endfunction


function LoadJumpSounds()
	if GetMusicExistsOGG(jump1S) then DeleteMusicOGG(jump1S)
	if GetMusicExistsOGG(jump2S) then DeleteMusicOGG(jump2S)
	
	SetFolder("/media/sounds")
	LoadMusicOGG(jump1S, "jump" + str(crab1Type) + ".ogg")
	LoadMusicOGG(jump2S, "jump" + str(crab2Type) + ".ogg")
endfunction

function LoadBaseImages()
	
	SetFolder("/media/fonts")
	
	LoadImage(fontSpecialI, "fontSpecial.png")
	LoadImage(fontDescI, "fontDesc.png")
	LoadImage(fontDescItalI, "fontDescItal.png")
	LoadImage(fontCrabI, "fontCrab.png")
	LoadImage(fontScoreI, "ScoreFont.png")
	
	//#constant fontDesc 2
	
	SetFolder("/media/art")
	
	//The lives
	//for i = 1 to 6
		//Only loading in the base life images
		//LoadImage(crab1life1I + (i-1)*3, "crab" + str(i) + "life1.png")
	//next i
	
	for i = 1 to 6
		//Loading in the chibi crabs
		//LoadImage(crab1life1I + (i-1)*3, "crab" + str(i) + "life1.png")
	next i
	
	//Old way of load lives (all of them)
//~	for i = 1 to 6
//~			for j = 1 to 3
//~				LoadImage(crab1life1I - 1 + j + (i-1)*3, "crab" + str(i) + "life" + str(j) + ".png")
//~			next j
//~	next i
	
	SetFolder("/media/envi")
	
	LoadImage(bg1I, "bg1.png")
	LoadImage(bg2I, "bg2.png")
	LoadImage(bg3I, "bg3.png")
	LoadImage(bg4I, "bg4.png")
	LoadImage(bg5I, "bg5.png")
	LoadImage(bgPI, "pauseForeground.png")
	LoadImage(bgRainSwipeI, "rainbowSwipe.png")
	
	LoadImage(starParticleI, "starParticle.png")
	
	for i = special4s1 to special4s8
		LoadImage(i, "ravespprop" + str(i - special4s1 + 1) + ".png")
	next i
	
	LoadImage(crabpingI, "crabPing.png")
	
	for i = 1 to 6
		jumpPartI[i] = jumpPartI1 + i - 1
		LoadImage(jumpPartI[i], "jumpP" + str(i) + ".png")
	next i
	
	LoadImage(attackPartI, "attackParticle.png")
	LoadImage(attackPartInvertI, "attackParticleInvert.png")
	
	/*
	LoadImage(planetVar1I, "planet1alt1.png")
	LoadImage(planetVar2I, "planet1alt2.png")
	LoadImage(planetVar3I, "planet1alt3.png")
	LoadImage(planetVar4I, "planet1alt4.png")
	LoadImage(planetVar5I, "planet1alt5.png")
	LoadImage(planetVar6I, "planet1alt6.png")
	LoadImage(planetVar7I, "planet1alt7.png")
	LoadImage(planetVar8I, "planet1alt8.png")
	*/

	//Setting up the planet image indexes for later
	for i = 1 to planetITotalMax
		planetVarI[i] = 400 + i
	next i
	
	
	LoadImage(fruit1I, "fruit1.png")
	LoadImage(fruit2I, "fruit2.png")
	LoadImage(fruit3I, "fruit3.png")
	LoadImage(fruit4I, "fruit4.png")
	LoadImage(fruit5I, "fruit5.png")
	LoadImage(fruit6I, "fruit6.png")
	
	LoadImage(flameI1, "flame1.png")
	LoadImage(flameI2, "flame2.png")
	LoadImage(flameI3, "flame3.png")
	LoadImage(flameI4, "flame4.png")
	
			
	SetFolder("/media/ui")
	
	LoadImage(logoI, "title.png")
	LoadImage(logoDemoI, "titleDemo.png")
	LoadImage(logoFruitI, "titleFruit.png")
	
	SetFolder("/media")
	
	LoadImage(meteorGlowI, "glow.png")
	
	LoadImage(expOrbI, "exp.png")
	LoadImage(expBarI1, "expBar1.png")
	LoadImage(expBarI2, "expBar2.png")
	LoadImage(expBarI3, "expBar3.png")
	LoadImage(expBarI4, "expBar4.png")
	LoadImage(expBarI5, "expBar5.png")
	LoadImage(expBarI6, "expBar6.png")
	
	LoadImage(boarderI, "boader.png")
	LoadImage(ufoI, "spaceNed.png")
	LoadImage(ninjaStarI, "ninjaStar.png")
	
endfunction

function LoadStartImages(loading)
	
	if loading
		//Loading all of the images
		
		SetFolder("/media/envi")
		//LoadImage(bg4I, "bg4.png")
		
		for i = 1 to 16
			//LoadImage(warpI1 - 1 + i, "hyperspacecolorized" + str(i) + ".png")
		next i
		
	else
		//Deleting all of the images
		
		//DeleteImage(bg4I)
		for i = 1 to 16
			//DeleteImage(warpI1 - 1 + i)
		next i
		
	endif
	
endfunction

function LoadCharacterSelectImages(loading)
	
	if loading
		//Loading all of the images
		
		
		SetFolder("/media/art")
	
		//Loading the start screen images
		for i = 1 to 6
			//if i = 1 or i = 2 or i = 4 or i = 6
				for j = 1 to 6
					LoadImage(crab1select1I - 1 + j + i*10, "crab" + str(i) + "select" + str(j) + ".png")
					SyncG() //This is here so that the particles can keep on moving
				next j
				//Sync() //This is here so that the particles can keep on moving
			//endif
		next i
		
		SetFolder("/media/envi")
		//LoadImage(bg5I, "bg5.png")
		
//~		if GetDeviceBaseName() = "android"
//~			SetFolder("/media/sounds")
//~			
//~			LoadMusicOGG(arrowS, "arrow.ogg")
//~			LoadMusicOGG(chooseS, "choose.ogg")
//~		endif
		
	else
		//Deleting all of the images
		
		for i = 1 to 6
			for j = 1 to 6
				if GetImageExists(crab1select1I - 1 + j + i*10) then DeleteImage(crab1select1I - 1 + j + i*10)
			next j
		next i
		
		//DeleteImage(bg5I)
		
//~		if GetDeviceBaseName() = "android"
//~			StopMusicOGGSP(arrowS)
//~			StopMusicOGGSP(chooseS)
//~		endif
		
	endif
	
	
	
endfunction

function LoadGameImages(loading)
	
	if loading
		//Loading all of the images
		
		SetFolder("/media/envi")
		//LoadImage(bg1I, "bg1.png")
		//LoadImage(bg2I, "bg2.png")
		//LoadImage(bg3I, "bg3.png")
		
		LoadImage(meteorI1, "meteor1.png")
		LoadImage(meteorI2, "meteor2.png")
		LoadImage(meteorI3, "meteor3.png")
		LoadImage(meteorI4, "meteor4.png")
		LoadImage(meteorTractorI, "tractor.png")
		
		for i = 1 to planetIMax
			LoadImage(planetVarI[i], "p" + str(i) + ".png")
		next i
		for i = 1 to planetITotalMax - planetIMax
			LoadImage(planetVarI[planetIMax + i], "legendp" + str(i) + ".png")
		next i
		
		
		
//~		if GetDeviceBaseName() = "android"
//~			SetFolder("/media/sounds")
//~			
//~			if crab1Type = 1 or crab2Type = 1 then LoadMusicOGG(ufoS, "ufo.ogg")
//~			if crab1Type = 2 or crab2Type = 2
//~				LoadMusicOGG(wizardSpell1S, "wizardSpell1.ogg")
//~				LoadMusicOGG(wizardSpell2S, "wizardSpell2.ogg")
//~			endif
//~			if crab1Type = 6 or crab2Type = 6 then LoadMusicOGG(ninjaStarS, "ninjaStar.ogg")
//~			
//~			LoadMusicOGG(turnS, "turn.ogg")
//~			LoadMusicOGG(specialS, "special.ogg")
//~			LoadMusicOGG(specialExitS, "specialExit.ogg")
//~			LoadMusicOGG(explodeS, "explode.ogg")
//~			LoadMusicOGG(launchS, "launch.ogg")
//~			LoadMusicOGG(crackS, "crack.ogg")
//~			LoadMusicOGG(flyingS, "flying.ogg")
//~			LoadMusicOGG(landingS, "landing.ogg")		
//~		
//~			//LoadMusicOGG(exp1S, "exp1.ogg")
//~			//LoadMusicOGG(exp2S, "exp2.ogg")
//~			//LoadMusicOGG(exp3S, "exp3.ogg")
//~			//LoadMusicOGG(exp4S, "exp4.ogg")
//~			//LoadMusicOGG(exp5S, "exp5.ogg")
//~			
//~		endif
		
		//The dynamic crab loader!
		for i = 1 to 2
			
			SetFolder("/media/crabs")
			
			crabType = crab2Type
			alt$ = AltStr(crab2Alt) //crab2Alt
			
			if i = 1
				if (crab1type = crab2type) and (crab1alt = crab2alt) //TODO: Add alternate checker here
					//The same crab
					i = 2
				else
					//Different crabs
					crabType = crab1Type
					alt$ = AltStr(crab1Alt)
				endif
			endif
			
			index = crab1start1I + (i-1)*20
			
			for j = 1 to 17
				act$ = "" //The action to use in the sprite name
				num = 0	//A second index, to subtract from the index, for the proper image name
				if j <=2
					act$ = "start"
				elseif j <= 10
					act$ = "walk"
					num = -2
				elseif j <= 12
					act$ = "jump"
					num = -10
				elseif j <= 14
					act$ = "death"
					num = -12
				else
					act$ = "skid"
					num = -14
				endif
				
				file$ = "crab" + str(crabType) + alt$ + act$ + str(j+num) + ".png"
				if GetFileExists(file$)
					LoadImage(index, file$)
				else
					LoadImage(index, "white.png")
				endif
			
				
				loadedCrabSprites.insert(index)
				inc index, 1
			next j
			
			SetFolder("/media/art")
			
			index = crab1attack1I - 1 + i
			file$ = "crab" + str(crabType) + alt$ + "attack1.png"
			if GetFileExists(file$)
				LoadImage(index, file$)
			else
				LoadImage(index, "white.png")
			endif
			file$ = "crab" + str(crabType) + alt$ + "attack2.png"
			if GetFileExists(file$)
				LoadImage(index+10, file$)
			else
				LoadImage(index+10, "white.png")
			endif
			file$ = "crab" + str(crabType) + alt$ + "attack3.png"
			if GetFileExists(file$)
				LoadImage(index+20, file$)
			else
				LoadImage(index+20, "white.png")
			endif
			
			loadedCrabSprites.insert(index)
			loadedCrabSprites.insert(index+10)
			loadedCrabSprites.insert(index+20)
			
			//Lives loading
			index = crab1life1I + (i-1)*3
			for k = 1 to 3
				file$ = "crab" + str(crabType) + alt$ + "life" + str(k) + ".png"
				if GetFileExists(file$)
					LoadImage(index, file$)
				else
					LoadImage(index, "white.png")
				endif
				loadedCrabSprites.insert(index)
				inc index, 1
			next k
			
			SetFolder("/media/ui")
			//Special images
			
			//TODO: crab1life1I images
			
		next i
				
		//Temporary if, until there is a better crab loading system
		if 1 = 0 // Not using //GetImageExists(crab1start1I) = 0
			//Defunct, example for one crab
			LoadImage(crab1start1I, "crab1start1.png")
			LoadImage(crab1start2I, "crab1start2.png")
			LoadImage(crab1walk1I, "crab1walk1.png")
			LoadImage(crab1walk2I, "crab1walk2.png")
			LoadImage(crab1walk3I, "crab1walk3.png")
			LoadImage(crab1walk4I, "crab1walk4.png")
			LoadImage(crab1walk5I, "crab1walk5.png")
			LoadImage(crab1walk6I, "crab1walk6.png")
			LoadImage(crab1walk7I, "crab1walk7.png")
			LoadImage(crab1walk8I, "crab1walk8.png")
			LoadImage(crab1jump1I, "crab1jump1.png")
			LoadImage(crab1jump2I, "crab1jump2.png")
			LoadImage(crab1death1I, "crab1death1.png")
			LoadImage(crab1death2I, "crab1death2.png")
			LoadImage(crab1skid1I, "crab1skid1.png")
			LoadImage(crab1skid2I, "crab1skid2.png")
			LoadImage(crab1skid3I, "crab1skid3.png")
			
			SetFolder("/media/art")
	
			LoadImage(crab1attack1I, "crab1attack1.png")
			LoadImage(crab1attack2I, "crab1attack2.png")
		endif
		
	else
		//Deleting all of the images
		
		//DeleteImage(bg1I)
		//DeleteImage(bg2I)
		//DeleteImage(bg3I)
		
		DeleteImage(meteorI1)
		DeleteImage(meteorI2)
		DeleteImage(meteorI3)
		DeleteImage(meteorI4)
		DeleteImage(meteorTractorI)
		
		for i = 1 to planetIMax
			DeleteImage(planetVarI[i])
		next i
		for i = 1 to planetITotalMax - planetIMax
			DeleteImage(planetVarI[planetIMax + i])
		next i
		
		//if GetImageExists(crab3attack3I) then DeleteImage(crab3attack3I)
		//if GetImageExists(crab5attack3I) then DeleteImage(crab5attack3I)
		
		cLength = loadedCrabSprites.length
		for i = 0 to cLength
			if GetImageExists(loadedCrabSprites[i]) then DeleteImage(loadedCrabSprites[i])
		next i
		for i = 0 to cLength
			loadedCrabSprites.remove(0)
		next i
		
	endif
	
endfunction

function LoadResultImages(loading)
	
	
endfunction


global crabPause1 as string[6]
global crabPause2 as string[6]

function SetCrabPauseStrings()
	crabPause1[1] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "Double-tap: Roll Forward"
	crabPause1[2] = "Speed: {{}}} Turn: {{{{}" + chr(10) + "Double-tap: Launch Forward"
	crabPause1[3] = "Speed: {{{{{ Turn: {}}}}" + chr(10) + "Double-tap: Quick Brake"
	crabPause1[4] = "Speed: {{{{} Turn: {{}}}" + chr(10) + "Double-tap: Launch Up"
	crabPause1[5] = "Speed: {{{}} Turn: {{{}}" + chr(10) + "Double-tap: Roll Back"
	crabPause1[6] = "Speed: {{{}} Turn: {{{{{" + chr(10) + "Tap: Instant Turn"
	
	crabPause2[1] = "Special: Meteor Shower" + chr(10) + "Call Space Ned to rain down" + chr(10) + "fast meteors on your opponent."
	crabPause2[2] = "Special: Conjure Comets" + chr(10) + "Materialize three waves of" + chr(10) + "comets on the opposite screen."
	crabPause2[3] = "Special: Orbital Nightmare" + chr(10) + "Make everything (planets, meteors," + chr(10) + "crabs) on the other screen spin."
	crabPause2[4] = "Special: Party Time!" + chr(10) + "Obscure your opponent's vision" + chr(10) + "with intense rave lights."
	crabPause2[5] = "Special: Fast Forward" + chr(10) + "Speed up your enemy's" + chr(10) + "game for a short while."
	crabPause2[6] = "Special: Shuri-Krustacean" + chr(10) + "Fling deadly projecticles" + chr(10) + "directly up the screen."
endfunction

global chapterTitle as string[25]
global chapterDesc as string[25]

function SetStoryShortStrings()
	chapterTitle[1] = "The Idea"
	chapterDesc[1] = "After an unfortunate event," + chr(10) + "a chance encounter leads" + chr(10) + "Space Crab down a path" + chr(10) + "he never expected!"
	
	chapterTitle[2] = "The Strategy"
	chapterDesc[2] = "To fill out the founding" + chr(10) + "members of the Star Seekers," + chr(10) + "Ladder Wizard seeks the most" + chr(10) + "powerful crabs he knows."
	
	chapterTitle[3] = "The Fan"
	chapterDesc[3] = "Top Crab shouldn't" + chr(10) + "be here :P" + chr(10) + "This part's not done yet." + chr(10) + "Luckily, no demo" + chr(10) + "should see this."
	
	chapterTitle[4] = ""
	chapterDesc[4] = ""
	
	chapterTitle[5] = "Political Influence"
	chapterDesc[5] = ""
	
	chapterTitle[6] = "The Adventurer"
	chapterDesc[6] = ""
	
	chapterTitle[7] = "The Transportation Expert"
	chapterDesc[7] = ""
	
	chapterTitle[8] = ""
	chapterDesc[8] = ""
	
	chapterTitle[9] = "The Physical Fitness"
	chapterDesc[9] = ""
	
	chapterTitle[10] = "Mister Music"
	chapterDesc[10] = ""
	
	chapterTitle[11] = ""
	chapterDesc[11] = ""
	
	chapterTitle[12] = "The Cosmic Cook"
	chapterDesc[12] = ""
	
	chapterTitle[13] = "New Crab 1"
	chapterDesc[13] = ""
	
	chapterTitle[14] = "Single & Mingling"
	chapterDesc[14] = ""
	
	chapterTitle[15] = "The Calculator?"
	chapterDesc[15] = ""
	
	chapterTitle[16] = "The Party...?"
	chapterDesc[16] = ""
	
	chapterTitle[17] = "The Voice of Reason"
	chapterDesc[17] = ""
	
	chapterTitle[18] = "The Divine Eye-in-the-Sky"
	chapterDesc[18] = ""
	
	chapterTitle[19] = "The Crab Resources Department"
	chapterDesc[19] = ""
	
	chapterTitle[20] = "New Crab 2"
	chapterDesc[20] = ""
	
	chapterTitle[21] = "The Other Side of the Paw"
	chapterDesc[21] = ""
	
	chapterTitle[22] = "The Valiant Defender"
	chapterDesc[22] = ""
	
	chapterTitle[23] = "The Starlight Rival"
	chapterDesc[23] = ""
	
	chapterTitle[24] = "Fight for the Future!"
	chapterDesc[24] = ""
	
	chapterTitle[25] = "The Future"
	chapterDesc[25] = ""
	
endfunction

function AltStr(alt)
	myStr$ = ""
	if alt = 1 then myStr$ = "a"
	if alt = 2 then myStr$ = "b"
	if alt = 3 then myStr$ = "c"
endfunction myStr$
/*
The Code Graveyard

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



#constant crab3start1I 141
#constant crab3start2I 142
#constant crab3walk1I 143
#constant crab3walk2I 144
#constant crab3walk3I 145
#constant crab3walk4I 146
#constant crab3walk5I 147
#constant crab3walk6I 148
#constant crab3walk7I 149
#constant crab3walk8I 150
#constant crab3jump1I 151
#constant crab3jump2I 152
#constant crab3death1I 153
#constant crab3death2I 154
#constant crab3skid1I 155
#constant crab3skid2I 156
#constant crab3skid3I 157

#constant crab4start1I 161
#constant crab4start2I 162
#constant crab4walk1I 163
#constant crab4walk2I 164
#constant crab4walk3I 165
#constant crab4walk4I 166
#constant crab4walk5I 167
#constant crab4walk6I 168
#constant crab4walk7I 169
#constant crab4walk8I 170
#constant crab4jump1I 171
#constant crab4jump2I 172
#constant crab4death1I 173
#constant crab4death2I 174
#constant crab4skid1I 175
#constant crab4skid2I 176
#constant crab4skid3I 177

#constant crab5start1I 181
#constant crab5start2I 182
#constant crab5walk1I 183
#constant crab5walk2I 184
#constant crab5walk3I 185
#constant crab5walk4I 186
#constant crab5walk5I 187
#constant crab5walk6I 188
#constant crab5walk7I 189
#constant crab5walk8I 190
#constant crab5jump1I 191
#constant crab5jump2I 192
#constant crab5death1I 193
#constant crab5death2I 194
#constant crab5skid1I 195
#constant crab5skid2I 196
#constant crab5skid3I 197

#constant crab6start1I 201
#constant crab6start2I 202
#constant crab6walk1I 203
#constant crab6walk2I 204
#constant crab6walk3I 205
#constant crab6walk4I 206
#constant crab6walk5I 207
#constant crab6walk6I 208
#constant crab6walk7I 209
#constant crab6walk8I 210
#constant crab6jump1I 211
#constant crab6jump2I 212
#constant crab6death1I 213
#constant crab6death2I 214
#constant crab6skid1I 215
#constant crab6skid2I 216
#constant crab6skid3I 217

*/
