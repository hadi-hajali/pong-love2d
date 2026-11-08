local windowWidth = 800
local windowHeight = 600
local waitingForServe = true
local serveDirection = 1

-- Return the ball to the center
local function resetBall()
    ball.x = (windowWidth - ball.width) / 2
    ball.y = (windowHeight - ball.height) / 2
    ball.dx = 0
    ball.dy = 0
    waitingForServe = true
end

-- Check whether two rectangles overlap (AABB)
local function checkCollision(a, b)
    return a.x < b.x + b.width
        and a.x + a.width > b.x
        and a.y < b.y + b.height
        and a.y + a.height > b.y
end

-- Set up the game once at startup
function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("Pong - Hadi Haj Ali")
    love.graphics.setBackgroundColor(0.05, 0.05, 0.08)

    player1 = {
        x = 30,
        y = 250,
        width = 15,
        height = 100,
        speed = 350,
        score = 0
    }

    player2 = {
        x = 755,
        y = 250,
        width = 15,
        height = 100,
        speed = 350,
        score = 0
    }

    ball = {
        x = 0,
        y = 0,
        width = 14,
        height = 14,
        dx = 0,
        dy = 0
    }

    scoreFont = love.graphics.newFont(36)
    textFont = love.graphics.newFont(18)

    resetBall()
end

-- Move a paddle and keep it inside the window
local function movePaddle(paddle, upKey, downKey, dt)
    if love.keyboard.isDown(upKey) then
        paddle.y = paddle.y - paddle.speed * dt
    end

    if love.keyboard.isDown(downKey) then
        paddle.y = paddle.y + paddle.speed * dt
    end

    paddle.y = math.max(
        0,
        math.min(windowHeight - paddle.height, paddle.y)
    )
end

local function updateBall(dt)
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Bounce off the top and bottom walls
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = math.abs(ball.dy)
    elseif ball.y + ball.height >= windowHeight then
        ball.y = windowHeight - ball.height
        ball.dy = -math.abs(ball.dy)
    end

    -- Bounce off the left paddle
    if ball.dx < 0 and checkCollision(ball, player1) then
        ball.x = player1.x + player1.width
        ball.dx = -ball.dx
    end

    -- Bounce off the right paddle
    if ball.dx > 0 and checkCollision(ball, player2) then
        ball.x = player2.x - ball.width
        ball.dx = -ball.dx
    end

    -- Award a point when the ball leaves the screen
    if ball.x + ball.width < 0 then
        player2.score = player2.score + 1
        serveDirection = -1
        resetBall()
    elseif ball.x > windowWidth then
        player1.score = player1.score + 1
        serveDirection = 1
        resetBall()
    end
end

-- Update movement and collisions every frame
function love.update(dt)
    -- Small steps help prevent missed collisions on slow frames
    local steps = math.max(1, math.ceil(dt / (1 / 120)))
    local stepDt = dt / steps

    for i = 1, steps do
        movePaddle(player1, "w", "s", stepDt)
        movePaddle(player2, "up", "down", stepDt)

        if not waitingForServe then
            updateBall(stepDt)
        end
    end
end

-- Handle single key presses
function love.keypressed(key)
    if key == "space" and waitingForServe then
        ball.dx = 300 * serveDirection
        ball.dy = 200
        waitingForServe = false

    elseif key == "r" then
        player1.y = 250
        player2.y = 250
        player1.score = 0
        player2.score = 0
        serveDirection = 1
        resetBall()

    elseif key == "escape" then
        love.event.quit()
    end
end

-- Draw the game every frame
function love.draw()
    -- Dashed center line
    love.graphics.setColor(0.25, 0.25, 0.3)

    for y = 0, windowHeight, 30 do
        love.graphics.rectangle(
            "fill",
            windowWidth / 2 - 2, y,
            4, 15
        )
    end

    -- Left paddle: blue
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle(
        "fill",
        player1.x, player1.y,
        player1.width, player1.height
    )

    -- Right paddle: orange
    love.graphics.setColor(1, 0.5, 0.2)
    love.graphics.rectangle(
        "fill",
        player2.x, player2.y,
        player2.width, player2.height
    )

    -- Ball
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle(
        "fill",
        ball.x, ball.y,
        ball.width, ball.height
    )

    -- Scores
    love.graphics.setFont(scoreFont)
    love.graphics.printf(
        tostring(player1.score),
        0, 25, windowWidth / 2, "center"
    )
    love.graphics.printf(
        tostring(player2.score),
        windowWidth / 2, 25,
        windowWidth / 2, "center"
    )

    -- Controls
    love.graphics.setFont(textFont)
    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.print("W / S", 75, 15)
    love.graphics.print("UP / DOWN", 610, 15)

    love.graphics.printf(
        "R: Reset  |  ESC: Quit",
        0, windowHeight - 30,
        windowWidth, "center"
    )

    if waitingForServe then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            "Press SPACE to serve",
            0, 350, windowWidth, "center"
        )
    end
end