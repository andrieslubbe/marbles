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
  local effects = {}
  --local etimerM = 1/30
  --local etimer = etimerM

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
  function self.getRange()
    return chain
  end

  function self.update(dt)
    --local mult = 18
    --etimer = etimer - dt
    --if etimer < 0 then
    --  etimer = etimerM
      table.insert(effects, particles.new(
        physics.getX(),physics.getY(),physics.getRadius()-1,
        'green', 1, true))
    --end
    for e=#effects,1,-1 do
      local effect = effects[e]
      if effect.isDead() == true then
        table.remove(effects, e)
      else
        effect.update(dt)
      end
    end
    chain = chain + curHealth
    curHealth = 0
    da = distAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    local moveAngles = {}
    if da.dist < chain then
      if love.keyboard.isDown("w") then
        --physics:applyForce(0, -speed*dt)
        table.insert(moveAngles, math.pi * 1.5)
        if love.keyboard.isDown("s") then
          table.insert(moveAngles,math.pi*2)
        end
      elseif love.keyboard.isDown("s") then
        --physics:applyForce(speed*dt, 0)
        table.insert(moveAngles,0)
      end
      if love.keyboard.isDown("r") then
        --physics:applyForce(0, speed*dt)
        table.insert(moveAngles,math.pi / 2)
      end
      if love.keyboard.isDown("a") then
        --physics:applyForce(-speed*dt, 0)
        table.insert(moveAngles, math.pi)
      end
      
      if #moveAngles > 0 then
        local sum = 0
        for _,v in pairs(moveAngles) do -- Get the sum of all numbers in t
          sum = sum + v
        end
        local moveAngle = sum / #moveAngles
        --moveAngle = moveAngle % (2 * math.pi)
        local xbounce = math.cos(moveAngle) * speed * dt
        local ybounce = math.sin(moveAngle) * speed * dt
        physics:applyForce(xbounce,ybounce)
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
    --love.graphics.setColor(unpack(pal.purple))
    --love.graphics.arc('line', 'open', hole.getX(), hole.getY(), chain, 
    --  11.5/6 * math.pi, 9.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', hole.getX(), hole.getY(), chain, 
    --  8.5/6 * math.pi, 6.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', hole.getX(), hole.getY(), chain, 
    --  5.5/6 * math.pi, 3.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', hole.getX(), hole.getY(), chain, 
    --  2.5/6 * math.pi, .5 / 6 * math.pi)

    

    
    --local stress = math.max(0.5, (da.dist / chain)^3)
    --love.graphics.setColor(1 - stress/4, 1 - stress, 1 - stress)
    --love.graphics.line(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    
    
    
    --love.graphics.print(curdist, physics.getX(), physics.getY())
    --love.graphics.setColor(.2, 1, 0.1)
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  function self.drawEffects()
    for i, e in ipairs(effects) do
      e.draw()
    end
    
  end

  return self
end
