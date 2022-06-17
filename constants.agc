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

Crab types (internal):
1 - Space Crab
2 - Ladder Wizard
3 - Top Crab
4 - Rave Crab
5 - Chrono Crab
6 - Ninja Crab

*/

//Number of crabs in the game - made a constant in case we add/remove crabs
#constant NUM_CRABS 6

//Gameplay constants & variables
#constant planetSize 220
#constant metSizeX 58
#constant metSizeY 80

#constant spaceCrabTimeMax 200	//This is just for moving the UFO
#constant topCrabTimeMax 1500
#constant raveCrabTimeMax 1600
#constant chronoCrabTimeMax 2300	//Is longer because the timer goes down faster
#constant ninjaCrabTimeMax 500	

#constant hitSceneMax 300
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
global crab1JumpDMax = 28	//This variable used to be in degrees, now it's in ticks
//Original jump values: 3.5, 38

global crab1Deaths = 0
global crab1PlanetS as Integer[3]
#constant planetIconSize 40

//For the screen nudging whenever a meteor hits
global nudge1R# = 0
global nudge1Theta# = 0

global crab2R# = 1	//Same constants for crab 2
global crab2Theta# = 270
global crab2Dir# = 1
global crab2Vel# = 1.28
global crab2Accel# = .1
global crab2Turning = 0
global crab2Type = 1

global nudge2R# = 0
global nudge2Theta# = 0

global gameDifficulty1 = 1
global gameDifficulty2 = 1

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
global meteorCost1 = 1 //10
global specialCost1 = 3 //40
global specialTimerAgainst2# = 0

global expTotal2 = 0
global meteorCost2 = 1
global specialCost2 = 3
global specialTimerAgainst1# = 0

//Input buffers
global buffer1 = 0
global buffer2 = 0

global meteorSprNum = 1001
global expSprNum = 2001
global expList as Integer[0]

//Meteor type, countdown, game screen
global met1CD1# = 300
global met2CD1# = 400
global met3CD1# = 400

global met1CD2# = 300
global met2CD2# = 400
global met3CD2# = 400

#constant met1RNDLow 190		//OG: 230
#constant met1RNDHigh 300	//OG: 330
#constant met2RNDLow 300
#constant met2RNDHigh 400
#constant met3RNDLow 450
#constant met3RNDHigh 650
	
#constant metStartDistance 700

//Sprite Indexes
#constant crab1 1
#constant crab2 2
#constant split 3

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
#constant planetIRandStart 50
#constant planetVar1I 51
#constant planetVar2I 52
#constant planetVar3I 53
#constant planetVar4I 54
#constant planetVar5I 55
#constant planetVar6I 56
#constant planetVar7I 57
#constant planetVar8I 58

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
#constant raveBass1 21
#constant raveBass2 22

//Sound effects volume
global volumeM = 40
global volumeSE = 20


//Start screen sprites 
#constant SPR_TITLE 200 
#constant SPR_START 201 
 
//Character select screen sprites - player 1 
#constant SPR_CS_READY_1 300 
#constant SPR_CS_ARROW_L_1 301 
#constant SPR_CS_ARROW_R_1 302 
#constant TXT_CS_CRAB_NAME_1 303
#constant TXT_CS_CRAB_DESC_1 304 
#constant TXT_CS_READY_1 305 
#constant SPR_CS_CRABS_1 390 
 
//Character select screen sprites - player 2
#constant SPR_CS_READY_2 400
#constant SPR_CS_ARROW_L_2 401
#constant SPR_CS_ARROW_R_2 402 
#constant TXT_CS_CRAB_NAME_2 403
#constant TXT_CS_CRAB_DESC_2 404 
#constant TXT_CS_READY_2 405
#constant SPR_CS_CRABS_2 490 

// Game states
#constant START 0
#constant CHARACTER_SELECT 1
#constant GAME 2
#constant PAUSE 3
#constant RESULTS 4

type meteor
	
	spr as integer
	//Backup sprite is this + 10000
	
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
	
	
	LoadSoundOGG(exp1S, "exp1.ogg")
	LoadSoundOGG(exp2S, "exp2.ogg")
	LoadSoundOGG(exp3S, "exp3.ogg")
	LoadSoundOGG(exp4S, "exp4.ogg")
	LoadSoundOGG(exp5S, "exp5.ogg")
	
	LoadSoundOGG(ufoS, "ufo.ogg")
	LoadSoundOGG(wizardSpell1S, "wizardSpell1.ogg")
	LoadSoundOGG(wizardSpell2S, "wizardSpell2.ogg")
	LoadSoundOGG(ninjaStarS, "ninjaStar.ogg")
		
	SetFolder("/media")
	
endfunction

function LoadBaseMusic()
	SetFolder("/media/sounds")
		
	LoadMusicOGG(raveBass1, "raveBass.ogg")
	LoadMusicOGG(raveBass2, "raveBass2.ogg")
	
	SetFolder("/media")
	
	SetMusicSystemVolumeOGG(volumeM)
	
endfunction

function LoadBaseImages()
	SetFolder("/media/envi")
	
	LoadImage(planetVar1I, "planet1alt1.png")
	LoadImage(planetVar2I, "planet1alt2.png")
	LoadImage(planetVar3I, "planet1alt3.png")
	LoadImage(planetVar4I, "planet1alt4.png")
	LoadImage(planetVar5I, "planet1alt5.png")
	LoadImage(planetVar6I, "planet1alt6.png")
	LoadImage(planetVar7I, "planet1alt7.png")
	LoadImage(planetVar8I, "planet1alt8.png")
	
	LoadImage(meteorI1, "meteor1.png")
	LoadImage(meteorI2, "meteor2.png")
	LoadImage(meteorI3, "meteor3.png")
	LoadImage(meteorI4, "meteor4.png")
	LoadImage(meteorTractorI, "tractor.png")
	
	SetFolder("/media")
	
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
