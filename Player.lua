player = {}

function player.new(x, y, r, health)
  local self = {}
  self.__index = self
  --local dead = false
  local chain = health
  local speed = 18
  local damp = 1.5
  local pickup = 0
  --local curdist = nil
  --local curangle = nil
  local da = nil
  --local effects = {}
  --local grow = 0
  --local timerM = 1/20
  --local timer = timerM
  
  --local pulseO,pulseM,pulse,pulseV = false,4,0,30
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
  function self.pulse()
    if not pulseO then
      pulseO = true
    end
  end
  function self.getPickup()
    return pickup
  end

  function self.update(dt)
    
    --local mult = 18
    --etimer = etimer - dt
    --if etimer < 0 then
    --  etimer = etimerM
    local col = 'purple'
    if level > 8  then
      col = 'white'
    end
      table.insert(particles, particles.new(
        physics.getX(),physics.getY(),physics.getRadius()-1,
        col, 1, 1, 0,0))
    --end
    --for e=#effects,1,-1 do
    --  local effect = effects[e]
    --  if effect.isDead() == true then
    --    table.remove(effects, e)
    --  else
    --    effect.update(dt)
    --  end
    --end
    chain = chain + curHealth
    curHealth = 0
    da = distAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    local moveAngles = {}

    --local joysticks = love.joystick.getJoysticks()
    

    if da.dist < chain then
      if #joysticks > 0 then
        joystick = joysticks[1]
        local xaxis = joystick:getGamepadAxis("leftx") * speed
        local yaxis = joystick:getGamepadAxis("lefty") * speed
        --print(xaxis, yaxis)
        physics:applyForce(xaxis, yaxis)
      else
        if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
          table.insert(moveAngles, math.pi * 1.5)
          if love.keyboard.isDown("s") or love.keyboard.isDown("right") then
            table.insert(moveAngles,math.pi*2)
          end
        elseif love.keyboard.isDown("s") or love.keyboard.isDown("right") then
          table.insert(moveAngles,0)
        end
        if love.keyboard.isDown("r") or love.keyboard.isDown("down") then
          table.insert(moveAngles,math.pi / 2)
        end
        if love.keyboard.isDown("a")  or love.keyboard.isDown("left") then
          table.insert(moveAngles, math.pi)
        end
        
        if #moveAngles > 0 then
          local sum = 0
          for _,v in pairs(moveAngles) do -- Get the sum of all numbers in t
            sum = sum + v
          end
          local moveAngle = sum / #moveAngles
          --moveAngle = moveAngle % (2 * math.pi)
          local xbounce = math.cos(moveAngle) * speed
          local ybounce = math.sin(moveAngle) * speed
          physics:applyForce(xbounce,ybounce)
        end
      end
    else 
      local xbounce = math.cos(da.angle) * speed
      local ybounce = math.sin(da.angle) * speed
      physics:applyForce(xbounce,ybounce)
    end
    
    
  end

  

  function physics:postSolve(other)
    --if other.identity == 'energy' then
    --  --print("collect")
    --  chain = chain + 1
    --end
  end

  function self.draw()
    --push:finish()
    --love.graphics.font(physics.get,0,20)
    --push:start()
    --if pulseO then
    --love.graphics.setColor(unpack(pal.blue))
    --love.graphics.arc('line', 'open', physics.getX(), physics.getY(), pulseV, 
    --  11.5/6 * math.pi, 9.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', physics.getX(), physics.getY(), pulseV, 
    --  8.5/6 * math.pi, 6.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', physics.getX(), physics.getY(), pulseV, 
    --  5.5/6 * math.pi, 3.5 / 6 * math.pi)
    --love.graphics.arc('line', 'open', physics.getX(), physics.getY(), pulseV, 
    --  2.5/6 * math.pi, .5 / 6 * math.pi)
    --end
    

    
    --local stress = math.max(0.5, (da.dist / chain)^3)
    --love.graphics.setColor(1 - stress/4, 1 - stress, 1 - stress)
    --love.graphics.line(physics.getX(), physics.getY(), hole.getX(), hole.getY())
    
    
    
    --love.graphics.print(curdist, physics.getX(), physics.getY())
    --love.graphics.setColor(.2, 1, 0.1)
    --love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
  end

  --function self.drawEffects()
  --  for i, e in ipairs(effects) do
  --    e.draw()
  --  end
  --  
  --end

  return self
end
