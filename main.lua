local menu_buttons = {}
local option_buttons = {}
local button_height = 64
local game_State = "menu"
local switch = false
local switch2 = false

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--THIS ARE THE OBJECT CLASS (WHERE THE VALUES OF OBJECTS ARE KEPT)
Class = require 'class'
require 'paddles'
require 'paddle2'
require 'ball'

--This is the multiplier value for the change of y (dy)
movementOfY = 350

function newButton(name, fn)
  return {
    name = name,
    fn = fn,
    
    now = false,
    last = false
  }
end
  
function love.load()
      math.randomseed(os.time())
      
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = false
    })
  
   paddlePlayerOne = paddles(40, 120, 25, 150)
   paddlePlayerTwo = paddle2(WINDOW_WIDTH -80, WINDOW_HEIGHT - 240, 25, 150)
  
   playBall = ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 20)
  -- Menu Buttons
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
  
  elseif game_State == 'start' then --When the game_State is start, the ball is not moving and its in the center
    game_Play() -- renders the objects on screen
  
  elseif game_State == 'play' then -- When the game_State is play, the objects now have collision and the ball is moving
    game_Play()
    
  elseif game_State == 'options' then
    game_Options()
  
  elseif game_State == 'exit' then
    love.event.quit()   
  end
  
  font = love.graphics.setNewFont(WINDOW_HEIGHT / 18)
  font_height = font:getHeight()

end
function love.update(dt)
   
   if game_State == 'play' then -- Condition to initialize the Ball update and the collision and resets
     
     playBall:update(dt)
     
     --(START) this handles the collision of the ball to the paddle
     if playBall:collision(paddlePlayerOne) then
       playBall.dx = -playBall.dx * 1.1
       playBall.x = paddlePlayerOne.x + 35
       
       if playBall.dy < 0 then
         playBall.dy = -math.random(25, 250)
       else
         playBall.dy = math.random(25, 250)
       end
     end
     
     if playBall:collision(paddlePlayerTwo) then
       playBall.dx = -playBall.dx * 1.1
       playBall.x = paddlePlayerTwo.x - 20
       
       if playBall.dy < 0 then
         playBall.dy = -math.random(25, 250)
       else
         playBall.dy = math.random(25, 250)
       end
       
     end
     -- (END)
     
     --(START) this handles the collision of the ball in respect to y
     if playBall.y <= 0 then
       playBall.y = 0
       playBall.dy = -playBall.dy
     end
     
     if playBall.y >= WINDOW_HEIGHT then
       playBall.y = WINDOW_HEIGHT - 20
       playBall.dy = -playBall.dy
      end
       
   end 
   --(END)
   
   --(START) this handles the reset of the ball
   if playBall.x < 0 then --conditional operator of the ball's x
     playBall:reset()
     game_State = 'start'
   end
   
   if playBall.x > WINDOW_WIDTH then
     playBall:reset()
     game_State = 'start'
   end 
  --(END)  
    
  --(START) this handles controls the paddle
  --CONTROL FOR PLAYER 1:
  if love.keyboard.isDown('w') then
     paddlePlayerOne.dy = -movementOfY
   elseif love.keyboard.isDown('s') then
     paddlePlayerOne.dy = movementOfY
    else
      paddlePlayerOne.dy = 0
   end
  --CONTROL FOR PLAYER 2:
   if love.keyboard.isDown('up') then
     paddlePlayerTwo.dy = -movementOfY
   elseif love.keyboard.isDown('down') then
     paddlePlayerTwo.dy = movementOfY
   else
      paddlePlayerTwo.dy = 0
   end
  --(END) 
   
  --Updates paddle movements 
   paddlePlayerOne:update(dt)
   paddlePlayerTwo:update(dt)
   
   
 end
 
 function love.keypressed(key)
   --This condition will initiate the game_State from 'start' to 'play'
   if game_State == 'start' then
     if key == 'enter' or key == 'return' then
       game_State = 'play'
     end
   end
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

function game_Play() --FUNCTION FOR RENDERING THE OBJECTS
    love.graphics.setColor(1, 1, 1, 1)
    paddlePlayerOne:render()
    paddlePlayerTwo:render()
    playBall:render()
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

