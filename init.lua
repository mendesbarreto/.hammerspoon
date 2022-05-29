
mash = { "alt", "ctrl", "cmd" }
logger = hs.logger.new('layout', 'debug')

function getPosition(direction, window)
  local windowFrame = window:frame()
  local screenFrame = window:screen():frame()
  local nextPosition

  logger.d(direction)

  if direction == "Right" then
    local nextWidth = screenFrame.w * 0.5
    nextPosition = { x = screenFrame.x + nextWidth, y = screenFrame.y, w = nextWidth, h = screenFrame.h }
  elseif direction == "Left" then
    nextPosition = { x = screenFrame.x, y = screenFrame.y, w = screenFrame.w * 0.5, h = screenFrame.h }
  elseif direction == "Up" then
    nextPosition = { x = screenFrame.x, y = screenFrame.y, w = screenFrame.w, h = screenFrame.h * 0.5}
  elseif direction == "Down" then
    local nextHeight = screenFrame.h * 0.5
    nextPosition = { x = screenFrame.x, y = screenFrame.y + nextHeight, w = screenFrame.w, h = nextHeight }
  else
    logger.d("Direction not available")
  end

  return nextPosition
end

function moveWindow(direction)
  local focusedWindow = hs.window.focusedWindow()
  local nextPosition = getPosition(direction, focusedWindow)

  if focusedWindow == nil or nextPosition == nil then
    logger.d("No focused window or position was provided")
    return
  end
  
  focusedWindow:move(nextPosition, nil, true)
end


function miniOrMaximize() 
  local focusedWindow = hs.window.focusedWindow()
  
  if focusedWindow then
    if focusedWindow:isMinimized() then
      focusedWindow:unminimize()
    else
      focusedWindow:minimize()
    end
  else
    logger.d("No focused window to minimize or maximize")
  end 

end

hs.hotkey.bind(mash, "Left", function() moveWindow("Left") end)
hs.hotkey.bind(mash, "Right", function() moveWindow("Right") end)
hs.hotkey.bind(mash, "Up", function() moveWindow("Up") end)
hs.hotkey.bind(mash, "Down", function() moveWindow("Down") end)
hs.hotkey.bind(mash, "m", function() miniOrMaximize()  end)
