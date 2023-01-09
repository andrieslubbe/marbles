-- virtual resolution library
push = require "libs/push/push"
bf = require("libs/breezefield")
Object = require "libs/classic/classic"
require 'Hole'
--require 'Ball'
require 'Player'
require 'Energies'
require 'Badies'

love.window.setTitle("Marbles")

gameWidth, gameHeight = 400, 240
screenWidth, screenHeight = 1200, 720



function love.load()
  world = bf.newWorld(0, 0, false)
  --world:addCollisionClass('Ghost', {ignores = {'Solid'}})
  love.graphics.setDefaultFilter('nearest', 'nearest')
  print(world:getGravity())
  
  
  push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {
    fullscreen = false,
    resizable = true,
    pixelperfect = true
  })
  push:setBorderColor{0.12, 0.11, 0.14} --default value

  --ground = bf.Collider.new(world, "Polygon",
  --        {0, 178, 0, 170 , 180, 170, 180, 178})
  --ground:setType("static")
  wallThicknes = 2
  ground = bf.Collider.new(world, "Rectangle", gameWidth/2, gameHeight-wallThicknes, gameWidth, wallThicknes)
  wall_left = bf.Collider.new(world, "Rectangle", wallThicknes, gameHeight/2, wallThicknes, gameHeight)
  wall_right = bf.Collider.new(world, "Rectangle", gameWidth-wallThicknes, gameHeight/2, wallThicknes, gameHeight)
  ceiling = bf.Collider.new(world, "Rectangle", gameWidth/2, wallThicknes, gameWidth, wallThicknes)
  ground:setType('static')
  wall_left:setType('static')
  wall_right:setType('static')
  ceiling:setType('static')
  --hole = bf.Collider.new(world, "Circle", gameWidth/2, gameHeight/2, 5)
  --hole:setType('static')
  destroy_queue = {}
  local boxSize = 4
  local boxOffset = wallThicknes + boxSize
  --food = {}
  --
  timerM = 3
  timer = timerM
  wavesM = 5
  waves = wavesM
  spawnMult = 1
  --for i = 1, 2 do
  --  local temp = bf.Collider.new(world, "Rectangle",love.math.random(boxOffset, gameWidth-boxOffset), 
  --    love.math.random(boxOffset, gameHeight-boxOffset), boxSize, boxSize)
  --  temp:setRestitution(0.15)
  --  temp:setLinearDamping(0.1)
  --  --temp:set
  --  table.insert(food, temp)
  --end

  
  for i = 1, 35 do
    local rad = 3
    local pos = randomPos(rad)
    table.insert(energies, energies.new(pos.x, pos.y, rad))
  end
  --ball = Ball.new( 325/5, 325/5)
  player = player.new(gameWidth / 2 - 15, gameHeight / 2, 4)
  
  
  --for i = 1, 4 do
  --  local temp = Bady.new(love.math.random(9, gameWidth-9), 9)
  --  table.insert(badies, temp)
  --end


  hole = Hole.new( gameWidth/2, gameHeight/2)
  bgplayer = love.graphics.newImage("art/greenS.jpg")
  bgbady = love.graphics.newImage("art/red.jpg")
  bgfood = love.graphics.newImage("art/grass.jpg")
  bgfood:setWrap("repeat", "repeat")
  bgfoodquad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgfood:getWidth(), bgfood:getHeight())
end

function randomPos(rad)
  local out = {}
  local boxOffset = wallThicknes + rad
  out.x = love.math.random(boxOffset, gameWidth-boxOffset)
  out.y = love.math.random(boxOffset, gameHeight-boxOffset)
  return out
end

--function love.mousepressed()
--  local x, y
--  local radius = 3
--  x, y = push:toGame(love.mouse.getPosition())
--  print(x,y)
--  local colls = world:queryCircleArea(x, y, radius)
--  for _, collider in ipairs(colls) do
--    print(collider.identity)
--    if collider.identity == 'bady' then
--      collider:destroy()
--    end
--  end
--end

