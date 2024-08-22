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
global inputSkip = 0
global inputLeft = 0
global inputRight = 0
global inputUp = 0
global inputDown = 0
global inputAttack1 = 0
global inputSpecial1 = 0
global inputTurn1 = 0

global inputSelect2 = 0
global inputExit2 = 0
global inputSkip2 = 0
global inputLeft2 = 0
global inputRight2 = 0
global inputUp2 = 0
global inputDown2 = 0
global inputAttack2 = 0
global inputSpecial2 = 0
global inputTurn2 = 0

//The timer for the starting screen
global startTimer# = 0

//Number of crabs in the game - made a constant in case we add/remove crabs
#constant NUM_CRABS 24 //6
#constant NUM_CHAPTERS 25
#constant STORY_CS_BONUS 1

//Gameplay constants & variables
#constant planetSize 220
global metSizeX = 58
global metSizeY = 80

#constant spaceCrabTimeMax 200	//This is just for moving the UFO
#constant topCrabTimeMax 1200
#constant raveCrabTimeMax 900
#constant chronoCrabTimeMax 1900	//Is longer because the timer goes down faster
#constant ninjaCrabTimeMax 500	

//										D		D		D		D		D		D		1		2		3		4		5		6		1		2		3		4		5		6		1		2		3		4		5		6
//									Nul	Space	Wizard	Top		Rave	Chrono	Ninja	Mad		King	Taxi	Fan		Jeff	Team P	Al		Cbcus	Barc	Hwaii	Rock	Crnme	Future	Knight	Sk8r	Holy	Cake	Chimera
global crabVel as float [24] = 		[0,	 1.28,	1.08,	2.48,	1.59,	1.38,	1.5,	1.3,	1.06,	2.78,	1.52,	1.33,	1.6,	1.30,	1.12,	2.2,	1.46,	1.4,	1.4,	1.39,	1.18,	2.3,	1.45,	1.36,	1.4]
global crabAccel as float [24] = 	[0,	 0.1,	0.13,	0.03,	0.08,	0.1,	0.1,	0.09,	0.13,	0.024,	0.09,	0.115,	0.1,	0.1,	0.12,	0.06,	0.09,	0.1,	0.1,	0.11,	0.14,	0.052,	0.08,	0.12,	0.1]	
global crabJumpHMax as float [24] = 	[0,	 5,		10.5,	8.0,	10.0,	5.0,	6.0,	4,		11.5,	7.0,	9.8,	5.0,	2,		6,		10.5,	3.0,	11.0,	6.0,	2.0,	-4,		9.0,	8.2,	15,		4.5,	7.0]
global crabJumpSpeed as float [24] =	[0,	 1.216,	1.516,	-3,		-1.28,	-3.216,	.816,	1.2,	1.516,	-2,		-1.0,	-3.22,	.8,		1.116,	1.516,	-3,		-2,		-4.0,	0.5,	1.3,	1.416,	-2.6,	-1.28,	-2.9,	.9]
global crabJumpDMax as float [24] =	[0,	 28,	40,		32,		43,		28,		26,		29,		38,		32,		37,		28,		27,		28,		40,		32,		45,		22,		27,		28,		35,		30,		55,		25,		25]
global crabFramerate as integer[24]=	[0,  10,	13,		10,		18,		10,		15,		14,		12,		15,		12,		10,		15,		12,		12,		16,		10,		12,		12,		10,		10,		14,		10,		12,		10]
global crabSPAtck as integer[24] = 	[0,	 20,	20,		25,		23,		30,		18,		20,		16,		21,		25,		29,		20,		20,		20,		25,		23,		30,		20,		17,		23,		25,		26,		30,		20]
//global crabSPAtck as integer[24] = 	[0,	 20,	20,		25,		23,		0,		18,		20,		16,		21,		1,		0,		20,		20,		20,		1,		1,		0,		1,		1,		1,		1,		1,		0,		1]


#constant lastTranType 2

#constant hitSceneMax 240
global hit1Timer# = 0
global hit2Timer# = 0

global firstFight = 1
global gameTimer# = 0

global gameScale# = 1
#constant regMScale 1
#constant regDScale .7
#constant classicScaleMod 1.3

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
global crab1Evil = 0
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
global crab2Evil = 0

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
global storyEasy = 0

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

//Statistics Variables
global totalSecondsPlayed = 0
global localSeconds# = 0
global fightTotal = 0
global mirrorTotal = 0
global classicTotal = 0
global fightSeconds = 0
global fightSecondsLocal# = 0
global crabPlayed as Integer[27]
global totalMeteors = 0
global scoreTableMirror as Integer[27]
global scoreTableClassic as Integer[27]


global p1Ready = 0
global p2Ready = 0

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
#constant easyButton 17

//Just a sheet for when things need to be covered up
#constant coverS 11
#constant curtain 12
#constant curtainB 13

#constant SPR_SELECT1 921
#constant SPR_SELECT2 922
#constant SPR_SELECT3 923
#constant SPR_SELECT4 924

//This is for the player 2 selection
#constant SPR_SELECT5 925
#constant SPR_SELECT6 926
#constant SPR_SELECT7 927
#constant SPR_SELECT8 928

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

#constant fontSpecialI 1001
#constant fontDescI 1002	//Tahoma
#constant fontDescItalI 1004	//Tahoma (Italicized)
#constant fontCrabI 1003	//Somerset Barnyard
#constant fontScoreI 1005	//SnowTunes UI Font
#constant fontTitleScreenI 1006	//Corbel (Italicised)

#constant starParticleI 11

//The indexs are reserved, but no constants are needed
#constant crab1select1I 20301
/*
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
*/

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
#constant clockI 74
#constant clockMinI 75
#constant clockHourI 76

#constant bg1I 81
#constant bg2I 82
#constant bg3I 83
#constant bg4I 84
#constant bg5I 85
#constant bg6I 86
#constant bg7I 87
#constant bg8I 88
#constant bg9I 89
#constant bgPI 90 	//Pause foreground
#constant bgRainSwipeI 92

