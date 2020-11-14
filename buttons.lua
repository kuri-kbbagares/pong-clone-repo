buttons = Class{}
require 'keybindings'

local switch = false
local switch2 = false
edit = false

local button_height = WINDOW_HEIGHT / 11.25
local button_width = WINDOW_WIDTH * 0.25
local spacing = WINDOW_HEIGHT / 40

local fullscreen = {'Fullscreen: Off', WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.68, WINDOW_WIDTH * 0.8, 'left'}
local vsync = {'Vsync: Off', WINDOW_WIDTH * 0.15, WINDOW_HEIGHT * 0.68, WINDOW_WIDTH, 'left'}

p1keyUpOpen, p1keyDownOpen, p2keyUpOpen, p2keyDownOpen = false, false, false, false
local p1keyUp = "w"
local p1keyDown = "s"
local p2keyUp = "up"
local p2keyDown = "down"

local menu_buttons = {}

-- For function 'SetButtons' that gives them a name, a given function when clicked, and can only be clicked once (now & last)
function newButton(name, fn, key)
  return {
    name = name,
    fn = fn,
    
    now = false,
    last = false
  }
end

function buttons:SetButtons()
  table.insert(menu_buttons, newButton(
    "Start Game",
    function()
    game_State = 'start'
    end))
  table.insert(menu_buttons, newButton(
    "Options",
    function()
    game_State = 'options'
    end))
  table.insert(menu_buttons, newButton(
    "Exit",
    function()
    game_State ='exit'
    end))
end

function buttons:MenuButton(button_number)
  local button_number = 0

  for i, buttons in ipairs(menu_buttons) do
    buttons.last = buttons.now
    local button_xlocation = (WINDOW_WIDTH * 0.5) - (button_width * 0.5)
    local button_ylocation = (WINDOW_HEIGHT * 0.5) + button_number
      
    love.graphics.setColor(0,0,0,0)
    love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width, button_height)
    
    local textcolor = {1,1,1,1}  
    local mx, my = love.mouse.getPosition() -- Position of mouse according to x & y axis
    local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
    if highlight then
      textcolor = {1,1,0,1}
    end
    love.graphics.setColor(unpack(textcolor))
    love.graphics.printf(buttons.name, 0, (WINDOW_HEIGHT * 0.51) + button_number, WINDOW_WIDTH, 'center')
   
    buttons.now = love.mouse.isDown(1)
    if buttons.now == true and not buttons.last and highlight then
      buttons.fn()
    end

    button_number = button_number + (button_height + spacing)
  end
end

function buttons:PlayerKey(key)
  -- Player 1
  local button_xlocation = WINDOW_WIDTH * 0.15
  local button_ylocation = WINDOW_HEIGHT * 0.3
  love.graphics.printf("Player 1", button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')

  -- Player 1 Up Key
  local button_xlocation = WINDOW_WIDTH * 0.2
  local button_ylocation = WINDOW_HEIGHT * 0.4
  local textcolor = {1,1,1,1}
  local mx, my = love.mouse.getPosition() -- Position of mouse according to x & y axis
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))

  click = love.mouse.isDown(1)
  if click == true and highlight then
    p1keyUp = "<Insert Key>"
    p1keyUpOpen = true
  end

  if key ~= nil then
    if p1keyUpOpen == true then
      if love.keyboard.isDown(tostring(key)) then
        edit = true
        keybindings:list(key)
        if p1keyUpOpen == false then
          p1keyUp = InputKey
          p1Up = p1keyUp
        end
      end
    end
  end

  love.graphics.printf("Up: " .. p1keyUp, button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')

  -- Player 1 Down Key
  local button_xlocation = WINDOW_WIDTH * 0.2
  local button_ylocation = WINDOW_HEIGHT * 0.5
  local textcolor = {1,1,1,1}
  local mx, my = love.mouse.getPosition() -- Position of mouse according to x & y axis
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))

  click = love.mouse.isDown(1)
  if click == true and highlight then
    p1keyDown = "<Insert Key>"
    p1keyDownOpen = true
  end

  if key ~= nil then
    if p1keyDownOpen == true then
      if love.keyboard.isDown(tostring(key)) then
        edit = true
        keybindings:list(key)
        if p1keyDownOpen == false then
          p1keyDown = InputKey
          p1Down = p1keyDown
        end
      end
    end
  end

  love.graphics.printf("Down: " .. p1keyDown, button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')

  -- Player 2
  local button_xlocation = WINDOW_WIDTH * 0.57
  local button_ylocation = WINDOW_HEIGHT * 0.3
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf("Player 2", button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')

  -- Player 2 Up Key
  local button_xlocation = WINDOW_WIDTH * 0.6
  local button_ylocation = WINDOW_HEIGHT * 0.4
  local textcolor = {1,1,1,1}
  local mx, my = love.mouse.getPosition() -- Position of mouse according to x & y axis
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))

  click = love.mouse.isDown(1)
  if click == true and highlight then
    p2keyUp = "<Insert Key>"
    p2keyUpOpen = true
  end

  if key ~= nil then
    if p2keyUpOpen == true then
      if love.keyboard.isDown(tostring(key)) then
        edit = true
        keybindings:list(key)
        if p2keyUpOpen == false then
          p2keyUp = InputKey
          p2Up = p2keyUp
        end
      end
    end
  end

  love.graphics.printf("Up: " .. p2keyUp, button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')

  -- Player 2 Down Key
  local button_xlocation = WINDOW_WIDTH * 0.6
  local button_ylocation = WINDOW_HEIGHT * 0.5
  local textcolor = {1,1,1,1}
  local mx, my = love.mouse.getPosition() -- Position of mouse according to x & y axis
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))

  click = love.mouse.isDown(1)
  if click == true and highlight then
    p2keyDown = "<Insert Key>"
    p2keyDownOpen = true
  end

  if key ~= nil then
    if p2keyDownOpen == true then
      if love.keyboard.isDown(key) then
        edit = true
        keybindings:list(key)
        if p2keyDownOpen == false then
          p2keyDown = InputKey
          p2Down = p2keyDown
        end
      end
    end
  end

  love.graphics.printf("Down: " .. p2keyDown, button_xlocation, button_ylocation, WINDOW_WIDTH, 'left')
