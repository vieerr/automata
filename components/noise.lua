require ("libraries.middleclass")

Noise = class('Noise')

function generateNoise(str)
    print(string.byte(str))
end