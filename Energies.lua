
energies = {}
function energies.new(x, y, r)
  local self = {}
  self.__index = self
  local dead = false
  local moveCenter = false
  local sense = 3
  local senseScale = math.random(4,14)/10
  local da = nil
  local timerM = math.random(25,75)/100
  local timer = timerM
  local rewalkM = math.random(2,6)
  local rewalk = rewalkM
  local closest = nil
  local speed = 0.42
  local mode = {r=0, g=0, b = 0}
  local xdir,ydir = nil
  --local effects = {}
  --local etimerM = 2
  --local etimer = etimerM

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

  function self.update(dt)
    --etimer = etimer - dt
    --if etimer < 0 then
    --  etimer = etimerM
    --  table.insert(effects, particles.new(
    --    physics.getX(),physics.getY(),physics.getRadius()*.8,
    --    'green',8,0,0,0))
    --end
    --for e=#effects,1,-1 do
    --  local effect = effects[e]
    --  if effect.isDead() == true then
    --    table.remove(effects, e)
    --  else
    --    effect.update(dt)
    --  end
    --end


    local x = physics.getX()
    local y = physics.getY()
    timer = timer - dt
    if timer < 0 then
      timer = timerM
      --moveCenter = false

      da = distAngle(x, y, hole.getX(), hole.getY())
      --print(da.dist)
      --sense = 180 / (da.dist ^ 0.8) + physics.getRadius()
      sense =  senseScale * .4 * (da.dist) + physics.getRadius() *2
      --local  closest = nil
      closest = nil
      local colls = world:queryCircleArea(x, y, sense)
      for _, collider in ipairs(colls) do
        if collider.identity == 'energy' then
          local a = distAngle(x, y, collider.getX(), collider.getY())
          if a.dist > 0 and (closest == nil or closest.dist > a.dist) then
            closest = a
          end
        
        end
        --elseif collider.identity == 'wall' then
        --  moveCenter = true
        --end
      end
    end
    
    local da = distAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY()) 
  --if moveCenter then
    xdir = 0.5 * math.cos(da.angle) * speed
    ydir = 0.5 * math.sin(da.angle) * speed

    rewalk = rewalk - dt
    if rewalk < 0 then
      rewalk = rewalkM
      dir = math.random() * math.pi * 2
      xdir = xdir + .5 * math.cos(dir) * speed
      ydir = ydir +.5 * math.sin(dir) * speed
    end
    --local xdir, ydir = nil
    
      --mode = {r=1, g=0, b = 0}
      --physics:applyForce(xbounce,ybounce)
    --elseif closest ~= nil then
    if closest ~= nil then
      xdir = xdir - math.cos(closest.angle) * speed
      ydir = ydir - math.sin(closest.angle) * speed
    end
      --mode = {r=0, g=1, b = 0}
      --physics:applyForce(-xdir,-ydir)
    --else

  
      
      --mode = {r=0, g=0, b = 1}
    --end
    --xdir = x1 + x2/ 2 + x3 / 4
    --xdir = x1 + x2/ 2 + x3 / 4
    physics:applyForce(xdir,ydir)
  end

  function physics:postSolve(other)
    if other.identity == 'player' then
      --print("collect")
      if grow == 0 then
        curHealth = curHealth + 3
      else 
        bonusHealth = bonusHealth + 3
      end
      dead = true
    --elseif other.identity == 'wall' then
    --  moveCenter = true
    end
  end
  
  function physics:draw(alpha)

  end

  --function self.drawEffects()
  --  for i, e in ipairs(effects) do
  --    e.draw()
  --  end
  --  --push:finish()
  --  --local x, y = push:toReal(physics.getX(), physics.getY())
  --  --love.graphics.circle('line', x, y, sense)
  --  --push:start()
  --end

  return self
end
