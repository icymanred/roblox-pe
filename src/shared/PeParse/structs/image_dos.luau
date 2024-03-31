local module =  {}
local structUtils = require(script.Parent.structutils)
local ct = require(script.Parent.Parent.Parent.ctypes.ctypes)
export type IMAGE_DOS_HEADER = {
    magic_byte:number,
    lastBytes:number,
    PageCount:number,
    relocations:number,
    headerSize:number,
    minextraparagraphs:number,
    maxextraparagraphs:number,
    InitSSVal:number,
    InitSPVal:number,
    Checksum:number,
    InitIpVal:number,
    InitCSVal:number,
    RelocAdresss:number,
    Overlay:number,
    ReservedWords:{number},
    OemId:number,
    OemInfo:number,
    ReservedWords2:{number},
    NewHeaderAdress:number
}







local printFormat = [[
    
    Magic byte: %X
    Last bytes: %X
    Page count: %X
    Relocations: %X
    Size of header in paragraphs: %X
    Minimum extra paragraphs needed: %X
    Maximum extra paragraphs needed: %X
    Initial (relative) SS value: %X
    Initial SP value: %X
    Checksum: %X
    Initial IP value: %X
    Initial (relative) CS value: %X
    File adress of relocation table: %X
    Overlay Number: %X
    Reserved words[4]: %X,%X,%X,%X
    OEM identifier (for OEM information): %X
    OEM information; OEM identifier specific: %X
    Reserved words[10]: %X,%X,%X,%X,%X,%X,%X,%X,%X,%X
    File adress of new exe header: %X
]]








 function  module.constructFromPeBuffer(callee,buf:buffer):IMAGE_DOS_HEADER 
    local function quickWord(of)
        return structUtils.quickBytes(of, buf, ct.WORD)

    end
    local function quickArray(of,size)
        return structUtils.quickArray(of, size, buf, ct.WORD)

    end
    local newdos = {} :: IMAGE_DOS_HEADER
      newdos.magic_byte = quickWord(0)
      newdos.lastBytes = quickWord(2)
      newdos.PageCount = quickWord(4)
      newdos.relocations = quickWord(6)
      newdos.headerSize = quickWord(8)
      newdos.minextraparagraphs = quickWord(0xA)
      newdos.maxextraparagraphs = quickWord(0xC)
      newdos.InitSSVal = quickWord(0xE)
      newdos.InitSPVal = quickWord(0x10)
      newdos.Checksum = quickWord(0x12)
      newdos.InitIpVal =  quickWord(0x14)
      newdos.InitCSVal = quickWord(0x16)
      newdos.RelocAdresss = quickWord(0x18)
      newdos.Overlay = quickWord(0x1A)
      newdos.ReservedWords = quickArray(0x1C, 4)
      newdos.OemId = quickWord(0x24)
      newdos.OemInfo = quickWord(0x26)
      newdos.ReservedWords2 = quickArray(0x28, 10)
      newdos.NewHeaderAdress = quickWord(0x3c)
    
      setmetatable(newdos, { __tostring=function(tab:IMAGE_DOS_HEADER)
        print(tab.ReservedWords)
        local st = string.format(printFormat,
        tab.magic_byte,
        tab.lastBytes,
        tab.PageCount,
        tab.relocations,
        tab.headerSize,
        tab.minextraparagraphs,
        tab.maxextraparagraphs,
        tab.InitSSVal,
        tab.InitSPVal,
        tab.Checksum,
        tab.InitIpVal,
        tab.InitCSVal,
        tab.RelocAdresss,
        tab.Overlay,
        tab.ReservedWords[1],
        tab.ReservedWords[2],
        tab.ReservedWords[3],
        tab.ReservedWords[4],
        tab.OemId,
        tab.OemInfo,
        tab.ReservedWords2[1],tab.ReservedWords2[2],tab.ReservedWords2[3],
        tab.ReservedWords2[4],tab.ReservedWords2[5],tab.ReservedWords2[6],
        tab.ReservedWords2[7],tab.ReservedWords2[8],tab.ReservedWords2[9],
        tab.ReservedWords2[10],
        tab.NewHeaderAdress
        
    )
    return st
    
    
    
    end})
    
      return newdos


end




local mt = {__call=module.constructFromPeBuffer}
setmetatable(module, mt)

return module