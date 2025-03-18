require("components.map")
require("components.maze")
require("components.patterns")
require("components.curtain")

camera = require 'libraries/camera'
suit = require('libraries.suit')
Talkies = require('libraries.talkies')

function love.load()
    love.keyboard.setKeyRepeat(true)
    -- global variables
    created = false
    darkness = true
    input = {
        text = ""
    }
    scene = 1
    current_cell = 1
    Talkies.font = love.graphics.newFont("assets/fonts/Pixel UniCode.ttf", 40)

    -- map
    love.graphics.setBackgroundColor(0, 0, 0)
    CurtainCanvas = love.graphics.newCanvas(2000, 2000)
    worldMap = {}
    map = Map:new(Maze)
    patterns = Patterns:new(Maze)

    -- camera
    cam = camera()
    cam.scale = 1.5

    -- player
    player = {
        grid_x = 1024,
        grid_y = 1024,
        act_x = 200,
        act_y = 200,
        speed = 15
    }
    animation = newAnimation(love.graphics.newImage("ghost.png"), 32, 32, 1.5)

    -- dialogs
    Talkies.say("",
        "'El libre albedrío es el regalo de Dios a nuestro mundo, a nuestra raza, nuestro destino es forjado de nuestras decisiones.\nEs nuestro deber equivocarnos'\nDemian recordaba las palabras de su abuelo en una fría noche de diciembre",
        {
            padding = 70,
            textSpeed = "medium"
        })
    Talkies.say("",
        "Los latidos de su corazón casi parecieron detenerse\nEl esfuerzo por respirar era cada vez más grande\nMientras aún silencioso, e inmovil *ÉL* miraba a Demian",
        {
            padding = 60,
            textSpeed = "medium"
        })
    Talkies.say("",
        "El libre albedrío no es más que un mero cuento de hadas, una ilusión que nos hace creer que nuestras decisiones son nuestras, que nuestras acciones son nuestras, que nuestras vidas son nuestras\nPero no lo son\nNunca lo han sido\nNunca lo serán",
        {
            padding = 60,
            textSpeed = "medium"
        })
    Talkies.say("",
        "La vida humana no es más que un conjunto de variables que pasan por el automata de la vida al que ustedes llaman destino o Dios\nNo importa lo que decidas hoy o mañana, tu destino ya está escrito, tu vida ya está escrita, tu muerte ya está escrita",
        {
            padding = 60,
            textSpeed = "medium"
        })
    Talkies.say("", "Pero solo hay una forma de demostartelo, dime Demian ¿Cuál es el sentido de la vida?", {
        padding = 60,
        textSpeed = "medium"
    })
end

function love.update(dt)
    -- talkies required handler
    Talkies.update(dt)

    -- player movement
    player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
    player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)

    cam:lookAt(player.act_x, player.act_y)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    animation.currentTime = animation.currentTime + dt
    if animation.currentTime >= animation.duration then
        animation.currentTime = animation.currentTime - animation.duration
    end
    if (scene == 5) then
        suit.layout:reset(love.graphics.getWidth() / 2.5, love.graphics.getHeight() / 5)
        suit.Input(input, suit.layout:row(250, 100))
    end
end

