particles = {}

function particles.new(x,y,r,col,timer,shrink)
  local self = {}
  self.__index = self

  --local timerM = lifetime
  --local timer = timerM
  local x,y,r,timer = x,y,r,timer
  local deltar = r/timer
  local dead = false
  local col = pal[col]

  function self.isDead()
    return dead
  end

  function self.update(dt)
    timer = timer - dt
    if timer < 0 then
      dead = true
    end
    if shrink then 
     r = r - deltar * dt
    end
  end

  function self.draw()
    love.graphics.setColor(unpack(col))
    love.graphics.circle('fill',x,y,r,8)
  end

  return self

end