AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_zombies/slow1.mdl", "models/vj_zombies/slow2.mdl", "models/vj_zombies/slow3.mdl", "models/vj_zombies/slow4.mdl", "models/vj_zombies/slow5.mdl", "models/vj_zombies/slow6.mdl", "models/vj_zombies/slow7.mdl", "models/vj_zombies/slow8.mdl", "models/vj_zombies/slow9.mdl", "models/vj_zombies/slow10.mdl", "models/vj_zombies/slow11.mdl", "models/vj_zombies/slow12.mdl"}
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED
ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = {"vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke", "vjseq_attackf"}
ENT.MeleeAttackDistance = 32
ENT.MeleeAttackDamageDistance = 65
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackPlayerSpeed = true
ENT.MeleeAttackBleedEnemy = true
ENT.DisableFootStepSoundTimer = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
ENT.FlinchHitGroupMap = {
	{HitGroup = HITGROUP_HEAD, Animation = "vjges_flinch_head"},
	{HitGroup = HITGROUP_CHEST, Animation = "vjges_flinch_chest"},
	{HitGroup = HITGROUP_LEFTARM, Animation = "vjges_flinch_leftArm"},
	{HitGroup = HITGROUP_RIGHTARM, Animation = "vjges_flinch_rightArm"},
	{HitGroup = HITGROUP_LEFTLEG, Animation = ACT_FLINCH_LEFTLEG},
	{HitGroup = HITGROUP_RIGHTLEG, Animation = ACT_FLINCH_RIGHTLEG}
}

ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav", "npc/zombie/foot2.wav", "npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/slow/zombie_idle1.wav", "vj_zombies/slow/zombie_idle2.wav", "vj_zombies/slow/zombie_idle3.wav", "vj_zombies/slow/zombie_idle4.wav", "vj_zombies/slow/zombie_idle5.wav", "vj_zombies/slow/zombie_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/slow/zombie_alert1.wav", "vj_zombies/slow/zombie_alert2.wav", "vj_zombies/slow/zombie_alert3.wav", "vj_zombies/slow/zombie_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/slow/zombie_attack_1.wav", "vj_zombies/slow/zombie_attack_2.wav", "vj_zombies/slow/zombie_attack_3.wav", "vj_zombies/slow/zombie_attack_4.wav", "vj_zombies/slow/zombie_attack_5.wav", "vj_zombies/slow/zombie_attack_6.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav", "vj_zombies/slow/miss2.wav", "vj_zombies/slow/miss3.wav", "vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/slow/zombie_pain1.wav", "vj_zombies/slow/zombie_pain2.wav", "vj_zombies/slow/zombie_pain3.wav", "vj_zombies/slow/zombie_pain4.wav", "vj_zombies/slow/zombie_pain5.wav", "vj_zombies/slow/zombie_pain6.wav", "vj_zombies/slow/zombie_pain7.wav", "vj_zombies/slow/zombie_pain8.wav"}
ENT.SoundTbl_Death = {"vj_zombies/slow/zombie_die1.wav", "vj_zombies/slow/zombie_die2.wav", "vj_zombies/slow/zombie_die3.wav", "vj_zombies/slow/zombie_die4.wav", "vj_zombies/slow/zombie_die5.wav", "vj_zombies/slow/zombie_die6.wav"}

local sdFootScuff = {"npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
-- "vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke", "vjseq_attackf"   |   Unused (Faster): "vjseq_swatrightmid", "vjseq_swatleftmid"
-- "vjseq_attacke", "vjseq_attackf"   |   Unused (Faster): "vjseq_swatleftlow", "vjseq_swatrightlow"
--
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "scuff" then
		self:PlayFootstepSound(sdFootScuff)
	elseif key == "melee" then
		self.MeleeAttackDamage = 20
		self:ExecuteMeleeAttack()
	elseif key == "melee_heavy" then
		self.MeleeAttackDamage = 30
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if self:IsOnFire() then
		if act == ACT_IDLE then
			return ACT_IDLE_ON_FIRE
		elseif act == ACT_RUN or act == ACT_WALK then
			return ACT_WALK_ON_FIRE
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end