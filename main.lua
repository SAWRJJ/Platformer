function love.load()
    anim8 = require "libraries/anim8/anim8"
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    
    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    animations.junp = anim8.newAnimation(grid('1-7', 2), 0.05)
    animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)

    wf = require 'libraries/windfield/windfield'
    -- 改变重力方向
    world = wf.newWorld(0, 800, false) 
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('platform')
    world:addCollisionClass('player' --[[, {ignores = {'platform'}}]])
    world:addCollisionClass('danger')
    player = world:newRectangleCollider(360, 100, 80, 80, {collision_class = "player"})
    player:setFixedRotation(true)
    player.speed = 240
    player.animation = animations.run

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

    player.animation:update(dt)

end

function love.draw()
    world:draw()
    player.animation:draw(sprites.playerSheet, 0, 0)
end

function love.keypressed(key)
    if key == 'space' then
        local colliders = world:queryRectangleArea(player:getX() - 40, player:getY()+40, 80, 2, {'platform'})
        if #colliders > 0 then
            player:applyLinearImpulse(0, -6000)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'platform', 'danger'})
        for i,c in ipairs(colliders) do
            c:destory()
        end
    end
end