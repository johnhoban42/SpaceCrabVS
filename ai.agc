// File: ai.agc
// Created: 23-02-13
//#include "game2.agc"

global turnCooldown# = 0

function AITurn()
	doTurn = 0
	if turnCooldown# < 1
		doTurn = PredictHit(0)
	else
		inc turnCooldown#, -1
	endif
	
	Print("Turn timer")
	Print(turnCooldown#)
	
	//Logic for the AI turn is processed here
	//If doing a turn, then doTurn is set to 1 (it is the return variable)
	
	if doTurn
		Print("Starting Turn Cooldown")
		turnCooldown# = 144
	endif
	
endfunction doTurn

function PredictHit(framesAhead#)
	//Print("Inside PredictHit")
	// return flag
	collisionPredicted = 0
	// calculate crab's future theta
	futureCrab2Theta# = crab2Theta# + crab2Vel# * framesAhead#
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
		cat = meteorActive2[i].cat
		//Print("Meteor Category")
		//Print(cat)
		// perform future radius/theta calcs based on type of meteor and passed number of frames ahead we are looking
		if cat = 1	//Normal meteor
			Print("Normal Meteor")
			futureMeteorR# = meteorActive2[i].r - met1speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#
		elseif cat = 2 //Rotating meteor
			Print("Rotating Meteor")
			futureMeteorR# = meteorActive2[i].r - met2speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#
			futureMeteorTheta# = meteorActive2[i].theta + 1*framesAhead#	
		elseif cat = 3 // fast meteor
			Print("Fast Meteor")
			futureMeteorR# = meteorActive2[i].r - met3speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#		
		endif
		//Print("Future Meteor Radius")
		//Print(futureMeteorR#)
		//Print("Future Meteor Theta")
		//Print(futureMeteorTheta#)
		// calculate distance between future crab and future meteor to determine if a collision would be imminent
		distance# = sqrt( crab2R# * crab2R# + futureMeteorR# * futureMeteorR# - 2 * crab2R# * futureMeteorR# * cos( futureCrab2Theta# - futureMeteorTheta# ) )
		//Print("Distance between crab and a meteor")
		//Print(distance#)
		if distance# < 150
			Print("Danger Close")
			// extra checks to see if crab is already moving away from meteor when a dangerously close one is detected
			movingAway = 0
			// make sure we're working with a proper theta value for the meteor first
			if futureMeteorTheta# > 360
				while futureMeteorTheta# > 360 
					inc futureMeteorTheta#, -360
				endwhile
			endif
			// handle edge cases where a dangerous proximity is detected between crab and meteor on either side of the 0/360 divide
			// this assumes that the distance check is small enough that danger is never detected from a meteor more than 90 degrees away from the crab
			if abs(futureMeteorTheta# - futureCrab2Theta#) > 90
				// take the higher value and make it negative
				if futureCrab2Theta# > futureMeteorTheta#
					inc futureCrab2Theta#, -360
				else
					inc futureMeteorTheta#, -360
				endif
			endif
			// if crab is more clockwise rotated than meteor and will continue to rotate clockwise 
			// OR crab is less clockwise rotated than meteor and will continue to rotate counterclockwise
			// OR meteor is rotating clockwise, crab is rotating counterclockwise, and the distance is still great enough that a true collision isn't actually imminent
			if (futureCrab2Theta# > futureMeteorTheta# and crab2Dir# > 0) or ((futureCrab2Theta# < futureMeteorTheta# and crab2Dir# < 0)) or (cat = 2 and crab2Dir# < 0 and distance# > 100)
				movingAway = 1
			endif
			if not movingAway
				collisionPredicted = 1
				exit
			endif
		endif
	next i
	//Print("No collision detected")
endfunction collisionPredicted
