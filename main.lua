plane = {
    src = 'images/14bis.png',
    size = { x = 64, y = 63 },
    position = { x = 0, y = 0 },
}

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

function love.load()
    love.window.setMode(320, 480, { resizable = false })
    love.window.setTitle('14bis vs Meteoros')
    background = love.graphics.newImage('images/background.png')
    plane.ref = love.graphics.newImage(plane.src)
    x, y, w, h = 20, 20, 60, 20
end

function love.update(dt)
    updatePlainPosition()
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(plane.ref, plane.position.x, plane.position.y)
end