#constant meteorGlowI 91



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


#constant banner1I 241
//This goes on through... the rest of 300, to be safe

#constant crabpingI 400

//Planets images are 401 to 430
#constant planetIMax 60
//#constant planetITotalMax 29
#constant planetILegMax 23
//global planetVarI as Integer[planetITotalMax]

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

#constant jumpPartI1 601		//J
global jumpPartI as Integer[6, 4]

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

#constant mAlt1I 481
#constant mAlt2I 482
#constant mAlt3I 483
#constant mAlt4I 484
#constant mAlt5I 485
#constant mAlt6I 486
#constant mAlt7I 487
#constant mAlt8I 488
#constant mAlt9I 489

#constant mAlt2aI 490

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
#constant turnSDog 15

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

#constant kingSpellS 29
#constant knightSpellS 30

#constant talk1S 31
#constant talkBS 32

//Music Indexes
#constant titleMusic 101
#constant characterMusic 102
#constant resultsMusic 103
#constant loserMusic 109

#constant fightAMusic 104	//Andy's fight song (Twelve Legged Tango)
#constant fightBMusic 105	//Brad's fight song (Starlight Rivals)
#constant fightJMusic 106	//John's fight song (The Final Remuloude)
#constant tutorialMusic 107	//The tutorial song
#constant spMusic 108		//Mirror Music (Chrome Coast)
#constant tomatoMusic 110 	//End of Chapter song (Marigold Tomato)
#constant loveMusic 111		//Love Me Space Crab!!
#constant unlockMusic 112	//Unlocking Jingle
#constant emotionMusic 113	//Emotional Song
#constant fightFMusic 114	//Fight For the Future!
#constant fightAJMusic 115	//To Battle
#constant chillMusic 116		//Back to my Hunch
#constant ragMusic 117		//Space Crab Rag
#constant ssidMusic 118  	//Shooting Stars into Dreams - REMix
#constant mcbMusic 119		//Melted Chocolate Bar
#constant fightMMusic 120	//Anger Point
#constant fightBVocalMusic 121
#constant creditsMusic 122
#constant skateMusic 123
#constant skateVocalMusic 124
#constant puppetMusic 125
#constant creditsVocalMusic 126


#constant dangerAMusic 211
#constant dangerBMusic 212
#constant dangerJMusic 213
#constant dangerCMusic 214
#constant dangerTMusic 215
#constant dangerFMusic 216
#constant dangerAJMusic 217
#constant dangerMMusic 218
#constant dangerSkateMusic 219
#constant dangerPuppetMusic 220

#constant raveBass1 126
#constant raveBass2 127
#constant fireMusic 128

#constant retro1M 131
#constant retro2M 132
#constant retro3M 133
#constant retro4M 134
#constant retro5M 135
#constant retro6M 136
#constant retro7M 137
#constant retro8M 138
#constant retro9M 139
#constant retro10M 140
#constant retro11M 141

#constant voice1 161
#constant voice2 162

global oldSong = 0

//Volume for music and sound effects & other settings
global volumeM = 100
global volumeSE = 100
global targetFPS = 5
global windowSize = 1

//SetMusicSystemVolumeOGG(volumeM)

//Start screen sprites
#constant SPR_TITLE 200 
#constant SPR_STORY_START 201
#constant SPR_STARTAI 202
#constant SPR_STARTMIRROR 203
#constant SPR_CLASSIC 204
#constant SPR_START1 205
#constant SPR_JUKEBOX 206
#constant SPR_STATS 207
//SPR_SETTINGS 208
#constant SPR_EXIT_GAME 209

#constant TXT_SINGLE 211
#constant TXT_MULTI 212
#constant TXT_OTHER 213


#constant TXT_SP_LOGO 214
#constant TXT_HIGHSCORE 215
#constant SPR_LEADERBOARD 216
#constant SPR_HARDGAME 217
#constant SPR_FASTGAME 218
#constant SPR_MUSICPICK 219
#constant SPR_EVIL 220

//Different Crab buttons for the single player mode
#constant SPR_SP_C1 256
#constant SPR_SP_C6 261
#constant SPR_SP_C24 279

#constant SPR_BG_START 299


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
#constant SPR_CS_CRABS_1 4390
#constant SPR_CS_TXT_BACK_1 389
#constant SPR_CS_FASTGAME 308
#constant SPR_CS_HARDGAME 309
#constant SPR_CS_MUSICPICK 310
#constant SPR_CS_EVILSWITCH_1 311

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
#constant SPR_CS_CRABS_2 4900 
#constant SPR_CS_TXT_BACK_2 489
#constant SPR_CS_EVILSWITCH_2 411

//Character select sprite indexes
global IMG_CS_CRAB as Integer[NUM_CRABS]

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

#constant SPR_STORY_EXIT 621
#constant SPR_STORY_SKIP 622

//Statistics texts
#constant ST_TITLE 651
#constant ST_TXT1 652
#constant ST_TXT2 653

#constant ST_BACK1 654
#constant ST_SWITCH1 655

#constant ST_TXT3 656
#constant ST_TXT4 657
#constant ST_TXT5 658

#constant ST_TXT6 659
#constant ST_TXT7 660
#constant ST_TXT8 661

//Settings Sprites: 801-900

global curChapter = 3
global curScene = 0
global highestScene = 0
global clearedChapter = 0
#constant finalChapter 25
global lineSkipTo = 0
global storyActive = 0
global storyMinScore = 0
global storyRetry = 0
global storyTimer# = 0

//Overall game unlocks
global altUnlocked as integer[6]
global firstStartup = 0
global speedUnlock = 0
global hardBattleUnlock
global musicBattleUnlock = 0
global evilUnlock = 0
global unlockAIHard = 0
global musicUnlocked = 7 	//Not finalized yet, but this will increment for every song unlockes
#constant musicUnlockEnd = 22

