local args = { ... }
local fileName = args[1]

local ptr = 1
local savedPtr
local cells = {}
local index = 1

function nextInstruction(instruction)
    if instruction == '+' then
        cells[index] = (cells[index] or 0) + 1
    elseif instruction == '-' then
        cells[index] = (cells[index] or 0) - 1
    elseif instruction == '>' then
        index = index + 1
    elseif instruction == '<' then
        index = index - 1
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
    local code
    local f = io.open(fileName, 'r')
    if not f then return error("File not found :(") end
    code = f:read('*a')
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
