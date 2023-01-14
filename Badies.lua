
badies = {}
function badies.new(x, y)
  local self = {}
  self.__index = self
  local dead = false
  local r = 4
  local timerM = math.random(15, 40) / 10
  --local timerV = math.random(0, timerM * 5) / 10
  local timer = -1
  local pow = math.random(700,2100)
  local damp = math.random(5,20)/100
  local effects = {}

  local physics = bf.Collider.new(world, 'Circle', x, y, r)
  physics.identity = 'bady'
  --local a = getAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY())
  --local xbounce = math.cos(a) * pow / 60
  --local ybounce = math.sin(a) * pow / 60
  --physics:applyForce(xbounce,ybounce)
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

  function self.isDead()
    return dead
  end
  function self.destroy()
    physics:destroy()
  end

  --function moveTowards(x1, y1, x2, y2)
  --  local t = distAngle(x1, y1, x2, y2)
  --  local out = {} 
  --  out.x = math.cos(t.angle)
  --  out.y = math.sin(t.angle)
  --  return out
  --end

  --function resetTimer()
  --  local t = math.random(0, timerV * 10) / 10
  --  --print(t)
  --  timer = timerM + t
  --end

  function self.update(dt)
    table.insert(effects, particles.new(
        physics.getX(),physics.getY(),physics.getRadius()-2,
        'orange',2.5,true))
    for e=#effects,1,-1 do
      local effect = effects[e]
      if effect.isDead() == true then
        table.remove(effects, e)
      else
        effect.update(dt)
      end
    end

    timer = timer - dt
    if timer < 0 then
      timer = timerM
      --dx = hole:getX() - x
      --dy = hole:getY() - y
      local a = getAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY())
      local xbounce = math.cos(a) * pow * dt
      local ybounce = math.sin(a) * pow * dt
      physics:applyForce(xbounce,ybounce)
    end
  end

  function physics:postSolve(other)
    if other.identity == "wall" then
      print("hit")
      dead = true
    end
  end

  function physics:draw(alpha)
    for i, e in ipairs(effects) do
      e.draw()
    end
    push:finish()
    
    push:start()
    --local xa = physics.getX() / gameWidth * screenWidth
    --local ya = physics.getY() / gameHeight * screenHeight
    --local ra = r / gameHeight * screenHeight
    --love.graphics.setColor(.4, 0, 0.05)
    --love.graphics.circle('line', xa, ya, ra)
    ----local s = math.floor(timerM*10)/10 .. ", " .. pow .. ", " .. damp
    ----love.graphics.print(s, x,y)
    --push:start()
  --  love.graphics.setColor(.4, 0, 0.05)
  --  love.graphics.circle('line', self:getX(), self:getY(), self:getRadius())
  end

  return self
end
