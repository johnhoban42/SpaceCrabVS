// File: ai.agc
// Created: 23-02-13
//#include "game2.agc"

global turnOccuring# = 0

function AITurn()
	doTurn = 0
	if turnOccuring# < 1
		doTurn = PredictHit(60)
	else
		inc turnOccuring#, -1
	endif
	
	Print("Turn timer")
	Print(turnOccuring#)
	
	//Logic for the AI turn is processed here
	//If doing a turn, then doTurn is set to 1 (it is the return variable)
	
	if doTurn
		Print("Starting Turn Timer")
		turnOccuring# = 144
	endif
	
endfunction doTurn

function PredictHit(framesAhead#)
	Print("Inside PredictHit")
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
			futureMeteorR# = meteorActive2[i].r - met1speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#
		elseif cat = 2 //Rotating meteor
			futureMeteorR# = meteorActive2[i].r - met2speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#
			futureMeteorTheta# = meteorActive2[i].theta + 1*framesAhead#	
		elseif cat = 3 // fast meteor
			futureMeteorR# = meteorActive2[i].r - met3speed*(1 + (gameDifficulty2-1)*diffMetMod)*framesAhead#		
		endif
		//Print("Future Meteor Radius")
		//Print(futureMeteorR#)
		//Print("Future Meteor Theta")
		//Print(futureMeteorTheta#)
		// check if crab and meteor are close in theta
		if Abs(futureCrab2Theta# - futureMeteorTheta#) < 10
			Print("Objects close in Theta")
			// check if crab and meteor are close in radius
			if Abs(crab2R# - futureMeteorR#) < 100
				//Print("Objects close in Radius, collision predicted")
				collisionPredicted = 1
			endif
		endif
		// collision predicted, abort loop
		if collisionPredicted
			exit
		endif
	next i
	//Print("No collision detected")
endfunction collisionPredicted
