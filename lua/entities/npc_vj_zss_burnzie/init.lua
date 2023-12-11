AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/burnzie.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.Immune_Fire = true -- Immune to fire damage

ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.5 -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 20

ENT.FootStepTimeRun = 0.2 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.3 -- Next foot step sound when it is walking
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"zsszombie/foot1.wav","zsszombie/foot2.wav","zsszombie/foot3.wav","zsszombie/foot4.wav"}
ENT.SoundTbl_Idle = {"zsszombies/zmisc_idle1.wav","zsszombies/zmisc_idle2.wav","zsszombies/zmisc_idle3.wav","zsszombies/zmisc_idle4.wav","zsszombies/zmisc_idle5.wav","zsszombies/zmisc_idle6.wav"}
ENT.SoundTbl_Alert = {"zsszombies/zmisc_alert1.wav","zsszombies/zmisc_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"zsszombie/miss1.wav","zsszombie/miss2.wav","zsszombie/miss3.wav","zsszombie/miss4.wav"}
ENT.SoundTbl_Pain = {"zsszombies/zmisc_pain1.wav","zsszombies/zmisc_pain2.wav","zsszombies/zmisc_pain3.wav","zsszombies/zmisc_pain4.wav","zsszombies/zmisc_pain5.wav","zsszombies/zmisc_pain6.wav"}
ENT.SoundTbl_Death = {"zsszombies/zmisc_die1.wav","zsszombies/zmisc_die2.wav","zsszombies/zmisc_die3.wav"}

-- Custom
ENT.Burnzie_ControllerFire = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
	ply:ChatPrint("JUMP: Ignite or Extinguish the Fire")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	function controlEnt:CustomOnKeyBindPressed(key)
		if key == IN_JUMP then
			if !self.VJCE_NPC.Burnzie_ControllerFire then
				self.VJCE_NPC.Burnzie_ControllerFire = true
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Igniting!")
			else
				self.VJCE_NPC.Burnzie_ControllerFire = false
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Extinguishing!")
			end
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if (IsValid(self:GetEnemy()) && !self.VJ_IsBeingControlled) or (self.VJ_IsBeingControlled && self.Burnzie_ControllerFire) then
		self.AnimTbl_Walk = {ACT_WALK_ON_FIRE}
		self.AnimTbl_Run = {ACT_WALK_ON_FIRE}
		self.AnimTbl_IdleStand = {ACT_IDLE_ON_FIRE}
		if !self:IsOnFire() then
			self:Ignite(9999)
		end
	else
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_WALK}
		self.AnimTbl_IdleStand = {ACT_IDLE}
		self:Extinguish()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	if self:IsOnFire() then hitEnt:Ignite(4) end
	return false
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo, hitgroup)
	self:Extinguish()
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnDeath_AfterCorpseSpawned(dmginfo, hitgroup, corpseEnt)
	self.Corpse:Ignite(math.Rand(8, 10), 0)
end