ball = Class{}

function ball:init(x, y, radius)
  self.x = x
  self.y = y
  self.radius = radius
  self.dy = math.random(2) == 1 and -200 or 200
  self.dx = math.random(-150, 150)
end

function ball:collision(paddles)
  if self.x > paddles.x + paddles.width or paddles.x > self.x + self.radius then
    return false
  end
  
  if self.y > paddles.y + paddles.height or paddles.y > self.y + self.radius then
    return false
  end
  
  return true
end

function ball:reset()
  self.x = game_width/2
  self.y = game_height/2
  self.dy = math.random(2) == 1 and -200 or 200
  self.dx = math.random(-150, 150)
end

function ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

function ball:render()
  love.graphics.circle('fill', self.x, self.y, self.radius)
end