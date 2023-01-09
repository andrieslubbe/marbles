player = {}

function player.new(x, y, r)
  local self = {}
  self.__index = self
  --local dead = false
  local chain = 30
  local speed = 1080
  local damp = 1.5
  --local curdist = nil
  --local curangle = nil
  local da = nil

  local physics = bf.Collider.new(world, 'Circle', x, y, r)
  physics.identity = 'player'
  physics:setRestitution(0.8) -- any function of shape/body/fixture works
  physics:setLinearDamping(damp)
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

  function self.update(dt)
    --local mult = 18
    da = distAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    if da.dist < chain then
      if love.keyboard.isDown("s") then
        physics:applyForce(speed*dt, 0)
      elseif love.keyboard.isDown("a") then
        physics:applyForce(-speed*dt, 0)
      elseif love.keyboard.isDown("w") then
        physics:applyForce(0, -speed*dt)
      elseif love.keyboard.isDown("r") then
        physics:applyForce(0, speed*dt)
      end
    else 
      local xbounce = math.cos(da.angle) * speed * dt
      local ybounce = math.sin(da.angle) * speed * dt
      physics:applyForce(xbounce,ybounce)
    end
    
  end

  function physics:postSolve(other)
    if other.identity == 'energy' then
      --print("collect")
      chain = chain + 3
    end
  end

  function physics:draw(alpha)
    local stress = math.max(0.5, (da.dist / chain)^3)
    love.graphics.setColor(1 - stress/4, 1 - stress, 1 - stress)
    love.graphics.line(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    --love.graphics.print(curdist, physics.getX(), physics.getY())
    --love.graphics.setColor(.2, 1, 0.1)
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  return self
end
