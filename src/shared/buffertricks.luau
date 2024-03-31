local buffertricks = {}

function buffertricks.reverseBuffer(buf) 
    local bufsz = buffer.len(buf)
    local newbuf = buffer.create(bufsz)
    for i = 1,bufsz-1 do
        buffer.writeu8(newbuf, bufsz-i, buffer.readu8(buf, i-1))
    end
    return newbuf
end



function buffertricks.xorBuffer(input1:buffer,input2:buffer)



end





return buffertricks