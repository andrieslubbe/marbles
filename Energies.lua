
energies = {}
function energies.new(x, y, r)
  local self = {}
  self.__index = self
  local dead = false
  local moveCenter = false
  local sense = 5
  local senseScale = math.random(6,14)/10
  local da = nil
  local timerM = math.random(25,75)/100
  local timer = timerM
  local rewalkM = math.random(2,8)
  local rewalk = rewalkM
  local closest = nil
  local speed = 30
  local mode = {r=0, g=0, b = 0}
  local xdir,ydir = nil
  local effects = {}
  local etimerM = 1/4
  local etimer = etimerM

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
    etimer = etimer - dt
    if etimer < 0 then
      etimer = etimerM
      table.insert(effects, particles.new(
        physics.getX(),physics.getY(),physics.getRadius()*.8,
        'green',8))
    end
    for e=#effects,1,-1 do
      local effect = effects[e]
      if effect.isDead() == true then
        table.remove(effects, e)
      else
        effect.update(dt)
      end
    end


    local x = physics.getX()
    local y = physics.getY()
    timer = timer - dt
    if timer < 0 then
      timer = timerM
      moveCenter = false

      da = distAngle(x, y, hole.getX(), hole.getY())
      --print(da.dist)
      --sense = 180 / (da.dist ^ 0.8) + physics.getRadius()
      sense =  senseScale * .05 * (da.dist ^ 1.2) + physics.getRadius() *2
      --local  closest = nil
      closest = nil
      local colls = world:queryCircleArea(x, y, sense)
      for _, collider in ipairs(colls) do
        if collider.identity == 'energy' then
          local a = distAngle(x, y, collider.getX(), collider.getY())
          if a.dist > 0 and (closest == nil or closest.dist > a.dist) then
            closest = a
          end
        
        
        elseif collider.identity == 'wall' then
          moveCenter = true
        end
      end
    end
    
    local da = distAngle(physics.getX(), physics.getY(), hole.getX(), hole.getY()) 
  --if moveCenter then
    xdir = 0.1 * math.cos(da.angle) * speed * dt
    ydir = 0.1 * math.sin(da.angle) * speed * dt

    rewalk = rewalk - dt
    if rewalk < 0 then
      rewalk = rewalkM
      dir = math.random() * math.pi * 2
      xdir = xdir + .5 * math.cos(dir) * speed * dt
      ydir = ydir +.5 * math.sin(dir) * speed * dt
    end
    --local xdir, ydir = nil
    
      --mode = {r=1, g=0, b = 0}
      --physics:applyForce(xbounce,ybounce)
    --elseif closest ~= nil then
    if closest ~= nil then
      xdir = xdir - math.cos(closest.angle) * speed * dt
      ydir = ydir - math.sin(closest.angle) * speed * dt
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
      dead = true
    --elseif other.identity == 'wall' then
    --  moveCenter = true
    end
  end

  function physics:draw(alpha)
    for i, e in ipairs(effects) do
      e.draw()
    end
    push:finish()
    local x, y = push:toReal(physics.getX(), physics.getY())
    --love.graphics.setColor(mode.r, mode.g, mode.b)
    --love.graphics.circle('line', x, y, sense)
    --local x2, y2 = push:toGame(physics.getX()+xdir*100,physics.getY()+ydir*100)
    --if x2 ~= nil and y2 ~= nil then
    --  
    --  love.graphics.line(x,y,x2,y2)
    --end
    --local ya = physics.getY() / gameHeight * screenHeight
    --local out = ""
    if closest ~= nil then
      --out = "A"
      --love.graphics.line(physics.getX(), physics.getY(), hole.getX(), hole.getY())
      --love.graphics.print(closest.dist, x, y)
    end
    --love.graphics.print(out, physics.getX(), physics.getY())
    push:start()
  end

  return self
end
