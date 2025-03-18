local class = require 'libraries.middleclass'

Patterns = class('Patterns')

function Patterns:paste(map, x, y)
    for px = 1, #Maze.static.pattern do
        for py = 1, #Maze.static.pattern[px] do
            map:add_cell((x - x % 5) / 5 + py, (y - y % 5) / 5 + px, Maze.static.pattern[px][py])
        end
    end
end

function Patterns:change(button)
    return Maze.static.pattern
end
