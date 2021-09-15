window = {
    title = 'Plain vs Meteors',
    size = { x = 320, y = 480 },
    background = {
        src = 'images/background.png',
    }
}

plane = {
    src = 'images/plane.png',
    size = { x = 56, y = 62 },
    position = { x = 0, y = 0 },
}

function setupPlainPosition()
    plane.position.x = window.size.x / 2 - plane.size.x / 2
    plane.position.y = window.size.y - plane.size.y / 2
end

function updatePlainPosition()
    if love.keyboard.isDown('w') then
        plane.position.y = plane.position.y - 1
    end
    if love.keyboard.isDown('s') then
        plane.position.y = plane.position.y + 1
    end
    if love.keyboard.isDown('a') then
        plane.position.x = plane.position.x - 1
    end
    if love.keyboard.isDown('d') then
        plane.position.x = plane.position.x + 1
    end
end

function explodePlane()
    plane.src = 'images/explosion.png'
    plane.ref = love.graphics.newImage(plane.src)
    audios.background:stop()
    audios.explosion:play()
    audios.gameover:play()
end

meteor_src = 'images/meteor.png'
meteors_max_size = 12
meteors = {}

function addMeteor()
    newMeteor = {
        size = { x = 56, y = 42 },
        position = {
            x = math.random(window.size.x),
            y = -50,
        },
        x_shift = math.random(-1,1),
        mass = math.random(3),
    }
    table.insert(meteors, newMeteor)
end

function updateMeteorsPosition()
    for index = #meteors,1,-1 do
        local meteor = meteors[index]
        if meteor.position.y < window.size.y then
            meteor.position.y = meteor.position.y + meteor.mass
            meteor.position.x = meteor.position.x + meteor.x_shift
        else
            table.remove(meteors, index)
        end
    end
end

shot_src = 'images/shot.png'
shots = {}

function shoot()
    shot = {
        size = { x = 12, y = 12 },
        position = {
            x = plane.position.x + plane.size.x / 2 - 6,
            y = plane.position.y,
        },
    }
    table.insert(shots, shot)
    audios.shot:play()
end

function updateShotsPosition()
    for index = #shots,1,-1 do
        if shots[index].position.y > 0 then
            shots[index].position.y = shots[index].position.y - 1
        else
            table.remove(shots, index)
        end
    end
end

function removeShootedMeteors()
    for i = #meteors,1,-1 do
        meteor = meteors[i]
        for j = #shots,1,-1 do
            shot = shots[j]
            if hasOverlay(meteor, shot) then
                table.remove(meteors, i)
                table.remove(shots, j)
                break
            end
        end
    end
end

function hasOverlay(o1, o2)
    return
        o1.position.x < o2.position.x + o2.size.x and
        o2.position.x < o1.position.x + o1.size.x and
        o1.position.y < o2.position.y + o2.size.y and
        o2.position.y < o1.position.y + o1.size.y 
end

function isPlaneCrashed()
    for index,meteor in ipairs(meteors) do
        if hasOverlay(plane, meteor) then
            return true
        end
    end
    return false
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'space' and not GAME_OVER then
        shoot()
    end
end

function loadImages()
    window.background.ref = love.graphics.newImage(window.background.src)
    plane.ref = love.graphics.newImage(plane.src)
    meteor_ref = love.graphics.newImage(meteor_src)
    shot_ref = love.graphics.newImage(shot_src)
    gameover_ref = love.graphics.newImage('images/gameover.png')
end

function loadAudioTracks()
    audios = {
        background = love.audio.newSource('audios/background.wav', 'static'),
        shot = love.audio.newSource('audios/shot.wav', 'static'),
        explosion = love.audio.newSource('audios/explosion.wav', 'static'),
        gameover = love.audio.newSource('audios/gameover.wav', 'static'),
    }
end

function love.load()
    math.randomseed(os.time())
    love.window.setTitle(window.title)
    love.window.setMode(window.size.x, window.size.y, { resizable = false })
    loadImages() 
    loadAudioTracks()
    audios.background:setLooping(true)
    audios.background:play()
    setupPlainPosition()
end

function love.update(dt)
    if(GAME_OVER) then return end
    updatePlainPosition()
    updateMeteorsPosition()
    updateShotsPosition()
    removeShootedMeteors()
    if #meteors < meteors_max_size then
        addMeteor()
    end
    if isPlaneCrashed() then
        explodePlane()
        GAME_OVER = true
    end
end

function love.draw()
    love.graphics.draw(window.background.ref, 0, 0)
    for index,meteor in ipairs(meteors) do
        love.graphics.draw(meteor_ref, meteor.position.x, meteor.position.y)
    end
    love.graphics.draw(plane.ref, plane.position.x, plane.position.y)
    for index,shot in ipairs(shots) do
        love.graphics.draw(shot_ref, shot.position.x, shot.position.y)
    end
    if GAME_OVER then
        love.graphics.draw(gameover_ref, window.size.x/2 - gameover_ref:getWidth()/2, window.size.y/2 - gameover_ref:getHeight()/2)
    end
end
