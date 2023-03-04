import "CoreLibs/object"

import "tetromino"

local pd <const> = playdate

class("Tetris").extends()

function Tetris:init(rows, columns)
    self.rows = rows
    self.columns = columns

    self.field = buildField(rows, columns)
    self.inputHandler = self:buildInputHandler()

    self:createNewTetromino()
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

        AButtonDown = function()
            self:rotateTetromino("right")
        end,

        BButtonDown = function()
            self:rotateTetromino("left")
        end
    }
end

function Tetris:GetInputHandler()
    return self.inputHandler
end

function Tetris:createNewTetromino()
    local initialX <const> = self.columns / 2 - 1
    self.currentTetromino = Tetromino(initialX, 1, "Z")
    self:placeTetrominoOnField()
end

function Tetris:rotateTetromino(direction)
    self:moveTetromino(function ()
        if direction == "right" then
            self.currentTetromino:RotateRight()
            local success = self:tryPlaceTetrominoWithOffset()
            if not success then
                self.currentTetromino:RotateLeft()
            end
        end
        if direction == "left" then
            self.currentTetromino:RotateLeft()
            local success = self:tryPlaceTetrominoWithOffset()
            if not success then
                self.currentTetromino:RotateRight()
            end
        end
    end)
end

function Tetris:tryPlaceTetrominoWithOffset()
    local currentX, currentY = self.currentTetromino.x, self.currentTetromino.y

    local deltas <const> = {
        {x=0, y=0},

        {x=-1, y=0},
        {x=1,  y=0},
        {x=0,  y=-1},
        {x=0,  y=1},

        {x=-1, y=-1},
        {x=1,  y=-1},
        {x=-1, y=1},
        {x=1,  y=1},

        {x=-2, y=0},
        {x=2,  y=0},
        {x=0,  y=-2},
        {x=0,  y=2},
    }

    for _, d in ipairs(deltas) do
        dx, dy = d.x, d.y
        self.currentTetromino.x = currentX + dx
        self.currentTetromino.y = currentY + dy
        if not self:isTetrominoPositionInvalid() then
            return true
        end
    end

    self.currentTetromino.x = currentX
    self.currentTetromino.y = currentY

    return false
end

function Tetris:moveTetromino(fnUpdateAndCheck)
    self:removeTetrominoFromField()
    local isTetrominoFixed = fnUpdateAndCheck()
    self:placeTetrominoOnField()

    if isTetrominoFixed then
        self:createNewTetromino()
    end
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
            return true
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
    local isInvalid = false
    local isBrickPositionInvalid <const> = function (x, y)
        if x < 1 or self.columns < x or
        y < 1 or self.rows < y or
        self.field[y][x] > 0 then
            isInvalid = true
        end
    end

    self.currentTetromino:ForEachBrick(isBrickPositionInvalid)

    return isInvalid
end

function Tetris:placeTetrominoOnField()
    self.currentTetromino:ForEachBrick(function (x, y)
        self.field[y][x] += 1
    end)
end

function Tetris:removeTetrominoFromField()
    self.currentTetromino:ForEachBrick(function (x, y)
        self.field[y][x] -= 1
    end)
end

function Tetris:Update(fnDrawOnField)
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
