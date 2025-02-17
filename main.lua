function love.load()
    wf = require 'libraries/windfield/windfield'
    -- 改变重力方向
    world = wf.newWorld(0, 800, false) 

    world:addCollisionClass('platform')
    world:addCollisionClass('player' --[[, {ignores = {'platform'}}]])
    world:addCollisionClass('danger')
    player = world:newRectangleCollider(360, 100, 80, 80, {collision_class = "player"})
    player:setFixedRotation(true)
    player.speed = 240

    platform = world:newRectangleCollider(250, 400, 300, 100, {collision_class = "platform"})
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0, 550, 800, 50, {collision_class = "danger"})
    dangerZone:setType('static')
end

function love.update(dt)
    world:update(dt)


    if player.body then
        local px, py = player:getPosition()
        if love.keyboard.isDown('d') then
            player:setX(px + player.speed*dt)
        end
        if love.keyboard.isDown('a') then
            player:setX(px - player.speed*dt)
        end

        if player:enter("danger") then
            player:destroy()
        end
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