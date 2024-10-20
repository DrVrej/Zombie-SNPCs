AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.StartHealth = 100
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke" ,"vjseq_attackf"}
ENT.MeleeAttackDistance = 32 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 65 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.TimeUntilMeleeAttackDamage = false
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.DisableFootStepSoundTimer = true
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS -- The regular flinch animations to play
ENT.HitGroupFlinching_Values = {
	{HitGroup = {HITGROUP_HEAD}, Animation = {"vjges_flinch_head"}},
	{HitGroup = {HITGROUP_CHEST}, Animation = {"vjges_flinch_chest"}},
	{HitGroup = {HITGROUP_LEFTARM}, Animation = {"vjges_flinch_leftArm"}},
	{HitGroup = {HITGROUP_RIGHTARM}, Animation = {"vjges_flinch_rightArm"}},
	{HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}},
	{HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}
}
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/slow/zombie_idle1.wav","vj_zombies/slow/zombie_idle2.wav","vj_zombies/slow/zombie_idle3.wav","vj_zombies/slow/zombie_idle4.wav","vj_zombies/slow/zombie_idle5.wav","vj_zombies/slow/zombie_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/slow/zombie_alert1.wav","vj_zombies/slow/zombie_alert2.wav","vj_zombies/slow/zombie_alert3.wav","vj_zombies/slow/zombie_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/slow/zombie_attack_1.wav","vj_zombies/slow/zombie_attack_2.wav","vj_zombies/slow/zombie_attack_3.wav","vj_zombies/slow/zombie_attack_4.wav","vj_zombies/slow/zombie_attack_5.wav","vj_zombies/slow/zombie_attack_6.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/slow/zombie_pain1.wav","vj_zombies/slow/zombie_pain2.wav","vj_zombies/slow/zombie_pain3.wav","vj_zombies/slow/zombie_pain4.wav","vj_zombies/slow/zombie_pain5.wav","vj_zombies/slow/zombie_pain6.wav","vj_zombies/slow/zombie_pain7.wav","vj_zombies/slow/zombie_pain8.wav"}
ENT.SoundTbl_Death = {"vj_zombies/slow/zombie_die1.wav","vj_zombies/slow/zombie_die2.wav","vj_zombies/slow/zombie_die3.wav","vj_zombies/slow/zombie_die4.wav","vj_zombies/slow/zombie_die5.wav","vj_zombies/slow/zombie_die6.wav"}

local sdFootScuff = {"npc/zombie/foot_slide1.wav", "npc/zombie/foot_slide2.wav", "npc/zombie/foot_slide3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
local defModels = {"models/vj_zombies/slow1.mdl", "models/vj_zombies/slow2.mdl", "models/vj_zombies/slow3.mdl", "models/vj_zombies/slow4.mdl", "models/vj_zombies/slow5.mdl", "models/vj_zombies/slow6.mdl", "models/vj_zombies/slow7.mdl", "models/vj_zombies/slow8.mdl", "models/vj_zombies/slow9.mdl", "models/vj_zombies/slow10.mdl", "models/vj_zombies/slow11.mdl", "models/vj_zombies/slow12.mdl"}
--
function ENT:PreInit()
	-- Allows child classes to change the model such Zombie Mini Boss
	if !self.Model then
		self.Model = defModels
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
-- "vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke" ,"vjseq_attackf"   |   Unused (Faster): "vjseq_swatrightmid", "vjseq_swatleftmid"
-- "vjseq_attacke" ,"vjseq_attackf"   |   Unused (Faster): "vjseq_swatleftlow", "vjseq_swatrightlow"
--
function ENT:OnInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "scuff" then
		self:FootStepSoundCode(sdFootScuff)
	elseif key == "melee" then
		self.MeleeAttackDamage = 20
		self:MeleeAttackCode()
	elseif key == "melee_heavy" then
		self.MeleeAttackDamage = 30
		self:MeleeAttackCode()
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