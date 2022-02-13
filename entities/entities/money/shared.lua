function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Value")
end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Roubles"
ENT.Category = "Buildings"
ENT.Author = "Penial/Pikachu"
ENT.Contact = "jacksonwassermann55@icloud.com"
ENT.Purpose = "Physical roubles"
ENT.Instructions = "Pick up to make roubles."

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.Model = "models/props/cs_assault/money.mdl"