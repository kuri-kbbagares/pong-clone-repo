local menu_buttons = {}
local option_buttons = {}
local button_height = 64
local game_State = "menu"
local switch = false
local switch2 = false

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function newButton(name, fn)
  return {
    name = name,
    fn = fn,
    
    now = false,
    last = false
  }
end
  
function love.load()
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = false
    })
  -- Menu Buttons
  table.insert(menu_buttons, newButton(
      "Start Game",
      function()
      game_State = 'play'
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

-- Option Buttons
  table.insert(option_buttons, newButton(
      "1920 x 1080",
      function()
        WINDOW_WIDTH = 1920
        WINDOW_HEIGHT = 1080
      end))
  table.insert(option_buttons, newButton(
      "1600 x 900",
      function()
        WINDOW_WIDTH = 1600
        WINDOW_HEIGHT = 900
      end))
  table.insert(option_buttons, newButton(
      "1280 x 720",
      function()
        WINDOW_WIDTH = 1280
        WINDOW_HEIGHT =720
      end))
  
  fullscreen = {'Fullscreen: Off', WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH * 0.8, 'left'}
  vsync = {'Vsync: Off', WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH, 'left'}
end

function love.draw()
  if game_State == 'menu' then
    game_Menu()
  
  elseif game_State == 'play' then
    game_Play()
  
  elseif game_State == 'options' then
    game_Options()
  
  elseif game_State == 'exit' then
    love.event.quit()   
  end
  
  font = love.graphics.setNewFont(WINDOW_HEIGHT / 18)
  font_height = font:getHeight()

end

function game_Menu()
  local button_width = WINDOW_WIDTH * (1/4)
  local spacing = 16
  local button_number = 0
    
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('Pong', 0, WINDOW_HEIGHT / 5, WINDOW_WIDTH, 'center')
    
  for i, buttons in ipairs(menu_buttons) do
    buttons.last = buttons.now
    button_xlocation = (WINDOW_WIDTH * 0.5) - (button_width * 0.5)
    button_ylocation = (WINDOW_HEIGHT * 0.5) + button_number
      
    love.graphics.setColor(0,0,0,0)
    love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width, button_height)
    
    local textcolor = {1,1,1,1}  
    local mx, my = love.mouse.getPosition() -- Positions of mouse according to x & y axis
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

function game_Play()
  
end

function game_Options()
  local button_width = WINDOW_WIDTH * 0.25
  local spacing = WINDOW_HEIGHT / 45
  local button_number = 0
  
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('Options', 0, WINDOW_HEIGHT / 12, WINDOW_WIDTH, 'center')
  love.graphics.printf('Resolution:', WINDOW_WIDTH / 6, WINDOW_HEIGHT / 4, WINDOW_WIDTH, 'left')
  
  -- Resolution buttons
  for i, buttons in ipairs(option_buttons) do
    buttons.last = buttons.now
    button_xlocation = (WINDOW_WIDTH * 0.5) - (button_width * 0.5)
    button_ylocation = (WINDOW_HEIGHT * 0.24) + button_number
    
    love.graphics.setColor(0,0,0,0)
    love.graphics.rectangle("fill", button_xlocation, button_ylocation, button_width, button_height)
    
    local textcolor = {1,1,1,1}  
    local mx, my = love.mouse.getPosition() -- Positions of mouse according to x & y axis
    local highlight = mx > button_xlocation and mx < button_xlocation + button_width and my > button_ylocation and my < button_ylocation + button_height
    if highlight then
      textcolor = {1,1,0,1}
    end
    
    love.graphics.setColor(unpack(textcolor))
    love.graphics.printf(buttons.name, 0, (WINDOW_HEIGHT * 0.25) + button_number, WINDOW_WIDTH, 'center')
    buttons.now = love.mouse.isDown(1)
    if buttons.now == true and not buttons.last and highlight then
      buttons.fn()
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
      fullscreen = {'Fullscreen: Off', WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH * 0.8, 'left'}
      vsync = {'Vsync: Off', WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH, 'left'}
    end
    button_number = button_number + (button_height + spacing)
    
  end
  
  -- Vsync Button
  button_Vsync(button_width, spacing, button_number)
  -- Fullscreen Button
  button_Fullscreen(button_width, spacing, button_number)
  -- Exit Button
  button_exit(button_width, spacing, button_number)
end

function button_Vsync(button_width, spacing, button_number)
  local mx, my = love.mouse.getPosition()
  love.graphics.setColor(0,0,0,0)
  love.graphics.rectangle("fill", WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.6, button_width * 0.65, button_height)
  
  -- Boxed Location of 'Vsync' button and activates the 'highlight' variable
  local textcolor = {1,1,1,1} 
  local highlight = mx > WINDOW_WIDTH * 0.2 and mx < WINDOW_WIDTH * 0.2 + button_width * 0.65 and my > WINDOW_HEIGHT * 0.6 and my < WINDOW_HEIGHT * 0.6 + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  
  love.graphics.setColor(unpack(textcolor))
  love.graphics.printf(unpack(vsync))
  click = love.mouse.isDown(1)
  
  if click == true and highlight then
    if switch2 == true then
      vsync = {'Vsync: Off', WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync = false})
    end
    if switch2 == false then
      vsync = {'Vsync: On', WINDOW_WIDTH * 0.2, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {vsync = true})
    end
    switch2 = not switch2
  end
end

function button_Fullscreen(button_width, spacing, button_number)
  local mx, my = love.mouse.getPosition()
  love.graphics.setColor(0,0,0,0)
  love.graphics.rectangle("fill", WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.6, button_width * 0.95, button_height )
  
  -- Boxed Location of 'Fullscreen' button and activates the 'highlight' variable
  local textcolor = {1,1,1,1}
  local highlight = mx > WINDOW_WIDTH * 0.57 and mx < WINDOW_WIDTH * 0.57 + button_width * 0.95 and my > WINDOW_HEIGHT * 0.6 and my < WINDOW_HEIGHT * 0.6 + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end

  love.graphics.setColor(unpack(textcolor))
  love.graphics.printf(unpack(fullscreen))
  click = love.mouse.isDown(1)
  
  if click == true and highlight then  
    if switch == true then
      fullscreen = {'Fullscreen: Off', WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH * 0.8, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false})
    end
    if switch == false then
      fullscreen = {'Fullscreen: On', WINDOW_WIDTH * 0.57, WINDOW_HEIGHT * 0.6, WINDOW_WIDTH * 0.8, 'left'}
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = true})
    end
    switch = not switch
  end
end

function button_exit(button_width, spacing, button_number)
  local mx, my = love.mouse.getPosition()
  love.graphics.setColor(0,0,0,0)
  love.graphics.rectangle("fill", WINDOW_WIDTH * 0.78, WINDOW_HEIGHT * 0.8, button_width * 0.35, button_height)
  
  -- Boxed Location of 'exit' button and activates the 'highlight' variable
  local textcolor = {1,1,1,1}  
  local highlight = mx > WINDOW_WIDTH * 0.78 and mx < WINDOW_WIDTH * 0.78 + button_width * 0.35 and my > WINDOW_HEIGHT * 0.8 and my < WINDOW_HEIGHT * 0.8 + button_height
  if highlight then
    textcolor = {1,1,0,1}
  end
  love.graphics.setColor(unpack(textcolor))
  exit = love.graphics.printf('Exit', 0, WINDOW_HEIGHT * 0.8, WINDOW_WIDTH * 0.85, 'right')
  exit = love.mouse.isDown(1)
  if exit == true and highlight then
    game_State = 'menu'
  end
end

