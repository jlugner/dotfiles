HYPER = {"cmd", "alt", "ctrl", "shift"}
MODE_KEY = 'MODE'
MODE_WORK = 'Work'
MODE_CASUAL = 'Casual'

hs.window.animationDuration = 0
hs.window.setShadows(false)

switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
switcher.ui.highlightColor = {0.4, 0.4, 0.5, 0.8}
switcher.ui.thumbnailSize = 112
switcher.ui.selectedThumbnailSize = 284
switcher.ui.backgroundColor = {0.3, 0.3, 0.3, 0.5}
-- switcher.ui.fontName = 'System'
switcher.ui.textSize = 14
switcher.ui.showSelectedTitle = false
hs.application.enableSpotlightForNameSearches(true)

-- Utils
function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function screenCount()
  return tableLength(hs.screen.allScreens())
end

function killIfRunning(applicationName)
  application = hs.appfinder.appFromName(applicationName)
  if application then application:kill() end
end

function hideIfRunning(applicationName)
  application = hs.appfinder.appFromName(applicationName)
  if application then application:hide() end
end

-- Move focused window to specified coordinates
function push(x, y, w, h)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w*x)
  f.y = max.y + (max.h*y)
  f.w = max.w*w
  f.h = max.h*h
  win:setFrame(f)
end

hs.hotkey.bind(HYPER, "U", function() push(0, 0, 0.5, 0.5) end)       -- Upper left corner
hs.hotkey.bind(HYPER, "O", function() push(0.5, 0, 0.5, 0.5) end)     -- Upper right corner
hs.hotkey.bind(HYPER, "N", function() push(0, 0.5, 0.5, 0.5) end)     -- Lower left corner
hs.hotkey.bind(HYPER, ",", function() push(0.5, 0.5, 0.5, 0.5) end)   -- Lower right corner
hs.hotkey.bind(HYPER, "J", function() push(0, 0, 0.5, 1) end)         -- Left half
hs.hotkey.bind(HYPER, "L", function() push(0.5, 0, 0.5, 1) end)       -- Right half
hs.hotkey.bind(HYPER, "M", function() push(0, 0.5, 1, 0.5) end)       -- Lower half
hs.hotkey.bind(HYPER, "I", function() push(0, 0, 1, 0.5) end)         -- Top half
hs.hotkey.bind(HYPER, "K", function() push(0, 0, 1, 1) end)           -- Full
hs.hotkey.bind(HYPER, "H", function() push(0.25, 0, 0.5, 1) end)      -- Full height, mid width, centered
hs.hotkey.bind(HYPER, "G", function() push(0.25, 0.25, 0.5, 0.5) end) -- Mid height, mid width, centered

function singleMonitorCodeLayout()
  screen = hs.screen('Built%-in')
  hs.application.launchOrFocus("Visual Studio Code")
  hs.application.launchOrFocus("iTerm")
  local windowLayout = {
    {"Code", nil, screen, hs.layout.maximized, nil, nil},
  }
  hs.layout.apply(windowLayout)
end

function doubleMonitorCodeLayout()
  laptopScreen = hs.screen('Built%-in')
  primaryScreen = hs.screen.primaryScreen()
  hs.application.launchOrFocus("Visual Studio Code")
  hs.application.launchOrFocus("iTerm")
  hs.application.launchOrFocus("Google Chrome")
  local windowLayout = {
    {"Code", nil, primaryScreen, hs.layout.maximized, nil, nil},
    {"iTerm2", nil, laptopScreen, hs.layout.left25, nil, nil},
    {"Google Chrome", nil, laptopScreen, hs.layout.right75, nil, nil}
  }
  hs.layout.apply(windowLayout)
end

function trippleMonitorCodeLayout()
  laptopScreen = hs.screen('Built%-in')
  primaryScreen = hs.screen.primaryScreen()
  laptopPositionX, _y = laptopScreen:position()
  local secondExternalScreenX = (laptopPositionX < 0 and 1 or -1)
  secondExternalScreen = hs.screen({x=secondExternalScreenX, y=0})

  hs.application.launchOrFocus("Visual Studio Code")
  hs.application.launchOrFocus("iTerm")
  hs.application.launchOrFocus("Google Chrome")
  hs.application.launchOrFocus("Music")
  local windowLayout = {
    {"Code", nil, primaryScreen, hs.layout.maximized, nil, nil},
    {"iTerm2", nil, laptopScreen, hs.layout.maximized, nil, nil},
    {"Google Chrome", nil, secondExternalScreen, hs.layout.right50, nil, nil},
    {"Music", nil, secondExternalScreen, hs.layout.left50, nil, nil}
  }
  hs.layout.apply(windowLayout)
end

function setCodeLayout()
  local screens = screenCount()
  if screens == 1 then
    singleMonitorCodeLayout()
  elseif screens == 2 then
    doubleMonitorCodeLayout()
  else
    trippleMonitorCodeLayout()
  end
end

hs.hotkey.bind(HYPER, "1", function()
  singleMonitorCodeLayout()
end)

hs.hotkey.bind(HYPER, "2", function()
  doubleMonitorCodeLayout()
end)

hs.hotkey.bind(HYPER, "3", function()
  trippleMonitorCodeLayout()
end)

-- Move focused window one screen right
hs.hotkey.bind(HYPER, "Right", function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenEast(0)
end)

-- Move focused window one screen left
hs.hotkey.bind(HYPER, "Left", function()
  local win = hs.window.focusedWindow()
  win:moveOneScreenWest(0)
end)

-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind('alt','tab', function()
  switcher:next()
end)

hs.hotkey.bind('alt-shift','tab', function()
  switcher:previous()
end)

-- Mode switching
function enterWorkMode()
  killIfRunning("Mail")
  hideIfRunning("Safari")
  setCodeLayout()
end

function enterCasualMode()
  killIfRunning("Slack")
  killIfRunning("Microsoft Teams")
  killIfRunning("Microsoft Outlook")
  hideIfRunning("Google Chrome")
end

hs.hotkey.bind(HYPER, "W", function()
  current_mode = hs.settings.get(MODE_KEY)
  local new_mode = (current_mode == MODE_WORK and MODE_CASUAL or MODE_WORK)
  hs.settings.set(MODE_KEY, new_mode)

  hs.alert.show("Switching to new mode: " .. new_mode)
  if new_mode == MODE_WORK then
    enterWorkMode()
  elseif new_mode == MODE_CASUAL then
    enterCasualMode()
  else
    -- what?
  end
end)

-- Browser management - open links etc depending on mode and whatever else we like
hs.urlevent.httpCallback = function(scheme, host, params, fullUrl)
  mode = hs.settings.get(MODE_KEY)
  local browser
  if mode == MODE_CASUAL then
    browser = 'com.apple.Safari'
  elseif mode == MODE_WORK then
    browser = 'com.google.Chrome'
  else
    hs.alert.show('Unknown mode used, opening link in default browser')
    browser = 'com.apple.Safari'
  end
  hs.urlevent.openURLWithBundle(fullUrl, browser)
end

hs.hotkey.bind(HYPER, "R", function ()
  hs.reload()
end)
hs.settings.set(MODE_KEY, MODE_CASUAL)
hs.alert.show("Config loaded, mode: " .. MODE_CASUAL)


