function updateCurtainCanvas(x, y, radius)

    love.graphics.setCanvas(CurtainCanvas)
    -- black curtain
    love.graphics.setBlendMode("alpha")
    love.graphics.setColor(0, 0, 0) -- black
    love.graphics.rectangle('fill', 0, 0, CurtainCanvas:getWidth(), CurtainCanvas:getHeight())

    -- circle hole
    love.graphics.setBlendMode("replace")
    love.graphics.setColor(0, 0, 0, 0.97)
    love.graphics.draw(Mesh, x, y, 0, radius)
    love.graphics.setCanvas()
end

function removeCurtain()
    love.graphics.setCanvas(CurtainCanvas)
    -- Clear the canvas by setting it to transparent
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setCanvas()
end


function createMesh(radius)
    love.graphics.setBackgroundColor(1, 1, 1)
    local meshVertices = {} -- for fan mesh
    table.insert(meshVertices, {0, 0, 0, 0, 1, 1, 1, 0}) -- white dot int the middle
    for angle = 0, 360, 10 do
        local x = 0 + radius * math.cos(math.rad(angle))
        local y = 0 + radius * math.sin(math.rad(angle))
        table.insert(meshVertices, {x, y, 0, 0, 0, 0, 0, 1}) -- black dots on perimeter
    end
    return love.graphics.newMesh(meshVertices, "fan")
end

