local buffertricks = {}

function buffertricks.reverseBuffer(buf) 
    local bufsz = buffer.len(buf)
    local newbuf = buffer.create(bufsz)
    for i = 1,bufsz-1,1 do
        buffer.writeu8(newbuf, bufsz-i, buffer.readu8(buf, i-1))
    end
    return newbuf
end

local bitsize = 31;
local byte_width = 8;

function buffertricks.xorBuffer(input1:buffer,input2:buffer)



end

function buffertricks.flipEndiness(num:number) 
    local bufnumber = 0;
    for i = 0,24,8 do 
        local curbyte = bit32.extract(num, i,byte_width)
        curbyte = bit32.lshift(curbyte, 24-i)
        bufnumber = bit32.bor(bufnumber,curbyte)
    end
    return bufnumber
end





return buffertricks