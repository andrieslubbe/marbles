
energies = {}
function energies.new(x, y, r)
  local self = {}
  self.__index = self
  local dead = false

  local physics = bf.Collider.new(world, 'Circle', x, y, r)
  --local buffer = bf.Collider.new(world, 'Circle', x, y, r*2)
  physics.identity = 'energy'
  physics:setLinearDamping(3)
  setmetatable(self, physics)

  function self.getX()
    return physics.getX()
  end
  function self.getY()
    return physics.getY()
  end
  function self.getRadius()
    return physics.getRadius()
  end

  function self.isDead()
    return dead
  end
  function self.destroy()
    physics:destroy()
  end

  --function self.update(dt)
  --  local x, y
  --  local radius = 3
  --  local colls = world:queryCircleArea(physics.getX(), physics.getY(), radius)
  --  for _, collider in ipairs(colls) do
  --    if collider.identity == 'player' then
  --      local a = getAngle(physics.getX(), physics.getY(), collider.getX(), collider.getY())
  --      local xbounce = math.cos(a) * 3 * dt
  --      local ybounce = math.sin(a) * 3 * dt
  --      physics:applyForce(xbounce,ybounce)
  --    end
  --  end
  --end

  function physics:postSolve(other)
    if other.identity == 'player' then
      --print("collect")
      dead = true
    end
  end

  function physics:draw(alpha)
    --love.graphics.setColor(.2, 1, 0.1)
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  return self
end
