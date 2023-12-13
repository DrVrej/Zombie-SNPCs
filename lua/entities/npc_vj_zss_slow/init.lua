AddCSLuaFile("shared.lua")
include('shared.lua')
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
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke" ,"vjseq_attackf"}
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 65 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 1
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 1 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 1 -- Next foot step sound when it is walking
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_zombies/slow/foot1.wav","vj_zombies/slow/foot2.wav","vj_zombies/slow/foot3.wav","vj_zombies/slow/foot4.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/slow/zombie_idle1.wav","vj_zombies/slow/zombie_idle2.wav","vj_zombies/slow/zombie_idle3.wav","vj_zombies/slow/zombie_idle4.wav","vj_zombies/slow/zombie_idle5.wav","vj_zombies/slow/zombie_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/slow/zombie_alert1.wav","vj_zombies/slow/zombie_alert2.wav","vj_zombies/slow/zombie_alert3.wav","vj_zombies/slow/zombie_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/slow/zombie_attack_1.wav","vj_zombies/slow/zombie_attack_2.wav","vj_zombies/slow/zombie_attack_3.wav","vj_zombies/slow/zombie_attack_4.wav","vj_zombies/slow/zombie_attack_5.wav","vj_zombies/slow/zombie_attack_6.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/slow/zombie_pain1.wav","vj_zombies/slow/zombie_pain2.wav","vj_zombies/slow/zombie_pain3.wav","vj_zombies/slow/zombie_pain4.wav","vj_zombies/slow/zombie_pain5.wav","vj_zombies/slow/zombie_pain6.wav","vj_zombies/slow/zombie_pain7.wav","vj_zombies/slow/zombie_pain8.wav"}
ENT.SoundTbl_Death = {"vj_zombies/slow/zombie_die1.wav","vj_zombies/slow/zombie_die2.wav","vj_zombies/slow/zombie_die3.wav","vj_zombies/slow/zombie_die4.wav","vj_zombies/slow/zombie_die5.wav","vj_zombies/slow/zombie_die6.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
local defModels = {"models/zombie/zclassic_01.mdl", "models/zombie/zclassic_02.mdl", "models/zombie/zclassic_03.mdl", "models/zombie/zclassic_04.mdl", "models/zombie/zclassic_05.mdl", "models/zombie/zclassic_06.mdl", "models/zombie/zclassic_07.mdl", "models/zombie/zclassic_08.mdl", "models/zombie/zclassic_09.mdl", "models/zombie/zclassic_10.mdl", "models/zombie/zclassic_11.mdl", "models/zombie/zclassic_12.mdl"}
--
function ENT:CustomOnPreInitialize()
	-- Allows child classes to change the model such Zombie Mini Boss
	if !self.Model then
		self.Model = defModels
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
---------------------------------------------------------------------------------------------------------------------------------------------
-- "vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke" ,"vjseq_attackf"   |   Unused (Faster): "vjseq_swatrightmid", "vjseq_swatleftmid"
-- "vjseq_attacke" ,"vjseq_attackf"   |   Unused (Faster): "vjseq_swatleftlow", "vjseq_swatrightlow"
--
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	local curSeq = self:GetSequenceName(self:GetSequence())
	if curSeq == "attackE" or curSeq == "attackF" then -- Heavier attacks
		self.MeleeAttackDamage = 30
	else
		self.MeleeAttackDamage = 20
	end
end