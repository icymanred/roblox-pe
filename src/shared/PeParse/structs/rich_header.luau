local rich_header = {}
local utils = require(script.Parent.Parent.Parent.utils)





local _DISTANCE_FROM_PEHEADERS  = 12

export type  RichKP = {
    highProdId:number,
    lowBuildId:number,
    count:number
}
export type rich_header_decrypted  = {
    BeginOffset:number,
    identifier:string,
    compIds:{RichKP}
}



export type rich_header = {
    BeginOffset:number,
    DansId:number, 
    CompIds:{number},
    RichId:number,
    Checksum:number,
    isDecrypted:rich_header_decrypted?

}
function rich_header.decryptRH(rh:rich_header):rich_header_decrypted
    if rh.isDecrypted then
        return rh.isDecrypted

    else 
        --TODO!!!
        -- Make sure to account for the 12 bytes ( 3 DWORDS) of zeros when setting key pair order
        return {}::rich_header_decrypted
    end 


end
local _DNSDCRYPTED = 0x536E6144 -- This is what dans looks like decrypted
local _RHCHECK = 0x52696368

function rich_header.frombufandof(buf:buffer,OffsetOfPeHeader:number) -- This is the best way to find the rich header as the offset and size varies.
local endLoc = OffsetOfPeHeader-_DISTANCE_FROM_PEHEADERS
local checksum  = buffer.readu32(buf, endLoc)
local RICH_SIG_HEX = buffer.readu32(buf, endLoc-4)

local endrich = endLoc-4
if (RICH_SIG_HEX ~= _RHCHECK ) then 
    print("Offset is incorrect")
    -- TODO add some sort of fix or extra info
    return
end

-- local res = utils.xorDWORD(utils.flipEndiness(buffer.readu32(buf,0x80)), utils.flipEndiness(checksum))
local rh = {}::rich_header
rh.Checksum = checksum
rh.RichId = RICH_SIG_HEX
rh.CompIds = {}
local dansId = false
local OFF = 4

while not dansId do 
    local curWord = utils.flipEndiness(buffer.readu32(buf, endrich-OFF));
    local asNum = utils.xorDWORD(curWord, utils.flipEndiness(checksum));
    if asNum == _DNSDCRYPTED then

        dansId = asNum;
        rh.BeginOffset = endrich-OFF
        print(`Dansid found at offset {endrich-OFF}`)
        break
    end
    table.insert(rh.CompIds,curWord)
    OFF = OFF + 4;
    print(`At offset {endrich-OFF} there is hex: {string.format("%X",utils.flipEndiness(curWord))}`)    





end

return rh


end

return rich_header