-- virtual resolution library
push = require "libs/push/push"
bf = require("libs/breezefield")
Object = require "libs/classic/classic"
require 'Hole'
--require 'Ball'
require 'Player'
require 'Energies'
require 'Badies'
require 'Walls'
require 'Particles'

love.window.setTitle("Marbles")

gameWidth, gameHeight = 400, 240
screenWidth, screenHeight = 1200, 720

pal = {
  white = {0.929, 0.925, 0.847},
  --yellow = {0.918, 0.620, 0.102},
  blue = {0.424, 0.792, 0.878},
  orange = {0.922, 0.451, 0.157},
  purple = {0.333, 0.255, 0.373},
  --pink = {0.580, 0.106, 0.357},
  --green = {0.216, 0.239, 0.024},
  --blue = {0.051, 0.118, 0.129},
  black = {0.024, 0.016, 0.122}
}
--local font = love.graphics.newImageFont("art/font.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
local font = love.graphics.newFont(28)
local fontS = love.graphics.newFont(20) 

function love.load()
  pause = true
  world = bf.newWorld(0, 0, false)
  --world:addCollisionClass('Ghost', {ignores = {'Solid'}})
  love.graphics.setDefaultFilter('nearest', 'nearest')
  print(world:getGravity())
  
  
  push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {
    fullscreen = false,
    resizable = true,
    pixelperfect = true
  })
  --push:setBorderColor{0.12, 0.11, 0.14} --default value
  push:setBorderColor{pal.black}

  --ground = bf.Collider.new(world, "Polygon",
  --        {0, 178, 0, 170 , 180, 170, 180, 178})
  --ground:setType("static")
  curHealth = 0
  wallThicknes = 2
  table.insert(walls, walls.new(gameWidth/2, gameHeight+wallThicknes, gameWidth + wallThicknes*2, wallThicknes))
  table.insert(walls, walls.new(gameWidth/2, -wallThicknes, gameWidth + wallThicknes * 2, wallThicknes))
  table.insert(walls, walls.new(-wallThicknes, gameHeight/2, wallThicknes, gameHeight))
  table.insert(walls, walls.new(gameWidth+wallThicknes, gameHeight/2, wallThicknes, gameHeight))
  
  --ground = bf.Collider.new(world, "Rectangle", gameWidth/2, gameHeight-wallThicknes, gameWidth, wallThicknes)
  --wall_left = bf.Collider.new(world, "Rectangle", wallThicknes, gameHeight/2, wallThicknes, gameHeight)
  --wall_right = bf.Collider.new(world, "Rectangle", gameWidth-wallThicknes, gameHeight/2, wallThicknes, gameHeight)
  --ceiling = bf.Collider.new(world, "Rectangle", gameWidth/2, wallThicknes, gameWidth, wallThicknes)
  --ground:setType('static')
  --wall_left:setType('static')
  --wall_right:setType('static')
  --ceiling:setType('static')
  --hole = bf.Collider.new(world, "Circle", gameWidth/2, gameHeight/2, 5)
  --hole:setType('static')
  --destroy_queue = {}
  local boxSize = 4
  local boxOffset = wallThicknes + boxSize

  
  --food = {}
  level = 1
  rangeOffset = -10
  levelThresh = 100
  maxScore = 0
  bonusHealth = 0
  grow = 0
  growtimerM = 1/30
  growtimer = growtimerM

  timerM = 3
  timer = timerM
  wavesM = 3
  waves = wavesM
  spawnMult = 2
  --for i = 1, 2 do
  --  local temp = bf.Collider.new(world, "Rectangle",love.math.random(boxOffset, gameWidth-boxOffset), 
  --    love.math.random(boxOffset, gameHeight-boxOffset), boxSize, boxSize)
  --  temp:setRestitution(0.15)
  --  temp:setLinearDamping(0.1)
  --  --temp:set
  --  table.insert(food, temp)
  --end

  
  for i = 1, 40 do
    local rad = 3
    local pos = randomPos(rad)
    table.insert(energies, energies.new(pos.x, pos.y, rad))
  end
  --ball = Ball.new( 325/5, 325/5)
  startHealth = 30
  player = player.new(gameWidth / 2 - 15, gameHeight / 2, 4, startHealth)
  
  
  --for i = 1, 4 do
  --  local temp = Bady.new(love.math.random(9, gameWidth-9), 9)
  --  table.insert(badies, temp)
  --end
  hole = hole.new( gameWidth/2, gameHeight/2)

  --font = love.graphics.newFont(28) 
  bgback = love.graphics.newImage("art/background.png")
  bgback:setWrap("repeat", "repeat")
  bgbackquad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgback:getWidth(), bgback:getHeight())


  bgrange = love.graphics.newImage("art/range1.png")
  bgrange:setWrap("repeat", "repeat")
  bgrangequad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgrange:getWidth(), bgrange:getHeight())

  bghole = love.graphics.newImage("art/hole.png")
  bghole:setWrap("repeat", "repeat")
  bgholequad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bghole:getWidth(), bghole:getHeight())  
  
  bgplayer = love.graphics.newImage("art/player.png")
  bgplayer:setWrap("repeat", "repeat")
  bgplayerquad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgplayer:getWidth(), bgplayer:getHeight())  
  
  bgbady = love.graphics.newImage("art/enemy.png")
  bgbady:setWrap("repeat", "repeat")
  bgbadyquad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgbady:getWidth(), bgbady:getHeight())
  
  bgfood = love.graphics.newImage("art/food.png")
  bgfood:setWrap("repeat", "repeat")
  bgfoodquad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgfood:getWidth(), bgfood:getHeight())
