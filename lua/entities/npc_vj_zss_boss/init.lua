AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/classic_gal_boss.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 850
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_attacka", "vjseq_attackb", "vjseq_attackc", "vjseq_attackd", "vjseq_attacke" ,"vjseq_attackf"}
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
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
ENT.FootStepTimeRun = 0.8 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking
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

-- Custom
ENT.ZBoss_NextMiniBossSpawnT = 0
ENT.ZBoss_LastAnimSet = 0 -- 0 = Regular | 1 = On fire
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Spawn Mini Zombie Bosses")
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
local defAng = Angle(0, 0, 0)
--
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && CurTime() > self.ZBoss_NextMiniBossSpawnT && !IsValid(self.MiniBoss1) && !IsValid(self.MiniBoss2) && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
		if self.VJ_IsBeingControlled == true then
			self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Spawning Mini Zombie Bosses! Cool Down: 20 seconds!")
		end
		local myPos = self:GetPos()
		local myAng = self:GetAngles()
		
		self:VJ_ACT_PLAYACTIVITY("vjseq_releasecrab", true, false, false)
		ParticleEffect("aurora_shockwave_debris", myPos, defAng, nil)
		ParticleEffect("aurora_shockwave", myPos, defAng, nil)
		VJ_EmitSound(self, "npc/zombie_poison/pz_call1.wav", 90, 80)
		
		local mini1 = ents.Create("npc_vj_zss_boss_mini")
		mini1:SetPos(myPos + self:GetRight()*60)
		mini1:SetAngles(myAng)
		mini1:Spawn()
		mini1:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack", true, 0.6, true, 0, {SequenceDuration=0.6})
		mini1:SetOwner(self)
		self.MiniBoss1 = mini1
		
		local mini2 = ents.Create("npc_vj_zss_boss_mini")
		mini2:SetPos(myPos + self:GetRight()*-60)
		mini2:SetAngles(myAng)
		mini2:Spawn()
		mini2:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack", true, 0.6, true, 0, {SequenceDuration=0.6})
		mini2:SetOwner(self)
		self.MiniBoss2 = mini2
		
		self.ZBoss_NextMiniBossSpawnT = CurTime() + 20
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	local curSeq = self:GetSequenceName(self:GetSequence())
	if curSeq == "attackE" or curSeq == "attackF" then -- Heavier attacks
		self.MeleeAttackDamage = 70
	else
		self.MeleeAttackDamage = 80
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnRemove()
	if !self.Dead then -- Remove mini bosses if we were removed (Undo, remover tool, etc.)
		if IsValid(self.MiniBoss1) then self.MiniBoss1:Remove() end
		if IsValid(self.MiniBoss2) then self.MiniBoss2:Remove() end
	end
end