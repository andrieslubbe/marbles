
walls = {}
function walls.new(x, y, width, height)
  local self = {}
  self.__index = self

  local physics = bf.Collider.new(world, "Rectangle", x, y, width, height)
  physics.identity = 'wall'
  physics:setType('static')
  setmetatable(self, physics)

  

  --function physics:draw(alpha)
  --  --push:finish()
  --  love.graphics.rectangle(physics.getX())
  --  --push:start()
  --end

  return self
end