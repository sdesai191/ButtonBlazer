local composer = require( "composer" )
local scene = composer.newScene()
local gameNetwork = require "gameNetwork" 

local function loadLocalPlayerCallback( event )
  playerName = event.data.alias
end
local function gameNetworkLoginCallback( event )
  gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
  return true
end
local function gpgsInitCallback( event )
  gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

gameNetwork.init("google", gpgsInitCallback)


local widget = require("widget")
startSound = audio.loadSound( "gameStart.ogg" )
function startGame ( event )
  if ("event.phase == ended") then
    audio.play( startSound )
    composer.gotoScene("game", {effect = "slideLeft", time = 333} )
  end
end

local function gotoCredits( event )
  if ("event.phase == ended") then
    audio.play( startSound )
    composer.removeScene( "menu", false )
    composer.showOverlay( "appCredit" )
  end
end

local function showLeaderboards( event )
  if ("event.phase == ended") then
    if gameNetwork.request("isConnected") then
     gameNetwork.show("leaderboards")
    else
      gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
    end
  end
end

native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )

function scene:create( event )
  local sceneGroup = self.view
  native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )  
  display.setDefault( "background", 255,255,255 )

  local startingButton = widget.newButton
  {
    width = 205,
    height = 205,
    label = "Start",
    emboss = false,
    font = "RT",
    fontSize = 40,
    labelYOffset = -5,
    labelColor = { default={ 255, 255, 255 }, over={ 255, 255, 255, 0.4 } },
    defaultFile = "blueButton.png",
    overFile = "blueButtonPressed.png",
    onRelease = startGame,
  }
    startingButton.x = display.contentCenterX
    startingButton.y = display.contentCenterY - 50
    sceneGroup:insert(startingButton)

  local leaderboardsButton = widget.newButton
  {
    width = 75,
    height = 75,
    defaultFile = "leaderboardsIcon.png",
    onEvent = showLeaderboards,
  }
  leaderboardsButton.x = display.contentCenterX - 50
  leaderboardsButton.y = display.contentCenterY + 220
  sceneGroup:insert(leaderboardsButton)

  local creditsButton = widget.newButton
  {
    width = 75,
    height = 75,
    defaultFile = "creditsIcon.png",
    onEvent = gotoCredits,
  }
  creditsButton.x = display.contentCenterX + 50
  creditsButton.y = display.contentCenterY + 220
  sceneGroup:insert(creditsButton)
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    local function systemEvents( event )
       print("systemEvent " .. event.type)
       if ( event.type == "applicationSuspend" ) then
          print( "suspending..........................." )
       elseif ( event.type == "applicationResume" ) then
          print( "resuming............................." )
          native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
       elseif ( event.type == "applicationExit" ) then
          print( "exiting.............................." )
       elseif ( event.type == "applicationStart" ) then
          native.setProperty( "androidSystemUiVisibility", "immersiveSticky" )
       end
       return true
    end

    Runtime:addEventListener( "system", systemEvents )
   
end



function scene:show( event )
    local sceneGroup = self.view
    --
    if event.phase == "did" then
    end
end
--
function scene:hide( event )
    local sceneGroup = self.view
    --
    if event.phase == "will" then
    end
end
--
function scene:destroy( event )
    local sceneGroup = self.view   
end

---------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
---------------------------------------------------------------------------------

return scene
