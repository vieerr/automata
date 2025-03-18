local class = require 'libraries.middleclass'

Patterns = class('Patterns')

local function stringToBitPatterns(str)
    local bitPatterns = {}
    for i = 1, #str do
        local char = str:sub(i, i)
        local ascii = string.byte(char)
        local bits = {}
        for j = 7, 0, -1 do
            bit = math.floor(ascii / 2 ^ j) % 2
            table.insert(bits, bit)
        end
        table.insert(bitPatterns, bits)
    end
    return bitPatterns

end

function Patterns:paste(map, x, y)
    for px = 1, #Maze.static.pattern do
        for py = 1, #Maze.static.pattern[px] do
            map:add_cell((x - x % 5) / 5 + py, (y - y % 5) / 5 + px, Maze.static.pattern[px][py])
        end
    end
end

function Patterns:change(str)
    Maze.static.pattern = stringToBitPatterns(str)

    return Maze.static.pattern
end
