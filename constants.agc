// File: constants.agc
// Created: 22-03-04


/*
Notes:

split - The middle screen bar
crab1 - The bottom crab, independent of it's costume
crab2 - The top crab, independent of it's costume

Depth List:

Crab - 3
Ninja stars - 4
Planets for Lives - 5
Clock Hands - 6
Clock - 7
EXP - 7
Planets - 8
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

#constant MOBILE 1
#constant DESKTOP 2

//The timer for the starting screen
global startTimer# = 0

//Number of crabs in the game - made a constant in case we add/remove crabs
#constant NUM_CRABS 6

//Gameplay constants & variables
#constant planetSize 220
#constant metSizeX 58
#constant metSizeY 80

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

#constant hitSceneMax 240
global hit1Timer# = 0
global hit2Timer# = 0

global gameTimer# = 0

global crab1R# = 1
global crab1Rdefault# = 1
global crab1Theta# = 270
global crab1framerate = 10
global crab1Dir# = 1		//Crab dir is a float that goes from 1 to -1, it multiplies the speed
global crab1Vel# = 1.28
global crab1Accel# = .1	//Is .1 because it takes 2 to reach full reversal, and original game timer was 20
global crab1Turning = 0 	//Is zero for when the crab isn't turning, and 1 or -1 depending on the direction it is CHANGING TO
global crab1Type = 1
global crab1JumpD# = 0
global crab1JumpHMax# = 5
global crab1JumpSpeed# = 1.216
global crab1JumpDMax = 28	//This variable used to be in degrees, now it's in ticks
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
global crab2Type = 6
global crab2JumpD# = 0
global crab2JumpHMax# = 5
global crab2JumpSpeed# = 1.216
global crab2JumpDMax = 28	//This variable used to be in degrees, now it's in ticks

global crab2Deaths = 0
global crab2PlanetS as Integer[3]

global nudge2R# = 0
global nudge2Theta# = 0

global gameDifficulty1 = 1
global gameDifficulty2 = 1
global difficultyBar = 10	//The amount of meteors it takes to make the difficulty go up

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

//Sprite Indexes
#constant crab1 1
#constant crab2 2
#constant split 3

#constant bgGame1 4
#constant bgGame2 5
#constant bgHit1 6
#constant bgHit2 7

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
#constant specialSprFront2 133
#constant specialSprBack2 134

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

//Image Indexes

#constant fontSpecialI 1
#constant fontDescI 2	//Tahoma
#constant fontDescItalI 4	//Tahoma (Italicized)
#constant fontCrabI 3	//Somerset Barnyard

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

#constant crab6life1I 386
#constant crab6life2I 387
#constant crab6life3I 388

#constant crab1attack1I 21
#constant crab2attack1I 22
#constant crab3attack1I 23
#constant crab4attack1I 24
#constant crab5attack1I 25
#constant crab6attack1I 26

#constant crab1attack2I 31
#constant crab2attack2I 32
#constant crab3attack2I 33
#constant crab4attack2I 34
#constant crab5attack2I 35
#constant crab6attack2I 36

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

#constant meteorGlowI 86

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


//Planets images are 401 to 430
#constant planetIMax 23
#constant planetITotalMax 29
global planetVarI as Integer[planetITotalMax]

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

//Sound Indexes
#constant turnS 1
#constant jumpS 2
#constant specialS 3
#constant specialExitS 4
#constant explodeS 5
#constant launchS 6
#constant crackS 7
#constant flyingS 8
#constant landingS 9
#constant arrowS 10
#constant chooseS 16

#constant exp1S 11
#constant exp2S 12
#constant exp3S 13
#constant exp4S 14
#constant exp5S 15

#constant ufoS 21
#constant wizardSpell1S 22
#constant wizardSpell2S 23
#constant ninjaStarS 24



//Music Indexes
#constant titleMusic 101
#constant characterMusic 102
#constant endMusic 103

#constant fightAMusic 104	//Andy's fight song
#constant fightBMusic 105	//Brad's fight song
#constant fightJMusic 106	//John's fight song

#constant raveBass1 121
#constant raveBass2 122
#constant fireMusic 123

//Volume for music and sound effects
global volumeM = 60
global volumeSE = 40

SetMusicSystemVolumeOGG(volumeM)

//Start screen sprites 
#constant SPR_TITLE 200 
#constant SPR_START1 201
#constant SPR_START2 203
#constant SPR_BG_START 202
#constant SPR_START1P 204

//Different Crab buttons for the single player mode
#constant SPR_STARTC1 205
#constant SPR_STARTC2 206
#constant SPR_STARTC3 207
#constant SPR_STARTC4 208
#constant SPR_STARTC5 209
#constant SPR_STARTC6 210

#constant SPR_STARTMM 211

 
//Character select screen sprites - player 1 
#constant SPR_CS_READY_1 300 
#constant SPR_CS_ARROW_L_1 301 
#constant SPR_CS_ARROW_R_1 302 
#constant SPR_CS_BG_1 306
#constant TXT_CS_CRAB_NAME_1 303
#constant TXT_CS_CRAB_DESC_1 304 
#constant TXT_CS_READY_1 305 
#constant SPR_CS_CRABS_1 390
#constant SPR_CS_TXT_BACK_1 389
 
//Character select screen sprites - player 2
#constant SPR_CS_READY_2 400
#constant SPR_CS_ARROW_L_2 401
#constant SPR_CS_ARROW_R_2 402 
#constant SPR_CS_BG_2 406
#constant TXT_CS_CRAB_NAME_2 403
#constant TXT_CS_CRAB_DESC_2 404 
#constant TXT_CS_READY_2 405
#constant SPR_CS_CRABS_2 490 
#constant SPR_CS_TXT_BACK_2 489

// Game states
#constant START 0
#constant CHARACTER_SELECT 1
#constant GAME 2
#constant PAUSE 3
#constant RESULTS 4

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
	
	LoadSoundOGG(turnS, "turn.ogg")
	LoadSoundOGG(jumpS, "jump.ogg")
	LoadSoundOGG(specialS, "special.ogg")
	LoadSoundOGG(specialExitS, "specialExit.ogg")
	LoadSoundOGG(explodeS, "explode.ogg")
	LoadSoundOGG(launchS, "launch.ogg")
	LoadSoundOGG(crackS, "crack.ogg")
	LoadSoundOGG(flyingS, "flying.ogg")
	LoadSoundOGG(landingS, "landing.ogg")
	LoadSoundOGG(arrowS, "arrow.ogg")
	LoadSoundOGG(chooseS, "choose.ogg")
	
	
	LoadSoundOGG(exp1S, "exp1.ogg")
	LoadSoundOGG(exp2S, "exp2.ogg")
	LoadSoundOGG(exp3S, "exp3.ogg")
	LoadSoundOGG(exp4S, "exp4.ogg")
	LoadSoundOGG(exp5S, "exp5.ogg")
	
	LoadSoundOGG(ufoS, "ufo.ogg")
	LoadSoundOGG(wizardSpell1S, "wizardSpell1.ogg")
	LoadSoundOGG(wizardSpell2S, "wizardSpell2.ogg")
	LoadSoundOGG(ninjaStarS, "ninjaStar.ogg")
	
	
	//Have to load them all in AGAIN as music, thanks dumb android sound threads ):<
	if GetDeviceBaseName() = "android"
		LoadMusicOGG(turnS, "turn.ogg")
		LoadMusicOGG(jumpS, "jump.ogg")
		LoadMusicOGG(specialS, "special.ogg")
		LoadMusicOGG(specialExitS, "specialExit.ogg")
		LoadMusicOGG(explodeS, "explode.ogg")
		LoadMusicOGG(launchS, "launch.ogg")
		LoadMusicOGG(crackS, "crack.ogg")
		LoadMusicOGG(flyingS, "flying.ogg")
		LoadMusicOGG(landingS, "landing.ogg")
		LoadMusicOGG(arrowS, "arrow.ogg")
		LoadMusicOGG(chooseS, "choose.ogg")
		
		
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

function LoadBaseMusic()
	SetFolder("/media/music")
	
	LoadMusicOGG(fightAMusic, "fightA.ogg")
	LoadMusicOGG(characterMusic, "character.ogg")
	
	LoadMusicOGG(raveBass1, "raveBass.ogg")
	LoadMusicOGG(raveBass2, "raveBass2.ogg")
	LoadMusicOGG(fireMusic, "fire.ogg")
	
	SetFolder("/media")
	
	SetMusicSystemVolumeOGG(volumeM)
	
endfunction

function LoadBaseImages()
	
	SetFolder("/media/fonts")
	
	LoadImage(fontSpecialI, "fontSpecial.png")
	LoadImage(fontDescI, "fontDesc.png")
	LoadImage(fontDescItalI, "fontDescItal.png")
	LoadImage(fontCrabI, "fontCrab.png")
	
	//#constant fontDesc 2
	
	SetFolder("/media/art")
	
	//Loading the start screen images
	for i = 1 to 6
		if i = 1 or i = 2 or i = 6
			for j = 1 to 6
				LoadImage(crab1select1I - 1 + j + i*10, "crab" + str(i) + "select" + str(j) + ".png")
			next j
		endif
	next i
	
	//LoadImage(crab1select1I, "crab1select.png")
	//LoadImage(crab2select1I, "crab2select.png")
	
	LoadImage(crab1attack1I, "crab1attack1.png")
	LoadImage(crab1attack2I, "crab1attack2.png")
	LoadImage(crab2attack1I, "crab2attack1.png")
	LoadImage(crab2attack2I, "crab2attack2.png")
	LoadImage(crab6attack1I, "crab6attack1.png")
	LoadImage(crab6attack2I, "crab6attack2.png")
	
	//The lives
	for i = 1 to 6
		if i = 1 or i = 2 or i = 6
			for j = 1 to 3
				LoadImage(crab1life1I - 1 + j + (i-1)*3, "crab" + str(i) + "life" + str(j) + ".png")
			next j
		endif
	next i
	
	
	
	SetFolder("/media/envi")
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

	for i = 1 to planetITotalMax
		planetVarI[i] = 400 + i
	next i
	for i = 1 to planetIMax
		LoadImage(planetVarI[i], "p" + str(i) + ".png")
	next i
	for i = 1 to planetITotalMax - planetIMax
		LoadImage(planetVarI[planetIMax + i], "legendp" + str(i) + ".png")
	next i
	
	LoadImage(meteorI1, "meteor1.png")
	LoadImage(meteorI2, "meteor2.png")
	LoadImage(meteorI3, "meteor3.png")
	LoadImage(meteorI4, "meteor4.png")
	LoadImage(meteorTractorI, "tractor.png")
	
	LoadImage(bg1I, "bg1.png")
	LoadImage(bg2I, "bg2.png")
	LoadImage(bg3I, "bg3.png")
	LoadImage(bg4I, "bg4.png")
	LoadImage(bg5I, "bg5.png")
	
	SetFolder("/media")
	
	LoadImage(meteorGlowI, "glow.png")
	
	LoadImage(expOrbI, "exp.png")
	LoadImage(expBarI1, "expBar1.png")
	LoadImage(expBarI2, "expBar2.png")
	LoadImage(expBarI3, "expBar3.png")
	LoadImage(expBarI4, "expBar4.png")
	LoadImage(expBarI5, "expBar5.png")
	LoadImage(expBarI6, "expBar6.png")
	
	SetFolder("/media/crabs")
	
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
	
	LoadImage(crab2start1I, "crab2start1.png")
	LoadImage(crab2start2I, "crab2start2.png")
	LoadImage(crab2walk1I, "crab2walk1.png")
	LoadImage(crab2walk2I, "crab2walk2.png")
	LoadImage(crab2walk3I, "crab2walk3.png")
	LoadImage(crab2walk4I, "crab2walk4.png")
	LoadImage(crab2walk5I, "crab2walk5.png")
	LoadImage(crab2walk6I, "crab2walk6.png")
	LoadImage(crab2walk7I, "crab2walk7.png")
	LoadImage(crab2walk8I, "crab2walk8.png")
	LoadImage(crab2jump1I, "crab2jump1.png")
	LoadImage(crab2jump2I, "crab2jump2.png")
	LoadImage(crab2death1I, "crab2death1.png")
	LoadImage(crab2death2I, "crab2death2.png")
	
	LoadImage(crab6start1I, "crab6start1.png")
	LoadImage(crab6start2I, "crab6start2.png")
	LoadImage(crab6walk1I, "crab6walk1.png")
	LoadImage(crab6walk2I, "crab6walk2.png")
	LoadImage(crab6walk3I, "crab6walk3.png")
	LoadImage(crab6walk4I, "crab6walk4.png")
	LoadImage(crab6walk5I, "crab6walk5.png")
	LoadImage(crab6walk6I, "crab6walk6.png")
	LoadImage(crab6walk7I, "crab6walk7.png")
	LoadImage(crab6walk8I, "crab6walk8.png")
	LoadImage(crab6jump1I, "crab6jump1.png")
	LoadImage(crab6jump2I, "crab6jump2.png")
	LoadImage(crab6death1I, "crab6death1.png")
	LoadImage(crab6death2I, "crab6death2.png")
	
	
	SetFolder("/media")
	
	LoadImage(boarderI, "boader.png")
	LoadImage(ufoI, "spaceNed.png")
	LoadImage(ninjaStarI, "ninjaStar.png")
	
endfunction

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


*/