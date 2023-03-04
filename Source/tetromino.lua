import "CoreLibs/object"

class("Tetromino").extends()

function Tetromino:init(x, y, rotation)
    self.x = x
    self.y = y

    self.rotation = rotation

    self.tetrominoGridSize = 4

    --  1  2  3  4
    --  5  6  7  8
    --  9 10 11 12
    -- 13 14 15 16
    self.rotations = {
        { 2, 6, 7,  11 },
        { 3, 4, 6,  7 },
        { 3, 7, 8,  12 },
        { 7, 8, 10, 11 },
    }
end

function Tetromino:ForEachBrick(fn)
    local brickNumber
    for i = 1, self.tetrominoGridSize do
        for j = 1, self.tetrominoGridSize do
            brickNumber = (i - 1) * self.tetrominoGridSize + j
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
