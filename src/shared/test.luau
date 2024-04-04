local pe = script.Parent.PeParse
local dos = require(pe.structs.image_dos)
local rich = require(pe.structs.rich_header)
-- TODO add test conditions
local function test()
    local filebuf = buffer.fromstring(game:GetService("StudioService"):PromptImportFile({"exe"}):GetBinaryContents())
    local dos_img = dos(filebuf)
    print(dos_img)
   local rh =  rich.frombufandof(filebuf,dos_img.NewHeaderAdress);
   local d = rich.decryptRH(rh);
   for i,v in ipairs(d.compIds) do
    print(`\nProduct name: {rich.matchProdId(v.highProdId)}\nBuild id: {v.lowBuildId}\nCount: {v.count}\n------`)

   end
end


return test