AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2025 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_zombies/zombine.mdl"
ENT.StartHealth = 200
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"}
ENT.BloodColor = VJ.BLOOD_COLOR_RED

ENT.HasMeleeAttack = true
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK2
ENT.TimeUntilMeleeAttackDamage = false
ENT.MeleeAttackDamage = 35
ENT.MeleeAttackDistance = 30
ENT.MeleeAttackDamageDistance = 70
ENT.MeleeAttackDamageAngleRadius = 180 -- We need this because its eye position ends up rotating too much on melee!
ENT.MeleeAttackPlayerSpeed = true
ENT.MeleeAttackBleedEnemy = true

ENT.DisableFootStepSoundTimer = true
ENT.HasExtraMeleeAttackSounds = true

ENT.CanFlinch = true
ENT.AnimTbl_Flinch = ACT_FLINCH_PHYSICS
ENT.FlinchHitGroupMap = {{HitGroup = {HITGROUP_HEAD}, Animation = {ACT_FLINCH_HEAD}}, {HitGroup = {HITGROUP_LEFTARM}, Animation = {ACT_FLINCH_LEFTARM}}, {HitGroup = {HITGROUP_RIGHTARM}, Animation = {ACT_FLINCH_RIGHTARM}}, {HitGroup = {HITGROUP_LEFTLEG}, Animation = {ACT_FLINCH_LEFTLEG}}, {HitGroup = {HITGROUP_RIGHTLEG}, Animation = {ACT_FLINCH_RIGHTLEG}}}

ENT.SoundTbl_FootStep = {"vj_zombies/zombine/gear1.wav", "vj_zombies/zombine/gear2.wav", "vj_zombies/zombine/gear3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/zombine/idle1.wav", "vj_zombies/zombine/idle2.wav", "vj_zombies/zombine/idle3.wav", "vj_zombies/zombine/idle4.wav", "vj_zombies/zombine/idle5.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/zombine/alert1.wav", "vj_zombies/zombine/alert2.wav", "vj_zombies/zombine/alert3.wav", "vj_zombies/zombine/alert4.wav", "vj_zombies/zombine/alert5.wav", "vj_zombies/zombine/alert6.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"vj_zombies/zombine/attack1.wav", "vj_zombies/zombine/attack2.wav", "vj_zombies/zombine/attack3.wav", "vj_zombies/zombine/attack4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav", "vj_zombies/slow/miss2.wav", "vj_zombies/slow/miss3.wav", "vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/zombine/pain1.wav", "vj_zombies/zombine/pain2.wav", "vj_zombies/zombine/pain3.wav", "vj_zombies/zombine/pain4.wav"}
ENT.SoundTbl_Death = {"vj_zombies/zombine/die1.wav", "vj_zombies/zombine/die2.wav"}

ENT.MainSoundPitch = 100

-- Custom
ENT.Zombie_GrenadeOut = false -- Can only do it once!
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data)
	//print(key)
	if key == "step" then
		self:PlayFootstepSound()
	elseif key == "melee" then
		self:ExecuteMeleeAttack()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply)
	ply:ChatPrint("JUMP: To Pull Grenade (One time event!)")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:TranslateActivity(act)
	-- We have an active grenade
	if IsValid(self.Zombie_Grenade) then
		if act == ACT_IDLE then
			return ACT_HANDGRENADE_THROW1
		elseif (act == ACT_WALK or act == ACT_RUN) && IsValid(self:GetEnemy()) then
			if self.EnemyData.Distance < 1024 then -- Make it run when close to the enemy
				return ACT_HANDGRENADE_THROW3
			else
				return ACT_HANDGRENADE_THROW2
			end
		end
	elseif (act == ACT_WALK or act == ACT_RUN) then
		if self:IsOnFire() then
			return ACT_WALK_ON_FIRE
		elseif  IsValid(self:GetEnemy()) then
			if self.EnemyData.Distance < 1024 then -- Make it run when close to the enemy
				return ACT_RUN
			else
				return ACT_WALK
			end
		end
	end
	return self.BaseClass.TranslateActivity(self, act)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnThinkActive()
	-- Pull out the grenade
	if !self.Zombie_GrenadeOut then
		if self.VJ_IsBeingControlled then
			if  self.VJ_TheController:KeyDown(IN_JUMP) then
				self.VJ_TheController:PrintMessage(HUD_PRINTCENTER, "Pulling Grenade Out!")
				self:Zombie_CreateGrenade()
			end
		elseif IsValid(self:GetEnemy()) && self.EnemyData.Distance <= 256 && self:Health() <= 40 then
			self:Zombie_CreateGrenade()
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombie_CreateGrenade()
	self.Zombie_GrenadeOut = true
	self:PlayAnim(ACT_SLAM_DETONATOR_DRAW, true, false, true)
	timer.Simple(0.6, function()
		if IsValid(self) then
			local grenade = ents.Create("npc_grenade_frag")
			grenade:SetOwner(self)
			grenade:SetParent(self)
			grenade:Fire("SetParentAttachment", "grenade_attachment", 0)
			grenade:Spawn()
			grenade:Activate()
			grenade:Input("SetTimer", self, self, 3)
			grenade.VJ_ID_Grabbable = false -- So humans won't pick it up
			self.Zombie_Grenade = grenade
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnDeath(dmginfo, hitgroup, status)
	if status == "Finish" then
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
end