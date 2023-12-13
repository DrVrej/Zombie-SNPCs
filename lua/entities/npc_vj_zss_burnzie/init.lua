AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
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
ENT.SoundTbl_FootStep = {"vj_zombies/slow/foot1.wav","vj_zombies/slow/foot2.wav","vj_zombies/slow/foot3.wav","vj_zombies/slow/foot4.wav"}
ENT.SoundTbl_Idle = {"zsszombies/zmisc_idle1.wav","zsszombies/zmisc_idle2.wav","zsszombies/zmisc_idle3.wav","zsszombies/zmisc_idle4.wav","zsszombies/zmisc_idle5.wav","zsszombies/zmisc_idle6.wav"}
ENT.SoundTbl_Alert = {"zsszombies/zmisc_alert1.wav","zsszombies/zmisc_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"zsszombies/zmisc_pain1.wav","zsszombies/zmisc_pain2.wav","zsszombies/zmisc_pain3.wav","zsszombies/zmisc_pain4.wav","zsszombies/zmisc_pain5.wav","zsszombies/zmisc_pain6.wav"}
ENT.SoundTbl_Death = {"zsszombies/zmisc_die1.wav","zsszombies/zmisc_die2.wav","zsszombies/zmisc_die3.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Ignite or Extinguish the Fire")
	
	function controlEnt:CustomOnKeyBindPressed(key)
		if key == IN_JUMP then
			if !self.VJCE_NPC:IsOnFire() then
				self.VJCE_NPC:Ignite(99999)
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Igniting!")
				if self.VJCE_NPC:GetIdealActivity() == ACT_IDLE then
					self.VJCE_NPC:MaintainIdleAnimation(true)
				end
			else
				self.VJCE_NPC:Extinguish()
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Extinguishing!")
				if self.VJCE_NPC:GetIdealActivity() == ACT_IDLE then
					self.VJCE_NPC:MaintainIdleAnimation(true)
				end
			end
		end
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
function ENT:OnStateChange(oldState, newState)
	-- Set fire when its been alerted or seen an enemy
	if !self.VJ_IsBeingControlled then
		if newState == NPC_STATE_ALERT or newState == NPC_STATE_COMBAT then
			self:Ignite(99999)
		else
			self:Extinguish()
		end
		if self:GetIdealActivity() == ACT_IDLE then
			self:MaintainIdleAnimation(true)
		end
	end
	self.BaseClass.OnStateChange(self, oldState, newState)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	if self:IsOnFire() then
		hitEnt:Ignite(math.Rand(3, 5))
	end
end