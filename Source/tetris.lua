import "CoreLibs/object"

import "tetromino"

local pd <const> = playdate

class("Tetris").extends()

function Tetris:init(rows, columns)
    self.currentTetromino = nil

    self.rows = rows
    self.columns = columns

    self.field = buildField(rows, columns)
    self.inputHandler = self:buildInputHandler()
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

function Tetris:buildInputHandler()
    local upButtonTimer, leftButtonTimer, downButtonTimer, rightButtonTimer

    return {
        upButtonDown = function()
            upButtonTimer = pd.timer.keyRepeatTimer(function()
                self:moveTetrominoUp()
            end)
        end,
        upButtonUp = function()
            upButtonTimer:remove()
        end,

        leftButtonDown = function()
            leftButtonTimer = pd.timer.keyRepeatTimer(function()
                self:moveTetrominoLeft()
            end)
        end,
        leftButtonUp = function()
            leftButtonTimer:remove()
        end,

        downButtonDown = function()
            downButtonTimer = pd.timer.keyRepeatTimer(function()
                self:moveTetrominoDown()
            end)
        end,
        downButtonUp = function()
            downButtonTimer:remove()
        end,

        rightButtonDown = function()
            rightButtonTimer = pd.timer.keyRepeatTimer(function()
                self:moveTetrominoRight()
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

function Tetris:moveTetromino(fnUpdateAndCheck)
    self:removeTetrominoFromField()
    fnUpdateAndCheck()
    self:placeTetrominoOnField()
end

function Tetris:moveTetrominoUp()
    self:moveTetromino(function ()
        local oldY <const> = self.currentTetromino.y
        self.currentTetromino.y -= 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.y = oldY
        end
    end)
end

function Tetris:moveTetrominoLeft()
    self:moveTetromino(function ()
        local oldX <const> = self.currentTetromino.x
        self.currentTetromino.x -= 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.x = oldX
        end
    end)
end

function Tetris:moveTetrominoDown()
    self:moveTetromino(function ()
        local oldY <const> = self.currentTetromino.y
        self.currentTetromino.y += 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.y = oldY
        end
    end)
end

function Tetris:moveTetrominoRight()
    self:moveTetromino(function ()
        local oldX <const> = self.currentTetromino.x
        self.currentTetromino.x += 1
        if self:isTetrominoPositionInvalid() then
            self.currentTetromino.x = oldX
        end
    end)
end

function Tetris:isTetrominoPositionInvalid()
    if self.currentTetromino.x < 1 or
    self.currentTetromino.x > self.columns or
    self.currentTetromino.y < 1 or
    self.currentTetromino.y > self.rows then
        return true
    end

    return false
end

function Tetris:placeTetrominoOnField()
    self.field[self.currentTetromino.y][self.currentTetromino.x] += 1
end

function Tetris:removeTetrominoFromField()
    self.field[self.currentTetromino.y][self.currentTetromino.x] -= 1
end

function Tetris:Update(fnDrawOnField)
    if self.currentTetromino == nil then
        self.currentTetromino = Tetromino(1, 1)
        self:placeTetrominoOnField()
    end

    self:draw(fnDrawOnField)
end

function Tetris:draw(fnDrawOnField)
    for i = 1, #self.field do
        for j = 1, #self.field[i] do
            local isActive = self.field[i][j] > 0
            fnDrawOnField(j, i, isActive)
        end
    end
end
