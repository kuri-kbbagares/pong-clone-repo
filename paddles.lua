paddles = Class{}

function paddles:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0
end

function paddles:update(dt)
  --collision of the paddle in respect to the game_height
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  else
    self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.dy * dt)
  end
end


function paddles:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end