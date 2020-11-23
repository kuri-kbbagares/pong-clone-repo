paddle1 = Class{}

function paddle1:init(x, y, width, height)
  self.image = love.graphics.newImage('textures/paddle1.png') -- paddle image
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.dy = 0
end

function paddle1:update(dt)
  --collision of the paddle in respect to the game_height
  if self.dy < 0 then
    self.y = math.max(0, self.y + self.dy * dt)
  else
    self.y = math.min(WINDOW_HEIGHT - self.height, self.y + self.dy * dt)
  end
end


function paddle1:render()
  love.graphics.draw(self.image, self.x, self.y)
 -- love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end