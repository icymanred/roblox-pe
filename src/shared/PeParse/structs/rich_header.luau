local rich_header = {}
local utils = require(script.Parent.Parent.Parent.utils)
local prodids = require(script.Parent.lists.prodids)



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


function rich_header.matchProdId(num:number):string
    return ( prodids[num] or "<Unknown>")


end


function fullDecrypt(EncryptedIds:{number},checksum:number):{RichKP} -- checksum should always be flipped
local len = #EncryptedIds - 3
local decrypted = {}::{RichKP}
for i = len,1,-2 do 
    local curCount = utils.xorDWORD(EncryptedIds[i-1], checksum)
     local curkp = {}::RichKP
     curkp.count = curCount
    local prodbuild  = utils.xorDWORD(EncryptedIds[i], checksum)
    local low = bit32.extract( prodbuild,0,16) -- build id
    local high = bit32.extract(prodbuild, 16,16) -- prod id
    curkp.highProdId = high
    curkp.lowBuildId = low
    table.insert(decrypted,curkp)
end
return decrypted;
end



function rich_header.decryptRH(rh:rich_header):rich_header_decrypted
    if rh.isDecrypted then
        return rh.isDecrypted

    else 
        local f = {}::rich_header_decrypted
        f.compIds = fullDecrypt(rh.CompIds, rh.Checksum)
        f.BeginOffset = rh.BeginOffset;
        f.identifier = "DanS";
        rh.isDecrypted = f;
        return f;
    end 


end
local _DNSDCRYPTED = 0x536E6144 -- This is what dans looks like decrypted
local _RHCHECK = 0x52696368

function rich_header.frombufandof(buf:buffer,OffsetOfPeHeader:number):rich_header -- This is the best way to find the rich header as the offset and size varies.
local endLoc = OffsetOfPeHeader-_DISTANCE_FROM_PEHEADERS
local checksum  = utils.flipEndiness(buffer.readu32(buf, endLoc))
local RICH_SIG_HEX =  utils.flipEndiness(buffer.readu32(buf, endLoc-4))

local endrich = endLoc-4
if (RICH_SIG_HEX ~= _RHCHECK ) then 
    print("Offset is incorrect")
    utils.printh(RICH_SIG_HEX)
    utils.printh(_RHCHECK)
    -- TODO add some sort of fix or extra info
    print("Dos supplied offset is: ".. tostring(OffsetOfPeHeader))
    error("Fail wrong offset")
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
    local asNum = utils.xorDWORD(curWord,(checksum));
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