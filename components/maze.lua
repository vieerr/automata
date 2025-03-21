local class = require 'libraries.middleclass'

Maze = class('Maze')

function Maze:initialize(state, x, y, map)
    self.state = state
    self.x = x
    self.y = y
    self.map = map
end

function Maze:next_state()
    return self:conditions()
end

-- automata rules
function Maze:conditions()
    if self.state == 0 then
        if self:neighbourhood() == 3 then
            return 1
        else
            return 0
        end
    else
        if self:neighbourhood() >= 1 and self:neighbourhood() <= 4 then
            return 1
        else
            return 0
        end
    end
    return self.state
end

function Maze:neighbourhood()
    local a, b, c, d, e, f, g, h

    function coordinate_state(x, y)
        if self.map.present[x] == nil then
            return 0
        end
        if self.map.present[x][y] == nil then
            return 0
        end
        return self.map.present[x][y].state
    end

    a = coordinate_state(self.x - 1, self.y - 1)
    b = coordinate_state(self.x - 1, self.y)
    c = coordinate_state(self.x - 1, self.y + 1)
    d = coordinate_state(self.x, self.y + 1)
    e = coordinate_state(self.x, self.y - 1)
    f = coordinate_state(self.x + 1, self.y - 1)
    g = coordinate_state(self.x + 1, self.y)
    h = coordinate_state(self.x + 1, self.y + 1)

    local ret = 0
    local ta = {a, b, c, d, e, f, g, h}

    for k, v in ipairs(ta) do
        if v == 1 then
            ret = ret + 1
        end
    end

    return ret
end
