local class = require("libraries.middleclass")

Map = class("Map")

function Map:initialize()
    -- dimensiones del mapa
    Map.xsize = 60
    Map.ysize = 60
    Map.cell_class = Maze

    Map.present = {}
    for x = 1, Map.xsize do
        Map.present[x] = {}
        for y = 1, Map.ysize do
            Map.present[x][y] = Map.cell_class:new(0, x, y, self)
        end
    end

    Map.future = {}
    for x = 1, Map.xsize do
        Map.future[x] = {}
        for y = 1, Map.ysize do
            Map.future[x][y] = Map.cell_class:new(0, x, y, self)
        end
    end
end

function Map:iterate()
    for x = 1, Map.xsize do
        for y = 1, Map.ysize do
            Map.future[x][y].state = Map.present[x][y]:next_state()
        end
    end

    Map.present = Map.future
    Map.future = {}
    for x = 1, Map.xsize do
        Map.future[x] = {}
        for y = 1, Map.ysize do
            Map.future[x][y] = Map.cell_class:new(0, x, y, self)
        end
    end
end

function Map:draw()
    for x = 1, Map.xsize do
        for y = 1, Map.ysize do
            if Map.present[x][y].state then
                local the_cell = Map.present[x][y]
                local color = the_cell.colors[the_cell.state + 1]
                love.graphics.setColor(255, 255, 255)
                love.graphics.rectangle("fill", x,y, 4,4)
            end
        end
    end
end

-- generate a table of the current state of the map
function Map:generate_map()
    local map = {}

    for x = 1, Map.xsize do
        map[x] = {}
        for y = 1, Map.ysize do
            map[x][y] = Map.present[x][y].state
        end
    end

    return map
end

-- add a cell to the map
function Map:add_cell(x, y, state)
    Map.present[x][y] = Map.cell_class:new(state, x, y, self)
end

-- how many cells are alive around this cell
function Map:count_neighbors()
    local neighbor_map = {}

    for x = 1, Map.xsize do
        neighbor_map[x] = {}
        for y = 1, Map.ysize do
            neighbor_map[x][y] = Map.present[x][y]:neighbourhood()
     end
    end

    return neighbor_map
end