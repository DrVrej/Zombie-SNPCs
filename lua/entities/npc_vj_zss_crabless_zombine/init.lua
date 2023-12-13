AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/Zombie_Soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_fastattack"}
ENT.TimeUntilMeleeAttackDamage = 0.4
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.6 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
ENT.FlinchAnimationDecreaseLengthAmount = 0.4 -- This will decrease the time it can move, attack, etc. | Use it to fix animation pauses after it finished the flinch animation
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"vj_zombies/zombine/gear1.wav","vj_zombies/zombine/gear2.wav","vj_zombies/zombine/gear3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/zombine/idle1.wav","vj_zombies/zombine/idle2.wav","vj_zombies/zombine/idle3.wav","vj_zombies/zombine/idle4.wav","vj_zombies/zombine/idle5.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/zombine/alert1.wav","vj_zombies/zombine/alert2.wav","vj_zombies/zombine/alert3.wav","vj_zombies/zombine/alert4.wav","vj_zombies/zombine/alert5.wav","vj_zombies/zombine/alert6.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_zombies/zombine/attack1.wav","vj_zombies/zombine/attack2.wav","vj_zombies/zombine/attack3.wav","vj_zombies/zombine/attack4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/zombine/pain1.wav","vj_zombies/zombine/pain2.wav","vj_zombies/zombine/pain3.wav","vj_zombies/zombine/pain4.wav"}
ENT.SoundTbl_Death = {"vj_zombies/zombine/die1.wav","vj_zombies/zombine/die2.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

-- Custom
ENT.Zombie_GrenadeOut = false -- Can only do it once!
ENT.Zombie_ActGrenIdle = -1
ENT.Zombie_ActGrenRun = -1
ENT.Zombie_ActGrenWalk = -1
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	self.Zombie_ActGrenIdle = self:GetSequenceActivity(self:LookupSequence("idle_grenade"))
	self.Zombie_ActGrenRun = self:GetSequenceActivity(self:LookupSequence("run_all_grenade"))
	self.Zombie_ActGrenWalk = self:GetSequenceActivity(self:LookupSequence("walk_all_grenade"))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
	ply:ChatPrint("JUMP: To Pull Grenade (One time event!)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- We have an active grenade
	if IsValid(self.Zombie_Grenade) == true then
		if act == ACT_IDLE then
			return self.Zombie_ActGrenIdle
		elseif (act == ACT_WALK or act == ACT_RUN) && IsValid(self:GetEnemy()) then
			if self.LatestEnemyDistance < 1024 then
				return self.Zombie_ActGrenRun
			else
				return self.Zombie_ActGrenWalk
			end
		end
	elseif (act == ACT_WALK or act == ACT_RUN) && IsValid(self:GetEnemy()) then
		if self.LatestEnemyDistance < 1024 then
			return ACT_RUN
		else
			return ACT_WALK
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	-- Pull out the grenade
	if self.Zombie_GrenadeOut == false then
		if self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP) then
			self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Pulling Grenade Out!")
			self:Zombie_CreateGrenade()
		elseif self.VJ_IsBeingControlled == false && IsValid(self:GetEnemy()) && self.LatestEnemyDistance <= 256 && self:Health() <= 40 then
			self:Zombie_CreateGrenade()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CreateGrenade()
	self.Zombie_GrenadeOut = true
	self:VJ_ACT_PLAYACTIVITY("pullgrenade", true, false, true)
	timer.Simple(0.6, function()
		if IsValid(self) then
			local grenade = ents.Create("npc_grenade_frag")
			grenade:SetOwner(self)
			grenade:SetParent(self)
			grenade:Fire("SetParentAttachment", "grenade_attachment", 0)
			grenade:Spawn()
			grenade:Activate()
			grenade:Input("SetTimer", self, self, 3)
			grenade.VJTag_IsPickupable = false -- So humans won't pick it up
			self.Zombie_Grenade = grenade
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo, hitgroup)
	local grenade = self.Zombie_Grenade
	if IsValid(grenade) then
		local att = self:GetAttachment(self:LookupAttachment("grenade_attachment"))
		grenade:SetOwner(NULL)
		grenade:SetParent(NULL)
		grenade:Fire("ClearParent")
		grenade:SetMoveType(MOVETYPE_VPHYSICS)
		grenade:SetPos(att.Pos)
		grenade:SetAngles(att.Ang)
		local phys = grenade:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
			phys:Wake()
		end
	end
end