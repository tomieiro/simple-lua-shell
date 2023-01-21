return function(fs)
    return {
        {
            name = 'cd',
            description = 'Change the current directory',
            usage = 'cd <path>',
            aliases = { 'chdir' },
            callback = function(self, ...)
                local args = { ... }
                if #args == 0 then
                    print("Usage: " .. self.usage)
                    return
                end
                local path = args[1]
                if not fs.exists(path) then
                    print("No such file or directory")
                    return
                end
                if not fs.isDirectory(path) then
                    print("Not a directory")
                    return
                end
                cd = path
            end
        },
        {
            name = 'cp',
            description = 'Copy a file',
            usage = 'cp <source> <destination>',
            aliases = { 'copy' },
            callback = function(self, ...)
                local args = { ... }
                if #args < 2 then
                    print("Usage: " .. self.usage)
                    return
                end
                local source = args[1]
                local destination = args[2]
                if not fs.exists(source) then
                    print("No such file or directory")
                    return
                end
                if fs.isDirectory(source) then
                    print("Cannot copy a directory")
                    return
                end
                if fs.exists(destination) then
                    print("Destination already exists")
                    return
                end
                local file = io.open(source, "rb")
                if file then
                    local data = file:read("*a")
                    file:close()
                    file = io.open(destination, "wb")
                    if file then
                        file:write(data)
                        file:close()
                    else
                        print("Failed to open destination file")
                    end
                else
                    print("Failed to open source file")
                end
            end
        },
        {
            name = 'dir',
            description = 'List files in the current directory',
            usage = 'dir',
            aliases = { 'ls' },
            callback = function(self, ...)
                local args = { ... }
                if #args > 0 then
                    print("Usage: " .. self.usage)
                    return
                end
                local files = fs.list(cd)
                for _, file in ipairs(files) do
                    print(file)
                end
            end
        },
        {
            name = 'edit',
            description = 'Edit a file',
            usage = 'edit <file>',
            aliases = { 'edit' },
            callback = function(self, ...)
                local args = { ... }
                if #args == 0 then
                    print("Usage: " .. self.usage)
                    return
                end
                local path = args[1]
                if not fs.exists(path) then
                    print("No such file or directory")
                    return
                end
                if fs.isDirectory(path) then
                    print("Cannot edit a directory")
                    return
                end
                local file = io.open(path, "r")
                if file then
                    local data = file:read("*a")
                    file:close()
                    local result = os.execute("edit " .. path)
                    if result == 0 then
                        file = io.open(path, "w")
                        if file then
                            file:write(data)
                            file:close()
                        else
                            print("Failed to open file")
                        end
                    end
                else
                    print("Failed to open file")
                end
            end
        },
    }
end
