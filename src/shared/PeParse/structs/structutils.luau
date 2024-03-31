local structutils = {}

function structutils.quickBytes(of:number,buf:buffer,bytesize:number) 
    return buffer[`readu{bytesize*8}`](buf, of)

end

function structutils.quickArray(of,size,buf,bytesize:number):{number}
    local offsetAmount = bytesize;
    local tab:{number} = {}

    for i = 1,size,1 do 
        table.insert(tab,buffer[`readu{bytesize*8}`](buf,of))
        of = of + offsetAmount
    end
    return tab
end


return structutils