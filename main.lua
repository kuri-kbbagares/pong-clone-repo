WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
game_State = "menu"


--THIS ARE THE OBJECT CLASS (WHERE THE VALUES OF OBJECTS ARE KEPT)
Class = require 'class'
require 'paddles'
require 'ball'
require 'buttons'

--This is the multiplier value for the change of y (dy)
movementOfY = 350

function love.load()
      math.randomseed(os.time())
      
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = false
    })
  
   paddlePlayerOne = paddles(40, 120, 25, 150)
   paddlePlayerTwo = paddles(WINDOW_WIDTH -80, WINDOW_HEIGHT - 240, 25, 150)
  
   playBall = ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 20)
   
  buttons = buttons()

  -- It is a list of buttons that has the same y-axis which coded by "for" function 
  buttons:SetButtons()
  
  p1Up = 'w'
  p1Down = 's'
  p2Up = 'up'
  p2Down = 'down'
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

function love.textinput(key)

end

function love.keypressed(key)
  --This condition will initiate the game_State from 'start' to 'play'
  if game_State == 'start' then
    if key == 'enter' or key == 'return' then
      game_State = 'play'
    end
    if key == 'escape' then
      game_State = 'menu'
    end
  end

  if game_State == 'options' then
    buttons:PlayerKey(key)
  end
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
  if love.keyboard.isDown(p1Up) then
     paddlePlayerOne.dy = -movementOfY
   elseif love.keyboard.isDown(p1Down) then
     paddlePlayerOne.dy = movementOfY
    else
      paddlePlayerOne.dy = 0
   end
  --CONTROL FOR PLAYER 2:
   if love.keyboard.isDown(p2Up) then
     paddlePlayerTwo.dy = -movementOfY
   elseif love.keyboard.isDown(p2Down) then
     paddlePlayerTwo.dy = movementOfY
   else
      paddlePlayerTwo.dy = 0
   end
  --(END) 
   
  --Updates paddle movements 
   paddlePlayerOne:update(dt)
   paddlePlayerTwo:update(dt)
 end
 
function game_Menu()
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('Pong', 0, WINDOW_HEIGHT / 5, WINDOW_WIDTH, 'center')
  
  -- Menu Buttons
  buttons:MenuButton()
end

function game_Play() --FUNCTION FOR RENDERING THE OBJECTS
  love.graphics.setColor(1, 1, 1, 1)
  paddlePlayerOne:render()
  paddlePlayerTwo:render()
  playBall:render()
end

function game_Options()
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('Options', 0, WINDOW_HEIGHT * 0.05, WINDOW_WIDTH, 'center')
  love.graphics.printf('Keybindings:', WINDOW_WIDTH * 0.1, WINDOW_HEIGHT * 0.15, WINDOW_WIDTH, 'left')
  
  -- Player Key Buttons
  buttons:PlayerKey()
  -- Vsync Button
  buttons:Vsync()
  -- Fullscreen Button
  -- buttons:Fullscreen()
  -- Exit Button
  buttons:Exit()
end