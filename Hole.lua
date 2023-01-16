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
  function self.setInv(b)
    inv = b
  end


  function self.update(dt)
    if hit then
      inv = true
      hit = false
      curHealth = curHealth -1
    end
    cooldown = cooldown - dt
    if cooldown < 0 then
      inv = false
      cooldown = cooldownM
    end
  end


  function self.draw()
  --  local f = 'line'
    if inv then
  --    --f = 'fill'
  --    --love.graphics.setColor(0.922, 0.451, 0.157) --orange
      love.graphics.setColor(unpack(pal.purple))
    else
      love.graphics.setColor(unpack(pal.white))
    end
    love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius(), 16)
  --  
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



