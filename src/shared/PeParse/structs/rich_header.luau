local rich_header = {}
local utils = require(script.Parent.Parent.Parent.utils)





local _DISTANCE_FROM_PEHEADERS  = 12
local printh = utils.printh

export type  RichKP = {
    highProdId:number,
    lowBuildId:number,
    count:number
}
export type rich_header_decrypted  = {
    identifier:string,
    compIds:{RichKP}
}



export type rich_header = {
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

        return {}::rich_header_decrypted
    end 


end



function rich_header.frombufandof(buf:buffer,OffsetOfPeHeader:number) -- This is the best way to find the rich header as the offset and size varies.
local endLoc = OffsetOfPeHeader-_DISTANCE_FROM_PEHEADERS
local checksum  = buffer.readu32(buf, endLoc)
local RICH_SIG_HEX = buffer.readu32(buf, endLoc-4)
local RIGH_SIG_CHAR = buffer.readstring(buf, endLoc-4, 4)
local endrich = endLoc-4
local sizeof = 4
local res = utils.xorDWORD(utils.flipEndiness(buffer.readu32(buf,0x80)), utils.flipEndiness(checksum))
print(res)
print(utils.stringfromdword(res))


end

return rich_header