function love.update(dt)
  world:update(dt)
  timer = timer - dt
  if waves < 0 then 
    waves = wavesM
    spawnMult = math.random(6,20)/10
  end
  if timer < 0 then
    waves = waves - 1
    timer = (timerM + math.random(-10, 10) / 10) * spawnMult
    local side = love.math.random(0,3)
    
    --table.insert(badies, badies.new(love.math.random(9, gameWidth-9), 9))
    --print(table.getn(badies))
    if side == 0 then
      table.insert(badies, badies.new(love.math.random(9, gameWidth-9), 9))
    elseif side == 1 then
      table.insert(badies, badies.new(gameWidth-9, love.math.random(9, gameHeight-9)))
    elseif side == 2 then
      table.insert(badies, badies.new(love.math.random(9, gameWidth-9), gameHeight-9))
    elseif side == 3 then
      table.insert(badies, badies.new(9, love.math.random(9, gameHeight-9)))
    end
  end

  --spawnTimer = spawnTimer + dt
  --if spawnTimer > 3 then
  --  spawnTimer = 0
  --  local side = love.math.random(0,3)
  --  if side == 0 then
  --    temp = bf.Collider.new(world, "Circle",love.math.random(9, gameWidth-9), 
  --      9, 4)
  --  elseif side == 1 then
  --    temp = bf.Collider.new(world, "Circle",gameWidth-9, 
  --      love.math.random(9, gameHeight-9), 4)
  --  elseif side == 2 then
  --    temp = bf.Collider.new(world, "Circle",love.math.random(9, gameWidth-9), 
  --      gameHeight-9, 4)
  --  elseif side == 3 then
  --    temp = bf.Collider.new(world, "Circle",9, 
  --      love.math.random(9, gameHeight-9), 4)
  --  end
--
  --  local dx = hole:getX() - temp:getX()
  --  local dy = hole:getY() - temp:getY()
  --  local pow = 0.01
  --  --temp:applyForce(pos.x - holepos.x, pos.y-holepos.y)
  --  temp:applyLinearImpulse(dx * pow, dy * pow)
  --  temp:setLinearDamping(0.1)
  --  table.insert(badies, temp)
  --end
  player.update(dt)
  --for i, v in ipairs(badies) do
  --  v.update(dt)
  --end
  for i=#badies,1,-1 do
    local bady = badies[i]
    
    if bady.isDead() == true then
      print("dead")
      table.remove(badies, i)
      bady.destroy()
    else
      bady.update(dt)
    end
  end
  for i=#energies,1,-1 do
    local energy = energies[i]
    
    if energy.isDead() == true then
      print("collected")
      table.remove(energies, i)
      energy.destroy()
      --table.insert(energies, energies.new())
    --else
    --  energy.update(dt)
    end
  end
  --if spawnTimer > 1 then
    --for i=#food,1,-1 do
      --ceiling.fixture:setUserData(nil)
      --ceiling.fixture:destroy()
    --end
  --end

  
  --for b in pairs(destroy_queue) do
  --  world:DestroyBody(b)
  --  destroy_queue[b] = nil
  --end

end

local function playerStencil()
  love.graphics.circle("fill", player.getX() / gameWidth * screenWidth, 
    player.getY() / gameHeight * screenHeight, 
    player.getRadius() / gameWidth * screenWidth)
  --love.graphics.circle("fill", ball.getX(), ball.getY(), ball.getRadius())
end
local function badyStencil()
  for i, v in ipairs(badies) do
    love.graphics.circle("fill", 
      v.getX() / gameWidth * screenWidth, 
      v.getY() / gameHeight * screenHeight,
      v.getRadius() / gameWidth * screenWidth)
  end
end
local function foodStencil()
  for i, v in ipairs(energies) do
    love.graphics.circle("fill", v.getX() / gameWidth * screenWidth, v.getY()/ gameHeight * screenHeight, v.getRadius()/ gameHeight * screenHeight)
  end
end

function love.draw()
  
  --love.graphics.setStencilTest("greater", 0)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.stencil(foodStencil, "replace", 1)
  love.graphics.draw(bgfood, bgfoodquad, 0, 0)
  love.graphics.stencil(playerStencil, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.draw(bgplayer)
  love.graphics.stencil(badyStencil, "replace", 1)
  love.graphics.setStencilTest("greater", 0)
  love.graphics.draw(bgbady)
  love.graphics.setStencilTest()

  push:apply("start")
  
  
  
  world:draw()
  --love.graphics.setColor(0.04, 0.3, 0.02)
  --love.graphics.ellipse("fill", gameWidth/2, gameHeight/2, gameHeight/32, gameHeight/32, 8)
  --love.graphics.rectangle("line", 0,0,gameWidth,gameHeight)
  
  push:apply("end")
  
end


function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function getAngle(x1, y1, x2, y2)
  return math.atan2(y1 - y2,x1 - x2) + math.pi
end

function distAngle(x1, y1, x2, y2)
  out = {}
  out.dist = distanceBetween(x1, y1, x2, y2)
  out.angle = getAngle(x1, y1, x2, y2)
  return out
end