function love.draw()
    love.window.setFullscreen(true)
    if (scene == 1) then
        sceneImg = love.graphics.newImage("art/scene1.jpg")
        love.graphics.draw(sceneImg, love.graphics.getWidth() / 10, 0, 0, 1.3, 1.3) -- x: 0, y: 0, rot: 0, scale x and scale y

    elseif (scene == 2) then
        sceneImg = love.graphics.newImage("art/scene2.jpg")
        love.graphics.draw(sceneImg, love.graphics.getWidth() / 10, 0, 0, 1.3, 1.3) -- x: 0, y: 0, rot: 0, scale x and scale y

    elseif (scene == 3) then
        sceneImg = love.graphics.newImage("art/scene3.jpg")
        love.graphics.draw(sceneImg, love.graphics.getWidth() / 10, 0, 0, 1.3, 1.3) -- x: 0, y: 0, rot: 0, scale x and scale y
    elseif (scene == 4) then
        sceneImg = love.graphics.newImage("art/scene4.jpg")
        love.graphics.draw(sceneImg, love.graphics.getWidth() / 10, 0, 0, 1.3, 1.3) -- x: 0, y: 0, rot: 0, scale x and scale y
    elseif (scene == 5) then
        sceneImg = love.graphics.newImage("art/scene5.jpg")
        love.graphics.draw(sceneImg, love.graphics.getWidth() / 10, 0, 0, 1.3, 1.3) -- x: 0, y: 0, rot: 0, scale x and scale y
    else
        cam:attach()
        love.graphics.setBackgroundColor(254, 254, 254)

        if (created == false) then

            pattern_message = patterns:change(input.text)
            patterns:paste(map, 200, 200)

        for i = 1, 200 do
            map:iterate()
        end

            neigh = map:count_neighbors()
            worldMap = map:generate_map()
            Mesh = createMesh(1)

            created = true
        end

        for y = 1, #worldMap do
            for x = 1, #worldMap[y] do
                if worldMap[y][x] == 1 then

                    local neighbors = neigh[y][x]
                    if (neighbors == 4) then
                        worldMap[y][x] = 0
                    end
                    -- color paredes
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
                end
            end
        end
        -- populate borders with 1's
        for y = 1, #worldMap do
            worldMap[y][1] = 1
            worldMap[y][#worldMap[y]] = 1
        end

        for x = 1, #worldMap[1] do
            worldMap[1][x] = 1
            worldMap[#worldMap][x] = 1
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.setBlendMode("alpha")

        -- and than drawing curtain
        love.graphics.draw(CurtainCanvas)
        love.graphics.setColor(1, 1, 1)

        local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
        love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.act_x, player.act_y)

        cam:detach()
        love.graphics.print("Position: " .. player.grid_x .. ", " .. player.grid_y, 10, 10)
        if (created == true) then
            if (darkness == true) then
                updateCurtainCanvas(player.act_x, player.act_y, 100)
            else
                removeCurtain(player.act_x, player.act_y, 100)
            end
        end
    end
    Talkies.draw()
    suit.draw()
end

-- suit required handlers
function love.textedited(text, start, length)
    suit.textedited(text, start, length)
end

function love.textinput(t)
    suit.textinput(t)
end

-- keyboard handler
function love.keypressed(key, isrepeat)
    suit.keypressed(key)
    -- player movement
    if key == "up" then
        if testMap(0, -1) then
            player.grid_y = player.grid_y - 32
        end
    elseif key == "down" then
        if testMap(0, 1) then
            player.grid_y = player.grid_y + 32
        end
    elseif key == "left" then
        if testMap(-1, 0) then
            player.grid_x = player.grid_x - 32
        end
    elseif key == "right" then
        if testMap(1, 0) then
            player.grid_x = player.grid_x + 32
        end
        Talkies.draw()
        -- cinematic scenes
    elseif key == "space" and scene < 5 then

        Talkies.onAction()
    elseif key == "return" then
        scene = scene + 1
        Talkies.onAction()
    elseif key == "n" then
        darkness = not darkness
    end

    -- quit game
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

end

function love.wheelmoved(x, y)
    if love.keyboard.isDown("c") then
        if y > 0 and cam.scale <= 1.5 then
            cam.scale = cam.scale + 0.1
        elseif y < 0 and cam.scale >= 0.4 then
            cam.scale = cam.scale - 0.1
        end
    end
end

-- handle collisions
function testMap(x, y)
    if worldMap[(player.grid_y / 32) + y][(player.grid_x / 32) + x] == 1 then
        return false
    end
    return true
end

-- handle character animation
function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end

