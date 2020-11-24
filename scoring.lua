Class = require 'class'
 require 'paddles'
 require 'ball'
 require 'menu'

 main = Class{}

 -- This is the aspect ratio
 game_width = 1280
 game_height = 720

 --change of y variable ( hmmmm )
 movementOfY = 350
 menu = menu()

 function love.load()
   menu:store()
   math.randomseed(os.time()) --this is for math.random()

   paddlePlayerOne = paddles(40, 120, 25, 150)
   paddlePlayerTwo = paddles(game_width-80, game_height - 240, 25, 150)

   playBall = ball(game_width/2, game_height/2, 20)

   PlayerOneScore = 0
   PlayerTwoScore = 0

   ServingPlayer = 1

   WinningPlayer = 0

   gameState = 'start'
 end

 function love.update(dt)
   if gameState == 'serve' then
        playBall.dy = math.random(-50, 50)
        if ServingPlayer == 1 then
            playBall.dx = math.random(140, 200)
        else
            playBall.dx = -math.random(140, 200)
        end

   elseif gameState == 'play' then

     --this handles the collision of the ball to the paddle
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

     --this handles the collision of the ball in respect to y
      if playBall.y <= 0 then
        playBall.y = 0
        playBall.dy = -playBall.dy
      end

      if playBall.y >= game_height then
        playBall.y = game_height
        playBall.dy = -playBall.dy
      end
    end  

   -- updating the score and serving player
   if playBall.x < 0 then
      ServingPlayer = 1
      PlayerTwoScore = PlayerTwoScore + 1

      if PlayerTwoScore == 10 then
        WinningPlayer = 2
        gameState = 'done'
      else
        gameState = 'serve'
        playBall:reset()
        end
      end

    if playBall.x > game_width then
      ServingPlayer = 2
      PlayerOneScore = PlayerOneScore + 1

      if PlayerOneScore == 10 then
        WinningPlayer = 1
        gameState = 'done'
      else
        gameState = 'serve'
        playBall:reset()
      end
    end
  end



-- this handles controls the paddle
  if love.keyboard.isDown('w') then
     paddlePlayerOne.dy = -movementOfY
   elseif love.keyboard.isDown('s') then
     paddlePlayerOne.dy = movementOfY
    else
      paddlePlayerOne.dy = 0
   end

   if love.keyboard.isDown('up') then
     paddlePlayerTwo.dy = -movementOfY
   elseif love.keyboard.isDown('down') then
     paddlePlayerTwo.dy = movementOfY
   else
      paddlePlayerTwo.dy = 0
   end

   if gameState == 'play' then
     playBall:update(dt)
   end

   paddlePlayerOne:update(dt)
   paddlePlayerTwo:update(dt)


 end

 function love.keypressed(key)
   if key == 'escape' then
     love.event.quit()

    elseif key == 'enter' or key == 'return' then
      if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            gameState = 'serve'

            playBall:reset()

            -- reset the scores to 0
            PlayerOneScore = 0
            PlayerTwoScore = 0

            -- decide serving player as the opposite of who won
            if WinningPlayer == 1 then
                ServingPlayer = 2
            else
                ServingPlayer = 1
            end
        end
    end
end


function love.draw()
    push:start()

    if gameState == 'start' then
        -- (declare font size) love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        -- (declare font size) love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
    elseif gameState == 'done' then
        -- (declare font size) love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        -- (declare font size) love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- show the score before ball is rendered so it can move over the text
    displayScore()

    paddlePlayerOne:render()
    paddlePlayerTwo:render()
    playBall:render()

    displayFPS()

    -- end our drawing to push
    push:finish()
end

--[[
    Simple function for rendering the scores.
]]
function displayScore()
    -- score display
    -- (declare font size) love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(PlayerOneScore), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(PlayerTwoScore), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end

--[[
    Renders the current FPS.
]]

function play_Game()
  love.graphics.setColor(0, 0, 0, 1)
  love.graphics.printf(
    "PONG GAME",
    game_width/2 - 25,
    25,
    game_width
    --'center'
  )
  love.graphics.rectangle('line', 0, 0, game_width, game_height)
  -- love.graphics.circle('fill', game_width/2, game_height/2, 20)
  paddlePlayerOne:render()
  paddlePlayerTwo:render()
  playBall:render()

  fpsDisplay()
end

function fpsDisplay()
  love.graphics.setColor(0, 255/255, 0, 255/255)
  love.graphics.print('FPS : ' .. tostring(love.timer.getFPS()), 10, 10)
end
