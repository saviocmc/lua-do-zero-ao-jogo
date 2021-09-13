window = {
    title = 'Plain vs Meteors',
    size = { x = 320, y = 480 },
    background = {
        src = 'images/background.png',
    }
}

plane = {
    src = 'images/14bis.png',
    size = { x = 64, y = 63 },
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

meteor_src = 'images/meteoro.png'
meteors_max_size = 12
meteors = {}

function addMeteor()
    newMeteor = { x = math.random(window.size.x), y = 0 }
    table.insert(meteors, newMeteor)
end

function updateMeteorsPosition()
    for index,meteor in ipairs(meteors) do
        meteor.y = meteor.y + 1
    end
end

function removeInvisibleMeteors()
    for index = #meteors,1,-1 do
        if meteors[index].y > window.size.y then
            table.remove(meteors, index)
        end
    end
end

function love.load()
    love.window.setTitle(window.title)
    love.window.setMode(window.size.x, window.size.y, { resizable = false })
    window.background.ref = love.graphics.newImage(window.background.src)
    plane.ref = love.graphics.newImage(plane.src)
    meteor_ref = love.graphics.newImage(meteor_src)
    setupPlainPosition()
end

function love.update(dt)
    updatePlainPosition()
    updateMeteorsPosition()
    removeInvisibleMeteors()
    if #meteors < meteors_max_size then
        addMeteor()
    end
end

function love.draw()
    love.graphics.draw(window.background.ref, 0, 0)
    for index,meteor in ipairs(meteors) do
        love.graphics.draw(meteor_ref, meteor.x, meteor.y)
    end
    love.graphics.draw(plane.ref, plane.position.x, plane.position.y)
end
