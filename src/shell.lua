--- A simple Lua shell for file management.
--- @module "shell"

local fs = require("filesystem")
local cd = fs.getWorkingDirectory()
local args = { ... }

local function printUsage()
    print("Usage: shell <command> [arguments]")
    print("Available commands:")
    print("  cd <path> - Change the current directory")
    print("  cp <source> <destination> - Copy a file")
    print("  dir - List files in the current directory")
    print("  edit <file> - Edit a file")
    print("  help - Show this help")
    print("  mv <source> <destination> - Move a file")
    print("  rm <file> - Remove a file")
end

if #args == 0 then
    printUsage()
    return
end

local function find(t, v)
    for _, value in ipairs(t) do
        if value == v then
            return true
        end
    end
    return false
end

local load_commands = require("shell.commands")
if type(load_commands) ~= "function" then
    error("shell.commands must be a function")
end
local commands = load_commands(fs)

local command = args[1]
local commandArgs = {}

for i = 2, #args do
    commandArgs[i - 1] = args[i]
end

if command == "help" then
    printUsage()
    return
end

local found = false

for _, c in ipairs(commands) do
    if c.name == command or find(c.aliases, command) then
        found = true
        c.callback(c, unpack(commandArgs))
        break
    end
end

if not found then
    print("Unknown command: " .. command)
end
