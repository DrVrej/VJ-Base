
include('shared.lua')

function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
end

function ENT:Draw()
	
	--self:DrawEntityOutline( 1 )
	self.Entity:DrawModel()

end

surface.CreateFont( "HUDNumber2", { font = "Corinthian Bold", antialias = true, size = 40 } )


hook.Add("HUDPaint","ent_barricade",function()

		local visible_entity = LocalPlayer():GetEyeTrace().Entity
		if visible_entity:IsValid() then		 
			if LocalPlayer():GetEyeTrace().Entity then
				local entityClass = visible_entity:GetClass()
				local player_to_entity_distance = LocalPlayer():GetPos():Distance(visible_entity:GetPos())
				if (player_to_entity_distance < 100) and visible_entity:IsValid() then
					if (entityClass  == 'ent_barricade') then
					
							draw.DrawText("Press E To Build Barricade", "HUDNumber2", ScrW()/2, ScrH()/2+100, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)							
						
					end
				end
			end
		end

end)