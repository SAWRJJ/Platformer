function love.load()
    love.window.setMode(1000, 768)

    anim8 = require "libraries/anim8/anim8"
    sti = require "libraries/Simple-Tiled-Implementation/sti"
    sprites = {}
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    
    animations = {}
    animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)
    animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)

    wf = require 'libraries/windfield/windfield'
    -- 改变重力方向
    world = wf.newWorld(0, 800, false) 
    world:setQueryDebugDrawing(true)

    world:addCollisionClass('platform')
    world:addCollisionClass('player' --[[, {ignores = {'platform'}}]])
    world:addCollisionClass('danger')

    require('player')
    platform = world:newRectangleCollider(250, 400, 300, 100, {collision_class = "platform"})
    platform:setType('static')

    dangerZone = world:newRectangleCollider(0, 550, 800, 50, {collision_class = "danger"})
    dangerZone:setType('static')

    loadMap()
end

function love.update(dt)
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
end

function love.draw()
    
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    world:draw()
    drawPlayer()
end

function love.keypressed(key)
    if key == 'space' then
        if player.grounded then
            player:applyLinearImpulse(0, -4000)
            
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

function loadMap()
    gameMap = sti("maps/level1.lua")
end