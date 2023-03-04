import "CoreLibs/object"


local tetrominoGridSize <const> = 4

--  1  2  3  4
--  5  6  7  8
--  9 10 11 12
-- 13 14 15 16
local shapeRotations <const> = {
    I = {
        {2,  6, 10, 14},
        {5,  6,  7,  8},
        -- {3,  7, 11, 15},
        -- {9, 10, 11, 12},
    },
    J = {
        {2, 6, 9, 10},
        {1, 5, 6,  7},
        {2, 3, 6, 10},
        {5, 6, 7, 11},
    },
    L = {
        {2, 6, 10, 11},
        {5, 6,  7,  9},
        {1, 2,  6, 10},
        {3, 5,  6,  7},
    },
    O = {{1, 2, 5, 6}},
    S = {
        {6, 7, 9, 10},
        {1, 5, 6, 10},
        {2, 3, 5,  6},
        {2, 6, 7, 11},
    },
    T = {
        {5, 6, 7, 10},
        {2, 5, 6, 10},
        {2, 5, 6,  7},
        {2, 6, 7, 10},
    },
    Z = {
        {5, 6, 10, 11},
        {2, 5,  6,  9},
        {1, 2,  6,  7},
        {3, 6,  7, 10},
    },
}

function GetShapes()
    local shapes <const> = {}
    for k, _ in pairs(shapeRotations) do
        table.insert(shapes, k)
    end

    return shapes
end

class("Tetromino").extends()

function Tetromino:init(x, y, shape)
    self.x = x
    self.y = y

    self.rotation = 1


    self.rotations = shapeRotations[shape]

    self:adjustEmptyFirstRow()
end

function Tetromino:adjustEmptyFirstRow()
    local isEmptyFirstRow = true
    for i = 1, tetrominoGridSize do
        ---@diagnostic disable-next-line: undefined-field
        if table.indexOfElement(self.rotations[self.rotation], i) ~= nil then
            isEmptyFirstRow = false
        end
    end

    if isEmptyFirstRow then
        self.y -= 1
    end
end

function Tetromino:ForEachBrick(fn)
    local brickNumber
    for i = 1, tetrominoGridSize do
        for j = 1, tetrominoGridSize do
            brickNumber = (i - 1) * tetrominoGridSize + j
            ---@diagnostic disable-next-line: undefined-field
            if table.indexOfElement(self.rotations[self.rotation], brickNumber) ~= nil then
                fn(self.x + j - 1, self.y + i - 1)
            end
        end
    end
end

function Tetromino:rotate(delta)
    self.rotation = (self.rotation + delta) % #self.rotations
    if self.rotation < 1 then
        self.rotation += #self.rotations
    end
end

function Tetromino:RotateLeft()
    self:rotate(-1)
end
function Tetromino:RotateRight()
    self:rotate(1)
end
