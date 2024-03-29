// I DO APOLOGISE FOR MY ENGLISH. IT is not my primary language

TobaccoFactory.Config.Language = "EN-en"

TobaccoFactory.Config.Leaves = 3 // leaves inside leaves pack

TobaccoFactory.Config.LeavesTime = 3 // in seconds, how long does the leaves need to be in drying shelf

TobaccoFactory.Config.CrushingTableTaps = 10 // how many times does the player need to press E on the crushing table to make crushed leaves

TobaccoFactory.Config.TobaccoInJar = 250 // how many grams are in 1 jar of tobacco

TobaccoFactory.Config.CigaretteTubes = 100

TobaccoFactory.Config.CigaretteFilters = 150

TobaccoFactory.Config.CigaretteBoxes = 60



TobaccoFactory.Config.ShopList = {
  {
    name = "Tobacco Leaves Pack",
    price = 250,
    model = "models/props_junk/cardboard_box001a.mdl",
    class = "ntf_leavespack",
    time = 5, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(-50,0,20),
    camAng = Angle(20,0,0),
    customColor = Color(255,255,255),
    description = "Contains 3x tobacco leaves boxes.",
    limit = 3,
    fnc = function(self,k) end  // it goes off, when the entity is spawned
  },
  {
    name = "Drying Shelf",
    price = 650,
    model = "models/props_wasteland/kitchen_shelf001a.mdl",
    class = "ntf_drying_shelf",
    time = 3, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(0, 100, 85),
    camAng = Angle(20, -90, 0),
    customColor = Color(255,255,255),
    description = "Used in drying tobacco leaves.",
    limit = 1,
    fnc = function(self,k) self:SetAngles(self:GetAngles()+Angle(0,90,0)) end // it goes off, when the entity is spawned
  },
  {
    name = "Crushing Table",
    price = 450,
    model = "models/props/cs_militia/table_kitchen.mdl",
    class = "ntf_crushing_table",
    time = 3, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(-75, 0, 45),
    camAng = Angle(20, 0, 0),
    customColor = Color(255,255,255),
    description = "Used in crushing tobacco leaves.",
    limit = 1,
    fnc = function(self,k) end // it goes off, when the entity is spawned
  },
  {
    name = "Cigarette Tubes",
    price = 150,
    model = "models/props/cs_office/cardboard_box02.mdl",
    class = "ntf_tubes",
    time = 3, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(-20,0,10),
    camAng = Angle(20, 0, 0),
    customColor = Color(110,110,210), // CUSTOM COLOR WORKS ONLY IN GUI, THIS WILL NOT SET THE COLOR OF ENTITY WHEN SPAWNED
    description = "Used in packing table.",
    limit = 2,
    fnc = function(self,k) end // it goes off, when the entity is spawned
  },
  {
    name = "Cigarette Filters",
    price = 150,
    model = "models/props/cs_office/cardboard_box02.mdl",
    class = "ntf_filters",
    time = 3, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(-20,0,10),
    camAng = Angle(20, 0, 0),
    customColor = Color(210,110,110), // CUSTOM COLOR WORKS ONLY IN GUI, THIS WILL NOT SET THE COLOR OF ENTITY WHEN SPAWNED
    description = "Used in packing table.",
    limit = 2,
    fnc = function(self,k) end // it goes off, when the entity is spawned
  },
  {
    name = "Cigarette Boxes",
    price = 150,
    model = "models/props/cs_office/cardboard_box02.mdl",
    class = "ntf_boxes",
    time = 3, // in seconds MAX 255 seconds, due to 8 bits.
    camPos = Vector(-20,0,10),
    camAng = Angle(20, 0, 0),
    customColor = Color(110,210,110), // CUSTOM COLOR WORKS ONLY IN GUI, THIS WILL NOT SET THE COLOR OF ENTITY WHEN SPAWNED
    description = "Used in packing table.",
    limit = 2,
    fnc = function(self,k) end // it goes off, when the entity is spawned
  },
}
