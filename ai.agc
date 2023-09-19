// File: ai.agc
// Created: 23-02-13
//#include "game2.agc"

global turnCooldown# = 0
global thinkCooldown# = 0

global printAI = 0

#constant turnCooldownVeryHard = 60
#constant turnCooldownHard = 90
#constant turnCooldownMedium = 120
#constant turnCooldownEasy = 180
global turnCooldownMax# = turnCooldownMedium // number of ticks (1/60 of a second) after a turn during which the AI does not think

#constant randomJumpVeryHard = 1
#constant randomJumpHard = 25
#constant randomJumpMedium = 50
#constant randomJumpEasy = 75
global randomJumpPercent = randomJumpMedium // chance out of 100 that the crab will jump when given the opportunity to (except normal crab :))

#constant randomThinkTicksVeryHard = 18000000
#constant randomThinkTicksHard = 1800
#constant randomThinkTicksMedium = 600
#constant randomThinkTicksEasy = 60
global randomThinkTicksApplied = randomThinkTicksMedium // average number of ticks between failed attempts to think

#constant thinkCooldownVeryHard = 60
#constant thinkCooldownHard = 90
#constant thinkCooldownMedium = 120
#constant thinkCooldownEasy = 180
global thinkCooldownMax# = thinkCooldownMedium // number of ticks before the AI can think again after failing

#constant randomTurnVeryHard = 1
#constant randomTurnHard = 25
#constant randomTurnMedium = 50
#constant randomTurnEasy = 75
global randomTurnPercent = randomTurnMedium // chance out of 100 that the crab will turn when not thinking

global specialInterval# = 60 // number of ticks between attempts to use special / meteor attack
global specialTimer# = 0 // timer used to perform special attacks
global meteorsPerSpecial# = 2 // number of times meteor attack will be used before using special attack
global meteorsUsed# = 0 // number of meteor attacks used since last special attack
global doJump = 0 // flag set when crab should "double tap" the turn input in order to perform a jump action instead

global knowingAI = 0

function SetAIDifficulty(turner, idiot, leaper, clumsy, knowing)
	turnCooldownMax# = 240 - (knowing+1)*18
	randomThinkTicksApplied = 60 + idiot*150 + (Min(idiot, 3)-3)*200 + (Min(idiot, 7)-7)*5000
	randomJumpPercent = 5 + leaper*10
	randomTurnPercent = 5 + clumsy*10
	thinkCooldownMax# = 240 - (knowing+1)*18
endfunction

