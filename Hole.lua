hole = {}

function hole.new(x, y)
  local self = {}
  self.__index = self

  local cooldownM = .8
  local cooldown = 0
  local inv, hit = false
  local physics = bf.Collider.new(world, 'Circle', x, y, 5)
  physics:setType('static')
  physics.identity = 'hole'
  setmetatable(self, physics)


  function self.getX()
    return physics.getX()
  end
  function self.getY()
    return physics.getY()
  end
  function self.getRadius()
    return 5
  end
  function self.update(dt)
    if hit then
      inv = true
      hit = false
      curHealth = -1
    end
    cooldown = cooldown - dt
    if cooldown < 0 then
      inv = false
      cooldown = cooldownM
    end
  end


  function physics:draw(alpha)
    local f = 'line'
    if inv then
      --f = 'fill'
      --love.graphics.setColor(0.922, 0.451, 0.157) --orange
      love.graphics.setColor(0.216, 0.239, 0.024) --green
    else
      love.graphics.setColor(0.929, 0.925, 0.847) --white
    end
    love.graphics.circle(f, self:getX(), self:getY(), self:getRadius(), 8)
    
  end

  function physics:postSolve(other)
  if other.identity == 'bady' then
    --local i = #badies
    --badies[i].destroy()
    --table.remove(badies, i)
    if inv == false then
      hit = true
    end
    --print("bad")
  end
  --self:die()
  end

  return self
end



