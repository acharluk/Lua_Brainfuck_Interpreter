--lil patch for basic rules in the original BF interpreter

local args = { ... }
local fileName = args[1]

local ptr = 1
local savedPtr
local cells = {}
local index = 1

function nextInstruction(instruction)
    if instruction == '+' then
        cells[index] = (cells[index] or 0) + 1
        if cells[index] > 255 then cells[index] = -255 end
    elseif instruction == '-' then
        cells[index] = (cells[index] or 0) - 1
        if cells[index] < -255 then cells[index] = 255 end
    elseif instruction == '>' then
        index = index + 1
        if index > 2^16 then index = 0 end
    elseif instruction == '<' then
        index = index - 1
        if index < 0 then index = 2^16 end
    elseif instruction == '[' then
        savedPtr = ptr
    elseif instruction == ']' then
        if cells[index] ~= 0 then
            ptr = savedPtr
        end
    elseif instruction == '.' then
        io.write(string.char(cells[index] or 0))
    elseif instruction == ',' then
        cells[index] = tonumber(string.byte(io.read()))
    end
end

function main()
    local f = io.open(fileName, 'r')
    if not f then return error("File not found :(") end
    local code = f:read('*a')
    f:close()

    while ptr < #code do
        nextInstruction(code:sub(ptr, ptr))
        ptr = ptr + 1
    end

end

local ok, err = pcall(main)
if not ok then
    error("Error! " .. err)
end
