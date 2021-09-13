window = {
    title = 'Plain vs Meteors',
    size = { x = 320, y = 480 },
    background = {
        src = 'images/background.png',
    }
}

plane = {
    src = 'images/14bis.png',
    size = { x = 55, y = 63 },
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
    plane.src = 'images/explosao_nave.png'
    plane.ref = love.graphics.newImage(plane.src)
end

meteor_src = 'images/meteoro.png'
meteors_max_size = 12
meteors = {}

function addMeteor()
    newMeteor = {
        size = { x = 50, y = 40 },
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
    for index,meteor in ipairs(meteors) do
        meteor.position.y = meteor.position.y + meteor.mass
        meteor.position.x = meteor.position.x + meteor.x_shift
    end
end

function removeInvisibleMeteors()
    for index = #meteors,1,-1 do
        if meteors[index].position.y > window.size.y then
            table.remove(meteors, index)
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

function love.load()
    love.window.setTitle(window.title)
    love.window.setMode(window.size.x, window.size.y, { resizable = false })
    window.background.ref = love.graphics.newImage(window.background.src)
    plane.ref = love.graphics.newImage(plane.src)
    meteor_ref = love.graphics.newImage(meteor_src)
    setupPlainPosition()
    math.randomseed(os.time())
end

function love.update(dt)
    if(GAME_OVER) then return end
    updatePlainPosition()
    updateMeteorsPosition()
    removeInvisibleMeteors()
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
end
