HYPER = {"cmd", "alt", "ctrl", "shift"}

hs.window.animationDuration = 0
hs.window.setShadows(false)

local leftScreen = hs.screen{x=0,y=0}
local rightScreen = hs.screen{x=1,y=0}

switcher = hs.window.switcher.new() -- default windowfilter: only visible windows, all Spaces
switcher.ui.highlightColor = {0.4, 0.4, 0.5, 0.8}
switcher.ui.thumbnailSize = 112
switcher.ui.selectedThumbnailSize = 284
switcher.ui.backgroundColor = {0.3, 0.3, 0.3, 0.5}
-- switcher.ui.fontName = 'System'
switcher.ui.textSize = 14
switcher.ui.showSelectedTitle = false

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

hs.hotkey.bind(HYPER, "1", function()
  hs.application.launchOrFocus("Visual Studio Code")
  hs.application.launchOrFocus("Music")
  hs.application.launchOrFocus("iTerm")

  local windowLayout = {
      {"Code", nil, leftScreen, hs.layout.left75, nil, nil},
      {"iTerm2", nil, leftScreen, hs.layout.right25, nil, nil},
      {"Music", nil, rightScreen, hs.layout.maximized, nil, nil}
  }
  hs.layout.apply(windowLayout)
end)

hs.hotkey.bind(HYPER, "2", function()
  local windowLayout = {
      {"Code", nil, leftScreen, hs.layout.maximized, nil, nil},
      {"iTerm2", nil, rightScreen, hs.layout.maximized, nil, nil}
  }
  hs.layout.apply(windowLayout)
  hs.application.launchOrFocus("iTerm")
  hs.application.launchOrFocus("Visual Studio Code")
end)

hs.hotkey.bind(HYPER, "3", function()
  hs.application.launchOrFocus("Visual Studio Code")
  hs.application.launchOrFocus("iTerm")

  local windowLayout = {
      {"Code", nil, leftScreen, hs.layout.left75, nil, nil},
      {"iTerm2", nil, leftScreen, hs.layout.right25, nil, nil},
  }
  hs.layout.apply(windowLayout)
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

hs.hotkey.bind(HYPER, "R", function ()
  hs.reload()
end)
hs.alert.show("Config loaded")
