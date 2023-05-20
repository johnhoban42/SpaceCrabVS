// File: ai.agc
// Created: 23-02-13
//#include "game2.agc"

global turnCooldown# = 0
global thinkCooldown# = 0
global turnCooldownMax# = 120 // number of ticks (1/60 of a second) after a turn during which the AI does not think
global thinkCooldownMax# = 180 // number of ticks before the AI can think again after failing
global randomThinkTicks# = 600 // average number of ticks between failed attempts to think
global randomTurnPercent# = 100 // chance out of 100 that the crab will turn when not thinking
global specialInterval# = 60 // number of ticks between attempts to use special / meteor attack
global specialTimer# = 0 // timer used to perform special attacks
global meteorsPerSpecial# = 2 // number of times meteor attack will be used before using special attack
global meteorsUsed# = 0 // number of meteor attacks used since last special attack
global doJump = 0 // flag set when crab should "double tap" the turn input in order to perform a jump action instead
global randomJumpPercent# = 30 // chance out of 100 that the crab will jump when given the opportunity to

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
		// 1/randomThinkTicks chance to not perform an accurate hit prediction
		if Random(1, randomThinkTicks#) > 1
			doTurn = PredictHit(ScreenFPS() / 2.0) // half a second when adjusted via fpsr
			// if not normal crab, sometimes queue a jump instead of just a turn
			if doTurn and not crab2Type = 1 and Random(1, 100) <= randomJumpPercent#
				doJump = 1
			endif
		else
			// stop thinking for a bit
			thinkCooldown# = thinkCooldownMax#
			// randomly turn sometimes when starting to not think
			if Random(1, 100) <= randomTurnPercent#
				//Print("Not thinking, but turning!")
				doTurn = 1
			endif
		endif
		// normal crab should jump to gain distance and grab more pellets often, so have it jump randomly outside of the unthinking case, but only if not set to turn already
		if crab2Type = 1 and not doTurn and Random(1, 100) <= randomJumpPercent#
			doTurn = 1
			doJump = 1
		endif
	else
		// decrement the cooldowns
		inc turnCooldown#, -1
		inc thinkCooldown#, -1	
	endif
	
	Print("Turn timer")
	Print(turnCooldown#)
	Print("Think timer")
	Print(thinkCooldown#)
	
	//Logic for the AI turn is processed here
	//If doing a turn, then doTurn is set to 1 (it is the return variable)
	
	// prevent chain-turning for a bit when a turn is about to occur
	if doTurn
		Print("Starting Turn Cooldown")
		turnCooldown# = turnCooldownMax#
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
			Print("Normal Meteor")
			futureMeteorR# = meteorActive2[i].r - met1speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#
		elseif cat = 2 //Rotating meteor
			Print("Rotating Meteor")
			futureMeteorR# = meteorActive2[i].r - met2speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#
			futureMeteorTheta# = meteorActive2[i].theta + 1*timeAhead#
		elseif cat = 3 // fast meteor
			Print("Fast Meteor")
			futureMeteorR# = meteorActive2[i].r - met3speed*(1 + (gameDifficulty2-1)*diffMetMod)*timeAhead#		
		endif
		//Print("Future Meteor Radius")
		//Print(futureMeteorR#)
		//Print("Future Meteor Theta")
		//Print(futureMeteorTheta#)
		// calculate distance between future crab and future meteor to determine if a collision would be imminent
		distance# = sqrt( crab2R# * crab2R# + futureMeteorR# * futureMeteorR# - 2 * crab2R# * futureMeteorR# * cos( futureCrab2Theta# - futureMeteorTheta# ) )
		Print("Distance between crab and a meteor")
		Print(distance#)
		// check for closeness
		if distance# < 50
			Print("Danger Close")
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
					Print("Danger Close")
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