function AITurn()
	// jump case, reset the flag then force a tap input that should trigger a jump, since all doJump flag set cases are preceded by a doTurn
	if doJump
		doJump = 0
		exitFunction 1
	endif
	// return var
	doTurn = 0
	
	// need to not be turning and ready to think
	if turnCooldown# < 1 and thinkCooldown# < 1
		// 1/randomThinkTicksApplied chance to not perform an accurate hit prediction
		if Random(1, randomThinkTicksApplied*fpsr#) > 1
			doTurn = PredictHit(ScreenFPS() / 2.0) // half a second when adjusted via fpsr
			// if not normal crab, sometimes queue a jump instead of just a turn
			if doTurn and not crab2Type = 1 and Random(1, 100) <= randomJumpPercent
				doJump = 1
			endif
		else
			// stop thinking for a bit
			thinkCooldown# = thinkCooldownMax#/fpsr#
			// randomly turn sometimes when starting to not think
			if Random(1, 100) <= randomTurnPercent
				//Print("Not thinking, but turning!")
				doTurn = 1
				// normal crab should jump to gain distance and grab more pellets often, so have it jump randomly instead of turning
				if (crab2Type = 1) or (crab2Type <> 1 and Random(1, 100) <= randomJumpPercent)
					doJump = 1
				endif				
			endif
		endif
	else
		// decrement the cooldowns
		inc turnCooldown#, -1
		inc thinkCooldown#, -1	
	endif
	
	if printAI then Print("Turn timer")
	if printAI then Print(turnCooldown#)
	if printAI then Print("Think timer")
	if printAI then Print(thinkCooldown#)
	
	//Logic for the AI turn is processed here
	//If doing a turn, then doTurn is set to 1 (it is the return variable)
	
	// prevent chain-turning for a bit when a turn is about to occur
	if doTurn
		if printAI then Print("Starting Turn Cooldown")
		turnCooldown# = turnCooldownMax#/fpsr#
	endif
	
endfunction doTurn

function PredictHit(framesAhead#)
	// translate frames into a time based value to work with speed vars
	timeAhead# = framesAhead# * fpsr#
	// cut down prediction timing when under effects of chrono and rave specials
	if (crab1Type = 4 or crab1Type = 5) and specialTimerAgainst2# > 0
		timeAhead# = timeAhead# / 2
	endif
		
	//Print("Inside PredictHit")
	// return flag
	collisionPredicted = 0
	// calculate crab's future theta
	futureCrab2Theta# = crab2Theta# + crab2Vel# * crab2Dir# * timeAhead# + planet2RotSpeed#
	//Print("Future Crab Radius")
	//Print(crab2R#)
	//Print("Future Crab Theta")
	//Print(futureCrab2Theta#)
	// loop through each active meteor
	for i = 1 to meteorActive2.length
		// vars for holding a meteor's future radius and theta
		futureMeteorR# = meteorActive2[i].r
		futureMeteorTheta# = meteorActive2[i].theta
		//Print("Meteor Radius")
		//Print(futureMeteorR#)
		//Print("Meteor Theta")
		//Print(futureMeteorTheta#)
		// meteor's categoy
		cat = meteorActive2[i].cat
		//Print("Meteor Category")
		//Print(cat)
		// perform future radius/theta calcs based on type of meteor and passed number of frames ahead we are looking
		if cat = 1	//Normal meteor
			if printAI then Print("Normal Meteor")
			futureMeteorR# = meteorActive2[i].r - met1speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#
		elseif cat = 2 //Rotating meteor
			if printAI then Print("Rotating Meteor")
			futureMeteorR# = meteorActive2[i].r - met2speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#
			futureMeteorTheta# = meteorActive2[i].theta + 1*timeAhead#
		elseif cat = 3 // fast meteor
			if printAI then Print("Fast Meteor")
			futureMeteorR# = meteorActive2[i].r - met3speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#		
		endif
		//Print("Future Meteor Radius")
		//Print(futureMeteorR#)
		//Print("Future Meteor Theta")
		//Print(futureMeteorTheta#)
		// calculate distance between future crab and future meteor to determine if a collision would be imminent
		distance# = sqrt( crab2R# * crab2R# + futureMeteorR# * futureMeteorR# - 2 * crab2R# * futureMeteorR# * cos( futureCrab2Theta# - futureMeteorTheta# ) )
		if printAI then Print("Distance between crab and a meteor")
		if printAI then Print(distance#)
		// check for closeness
		if distance# < 50
			if printAI then Print("Danger Close")
			collisionPredicted = 1
			exit
		endif
	next i
	// suplementary checks against ninja stars
	if crab1Type = 6 and specialTimerAgainst2# > 0 and not collisionPredicted
		// translate to planar
		futureCrab2X# = crab2R#* cos(futureCrab2Theta#) + w / 2
		futureCrab2Y# = crab2R# * sin(futureCrab2Theta#) + ( h/4 - GetSpriteHeight(split)/4 )
		// iterate through throwing stars
		for i = special1Ex1 to special1Ex3
			// make sure the star exists
			if GetSpriteExists(i)
				// calculate future star position
				futureStarY# = GetSpriteMiddleY(i) + -5.5 * timeAhead#
				// calculate distance
				distance# = sqrt( pow(GetSpriteMiddleX(i) - futureCrab2X#, 2) + pow(futureStarY# - futureCrab2Y#, 2) )
				// check for closeness
				if distance# < 50
					if printAI then Print("Danger Close")
					collisionPredicted = 1
					exit
				endif
			endif
		next i
	endif
	//Print("No collision detected")
endfunction collisionPredicted

//Attempt to peform special attacks, regardless of whether doing so is actually possible
//Return 0 - No attack, 1 - Meteor attack, 2 - Special attack
function AISpecial()
	specialAttack = 0
	if specialTimer# > specialInterval#
	    if meteorsUsed# < meteorsPerSpecial#
			specialAttack = 1
		else
			specialAttack = 2
		endif
		specialTimer# = 0
	endif
	inc specialTimer#
endfunction specialAttack

//Reset Special Attack behavior after a special attack actually occurs
function AIResetSpecial(specialType#)
	if specialType# = 1
		inc meteorsUsed#
	elseif specialType# = 2
		meteorsUsed# = 0
	endif
endfunction
