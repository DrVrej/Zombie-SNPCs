include("entities/npc_vj_zss_slow/init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_zombies/gal_boss.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 850
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds

-- Custom
ENT.ZBoss_NextMiniBossSpawnT = 0
ENT.ZBoss_LastAnimSet = 0 -- 0 = Regular | 1 = On fire

local sdFootScuff = {"npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Spawn Mini Zombie Bosses")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "scuff" then
		self:FootStepSoundCode(sdFootScuff)
	elseif key == "melee" then
		self.MeleeAttackDamage = 70
		self:MeleeAttackCode()
	elseif key == "melee_heavy" then
		self.MeleeAttackDamage = 80
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
local defAng = Angle(0, 0, 0)
--
function ENT:OnThinkActive()
	if IsValid(self:GetEnemy()) && CurTime() > self.ZBoss_NextMiniBossSpawnT && !IsValid(self.MiniBoss1) && !IsValid(self.MiniBoss2) && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
		if self.VJ_IsBeingControlled == true then
			self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Spawning Mini Zombie Bosses! Cool Down: 20 seconds!")
		end
		local myPos = self:GetPos()
		local myAng = self:GetAngles()
		
		self:PlayAnim("vjseq_releasecrab", true, false, false)
		ParticleEffect("vj_aurora_shockwave", myPos, defAng, nil)
		VJ.EmitSound(self, "npc/zombie_poison/pz_call1.wav", 90, 80)
		
		local mini1 = ents.Create("npc_vj_zss_boss_mini")
		mini1:SetPos(myPos + self:GetRight()*60)
		mini1:SetAngles(myAng)
		mini1:Spawn()
		mini1:PlayAnim("vjseq_canal5aattack", true, 0.6, true, 0, {SequenceDuration=0.6})
		mini1:SetOwner(self)
		self.MiniBoss1 = mini1
		
		local mini2 = ents.Create("npc_vj_zss_boss_mini")
		mini2:SetPos(myPos + self:GetRight()*-60)
		mini2:SetAngles(myAng)
		mini2:Spawn()
		mini2:PlayAnim("vjseq_canal5aattack", true, 0.6, true, 0, {SequenceDuration=0.6})
		mini2:SetOwner(self)
		self.MiniBoss2 = mini2
		
		self.ZBoss_NextMiniBossSpawnT = CurTime() + 20
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if !self.Dead then -- Remove mini bosses if we were removed (Undo, remover tool, etc.)
		if IsValid(self.MiniBoss1) then self.MiniBoss1:Remove() end
		if IsValid(self.MiniBoss2) then self.MiniBoss2:Remove() end
	end
end