global gameIsFast = 0
global gameIsHard = 0
global gameSongSet = 1
#constant gameFastSpeed 1.4

//Ping sprites - 701 through 750

//Popup Sprite
#constant SPR_POPUP_BG 761
#constant SPR_POPUP_C 762
#constant TXT_POPUP 763

#constant SPR_POPUP_BG_2 766
#constant SPR_POPUP_C_2 767
#constant TXT_POPUP_2 768

//Tweens
#constant selectTweenTime# .4 //In seconds
#constant tweenOffP1 1
#constant tweenOnP1 2
#constant tweenOffP2 3
#constant tweenOnP2 4

//global tweenButton = 5
//tweenButton lasts until 25

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
global paused = 0	//Game is currently paused
global pauseTimer# = 0
global spType = 0
global spAIDiff = 3
global fruitMode = 0
#constant MIRRORMODE 1
#constant CLASSIC 2
#constant STORYMODE 3
#constant CHALLENGEMODE 4
#constant AIBATTLE 5

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
		LoadSoundOGG(turnSDog, "turnDog.ogg")
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
		LoadSoundOGG(kingSpellS, "kingSpell.ogg")
		LoadSoundOGG(knightSpellS, "knightSpell.ogg")
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
		
		//LoadMusicOGG(wizardSpell1S, "wizardSpell1.ogg")
		//LoadMusicOGG(wizardSpell2S, "wizardSpell2.ogg")
		//LoadMusicOGG(kingSpellS, "kingSpell.ogg")
		//LoadMusicOGG(knightSpellS, "knightSpell.ogg")
		
		LoadMusicOGG(ufoS, "ufo.ogg")
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
		if songID = fightBVocalMusic then LoadMusicOGG(fightBVocalMusic, "retro9.ogg")
		if songID = fightJMusic
			LoadMusicOGG(fightJMusic, "fightJ.ogg")
			SetMusicLoopTimesOGG(fightJMusic, 6.0, -1)
		endif
		if songID = tomatoMusic
			LoadMusicOGG(tomatoMusic, "tomato.ogg")
			SetMusicLoopTimesOGG(tomatoMusic, 24.0, -1)
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
		if songID = loveMusic
			LoadMusicOGG(loveMusic, "love.ogg")
			SetMusicLoopTimesOGG(loveMusic, 3.077, -1)
		endif
		if songID = emotionMusic
			LoadMusicOGG(emotionMusic, "emotion.ogg")
			SetMusicLoopTimesOGG(emotionMusic, 7.5, -1)
		endif
		if songID = fightFMusic
			LoadMusicOGG(fightFMusic, "fightF.ogg")
			SetMusicLoopTimesOGG(fightFMusic, 6.25, -1)
		endif
		if songID = fightAJMusic
			LoadMusicOGG(fightAJMusic, "fightAJ.ogg")
			SetMusicLoopTimesOGG(fightAJMusic, 7.2, -1)
		endif
		if songID = fightMMusic
			LoadMusicOGG(fightMMusic, "fightM.ogg")
			SetMusicLoopTimesOGG(fightMMusic, 3.0, -1)
		endif
		if songID = chillMusic
			LoadMusicOGG(chillMusic, "chill.ogg")
			SetMusicLoopTimesOGG(chillMusic, 0.967, -1)
		endif
		if songID = ragMusic
			LoadMusicOGG(ragMusic, "rag.ogg")
			SetMusicLoopTimesOGG(ragMusic, 3.158, -1)
		endif
		if songID = unlockMusic then LoadMusicOGG(unlockMusic, "unlock.ogg")
		if songID = ssidMusic then LoadMusicOGG(ssidMusic, "ssid.ogg")
		if songID = mcbMusic
			LoadMusicOGG(mcbMusic, "mcb.ogg")
			SetMusicLoopTimesOGG(mcbMusic, 3.803, -1)
		endif
		if songID = skateMusic then LoadMusicOGG(skateMusic, "skate.ogg")
		if songID = skateVocalMusic then LoadMusicOGG(skateVocalMusic, "skateVocal.ogg")
		if songID = creditsMusic then LoadMusicOGG(creditsMusic, "credits.ogg")
		if songID = creditsVocalMusic then LoadMusicOGG(creditsVocalMusic, "creditsVocal.ogg")
		
		//if id = 16 then song = fightBVocalMusic
	//if id = 17 then song = creditsMusic
	//if id = 20 then song = puppetMusic
		
		if songID = dangerAMusic then LoadMusicOGG(dangerAMusic, "dangerA.ogg")
		if songID = dangerBMusic then LoadMusicOGG(dangerBMusic, "dangerB.ogg")
		if songID = dangerJMusic then LoadMusicOGG(dangerJMusic, "dangerJ.ogg")
		if songID = dangerCMusic then LoadMusicOGG(dangerCMusic, "dangerC.ogg")
		if songID = dangerTMusic then LoadMusicOGG(dangerTMusic, "dangerT.ogg")
		if songID = dangerFMusic then LoadMusicOGG(dangerFMusic, "dangerF.ogg")
		if songID = dangerAJMusic then LoadMusicOGG(dangerAJMusic, "dangerAJ.ogg")
		if songID = dangerMMusic then LoadMusicOGG(dangerMMusic, "dangerM.ogg")
		if songID = dangerSkateMusic then LoadMusicOGG(dangerSkateMusic, "dangerSkate.ogg")
		//if songID = dangerPuppetMusic then
		
		if songID = raveBass1 and appState = STORY
			LoadMusicOGG(raveBass1, "special4.ogg")
		else
			if songID = raveBass1 and crab1Evil = 0 then LoadMusicOGG(raveBass1, "special4"+AltStr(crab1Alt)+".ogg")
			if songID = raveBass1 and crab1Evil = 1 then LoadMusicOGG(raveBass1, "fire.ogg")
		endif
		if songID = raveBass2 and crab2Evil = 0 then LoadMusicOGG(raveBass2, "special4"+AltStr(crab2Alt)+".ogg")
		if songID = raveBass2 and crab2Evil = 1 then LoadMusicOGG(raveBass2, "fire.ogg")
		
		rnd = Random(1,2)
		
		//if songID = wizardSpell1S and crab1Alt = 1 then LoadMusicOGG(wizardSpell1S, "wizardSpell1.ogg")
		//LoadMusicOGG(wizardSpell2S, "wizardSpell2.ogg")
		//LoadMusicOGG(kingSpellS, "kingSpell.ogg")
		//LoadMusicOGG(knightSpellS, "knightSpell.ogg")
		
		if songID = fireMusic then LoadMusicOGG(fireMusic, "fire.ogg")
		
		if songID = retro1M then LoadMusicOGG(retro1M, "special4a.ogg")
		if songID = retro2M then LoadMusicOGG(retro2M, "retro2.ogg")
		if songID = retro3M then LoadMusicOGG(retro3M, "retro3.ogg")
		if songID = retro4M then LoadMusicOGG(retro4M, "retro4.ogg")
		if songID = retro5M then LoadMusicOGG(retro5M, "retro5.ogg")
		if songID = retro6M then LoadMusicOGG(retro6M, "retro6.ogg")
		if songID = retro7M then LoadMusicOGG(retro7M, "retro7.ogg")
		if songID = retro8M then LoadMusicOGG(retro8M, "retro8.ogg")
		if songID = retro9M
			LoadMusicOGG(retro9M, "retro9.ogg")
			SetMusicLoopTimesOGG(retro9M, 3.855, -1)
		endif
		if songID = retro10M then LoadMusicOGG(retro10M, "retro10.ogg")
		if songID = retro11M then LoadMusicOGG(retro11M, "retro11.ogg")
	
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
	if str$ = "fightAJ" then id = fightAJMusic
	if str$ = "anger" then id = fightMMusic
	if str$ = "tomato" then id = tomatoMusic
	if str$ = "emotion" then id = emotionMusic
	if str$ = "chill" then id = chillMusic
	if str$ = "rag" then id = ragMusic
	if str$ = "love" then id = loveMusic
	if str$ = "characterSelect" then id = characterMusic
	if str$ = "results" then id = resultsMusic
	if str$ = "loserXD" then id = loserMusic
	if str$ = "chromecoast" then id = spMusic
	if str$ = "mcb" then id = mcbMusic
	if str$ = "ssid" then id = ssidMusic
	if str$ = "fightBVocal" then id = fightBVocalMusic
	if str$ = "credits" then id = creditsMusic
	if str$ = "creditsVocal" then id = creditsVocalMusic
	if str$ = "skate" then id = skateMusic
	if str$ = "skateVocal" then id = skateVocalMusic
	if str$ = "puppet" then id = puppetMusic
	if str$ = "fftf" then id = fightFMusic
	
	if str$ = "dangerA" then id = dangerAMusic
	if str$ = "dangerB" then id = dangerBMusic
	if str$ = "dangerJ" then id = dangerJMusic
	if str$ = "dangerC" then id = dangerCMusic
	if str$ = "dangerF" then id = dangerFMusic
	if str$ = "dangerAJ" then id = dangerAJMusic
	if str$ = "dangerM" then id = dangerMMusic
	if str$ = "dangerT" then id = dangerTMusic
	if str$ = "dangerSkate" then id = dangerSkateMusic
	if str$ = "dangerPuppet" then id = dangerPuppetMusic
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
	
	if str$ = "" then StopGamePlayMusic()

	if id <> 0 and GetMusicPlayingOGGSP(id) = 0
		StopGamePlayMusic()
		PlayMusicOGGSP(id, loopYN)
	endif
