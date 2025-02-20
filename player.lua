player = world:newRectangleCollider(360, 100, 40, 100, {collision_class = "player"})
player:setFixedRotation(true)
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1
player.grounded = true

function playerUpdate(dt)
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 20, player:getY()+50, 80, 2, {'platform'})
        if #colliders > 0 then
            player.grounded = true
        else
            player.grounded = false
        end
        
        player.isMoving = false
        local px, py = player:getPosition()
        if love.keyboard.isDown('d') then
            player:setX(px + player.speed*dt)
            player.isMoving = true
            player.direction = 1
        end
        if love.keyboard.isDown('a') then
            player:setX(px - player.speed*dt)
            player.isMoving = true
            player.direction = -1
        end

        if player:enter("danger") then
            player:destroy()
        end
    end

    if player.grounded then
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end
    player.animation:update(dt)
end

function drawPlayer()
    if player then
        local px, py = player:getPosition()
        player.animation:draw(sprites.playerSheet, px, py, nil, 0.25*player.direction, 0.25, 130, 300)
    end
end