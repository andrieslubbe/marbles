powerups = {}


function powerups.new(x, y, type)
  local self = {}
  self.__index = self
  local type = type--ptypes[math.random(1,#ptypes)]
  local img = love.graphics.newImage("art/powerups/" .. type .. ".png")
  local dead = false
  local collected = false

  local physics = bf.Collider.new(world, 'Circle', x, y, 5)
  --physics:setType('static')
  physics.identity = 'energy'
  setmetatable(self, physics)

  function self.isDead()
    return dead
  end
  function self.destroy()
    physics:destroy()
  end
  function self.kill()
    dead = true
  end
  function self.isCollected()
    return collected
  end

  function self.getType()
    return type
  end
  --offer 3 random powerups
  --

  --speed: player + applyForce
  --bounce/knockback:enemy + restitution
  --agility: player + setLinearDamping
  --size: player + radius
  --aoe: player emits aoe on hit which repulses nearby badies
  --auto repulse: hole repulses nearby badies on hit
  --magnet: energies move towards player

  --jump: chain strength -applyForce
  --chain disable: remove check of range




  function physics:postSolve(other)
    if other.identity == 'player' then
      for i, p in ipairs(powerups) do
        p.kill()
      end
      dead = true
      collected = true
    end
  
  end

  function physics:draw(alpha)
  end
  

  function self.draw()
    love.graphics.draw(img,x,y,nil,nil,nil,4,4)
  end

  return self
end