endfunction

function GetMusicByID(id)
	song = 0
	
	//Default unlocked songs
	if id = 1 then song = fightBMusic
	if id = 2 then song = fightAMusic
	if id = 3 then song = fightJMusic
	if id = 4 then song = ragMusic
	if id = 5 then song = chillMusic
	if id = 6 then song = characterMusic
	if id = 7 then song = resultsMusic
	
	//Songs unlocked through the game
	if id = 8 then song = tomatoMusic
	if id = 9 then song = fightAJMusic
	if id = 10 then song = spMusic
	if id = 11 then song = ssidMusic
	if id = 12 then song = mcbMusic
	if id = 13 then song = loveMusic
	if id = 14 then song = fightMMusic
	if id = 15 then song = emotionMusic
	//if id = 16 then song = fightBVocalMusic
	if id = 17 then song = creditsMusic
	if id = 18 then song = skateMusic
	if id = 19 then song = skateVocalMusic
	//if id = 20 then song = puppetMusic
	if id = 21 then song = fightFMusic
	if id = 22 then song = creditsVocalMusic
	
	if id = 31 then song = retro1M
	if id = 32 then song = retro2M
	if id = 33 then song = retro3M
	if id = 34 then song = retro4M
	if id = 35 then song = retro5M
	if id = 36 then song = retro6M
	if id = 37 then song = retro7M
	if id = 38 then song = retro8M
	if id = 39 then song = retro9M 	//Planetarium
	if id = 40 then song = retro10M //Cosmic Corner Store
	if id = 41 then song = retro11M //Takeoff
	
	if song = 0 then song = retro9M
	
endfunction song

