Ball = Object:extend()

function Ball.new(x, y)
  local n = bf.Collider.new(world, 'Circle', x, y, 4)
  n:setRestitution(0.8) -- any function of shape/body/fixture works
  n:setLinearDamping(1.5)
  setmetatable(n, Ball)
  return n
end

function Ball:draw(alpha)
  --love.graphics.setColor(.2, .6, 0.2)
  --love.graphics.circle('line', self:getX(), self:getY(), self:getRadius())
end

function Ball:update(dt)
  --TODO: allow for either or, not both (othewise will add too much force?)
  local mult = 18
  if love.keyboard.isDown("s") then
    ball:applyForce(mult, 0)
  elseif love.keyboard.isDown("a") then
    ball:applyForce(-mult, 0)
  elseif love.keyboard.isDown("w") then
    ball:applyForce(0, -mult)
  elseif love.keyboard.isDown("r") then
    ball:applyForce(0, mult)
  end

  local joysticks = love.joystick.getJoysticks()
  if #joysticks > 0 then
    joystick = joysticks[1]
    local xaxis = joystick:getGamepadAxis("leftx")
    local yaxis = joystick:getGamepadAxis("lefty")
    print(xaxis, yaxis)
    ball:applyForce(xaxis*mult, yaxis*mult)
  end
  
end
