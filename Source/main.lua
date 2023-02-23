import "field"

local pd <const> = playdate

local field <const> = Field()
field:draw()

---@diagnostic disable-next-line: duplicate-set-field
function pd.update()
end
