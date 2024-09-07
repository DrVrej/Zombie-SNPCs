AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_zombies/zombine.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 200
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK2
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDistance = 30 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
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
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS -- If it uses normal based animation, use this
ENT.HitGroupFlinching_Values = {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}
	-- ====== Sound Paths ====== --
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
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	end
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
			return ACT_HANDGRENADE_THROW1
		elseif (act == ACT_WALK or act == ACT_RUN) && IsValid(self:GetEnemy()) then
			if self.LatestEnemyDistance < 1024 then -- Make it run when close to the enemy
				return ACT_HANDGRENADE_THROW3
			else
				return ACT_HANDGRENADE_THROW2
			end
		end
	elseif (act == ACT_WALK or act == ACT_RUN) then
		if self:IsOnFire() then
			return ACT_WALK_ON_FIRE
		elseif  IsValid(self:GetEnemy()) then
			if self.LatestEnemyDistance < 1024 then -- Make it run when close to the enemy
				return ACT_RUN
			else
				return ACT_WALK
			end
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
	self:VJ_ACT_PLAYACTIVITY(ACT_SLAM_DETONATOR_DRAW, true, false, true)
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