// File: constants.agc
// Created: 22-03-04


/*
Notes:

split - The middle screen bar
crab1 - The bottom crab, independent of it's costume
crab2 - The top crab, independent of it's costume

Depth List:

Asteroid belt - 10
Meteors - 20
Behind image for fast meteors - 30

*/

//Gameplay constants & variables
#constant planetSize 220
#constant metSizeX 50
#constant metSizeY 70

global crab1Theta# = 270
global crab1Dir# = 1		//Crab dir is a float that goes from 1 to -1, it multiplies the speed
global crab1Vel# = 1.28
global crab1Accel# = .1	//Is .1 because it takes 2 to reach full reversal, and original game timer was 20
global crab1Turning = 0 	//Is zero for when the crab isn't turning, and 1 or -1 depending on the direction it is CHANGING TO

global crab2Theta# = 270 // Same constants for crab 2
global crab2Dir# = 1
global crab2Vel# = 1.28
global crab2Accel# = .1
global crab2Turning = 0

global meteorQueue1 as meteor[0]
global meteorQueue2 as meteor[0]
global meteorActive1 as meteor[0]
global meteorActive2 as meteor[0]

global expTotal1 = 0
global specialCost1 = 100

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

//Sprite Indexes
#constant crab1 1
#constant crab2 2
#constant split 3

#constant planet1 101
#constant planet2 102

#constant expBar1 111
#constant expHolder1 112
#constant meteorButton1 113
#constant specialButton1 114

#constant expBar2 121
#constant expHolder2 122
#constant meteorButton2 123
#constant specialButton2 124

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
	
	SetFolder("/media")
	
	LoadImage(expOrbI, "exp.png")
	LoadImage(expBarI1, "expBar1.png")
	LoadImage(expBarI2, "expBar2.png")
	LoadImage(expBarI3, "expBar3.png")
	LoadImage(expBarI4, "expBar4.png")
	LoadImage(expBarI5, "expBar5.png")
	LoadImage(expBarI6, "expBar6.png")
	
	
endfunction
