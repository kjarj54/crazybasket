function love.load()
    love.physics.setMeter(64)

    world = love.physics.newWorld(0, 9.81 * 64, true)

    bg = love.graphics.newImage("bg.png")
    basketball = love.graphics.newImage("ball.png")
    basket = love.graphics.newImage("canasta.png")

    message = ""
    mouseX = ""
    sum = 0
    points = 0
    time = 60
    R = 255
    G = 255
    B = 255
    goal = false
    endgame = false

    love.audio.stop()
    love.audio.play(love.audio.newSource("basket-rock.mp3", "stream"))

    objects = {}

    objects.ground = {}

    objects.ground.body = love.physics.newBody(world, 1000 / 2, 424 - 50 / 2)
    objects.ground.shape = love.physics.newRectangleShape(1000, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

    createBall()

    objects.block1 = {}

    objects.block1.body = love.physics.newBody(world, 768, 125, "static")
    objects.block1.shape = love.physics.newRectangleShape(0, 0, 10, 10)
    objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5)

    objects.block2 = {}
    objects.block2.body = love.physics.newBody(world, 848, 78, "static")
    objects.block2.shape = love.physics.newRectangleShape(0, 0, 10, 120)
    objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 5)

    love.graphics.setBackgroundColor(104, 136, 248)
    love.window.setMode(1000, 424)
    love.window.setTitle("Crazy Basket")
    love.window.setIcon(love.image.newImageData("ball.png"))

    love.graphics.setFont(love.graphics.newFont(42))

end

function love.update(dt)
    world:update(dt)
    if time > 1 then

        time = time - dt
        mouseX = love.mouse.getX()

        if love.mouse.isDown(1) then
            sum = sum + 20
            objects.ball.fixture:destroy()
            createBall()
            objects.ball.body:applyLinearImpulse(sum, -mouseX)
            goal = false
        else
            sum = 0
        end

        if objects.block1.body:getY() <= objects.ball.body:getY() and objects.block1.body:getY() + 10 >=
            objects.ball.body:getY() and objects.block1.body:getX() <= objects.ball.body:getX() and
            objects.block2.body:getX() >= objects.ball.body:getX() and goal == false then
            points = points + 1
            goal = true
        end

        R = 255
        G = 255
        B = 255
    else
        if endgame == false then
            R = 255
            G = 0
            B = 0

            sfx = love.audio.newSource("buzzer.mp3", "static")
            love.audio.play(sfx)
            message = "Game Over"
            mouseX = 0
            endgame = true
        end

    end
end

function createBall()
    -- Crea el objeto balón con sus propiedades físicas
    objects.ball = {}

    -- Posiciona el balón en la esquina inferior izquierda de la pantalla
    objects.ball.body = love.physics.newBody(world, 40, 424 - 100, "dynamic")

    -- Define la forma como un círculo con radio de 20 píxeles
    objects.ball.shape = love.physics.newCircleShape(20)

    -- Asocia la forma al cuerpo con una densidad de 1
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)

    -- Establece el coeficiente de restitución para simular rebotes realistas
    objects.ball.fixture:setRestitution(0.9)
end

function resetGame()
    -- Reinicia las variables del juego
    message = ""
    mouseX = 0
    sum = 0
    points = 0
    time = 60
    R = 255
    G = 255
    B = 255
    goal = false
    endgame = false

    -- Reinicia el estado del mundo físico
    world:destroy()
    world = love.physics.newWorld(0, 9.81 * 64, true)

    -- Vuelve a crear los objetos
    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, 1000 / 2, 424 - 50 / 2)
    objects.ground.shape = love.physics.newRectangleShape(1000, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)

    createBall()

    objects.block1 = {}
    objects.block1.body = love.physics.newBody(world, 768, 125, "static")
    objects.block1.shape = love.physics.newRectangleShape(0, 0, 10, 10)
    objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5)

    objects.block2 = {}
    objects.block2.body = love.physics.newBody(world, 848, 78, "static")
    objects.block2.shape = love.physics.newRectangleShape(0, 0, 10, 120)
    objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 5)

    -- Reinicia la música
    love.audio.stop()
    love.audio.play(love.audio.newSource("basket-rock.mp3", "stream"))
end

function love.keypressed(key)
    if key == "r" then
        resetGame()
    end
end

function love.draw()
    -- Dibuja la imagen de fondo en la posición (0, 0)
    love.graphics.draw(bg, 0, 0)

    -- Muestra la información de puntos y tiempo restante en pantalla
    love.graphics.setColor(255, 255, 255) -- Establece color blanco para el texto
    love.graphics.print(points, 80, 25) -- Muestra el puntaje actual
    love.graphics.print(math.floor(time) .. "s", 253, 25) -- Muestra el tiempo restante en segundos
    love.graphics.setColor(R, G, B) -- Aplica el color actual del juego (normal o rojo al finalizar)

    -- Dibuja el balón en su posición física actual con la rotación correcta
    love.graphics.draw(basketball, objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.body:getAngle(), 1, 1, basketball:getWidth() / 2, basketball:getHeight() / 2)

    -- Dibuja la canasta en una posición fija
    love.graphics.draw(basket, 815, 162, math.rad(0), 1, 1, basket:getWidth() / 2, basket:getHeight() / 2)

    -- Dibuja una barra verde vertical que representa la fuerza de impulso acumulada
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle("fill", 5, 424, 5, -sum)

    -- Dibuja una marca amarilla vertical que representa la posición del ratón (altura de lanzamiento)
    love.graphics.setColor(255, 255, 0)
    love.graphics.rectangle("fill", 4, 425, 5, -mouseX)

    -- Muestra el mensaje de fin de juego cuando corresponda
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf(message, 250, 180, 500, "center")

    if endgame then
        -- Muestra el mensaje para reiniciar el juego cuando el tiempo se acabe
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("Press R to Reset", 0, 380, 1000, "center")
    end

    -- Restaura el color actual del juego
    love.graphics.setColor(R, G, B)
end
