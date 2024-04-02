local buffertricks = {}

function buffertricks.reverseBuffer(buf) 
    local bufsz = buffer.len(buf)
    local newbuf = buffer.create(bufsz)
    for i = 1,bufsz-1,1 do
        buffer.writeu8(newbuf, bufsz-i, buffer.readu8(buf, i-1))
    end
    return newbuf
end

local maxbitfield = 24;
local byte_width = 8;


function buffertricks.printh(num:number) 
    print(string.format("%X",num));
    
end
function buffertricks.flipEndiness(num:number) 
    local bufnumber = 0;
    for i = 0,maxbitfield,8 do 
        local curbyte = bit32.extract(num, i,byte_width)
        curbyte = bit32.lshift(curbyte, 24-i)
        bufnumber = bit32.bor(bufnumber,curbyte)
    end
    return bufnumber
end

function buffertricks.xorDWORD(data:number,key:number)
    return buffertricks.flipEndiness(bit32.bxor(data,key))


end
function buffertricks.stringfromdword(e:number) 
    local nb = buffer.create(4);
    buffer.writeu32(nb, 0, e)
    return buffer.readstring(nb, 0, 4)
end

return buffertricks