Hole = Object:extend()

function Hole.new(x, y)
  local n = bf.Collider.new(world, 'Circle', x, y, 5)
  n:setType('static')
  setmetatable(n, Hole)
  return n
end

function Hole:draw(alpha)
  love.graphics.setColor(.4, .2, 0.0)
  love.graphics.circle('fill', self:getX(), self:getY(), self:getRadius())
end

function Hole:postSolve(other)
 if other.identity == 'bady' then
   --local i = #badies
   --badies[i].destroy()
   --table.remove(badies, i)
  print("bad")
 end
--self:die()
end
