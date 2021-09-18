local images = {}

local function loadImages()
    images.background = love.graphics.newImage('images/background.png')
    images.plane = love.graphics.newImage('images/plane.png')
    images.meteor = love.graphics.newImage('images/meteor.png')
    images.shot = love.graphics.newImage('images/shot.png')
    images.gameover = love.graphics.newImage('images/gameover.png')
    images.winner = love.graphics.newImage('images/winner.png')
end

local audios = {}

local function loadAudioTracks()
        audios.background = love.audio.newSource('audios/background.wav', 'static')
        audios.shot = love.audio.newSource('audios/shot.wav', 'static')
        audios.explosion = love.audio.newSource('audios/explosion.wav', 'static')
        audios.gameover = love.audio.newSource('audios/gameover.wav', 'static')
        audios.winner = love.audio.newSource('audios/winner.wav', 'static')
end

local window = {
    title = 'Plain vs Meteors',
    size = { x = 320, y = 480 },
}

local plane = {
    size = { x = 56, y = 62 },
    position = { x = 0, y = 0 },
}

local function setupPlainPosition()
    plane.position.x = window.size.x / 2 - plane.size.x / 2
    plane.position.y = window.size.y - plane.size.y
end

local function updatePlainPosition()
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

local function explodePlane()
    plane.src = 'images/explosion.png'
    plane.ref = love.graphics.newImage(plane.src)
    audios.background:stop()
    audios.explosion:play()
    audios.gameover:play()
end

local meteors_max_size = 12
local meteors = {}

local function addMeteor()
    local newMeteor = {
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

local function updateMeteorsPosition()
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

local shots = {}

local function shoot()
    local shot = {
        size = { x = 12, y = 12 },
        position = {
            x = plane.position.x + plane.size.x / 2 - 6,
            y = plane.position.y,
        },
    }
    table.insert(shots, shot)
    audios.shot:play()
end

local function updateShotsPosition()
    for index = #shots,1,-1 do
        if shots[index].position.y > 0 then
            shots[index].position.y = shots[index].position.y - 1
        else
            table.remove(shots, index)
        end
    end
end

local pointsCount = 0
local pointsToWin = 10

local function hasOverlay(o1, o2)
    return
        o1.position.x < o2.position.x + o2.size.x and
        o2.position.x < o1.position.x + o1.size.x and
        o1.position.y < o2.position.y + o2.size.y and
        o2.position.y < o1.position.y + o1.size.y
end

local function removeShootedMeteors()
    for i = #meteors,1,-1 do
        local meteor = meteors[i]
        for j = #shots,1,-1 do
            local shot = shots[j]
            if hasOverlay(meteor, shot) then
                table.remove(meteors, i)
                table.remove(shots, j)
                pointsCount = pointsCount + 1
                break
            end
        end
    end
end

local function isPlaneCrashed()
    for _,meteor in ipairs(meteors) do
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

function love.update()
    if(GAME_OVER or WINNER) then return end
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
    if pointsCount >= pointsToWin then
        WINNER = true
        audios.background:stop()
        audios.winner:play()
    end

end

function love.draw()
    love.graphics.draw(images.background, 0, 0)
    for _,meteor in ipairs(meteors) do
        love.graphics.draw(images.meteor, meteor.position.x, meteor.position.y)
    end
    love.graphics.draw(images.plane, plane.position.x, plane.position.y)
    for _,shot in ipairs(shots) do
        love.graphics.draw(images.shot, shot.position.x, shot.position.y)
    end
    love.graphics.print('Meteors to destroy: '..pointsToWin-pointsCount)
    if GAME_OVER then
        love.graphics.draw(
            images.gameover,
            window.size.x/2 - images.gameover:getWidth()/2,
            window.size.y/2 - images.gameover:getHeight()/2
        )
    end
    if WINNER then
        love.graphics.draw(
            images.winner,
            window.size.x/2 - images.winner:getWidth()/2,
            window.size.y/2 - images.winner:getHeight()/2
        )
    end
end