end

function randomPos(rad)
  local out = {}
  --local boxOffset =  rad
  out.x = love.math.random(rad, gameWidth-rad)
  out.y = love.math.random(rad, gameHeight-rad)
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

function love.gamepadpressed(joystick, button)
  if button == 'start' then
      --print("pause")
      pause = not pause
  elseif button =='x' then
    curHealth= 5
    --player.pulse()
  --  for i=#badies,1,-1 do
  --    local bady = badies[i]
  --    
  --    bady.kill()
  --  end
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    pause = not pause
  end
end

function growUpdate(dt)
  growtimer = growtimer - dt
  
    if growtimer < 0 then
      local chain = player.getRange()
      growtimer = growtimerM
      if grow ~= 0 then
        curHealth = curHealth + grow
      end
      if grow == 0 and chain >= levelThresh then
        if level == 15 then
          victory()
        end
        for i=#badies,1,-1 do
          badies[i].kill()
        end
        growtimerM = 1/30
        grow = 2
      end
      if chain >= 224 then
        growtimerM = 1/12
        grow = -1
      end
      if grow < 0  and chain <= startHealth + bonusHealth then
        curHealth = startHealth + bonusHealth - chain 
        bonusHealth = 0
        --if #badies > 0 then
        --  badies[1].kill()
        --end
        --grow = grow -
        --chain = 30
        grow = 0
        level = level + 1
        
        bgrange = love.graphics.newImage("art/range" .. level .. ".png")
        bgrange:setWrap("repeat", "repeat")
        bgrangequad = love.graphics.newQuad(0, 0, screenWidth, screenHeight, bgrange:getWidth(), bgrange:getHeight())      
      end
    end
end

function victory()
  for i=#badies,1,-1 do
    table.remove(badies, i)
  end
  for i=#energies,1,-1 do
    table.remove(energies, i)
  end
  pause = true
end

