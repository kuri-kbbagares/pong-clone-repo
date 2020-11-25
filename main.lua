WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
game_State = "menu"
playerServe = 1

local background = love.graphics.newImage('textures/background.png')
local menu_bg = love.graphics.newImage('textures/menu_bg.png')

--THIS ARE THE OBJECT CLASS (WHERE THE VALUES OF OBJECTS ARE KEPT)
Class = require 'class'
require 'paddle1'
require 'paddle2'
require 'ball'
require 'buttons'

--This is the multiplier value for the change of y (dy)
movementOfY = 350

function love.load()
      math.randomseed(os.time())
      
      menu_font = love.graphics.newFont('font.ttf', 32)
      
      sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
            
      love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = false
    })
  
   paddlePlayerOne = paddle1(40, 120, 25, 150)
   paddlePlayerTwo = paddle2(WINDOW_WIDTH -80, WINDOW_HEIGHT - 240, 25, 150)
   playBall = ball(WINDOW_WIDTH/2, WINDOW_HEIGHT/2, 20)
   winningPlayer = 0

   player1Score = 0
   player2Score = 0
   
  buttons = buttons()

  -- It is a list of buttons that has the same y-axis which coded by "for" function 
  buttons:SetButtons()

  -- Default key for the paddles
  p1Up = 'w'
  p1Down = 's'
  p2Up = 'up'
  p2Down = 'down'
end

function love.draw()
  love.graphics.draw(background, 0, 0)
            
  if game_State == 'menu' then
    game_Menu()
  
  elseif game_State == 'start' then --When the game_State is start, the ball is not moving and its in the center
    game_Play() -- renders the objects on screen
  
  elseif game_State == 'play'  then -- When the game_State is play, the objects now have collision and the ball is moving
    game_Play()
  
  elseif game_State == 'win' then
    game_End()
    
  elseif game_State == 'options' then
    game_Options()
  
  elseif game_State == 'exit' then
    love.event.quit()
  end

  love.graphics.setFont(menu_font)
end

function love.keypressed(key)
  --This condition will initiate the game_State from 'start' to 'play'
 if game_State == 'start' then
    if key == 'return' then
      game_State = 'play'
    elseif key == 'escape' then
      game_State = 'menu'
    end
  end

  if game_State == 'win' then
    if key == 'space' or 'escape' then
      player1Score = 0
      player2Score = 0
      game_State = 'menu'
    end
  end

  if game_State == 'options' then
    buttons:PlayerKey(key)
  end
end

function love.update(dt)
   if game_State == 'start' then
     if playerServe == 1 then
       playBall.dx = 200
     else 
       playBall.dx = -200
     end
   
   elseif game_State == 'play' then -- Condition to initialize the Ball update and the collision and resets
     --(START) this handles the collision of the ball to the paddle
     if playBall:collision(paddlePlayerOne) then
       playBall.dx = -playBall.dx * 1.1
       playBall.x = paddlePlayerOne.x + 40
       
       if playBall.dy < 0 then
         playBall.dy = -math.random(300, 500)
       else
         playBall.dy = math.random(300, 500)
       end
       sounds['paddle_hit']:play()
     end
     
     if playBall:collision(paddlePlayerTwo) then
       playBall.dx = -playBall.dx * 1.1
       playBall.x = paddlePlayerTwo.x - 20
       
       if playBall.dy < 0 then
         playBall.dy = -math.random(300, 500)
       else
         playBall.dy = math.random(300, 500)
       end
                        
       sounds['paddle_hit']:play()
                        
     end
     -- (END)
     
     --(START) this handles the collision of the ball in respect to y
     if playBall.y <= 0 then
       playBall.y = 0
       playBall.dy = -playBall.dy
       sounds['wall_hit']:play()
     end
     
     if playBall.y >= WINDOW_HEIGHT then
       playBall.y = WINDOW_HEIGHT - 20
       playBall.dy = -playBall.dy
       sounds['wall_hit']:play()
      end
      --(END) 

      --(START) this handles the reset of the ball
   if playBall.x < 0 then --conditional operator of the ball's x
     playerServe = 1
     player2Score = player2Score + 1
     sounds['score']:play()
    if player2Score == 10 then
       game_State = 'win'
       winningPlayer = 2
       
    else
      game_State = 'start'
      playBall:reset()
    end
   end
   
   if playBall.x > WINDOW_WIDTH then
     playerServe = 2
     player1Score = player1Score + 1
     sounds['score']:play()
    if player1Score == 10 then
      game_State = 'win'
      winningPlayer = 1
    else
      game_State = 'start'
      playBall:reset()
    end
   end 
  --(END) 
   end 
   
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
  
   if game_State == 'play' then
     playBall:update(dt)
   end 
   
  --Updates paddle movements
   paddlePlayerOne:update(dt)
   paddlePlayerTwo:update(dt)
 end
 
function game_Menu()
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('PONG', 0, WINDOW_HEIGHT / 5, WINDOW_WIDTH, 'center')
  
  -- Menu Buttons
  buttons:MenuButton()
end

function game_Play() --FUNCTION FOR RENDERING THE OBJECTS
  love.graphics.setColor(1, 1, 1, 1)
  paddlePlayerOne:render()
  paddlePlayerTwo:render()
  playBall:render()
  
  love.graphics.printf(tostring(player1Score), 0 , WINDOW_HEIGHT / 8, WINDOW_WIDTH/2, 'center')
  love.graphics.printf(tostring(player2Score), WINDOW_WIDTH/4, WINDOW_HEIGHT / 8, WINDOW_WIDTH, 'center')
end

function game_Options()
  love.graphics.setColor(1,1,1,1)
  love.graphics.printf('Options', 0, WINDOW_HEIGHT * 0.05, WINDOW_WIDTH, 'center')
  love.graphics.printf('Keybindings:', WINDOW_WIDTH * 0.1, WINDOW_HEIGHT * 0.15, WINDOW_WIDTH, 'left')
  
  -- Player Key Buttons
  buttons:PlayerKey()
  -- Vsync Button
  buttons:Vsync()
  -- Exit Button
  buttons:Exit()
end

function game_End()
  love.graphics.setColor(1, 1, 1, 1)
  
  love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
                        0, 10, WINDOW_WIDTH, 'center')

  -- The ball will return again to the center
  playBall:reset()
end

function fpsDisplay()
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print('FPS : ' .. tostring(love.timer.getFPS()), 10, 10)
end
