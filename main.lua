local composer = require("composer")
local scene = composer.newScene()
display.setStatusBar( display.HiddenStatusBar )
native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
     local function systemEvents( event )
       print("systemEvent " .. event.type)
       if ( event.type == "applicationSuspend" ) then
          print( "suspending..........................." )
       elseif ( event.type == "applicationResume" ) then
          print( "resuming............................." )
          native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
          composer.removeScene( "game", false )
          composer.gotoScene( "menu", { effect = "slideRight", time = 333} )
       elseif ( event.type == "applicationExit" ) then
          print( "exiting.............................." )
       elseif ( event.type == "applicationStart" ) then
          native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
          composer.removeScene( "menu", false )
          composer.gotoScene("menu")
       end
       return true
      end

    Runtime:addEventListener( "system", systemEvents )