function love.update(dt)
  score = (level - 1) * levelThresh + player.getRange() + rangeOffset
  if score > maxScore then
    maxScore = score
  end
  joysticks = love.joystick.getJoysticks()
  --if #joysticks > 0 then
  --  joystick = joysticks[1]
  --  if joystick:isGamepadDown("start") then
  --    print("pause")
  --    cooldown = .2
  --    pause = not pause
  --  end
  --end
  --if love.keypressed.isDown("space") then
  --  pause = not pause
  --end
  if pause then
    return
  end
  world:update(dt)
  hole.update(dt)

  growUpdate(dt)

  timer = timer - dt
  if waves < 0 then 
    waves = wavesM + level
    spawnMult = math.random(18-level,24-level/2)/10
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
      for i=1,12 do
        table.insert(particles, particles.new(
          bady.getX(),bady.getY(), 1,
          'orange',math.random(6,8)/10,-math.random(6,8)/10,math.random()*2*math.pi,math.random(14,22)))
      end
      --print("dead")
      table.remove(badies, i)
      local bx = bady.getX()
      local by = bady.getY()
      bady.destroy()
      local rad = 3
      --local pos = randomPos(rad)
      table.insert(energies, energies.new(bx, by, rad))
    else
      bady.update(dt)
    end
  end
  for i=#energies,1,-1 do
    local energy = energies[i]
    
    if energy.isDead() == true then
      --print("collected")
      table.remove(energies, i)
      energy.destroy()
      --table.insert(energies, energies.new())
    else
      energy.update(dt)
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
  for p=#particles,1,-1 do
    local particle = particles[p]
    if particle.isDead() == true then
      table.remove(particles, p)
    else
      particle.update(dt)
    end
  end

end

local function playerStencil()
  love.graphics.setColor(1,1,1)
  love.graphics.circle("fill", 
    player.getX(),-- / gameWidth * screenWidth, 
    player.getY(),-- / gameHeight * screenHeight, 
    player.getRadius())--R / gameWidth * screenWidth)
  --love.graphics.circle("fill", ball.getX(), ball.getY(), ball.getRadius())
end
local function badyStencil()
  love.graphics.setColor(1,1,1)
  for i, v in ipairs(badies) do
    love.graphics.circle("fill", 
      v.getX(),-- / gameWidth * screenWidth, 
      v.getY(),-- / gameHeight * screenHeight,
      v.getRadius())-- / gameWidth * screenWidth)
  end
end
local function foodStencil()
  love.graphics.setColor(1,1,1)
  for i, v in ipairs(energies) do
    love.graphics.circle("fill", 
      v.getX(),-- / gameWidth * screenWidth, 
      v.getY(), --/ gameHeight * screenHeight, 
      v.getRadius()) --/ gameHeight * screenHeight)
  end
end
local function holeStencil()
  love.graphics.setColor(1,1,1)
  love.graphics.circle("fill", hole.getX(), hole.getY(), hole.getRadius())
end
local function rangeStencil()
  love.graphics.setColor(1,1,1)
  love.graphics.circle("fill", hole.getX(), hole.getY(), player.getRange())
end

