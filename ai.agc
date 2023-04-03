// File: ai.agc
// Created: 23-02-13
//#include "game2.agc"

global turnCooldown# = 0
global randomThinkChance = 999 // chance out of 1000 that the crab will calculate what to do this tick
global randomTurnChance = 100 // chance out of 100 that the crab will turn when not thinking

function AITurn()
	doTurn = 0
	if turnCooldown# < 1
		if Random(1, 1000) <= randomThinkChance
			doTurn = PredictHit(ScreenFPS() / 2.0) // half a second when adjusted via fpsr 
		elseif Random(1, 100) <= randomTurnChance
			Print("Not thinking, but turning!")
			doTurn = 1
		endif
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
	timeAhead# = framesAhead# * fpsr#
	//Print("Inside PredictHit")
	// return flag
	collisionPredicted = 0
	// calculate crab's future theta
	futureCrab2Theta# = crab2Theta# + crab2Vel# * crab2Dir# * timeAhead# 
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
		//Print("Distance between crab and a meteor")
		//Print(distance#)
		if distance# < 50
			Print("Danger Close")
			collisionPredicted = 1
			exit
		endif
	next i
	//Print("No collision detected")
endfunction collisionPredicted