function LoadJumpSounds()
	if GetMusicExistsOGG(jump1S) then DeleteMusicOGG(jump1S)
	if GetMusicExistsOGG(jump2S) then DeleteMusicOGG(jump2S)
	
	SetFolder("/media/sounds")
	if GetFileExists("jump" + str(crab1Type) + AltStr(crab1Alt) + ".ogg")
		LoadMusicOGG(jump1S, "jump" + str(crab1Type) + AltStr(crab1Alt) + ".ogg")
		if crab1Evil and crab1Type = 4 and crab1Alt = 3
			DeleteMusicOGG(jump1S)
			LoadMusicOGG(jump1S, "arrow.ogg")
		endif
	else
		LoadMusicOGG(jump1S, "jump" + str(crab1Type) + ".ogg")
	endif
	if GetFileExists("jump" + str(crab2Type) + AltStr(crab2Alt) + ".ogg")
		LoadMusicOGG(jump2S, "jump" + str(crab2Type) + AltStr(crab2Alt) + ".ogg")
		if crab2Evil and crab2Type = 4 and crab2Alt = 3
			DeleteMusicOGG(jump2S)
			LoadMusicOGG(jump2S, "arrow.ogg")
		endif
	else
		LoadMusicOGG(jump2S, "jump" + str(crab2Type) + ".ogg")
	endif
endfunction

function LoadBaseImages()
	
	SetFolder("/media/fonts")
	
	LoadImage(fontSpecialI, "fontSpecial.png")
	LoadImage(fontDescI, "fontDesc.png")
	LoadImage(fontDescItalI, "fontDescItal.png")
	LoadImage(fontCrabI, "fontCrab.png")
	LoadImage(fontScoreI, "ScoreFont.png")
	LoadImage(fontTitleScreenI, "fontTitleScreen.png")
	
	//#constant fontDesc 2
	
	SetFolder("/media")
	
	//The lives
	//for i = 1 to 6
		//Only loading in the base life images
		//LoadImage(crab1life1I + (i-1)*3, "crab" + str(i) + "life1.png")
	//next i
	
	for i = 0 to 41
		if GetFileExists("musicBanners/banner" + Str(i) + ".png")
			LoadImage(banner1I+i, "musicBanners/banner" + Str(i) + ".png")
		endif
	next i
	
	//Old way of load lives (all of them)
