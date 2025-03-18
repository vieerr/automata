require("components.map")
require("components.maze")
require("components.patterns")
require("patterns.maze")

local suit = require('libraries.suit')
local Talkies = require('libraries.talkies')

created = false

local meshVertices = {} -- for fan mesh
local meshRadius = 1
table.insert(meshVertices, {0, 0, 0, 0, 1, 1, 1, 0}) -- white dot int the middle
for angle = 0, 360, 10 do
    local x = 0 + meshRadius * math.cos(math.rad(angle))
    local y = 0 + meshRadius * math.sin(math.rad(angle))
    table.insert(meshVertices, {x, y, 0, 0, 0, 0, 0, 1}) -- black dots on perimeter
end
Mesh = love.graphics.newMesh(meshVertices, "fan")

local function updateCurtainCanvas(x, y, radius)
    print(CurtainCanvas:getWidth())
    love.graphics.setCanvas(CurtainCanvas)
    -- black curtain
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(0, 0, 0, 1) -- black
    love.graphics.rectangle('fill', 0, 0, CurtainCanvas:getWidth(), CurtainCanvas:getHeight())

    -- circle hole
    love.graphics.setBlendMode("replace")
    love.graphics.setColor(0, 0, 0, 0.97)
    love.graphics.draw(Mesh, x, y, 0, radius)
    love.graphics.setCanvas()
end

local input = {
    text = ""
}

function love.load()
    Talkies.font = love.graphics.newFont("assets/fonts/Pixel UniCode.ttf", 40)
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
    scene = 1
    current_cell = 1
    camera = require 'libraries/camera'

    player = {
        grid_x = 1024,
        grid_y = 1024,
        act_x = 200,
        act_y = 200,
        speed = 15
    }

    cam = camera()
    cam.scale = 1.1
    animation = newAnimation(love.graphics.newImage("ghost-Sheet.png"), 32, 32, 1)

    -- set background
    love.graphics.setBackgroundColor(255, 255, 255)

    -- create canvas
    CurtainCanvas = love.graphics.newCanvas(2000, 2000)

    worldMap = {}
    map = Map:new(Maze)
    patterns = Patterns:new(Maze)
end

function love.textedited(text, start, length)
    -- for IME input
    suit.textedited(text, start, length)
end

function love.textinput(t)
    -- forward text input to SUIT
    suit.textinput(t)
end

function love.keypressed(key)
    -- forward keypresses to SUIT
    suit.keypressed(key)
end

function love.update(dt)
    Talkies.update(dt)
    player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
    player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)

    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- if love.keyboard.isDown("return") then
    --     scene = scene+1
    -- end

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

    -- updateCurtainCanvas(player.act_x, player.act_y, 100)

end

function love.draw()
    love.window.setFullscreen(true)
    love.graphics.setBackgroundColor(0, 0, 0)
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
            print(input.text)
            pattern_message = patterns:change(input.text)

            patterns:paste(map, 200, 200)

            for i = 1, 200 do
                map:iterate()
            end
            neigh = map:count_neighbors()
            worldMap = map:generate_map()
            created = true
        end

        -- update canvas
        -- updateCurtainCanvas(100, 100, 100)

        for y = 1, #worldMap do
            for x = 1, #worldMap[y] do
                if worldMap[y][x] == 1 then

                    local neighbors = neigh[y][x]
                    if (neighbors == 4) then
                        worldMap[y][x] = 0
                    end

                    love.graphics.setColor(0, 0, 0)
                    love.graphics.rectangle("fill", x * 32, y * 32, 32, 32)
                    love.graphics.setColor(1, 1, 1)
                    love.graphics.print(neighbors, x * 32, y * 32, 0, 2, 2)

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
        love.graphics.print("moouse position: " .. love.mouse.getX() .. ", " .. love.mouse.getY(), 10, 30)
    end
    Talkies.draw()
    suit.draw()
end

function love.keypressed(key, isrepeat)
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
    elseif key == "space" and scene < 5 then

        Talkies.onAction()
    elseif key == "return" then
        scene = scene + 1
        Talkies.onAction()

    end

end

function testMap(x, y)
    if worldMap[(player.grid_y / 32) + y][(player.grid_x / 32) + x] == 1 then
        return false
    end
    return true
end

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

function automata(str)
    local newstr = ""
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == "1" then
            newstr = newstr .. "11"
        else
            newstr = newstr .. "00"
        end
    end
    return newstr
end
