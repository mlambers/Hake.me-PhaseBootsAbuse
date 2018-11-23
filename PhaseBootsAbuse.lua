local PhaseBootsAbuse = {
	optionEnable = Menu.AddOption({"Utility", "Phase boots abuser"}, "1. Enabled", "Doge boots abuser"),
	chargeKey = Menu.AddKeyOption({"Utility", "Phase boots abuser"}, "3. Charge Key", Enum.ButtonCode.KEY_P),
	markKey = Menu.AddKeyOption({"Utility", "Phase boots abuser"}, "2. Mark Key", Enum.ButtonCode.KEY_P),
	cshotenemy = nil,
	cshotParticle = nil,
	inCharge = false
}

function PhaseBootsAbuse.OnUpdate()
    if Menu.IsEnabled(PhaseBootsAbuse.optionEnable) == false then return end
    local myHero = Heroes.GetLocal()
    if myHero == nil then return end
	if Entity.IsAlive(myHero) == false then return end
	
    if NPC.HasItem(myHero, "item_phase_boots", true) == false then return end

    if Menu.IsKeyDownOnce(PhaseBootsAbuse.markKey) then
        if not PhaseBootsAbuse.cshotParticle then
            local target = Input.GetNearestUnitToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_FRIEND)
            
			if 	target 
				and not NPC.GetModifier(target, "modifier_invulnerable") 
				and target ~= myHero 
			then
                PhaseBootsAbuse.cshotenemy = Input.GetNearestUnitToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_FRIEND)
                PhaseBootsAbuse.cshotParticle = Particle.Create("particles/units/heroes/hero_skywrath_mage/skywrath_mage_concussive_shot.vpcf")
                
				local customOrigin = Entity.GetAbsOrigin(PhaseBootsAbuse.cshotenemy)
                local zOrigin = customOrigin:GetZ()
                customOrigin:SetZ(zOrigin + 500)
                
				Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 0, customOrigin)
                Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 1, customOrigin)
                Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 2, Vector(500, 0, 0))   
            end
        else
            Particle.Destroy(PhaseBootsAbuse.cshotParticle)            
            PhaseBootsAbuse.cshotParticle = nil
            PhaseBootsAbuse.cshotenemy = nil
        end
    end

    if PhaseBootsAbuse.cshotParticle then
        local customOrigin = Entity.GetAbsOrigin(PhaseBootsAbuse.cshotenemy)
        local zOrigin = customOrigin:GetZ()
        customOrigin:SetZ(zOrigin + 500)
        Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 0, customOrigin)
        Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 1, customOrigin)
        Particle.SetControlPoint(PhaseBootsAbuse.cshotParticle, 2, Vector(500, 0, 0)) 
    end

    if Menu.IsKeyDownOnce(PhaseBootsAbuse.chargeKey) then 
        if NPC.HasModifier(myHero, "modifier_item_phase_boots_active")
			and NPC.IsStunned(myHero) == false
			and NPC.IsRooted(myHero) == false
		then
            Player.PrepareUnitOrders( Players.GetLocal(), Enum.UnitOrder.DOTA_UNIT_ORDER_ATTACK_TARGET, PhaseBootsAbuse.cshotenemy, Vector(0, 0, 0), nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, myHero, false, true)
        end
       
    end
end

return PhaseBootsAbuse