//~	for i = 1 to 6
//~			for j = 1 to 3
//~				LoadImage(crab1life1I - 1 + j + (i-1)*3, "crab" + str(i) + "life" + str(j) + ".png")
//~			next j
//~	next i
	
	SetFolder("/media/envi")
	size# = 1
	if dispH = 0 then size# = .5
	LoadImageResized(bg1I, "bg1.png", size#, size#, 0)
	LoadImageResized(bg2I, "bg2.png", size#, size#, 0)
	LoadImageResized(bg3I, "bg3.png", size#, size#, 0)
	LoadImageResized(bg4I, "bg4.png", size#, size#, 0)
	LoadImageResized(bg5I, "bg5.png", size#, size#, 0)
	LoadImageResized(bg6I, "bg6.png", size#, size#, 0)
	LoadImageResized(bg7I, "bg7.png", size#, size#, 0)
	LoadImageResized(bg8I, "bg8.png", size#, size#, 0)
	LoadImageResized(bg9I, "bg9.png", size#, size#, 0)
	LoadImageResized(bgPI, "pauseForeground.png", size#, size#, 0)
	LoadImage(bgRainSwipeI, "rainbowSwipe.png")
	
	LoadImage(starParticleI, "starParticle.png")
	
	for i = special4s1 to special4s8
		LoadImage(i, "ravespprop" + str(i - special4s1 + 1) + ".png")
	next i
	
	LoadImage(crabpingI, "crabPing.png")
	
	for i = 1 to 6
		for j = 0 to 3
			jumpPartI[i, j] = jumpPartI1 - 1 + i + j*10
			if GetFileExists("jumpP" + str(i) + AltStr(j) + ".png")
				LoadImage(jumpPartI[i, j], "jumpP" + str(i) + AltStr(j) + ".png")
			else
				LoadImage(jumpPartI[i, j], "jumpP" + str(i) + ".png")
			endif
		next j
	next i
	
	LoadImage(attackPartI, "attackParticle.png")
	LoadImage(attackPartInvertI, "attackParticleInvert.png")
	
	//Setting up the planet image indexes for later
	//for i = 1 to planetITotalMax
	//	planetVarI[i] = 400 + i
	//next i
	
	
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
	
	LoadImage(mAlt1I, "mAlt1.png")
	LoadImage(mAlt2I, "mAlt2.png")
	LoadImage(mAlt3I, "mAlt3.png")
	LoadImage(mAlt4I, "mAlt4.png")
	LoadImage(mAlt5I, "mAlt5.png")
	LoadImage(mAlt6I, "mAlt6.png")
	LoadImage(mAlt7I, "mAlt7.png")
	LoadImage(mAlt8I, "mAlt8.png")
	LoadImage(mAlt9I, "mAlt9.png")
	
	LoadImage(mAlt2aI, "mAlt2a.png")
			
	SetFolder("/media/ui")
	
	LoadImage(logoI, "vslogo.png")
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
	
endfunction

function LoadSelectCrabImages()
	SetFolder("/media/art")
	if dispH then scale# = 1
	if dispH = 0 then scale# = .5
	for i = 0 to NUM_CRABS-1 + spActive*STORY_CS_BONUS 
		crabRefType = Mod(i, 6)+1
		crabRefAlt = (i)/6
		for j = 1 to 6
			img = LoadImageResizedR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "select" + Str(j) + ".png", .25)
			//img = LoadImageResizedR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "sheet.png", scale#)
			//img = LoadImageResizedR("crab" + str(crabRefType) + AltStr(crabRefAlt) + "sheet.png", 1)
			//Regular size is 3510 by 2140
			//ResizeImage(img, 3510, 2140)
			//702 by 428
			if j = 1 then IMG_CS_CRAB[i] = img
		next j
	next i
endfunction

function LoadGameImages(loading)
	
	if loading
		//Loading all of the images
		
		SetFolder("/media/envi")
		
		LoadImage(meteorI1, "meteor1.png")
		LoadImage(meteorI2, "meteor2.png")
		LoadImage(meteorI3, "meteor3.png")
		LoadImage(meteorI4, "meteor4.png")
		LoadImage(meteorTractorI, "tractor.png")

		
		//The dynamic crab loader!
		for i = 1 to 2
			
			SetFolder("/media/crabs")
			
			crabType = crab2Type
			alt$ = AltStr(crab2Alt) //crab2Alt
			
			if i = 1
				if (crab1type = crab2type) and (crab1alt = crab2alt) //TODO: Add alternate checker here
					//The same crab
					//i = 2
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
				
				evilS$ = ""
				if i = 1 and crab1evil then evilS$ = "2"
				if i = 2 and crab2evil then evilS$ = "2"
				file$ = "crab" + str(crabType) + alt$ + evilS$ + act$ + str(j+num) + ".png"
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
			file$ = "crab" + str(crabType) + alt$ + evilS$ + "attack1.png"
			if GetFileExists(file$)
				LoadImage(index, file$)
			else
				LoadImage(index, "white.png")
			endif
			file$ = "crab" + str(crabType) + alt$ + evilS$ + "attack2.png"
			if GetFileExists(file$)
				LoadImage(index+10, file$)
			else
				LoadImage(index+10, "white.png")
			endif
			file$ = "crab" + str(crabType) + alt$ + evilS$ + "attack3.png"
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
				file$ = "crab" + str(crabType) + alt$ + evilS$ + "life" + str(k) + ".png"
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
		
		//for i = 1 to planetIMax
		//	DeleteImage(planetVarI[i])
		//next i
		//for i = 1 to planetITotalMax - planetIMax
		//	DeleteImage(planetVarI[planetIMax + i])
		//next i
		
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

global crabPause1 as string[6]
global crabPause2 as string[25]

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
	crabPause2[6] = "Special: Shuri-Krustacean" + chr(10) + "Fling deadly projecticles" + chr(10) + "directly through the screen."
	crabPause2[7] = "Special: Mad-eor Shower" + chr(10) + "Call Angry Ned to rain down" + chr(10) + "fast meteors on your opponent."
	crabPause2[8] = "Special: Royal Order" + chr(10) + "Order shrimp to fire three" + chr(10) + "rounds of canons on your enemy."
	crabPause2[9] = "Special: Stardust Spinout" + chr(10) + "Twists the opponent to make" + chr(10) + "all of their stuff spinout."
	crabPause2[10] = "Special: Crab-stalgia" + chr(10) + "Obscure your opponent's vision" + chr(10) + "with memories of the past."
	crabPause2[11] = "Special: Hourglass Curse" + chr(10) + "Speed up your enemy's" + chr(10) + "game with a cursed artifact."
	crabPause2[12] = "Special: Claw-Ball Toss" + chr(10) + "Fling flaming projecticles" + chr(10) + "directly through the screen."
	crabPause2[13] = "Special: Termination Claws" + chr(10) + "Incite The Law to catch" + chr(10) + "your opponent off gaurd."
	crabPause2[14] = "Special: Meteor Math" + chr(10) + "Send dangerous numbers to" + chr(10) + "the opposite screen."
	crabPause2[15] = "Special: Tail Chase" + chr(10) + "Makes the oppenent dizzy," + chr(10) + "spinning all of their stuff."
	crabPause2[16] = "Special: Ride the Wave" + chr(10) + "Obscure your opponent's vision" + chr(10) + "with gnarly beach waves."
	crabPause2[17] = "Special: Double Time" + chr(10) + "Speed up your opponent's" + chr(10) + "tempo, doubling their speed."
	crabPause2[18] = "Special: Heart Blast!!" + chr(10) + "Send deadly love bombs" + chr(10) + "directly through the screen."
	crabPause2[19] = "Special: Blackest Hole" + chr(10) + "Rip meteors from a black" + chr(10) + "hole, and onto your opponent."
	crabPause2[20] = "Special: Summon the Storm" + chr(10) + "Send meteors raining down" + chr(10) + "to your opponent's planet."
	crabPause2[21] = "Special: See You Later" + chr(10) + "He was a punk, she did ballet," + chr(10) + "this spins your opponent away."
	crabPause2[22] = "Special: Heavenly Light" + chr(10) + "Blind your adversary with" + chr(10) + "the power of holy glow."
	crabPause2[23] = "Special: Birthday Blast" + chr(10) + "Make your opponent age quicker," + chr(10) + "doubling their speed."
	crabPause2[24] = "Special: Shrimp Sorcery" + chr(10) + "Blast mythical shrimp" + chr(10) + "directly through the screen."
	crabPause2[25] = "Special: Devilish Light" + chr(10) + "Blind your adversary with" + chr(10) + "the devil's influence."
	//crabPause2[] = "Special: " + chr(10) + "" + chr(10) + ""
endfunction

function GetSpecialName(crabNum)
	name$ = ""
	if len(crabPause2[crabNum]) <> 0
		name$ = Mid(GetStringToken(crabPause2[crabNum], chr(10), 1), 10, -1)
	endif
endfunction name$

global chapterTitle as string[25]
global chapterDesc as string[25]

function SetStoryShortStrings()
	chapterTitle[1] = "The Idea"
	chapterDesc[1] = "After an unfortunate event," + chr(10) + "a chance encounter leads" + chr(10) + "Space Crab down a path" + chr(10) + "he never expected!"
	
	chapterTitle[2] = "The Strategy"
	chapterDesc[2] = "To fill out the founding" + chr(10) + "members of the Star Seekers," + chr(10) + "Ladder Wizard seeks the most" + chr(10) + "powerful crabs he can find."
	
	chapterTitle[3] = "The Fan"
	chapterDesc[3] = "Something big has happened" + chr(10) + "in the galaxy, and the" + chr(10) + "#1 Fan Crab is sure it's" + chr(10) + "because of Space Crab!"
	
	chapterTitle[4] = "The Trainee"
	chapterDesc[4] = "Top Crab is eager to prove" + chr(10) + "his worth, but does he" + chr(10) + "even HAVE worth?" + chr(10) + "Let's find out!"
	
	chapterTitle[5] = "Political Influence"
	chapterDesc[5] = "Royalty, meddling in the" + chr(10) + "affairs of commoners?" + chr(10) + "It's a thankless job, and" + chr(10) + "he won't let you forget it."
	
	chapterTitle[6] = "The Adventurer"
	chapterDesc[6] = "Daring escapes!" + chr(10) + "Multiplying meteors!" + chr(10) + "It's all here, and more!" + chr(10) + ""
	
	chapterTitle[7] = "The Transport"
	chapterDesc[7] = "Does Taxi Crab have" + chr(10) + "what it takes to" + chr(10) + "'roll' with the youth" + chr(10) + "of today?"
	
	chapterTitle[8] = "The Vacation"
	chapterDesc[8] = "Experience the luxaries of" + chr(10) + "the Garra Bonito with the" + chr(10) + "galaxy's 'Most Likely to" + chr(10) + "Take a Vacation'!"
	
	chapterTitle[9] = "The Physical Fitness"
	chapterDesc[9] = "The life of an athlete never" + chr(10) + "ends, especially with the" + chr(10) + "planetary marathon's" + chr(10) + "approaching start date."
	
	chapterTitle[10] = "Mister Music"
	chapterDesc[10] = "Sound check, one, two." + chr(10) + "Rock Lobster's got a new" + chr(10) + "set, and you've got" + chr(10) + "front row seats."
	
	chapterTitle[11] = "The History"
	chapterDesc[11] = "A generational legacy" + chr(10) + "comes to a head after" + chr(10) + "family gets involved." + chr(10) + ""
	
	chapterTitle[12] = "The Cosmic Cook"
	chapterDesc[12] = "'Space Crab placed an order?" + chr(10) + "With ME? That must" + chr(10) + "be a prank. Throw that" + chr(10) + "one in the trash.'"
	
	chapterTitle[13] = "Single & Mingling"
	chapterDesc[13] = "Cranime Wants to Indulge /" + chr(10) + "Crabacus Makes a Choice / " + chr(10) + "Cranime Finds Love Pt. 1 /" + chr(10) + "Cranime Finds Love Pt. 2"
	
	chapterTitle[14] = "The Calculator?"
	chapterDesc[14] = "It's the opening day" + chr(10) + "of the Star Seekers!" + chr(10) + "But is it everything" + chr(10) + "that was promised...?"
	
	chapterTitle[15] = "The Party...?"
	chapterDesc[15] = "Rave Crab's eternal" + chr(10) + "party may end sooner" + chr(10) + "than anticipated." + chr(10) + ""
	
	chapterTitle[16] = "Voice of Reason"
	chapterDesc[16] = "'SOMEONE'S GOTTA PUT" + chr(10) + "SPACE CRAB IN HIS" + chr(10) + "PLACE, AND I DON'T" + chr(10) + "SEE THEM STEPPING UP!!'"
	
	chapterTitle[17] = "The Eye-in-the-Sky"
	chapterDesc[17] = "Answering a prayer from" + chr(10) + "below, Holy Crab descends" + chr(10) + "to help the lost crabs" + chr(10) + "find their way."
	
	chapterTitle[18] = "Crab Resources Dept."
	chapterDesc[18] = "'Dealing with the consequences" + chr(10) + "of your actions? Al Legal is" + chr(10) + "here to get it all in writing." + chr(10) + "Just need you to sign here.'"
	
	chapterTitle[19] = "Other Side of the Paw"
	chapterDesc[19] = "Let's hear what Space Barc" + chr(10) + "has to say about all this!" + chr(10) + "There's gotta be something" + chr(10) + "in that little dog brain."
	
	chapterTitle[20] = "The Valiant Defender"
	chapterDesc[20] = "An evil force is rising." + chr(10) + "Will Crabyss Knight be" + chr(10) + "able to locate and stop" + chr(10) + "it in time?"
	
	chapterTitle[21] = "The Starlight Rival"
	chapterDesc[21] = "The sceme has been revealed!" + chr(10) + "Will Chrono Crab pull off" + chr(10) + "his master plot, and best" + chr(10) + "his Starlight Rival?"
	
	chapterTitle[22] = "Fight for the Future!"
	chapterDesc[22] = "With the Star Seekers united," + chr(10) + "Space Crab is left to deal" + chr(10) + "with one final question:" + chr(10) + "What happens next?"
	
	chapterTitle[23] = "Bonus 1: The Punk"
	chapterDesc[23] = "Many find Sk8r Crab to be" + chr(10) + "obnoxious. But will they say" + chr(10) + "the same about his song?" + chr(10) + ""
	
	chapterTitle[24] = "Bonus 2: The Jester"
	chapterDesc[24] = "This humble crab gets" + chr(10) + "more than he bargined for" + chr(10) + "when making a deal with" + chr(10) + "the devil."
	
	chapterTitle[25] = "The Future"
	chapterDesc[25] = "" + chr(10) + "The end." + chr(10) + "" + chr(10) + ""
	
endfunction

function PlayVoice(vID, crabT, crabA, evil)
	if GetMusicExistsOGG(vID) then StopMusicOGGSP(vID)
	SetFolder("/media/sounds/announcer")
	bonus$ = "1"
	if Random(1, 5) = 5 then bonus$ = "2"
	evil$ = ""
	if evil then evil$ = "2"
	LoadMusicOGG(vID, "crab" + Str(crabT) + AltStr(crabA) + evil$ + bonus$ + ".ogg")
	PlayMusicOGG(vID, 0)
	SetMusicVolumeOGG(vID, volumeSE)
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

Old crab stat value setting
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
	
	if crab2Type = 1		//Space
		//for i = crab1start1I to crab1skid3I
			//AddSpriteAnimationFrame(crab2, i)
		//next i
		crab2framerate = frameratecrab1
		specialCost2 = specialPrice1
		crab2Vel# = 1.28
		crab2Accel# = .1
		crab2JumpHMax# = 5
		crab2JumpSpeed# = 1.216
		crab2JumpDMax = 28
		
	elseif crab2Type = 2	//Wizard
		crab2framerate = frameratecrab2
		specialCost2 = specialPrice2
		crab2Vel# = 1.08
		crab2Accel# = .13
		crab2JumpHMax# = 10.5
		crab2JumpSpeed# = 1.516
		crab2JumpDMax = 40
		
	elseif crab2Type = 3	//Top
		//for i = crab3start1I to crab3skid3I
			//AddSpriteAnimationFrame(crab2, i)
		//next i
		crab2framerate = frameratecrab3
		specialCost2 = specialPrice3
		crab2Vel# = 2.48
		crab2Accel# = .03
		crab2JumpHMax# = 8
		crab2JumpSpeed# = -3
		crab2JumpDMax = 32
		
	elseif crab2Type = 4	//Rave
		//for i = crab4start1I to crab4skid3I
			//AddSpriteAnimationFrame(crab2, i)
		//next i
		crab2framerate = frameratecrab4
		specialCost2 = specialPrice4
		crab2Vel# = 1.59
		crab2Accel# = .08
		crab2JumpHMax# = 10
		crab2JumpSpeed# = -1.28
		crab2JumpDMax = 43
		
	elseif crab2Type = 5	//Chrono
		//for i = crab5start1I to crab5skid3I
			//AddSpriteAnimationFrame(crab2, i)
		//next i
		crab2framerate = frameratecrab5
		specialCost2 = specialPrice5
		crab2Vel# = 1.38
		crab2Accel# = .1
		crab2JumpHMax# = 5
		crab2JumpSpeed# = -3.216
		crab2JumpDMax = 28
		
	elseif crab2Type = 6	//Ninja
		//for i = crab6start1I to crab6skid3I
			//AddSpriteAnimationFrame(crab2, i)
		//next i
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
			//AddSpriteAnimationFrame(crab2, i)
		next i
		specialCost2 = 1
	endif

		if crabType = 1 and crabAlt = 0 then SetTextString(i, "METEOR SHOWER")
		if crabType = 1 and crabAlt = 1 then SetTextString(i, "MAD-EOR SHOWER")
		if crabType = 1 and crabAlt = 2 then SetTextString(i, "TERMINATION CLAWS")
		if crabType = 2 and crabAlt = 0 then SetTextString(i, "CONJURE COMETS")
		if crabType = 2 and crabAlt = 1 then SetTextString(i, "ROYAL ORDER")
		if crabType = 2 and crabAlt = 2 then SetTextString(i, "METEOR MATH")
		if crabType = 3 and crabAlt = 0 then SetTextString(i, "ORBITAL NIGHTMARE")
		if crabType = 3 and crabAlt = 1 then SetTextString(i, "STARDUST SPINOUT")
		if crabType = 4 and crabAlt = 0 then SetTextString(i, "PARTY TIME!")
		if crabType = 4 and crabAlt = 3 then SetTextString(i, "HEAVENLY LIGHT")
		if crabType = 5 and crabAlt = 0 then SetTextString(i, "FAST FOWARD")
		if crabType = 5 and crabAlt = 1 then SetTextString(i, "HOURGLASS CURSE")
		if crabType = 6 and crabAlt = 0 then SetTextString(i, "SHURI-KRUSTACEAN")
		if crabType = 6 and crabAlt = 1 then SetTextString(i, "CLAW-BALL TOSS")

The old turn code:

P1:
true1 = 0
//if (deviceType = DESKTOP and ((GetPointerPressed() and (GetPointerY() > GetSpriteY(split) + GetSpriteHeight(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(49))) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0) then true1 = 1
if dispH and (inputTurn1 or (GetPointerPressed() and (GetPointerX() < w/2) and Hover(meteorButton1) = 0 and Hover(specialButton1) = 0 and Hover(pauseButton) = 0)) then true1 = 1
true2 = 0
if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton1) = 0 and GetMulitouchPressedButton(specialButton1) = 0 and GetMultitouchPressedBottom()) then true2 = 1
//if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton1) = 0 and GetMulitouchPressedButton(specialButton1) = 0 and GetMultitouchPressedBottom() and deviceType = MOBILE) then true2 = 1
true3 = 0
if spActive = 1 and (((GetMultitouchPressedTop() or GetMultitouchPressedBottom()) and deviceType = MOBILE) or (inputTurn1 and deviceType = DESKTOP)) and not ButtonMultitouchEnabled(pauseButton) and not ButtonMultitouchEnabled(phantomPauseButton) then true3 = 1
//Activating the crab turn at an input

P2:
true1 = 0
//if (deviceType = DESKTOP and ((GetPointerPressed() and (GetPointerY() < GetSpriteY(split))) or (GetRawKeyPressed(32) or GetRawKeyPressed(50))) and Hover(meteorButton2) = 0 and Hover(specialButton2) = 0) then true1 = 1
if dispH and (inputTurn2 or (GetPointerPressed() and (GetPointerX() > w/2) and Hover(meteorButton2) = 0 and Hover(specialButton2) = 0 and Hover(pauseButton) = 0)) then true1 = 1
true2 = 0
if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton2) = 0 and GetMulitouchPressedButton(specialButton2) = 0 and GetMultitouchPressedTop()) then true2 = 1
//if (GetMulitouchPressedButton(split) = 0 and GetMulitouchPressedButton(meteorButton2) = 0 and GetMulitouchPressedButton(specialButton2) = 0 and GetMultitouchPressedTop() and deviceType = MOBILE) then true2 = 1
true3 = 0
if spType = MIRRORMODE and (((GetMultitouchPressedTop() or GetMultitouchPressedBottom()) and deviceType = MOBILE) or (inputTurn1 and deviceType = DESKTOP)) and not ButtonMultitouchEnabled(pauseButton) then true3 = 1
//Activating the crab turn at an input

//Process AI turning
	aiTurn = 0
	if aiActive = 1 then aiTurn = AITurn()
	
	if ((trueTurn and aiActive = 0) or aiTurn = 1) and crab2JumpD# = 0

*/
