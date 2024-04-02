local pe = script.Parent.PeParse
local dos = require(pe.structs.image_dos)
local rich = require(pe.structs.rich_header)

local function test()
    local filebuf = buffer.fromstring(game:GetService("StudioService"):PromptImportFile({"exe"}):GetBinaryContents())
    local dos_img = dos(filebuf)
    local rh = rich.frombufandof(filebuf,dos_img.NewHeaderAdress);
end


return test