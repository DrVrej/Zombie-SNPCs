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
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1 -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 5
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.HasLeapAttack = true -- Can this NPC leap attack?
ENT.AnimTbl_LeapAttack = {ACT_JUMP} -- Melee Attack Animations
ENT.LeapDistance = 400 -- The max distance that the NPC can leap from
ENT.LeapToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4, 0.6, 0.8, 1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 0.2 -- How much time until it runs the velocity code?
ENT.LeapAttackDamage = 15
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/fast/fzombie_idle1.wav","vj_zombies/fast/fzombie_idle2.wav","vj_zombies/fast/fzombie_idle3.wav","vj_zombies/fast/fzombie_idle4.wav","vj_zombies/fast/fzombie_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/fast/fzombie_alert1.wav","vj_zombies/fast/fzombie_alert2.wav","vj_zombies/fast/fzombie_alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/fast/attack1.wav","vj_zombies/fast/attack2.wav","vj_zombies/fast/attack3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_LeapAttackJump = {"vj_zombies/fast/hunter_attackmix_01.wav","vj_zombies/fast/hunter_attackmix_02.wav","vj_zombies/fast/hunter_attackmix_03.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/fast/fzombie_pain1.wav","vj_zombies/fast/fzombie_pain2.wav","vj_zombies/fast/fzombie_pain3.wav"}
ENT.SoundTbl_Death = {"vj_zombies/fast/fzombie_die1.wav","vj_zombies/fast/fzombie_die2.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	if !self.Model then
		-- Have to randomize it here soo all types spawn equally since some are only skins
		local randModel = math.random(1, 7)
		if randModel == 1 then
			self.Model = "models/vj_zombies/fast1.mdl"
		elseif randModel == 2 then
			self.Model = "models/vj_zombies/fast2.mdl"
		elseif randModel == 3 then
			self.Model = "models/vj_zombies/fast3.mdl"
		elseif randModel == 4 then
			self.Model = "models/vj_zombies/fast4.mdl"
			self:SetSkin(1)
		elseif randModel == 5 then
			self.Model = "models/vj_zombies/fast4.mdl"
			self:SetSkin(2)
		elseif randModel == 6 then
			self.Model = "models/vj_zombies/fast4.mdl"
			self:SetSkin(3)
		else
			self.Model = "models/vj_zombies/fast4.mdl"
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 50), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if !self:OnGround() && !self:IsMoving() then
			return ACT_GLIDE
		elseif self:IsOnFire() then
			return ACT_IDLE_ON_FIRE
		end
	elseif act == ACT_CLIMB_DOWN then -- Because there is no animation, so just use climb up!
		return ACT_CLIMB_UP
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:GetLeapAttackVelocity()
	local ene = self:GetEnemy()
	return VJ.CalculateTrajectory(self, ene, "Curve", self:GetPos() + self:OBBCenter(), ene:GetPos() + ene:OBBCenter(), 25) + self:GetForward() * 80
end