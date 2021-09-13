function love.load()
    love.window.setMode(320, 480, { resizable = false })
    love.window.setTitle('14bis vs Meteoros')
    background = love.graphics.newImage('images/background.png')
    x, y, w, h = 20, 20, 60, 20
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        y = y - 1
    end
    if love.keyboard.isDown('s') then
        y = y + 1
    end
    if love.keyboard.isDown('a') then
        x = x - 1
    end
    if love.keyboard.isDown('d') then
        x = x + 1
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.rectangle("fill", x, y, w, h)
end
