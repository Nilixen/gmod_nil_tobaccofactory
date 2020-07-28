TobaccoFactory = {}
TobaccoFactory.Config = TobaccoFactory.Config or {}
TobaccoFactory.Config.Lang = TobaccoFactory.Config.Lang or {}


if SERVER then
    print("tobacco factory loaded!")
    include("ntf/config/config.lua")
    include("ntf/config/"..TobaccoFactory.Config.Language..".lua")
    AddCSLuaFile("ntf/config/config.lua")
    AddCSLuaFile("ntf/config/"..TobaccoFactory.Config.Language..".lua")
    AddCSLuaFile("ntf/client/cl_fonts.lua")
    AddCSLuaFile("ntf/client/cl_gui_func.lua")
end
