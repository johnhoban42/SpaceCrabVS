#include "myLib.agc"

// Project: SpaceCrabVS 
// Created: 22-03-03

// show all errors

SetErrorMode(2)

// set window properties
SetWindowTitle( "SpaceCrabVS" )
SetWindowSize( 800, 1600, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

#constant w 800
#constant h 1600

// set display properties
SetVirtualResolution( w, h ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

SetVSync(1)

global fpsr#

do
	fpsr# = 60.0/ScreenFPS()
	
    Print( ScreenFPS() )
    Sync()
loop
