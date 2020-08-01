TobaccoFactory = {}
TobaccoFactory.Config = TobaccoFactory.Config or {}
TobaccoFactory.Client = TobaccoFactory.Client or {}
TobaccoFactory.Config.Lang = TobaccoFactory.Config.Lang or {}

if CLIENT then
    print("tobacco factory loaded!")
    include("ntf/config/config.lua")
    include("ntf/config/"..TobaccoFactory.Config.Language..".lua")
    include("ntf/client/cl_fonts.lua")
    include("ntf/client/cl_gui_func.lua")
end
