import "CoreLibs/object"

local pd <const> = playdate

class("Tetris").extends()

function Tetris:init(rows, columns)
    self.field = buildField(rows, columns)
    self.inputHandler = buildInputHandler()
end

-- rows - vertical dimension, row, like Y coordinate
-- columns - horizontal dimension, column, like X coordinate
-- returns field[rows][columns] (field[y][x])
function buildField(rows, columns)
    local field = {}

    for i = 1, rows do
        field[i] = {}
        for j = 1, columns do
            field[i][j] = 0
        end
    end

    field[2][3] = 1

    return field
end

function buildInputHandler()
    local rightButtonTimer

    return {
        rightButtonDown = function()
            rightButtonTimer = pd.timer.keyRepeatTimer(function()
                print("rightButtonDown")
            end)
        end,
        rightButtonUp = function()
            rightButtonTimer:remove()
        end,
    }
end

function Tetris:GetInputHandler()
    return self.inputHandler
end

function Tetris:Update(fnDrawOnField)
    for i = 1, #self.field do
        for j = 1, #self.field[i] do
            local isActive = self.field[i][j] > 0
            fnDrawOnField(j, i, isActive)
        end
    end
end
