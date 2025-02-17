function love.load()
    wf = require 'libraries/windfield/windfield'
    -- 改变重力方向
    world = wf.newWorld(0, 800) 

    player = world:newRectangleCollider(360, 100, 80, 80)
    player.speed = 240
    platform = world:newRectangleCollider(250, 499, 300, 100)
    platform:setType('static')
end

function love.update(dt)
    world:update(dt)


    local px, py = player:getPosition()
    if love.keyboard.isDown('d') then
        player:setX(px + player.speed*dt)
    end
    if love.keyboard.isDown('a') then
        player:setX(px - player.speed*dt)
    end
end

function love.draw()
    world:draw()
end

function love.keypressed(key)
    if key == 'w' then
        player:applyLinearImpulse(0, -5000)
    end
end