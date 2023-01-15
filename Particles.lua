particles = {}

function particles.new(x,y,r,col,timer,grow,dir,speed)
  local self = {}
  self.__index = self

  --local timerM = lifetime
  --local timer = timerM
  local x,y,r,timer,speed = x,y,r,timer,speed
  local deltar = r/timer
  local deltas = speed/timer
  local dead = false
  local col = pal[col]

  function self.isDead()
    return dead
  end

  function self.update(dt)
    if speed > 0 then
      speed = speed - deltar * dt
      x = x + math.cos(dir) * speed * dt
      y = y +  math.sin(dir) * speed * dt
    end
    
    timer = timer - dt
    if timer < 0 then
      dead = true
    end
     
    r = r - grow * deltar * dt
    
  end

  function self.draw()
    love.graphics.setColor(unpack(col))
    love.graphics.circle('fill',x,y,r,8)
  end

  return self

end