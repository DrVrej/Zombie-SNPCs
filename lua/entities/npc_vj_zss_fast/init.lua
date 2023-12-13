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
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.2 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 20
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.HasLeapAttack = true -- Should the SNPC have a leap attack?
ENT.AnimTbl_LeapAttack = {"leapstrike"} -- Melee Attack Animations
ENT.LeapDistance = 400 -- The distance of the leap, for example if it is set to 500, when the SNPC is 500 Unit away, it will jump
ENT.LeapToMeleeDistance = 150 -- How close does it have to be until it uses melee?
ENT.TimeUntilLeapAttackDamage = 0.2 -- How much time until it runs the leap damage code?
ENT.NextLeapAttackTime = 3 -- How much time until it can use a leap attack?
ENT.NextAnyAttackTime_Leap = 0.4 -- How much time until it can use any attack again? | Counted in Seconds
ENT.LeapAttackExtraTimers = {0.4,0.6,0.8,1} -- Extra leap attack timers | it will run the damage code after the given amount of seconds
ENT.TimeUntilLeapAttackVelocity = 0.2 -- How much time until it runs the velocity code?
ENT.LeapAttackVelocityForward = 300 -- How much forward force should it apply?
ENT.LeapAttackVelocityUp = 250 -- How much upward force should it apply?
ENT.LeapAttackDamage = 15
ENT.LeapAttackDamageDistance = 100 -- How far does the damage go?
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.6 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_zombies/slow/foot1.wav","vj_zombies/slow/foot2.wav","vj_zombies/slow/foot3.wav","vj_zombies/slow/foot4.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/fast/fzombie_idle1.wav","vj_zombies/fast/fzombie_idle2.wav","vj_zombies/fast/fzombie_idle3.wav","vj_zombies/fast/fzombie_idle4.wav","vj_zombies/fast/fzombie_idle5.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/fast/fzombie_alert1.wav","vj_zombies/fast/fzombie_alert2.wav","vj_zombies/fast/fzombie_alert3.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/fast/attack1.wav","vj_zombies/fast/attack2.wav","vj_zombies/fast/attack3.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_LeapAttackJump = {"vj_zombies/fast/hunter_attackmix_01.wav","vj_zombies/fast/hunter_attackmix_02.wav","vj_zombies/fast/hunter_attackmix_03.wav"}
ENT.SoundTbl_LeapAttackDamage = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/fast/fzombie_pain1.wav","vj_zombies/fast/fzombie_pain2.wav","vj_zombies/fast/fzombie_pain3.wav"}
ENT.SoundTbl_Death = {"vj_zombies/fast/fzombie_die1.wav","vj_zombies/fast/fzombie_die2.wav"}

-- Custom
ENT.Zombie_ActLeapIdle = -1 -- Uses an undefined animation
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnPreInitialize()
	-- Have to randomize it here soo all types spawn equally since some are only skins
	local randZombie = math.random(1, 6)
	if randZombie == 1 then
		self.Model = "models/zombie/zombie_fast01.mdl"
	elseif randZombie == 2 then
		self.Model = "models/zombie/zombie_fast03.mdl"
	elseif randZombie == 3 then
		self.Model = "models/zombie/zm_fast.mdl"
		self:SetSkin(1)
	elseif randZombie == 4 then
		self.Model = "models/zombie/zm_fast.mdl"
		self:SetSkin(2)
	elseif randZombie == 5 then
		self.Model = "models/zombie/zm_fast.mdl"
		self:SetSkin(3)
	else
		self.Model = "models/zombie/zm_fast.mdl"
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 50), Vector(-13, -13, 0))
	self.Zombie_ActLeapIdle = self:GetSequenceActivity(self:LookupSequence("LeapStrike"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	if act == ACT_IDLE then
		if !self:OnGround() then
			return self.Zombie_ActLeapIdle
		elseif self:IsOnFire() then
			return ACT_IDLE_ON_FIRE
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end