function love.draw()
  love.graphics.setFont(font)
  --push:start()
  --love.graphics.setBackgroundColor(1,1,1)
  --love.graphics.setColor(0.4, 0.3, 0.02)
  --love.graphics.rectangle("line", 0,0,gameWidth,gameHeight)
  --push:finish()
  
  --love.graphics.setStencilTest("greater", 0)
  --push:start()
  --push:finish()
  
  push:start()
  
  world:draw()
  --love.graphics.draw(bgback, bgbackquad, 0, 0)

  love.graphics.setStencilTest("greater", 0)
  love.graphics.stencil(rangeStencil, "replace", 1)
  love.graphics.draw(bgrange, bgrangequad, 0, 0)

  love.graphics.setStencilTest()
  --player.drawEffects()
  --for i,b in ipairs(badies) do
  --  b.drawEffects()
  --end
  --for i, f in ipairs(energies) do
  --  f.drawEffects()
  --end
  
  --love.graphics.setStencilTest()
  --love.graphics.setStencilTest("greater", 0)
  --love.graphics.stencil(holeStencil, "replace", 1)
  --love.graphics.draw(bghole, bgholequad, 0, 0)

  for i, e in ipairs(particles) do
    e.draw()
  end

  love.graphics.setStencilTest("greater", 0)
  love.graphics.stencil(playerStencil, "replace", 1)
  love.graphics.draw(bgplayer, bgplayerquad, 0, 0)

  --love.graphics.setStencilTest("greater", 0)
  love.graphics.stencil(foodStencil, "replace", 1)
  love.graphics.draw(bgfood, bgfoodquad, 0, 0)

  --love.graphics.setStencilTest("greater", 0)
  love.graphics.stencil(badyStencil, "replace", 1)
  love.graphics.draw(bgbady, bgbadyquad, 0, 0)
  love.graphics.setStencilTest()
  
  
  --love.graphics.setColor(0.04, 0.3, 0.02)
  --love.graphics.ellipse("fill", gameWidth/2, gameHeight/2, gameHeight/32, gameHeight/32, 8)
  --love.graphics.rectangle("line", 0,0,gameWidth,gameHeight)
  hole.draw()
  player.draw()

  push:finish()
  love.graphics.setColor(unpack(pal.white)) 
  local scoreD = player.getRange() + rangeOffset
  if grow ~= 0 then
    scoreD = scoreD .. ' + ' .. bonusHealth
  end
  love.graphics.printf(scoreD, 0, screenHeight / 20, screenWidth, 'center')
  local lvls = ''
  for i=1,level do
    lvls = lvls .. '•'
  end
  love.graphics.printf(lvls, 0, screenHeight/20 + 24, screenWidth,'center')

  love.graphics.setFont(fontS)
  local debugT = 'Waves: '.. waves .. 
    '\r\nMult: ' .. spawnMult
  love.graphics.print(debugT, 10, 50)
  
  love.graphics.print(love.timer.getFPS(),10,0)


  --love.graphics.printf(#badies, 0, screenHeight / 20, screenWidth, 'left')
  if pause then
    drawMenu()
    --push:start()
    --love.graphics.draw(bgrange, bgbadyquad, 0, 0)
    --push:finish()
    --push:finish()
    --return
  end

  
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

function drawOutlineRec(y,width,height)
  love.graphics.setColor(unpack(pal.black))
  love.graphics.rectangle("fill",screenWidth/2-width/2,y-13,width,height)
  love.graphics.setColor(unpack(pal.purple))
  love.graphics.rectangle("line",screenWidth/2-width/2,y-13,width,height)
end


function drawMenu()
  love.graphics.setColor(.2,.2,.2,.2)
  love.graphics.rectangle("fill",0,0,screenWidth,screenHeight)
  love.graphics.setColor(unpack(pal.black))
  drawOutlineRec(screenHeight/4+41,160,48)
  drawOutlineRec(screenHeight/4,200,48)
  
  drawOutlineRec(screenHeight/7*5,300,142)
  --love.graphics.rectangle("fill",screenWidth/2-80,screenHeight/4+44,160,40)
  --love.graphics.rectangle("fill",screenWidth/2-150,screenHeight/7*5-10,300,140)
  --love.graphics.setColor(unpack(pal.purple))
  --love.graphics.rectangle("line",screenWidth/2-100,screenHeight/4-10,200,50)
  --love.graphics.rectangle("line",screenWidth/2-80,screenHeight/4+44,160,40)
  --love.graphics.rectangle("line",screenWidth/2-150,screenHeight/7*5-10,300,140)
  love.graphics.setColor(unpack(pal.white))
  --love.graphics.print("PAUSED", screenWidth/2, screenHeight/3)
  love.graphics.printf("PAUSED", 0, screenHeight/4 , screenWidth, 'center')
  --love.graphics.printf("SELECT")
  love.graphics.setFont(fontS)
  love.graphics.printf('Score: ' .. maxScore, 0, screenHeight/4+41, screenWidth, 'center')
  --love.graphics.printf("Press start", 0, screenHeight/4 + 60, screenWidth, 'center')
  love.graphics.printf("Move using left joystick\r\nDefend home\r\nCollect food\r\n...\r\nPress start", 0, screenHeight/7*5 , screenWidth, 'center')

end