end

function buttons:Vsync()
  local mx, my = love.mouse.getPosition()
  local button_xlocation = WINDOW_WIDTH * 0.15
  local button_ylocation = WINDOW_HEIGHT * 0.68

  love.graphics.setColor(0,0,0,0)
  love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width * 0.65, button_height)
  
  -- Boxed Location of 'Vsync' button and activates the 'highlight' variable
  local textcolor = {1,1,1,1} 
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width * 0.65 and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  
  love.graphics.setColor(unpack(textcolor))
  love.graphics.printf(unpack(vsync))
  click = love.mouse.isDown(1)
  
  if click == true and highlight then
    if switch2 == true then
      vsync = {'Vsync: Off', button_xlocation, button_ylocation, WINDOW_WIDTH, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync = false})
    end
    if switch2 == false then
      vsync = {'Vsync: On', button_xlocation, button_ylocation, WINDOW_WIDTH, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync = true})
    end
    switch2 = not switch2
  end
end

--[[
function buttons:Fullscreen()
  local button_xlocation = WINDOW_WIDTH * 0.57
  local button_ylocation = WINDOW_HEIGHT * 0.68

  love.graphics.setColor(0,1,0,1)
  love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width, button_height )
  
  -- Boxed Location of 'Fullscreen' button and activates the 'highlight' variable
  local mx, my = love.mouse.getPosition()
  local textcolor = {1,1,1,1}
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end

  love.graphics.setColor(unpack(textcolor))
  love.graphics.printf(unpack(fullscreen))
  click = love.mouse.isDown(1)
  
  if click == true and highlight then  
    if switch == true then
      fullscreen = {'Fullscreen: Off', button_xlocation, button_ylocation, WINDOW_WIDTH * 0.8, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false})
    end
    if switch == false then
      fullscreen = {'Fullscreen: On', button_xlocation, button_ylocation, WINDOW_WIDTH * 0.8, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = true})
    end
    switch = not switch
  end
end
--]]

function buttons:Exit()
  local mx, my = love.mouse.getPosition()
  local button_xlocation = WINDOW_WIDTH * 0.78
  local button_ylocation = WINDOW_HEIGHT * 0.8

  love.graphics.setColor(0,0,0,0)
  love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width * 0.35, button_height)
  
  -- Boxed Location of 'exit' button and activates the 'highlight' variable
  local textcolor = {1,1,1,1}  
  local highlight = mx > button_xlocation and mx < button_xlocation + button_width * 0.35 and my > button_ylocation and my < button_ylocation + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))
  exit = love.graphics.printf('Exit', 0, button_ylocation, WINDOW_WIDTH * 0.85, 'right')
  exit = love.mouse.isDown(1)
  if exit == true and highlight then
    game_State = 'menu'
  end
end