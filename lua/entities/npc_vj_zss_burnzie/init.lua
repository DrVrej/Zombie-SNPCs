AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = "models/vj_zombies/burnzie.mdl" -- Model(s) to spawn with | Picks a random one if it's a table
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.Immune_Fire = true -- Immune to fire damage

ENT.HasMeleeAttack = true -- Can this NPC melee attack?
ENT.AnimTbl_MeleeAttack = ACT_MELEE_ATTACK1
ENT.MeleeAttackDistance = 32 -- How close an enemy has to be to trigger a melee attack | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go | false = Let the base auto calculate on initialize based on the NPC's collision bounds
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 20

ENT.DisableFootStepSoundTimer = true
	-- ====== Sound Paths ====== --
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/special/zmisc_idle1.wav","vj_zombies/special/zmisc_idle2.wav","vj_zombies/special/zmisc_idle3.wav","vj_zombies/special/zmisc_idle4.wav","vj_zombies/special/zmisc_idle5.wav","vj_zombies/special/zmisc_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/special/zmisc_alert1.wav","vj_zombies/special/zmisc_alert2.wav"}
ENT.SoundTbl_MeleeAttack = {"npc/zombie/claw_strike1.wav","npc/zombie/claw_strike2.wav","npc/zombie/claw_strike3.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/special/zmisc_pain1.wav","vj_zombies/special/zmisc_pain2.wav","vj_zombies/special/zmisc_pain3.wav","vj_zombies/special/zmisc_pain4.wav","vj_zombies/special/zmisc_pain5.wav","vj_zombies/special/zmisc_pain6.wav"}
ENT.SoundTbl_Death = {"vj_zombies/special/zmisc_die1.wav","vj_zombies/special/zmisc_die2.wav","vj_zombies/special/zmisc_die3.wav"}

---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Init()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:OnInput(key, activator, caller, data) 
	if key == "step" then
		self:FootStepSoundCode()
	elseif key == "melee" then
		self:MeleeAttackCode()
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_Initialize(ply, controlEnt)
	ply:ChatPrint("JUMP: Ignite or Extinguish the Fire")
	
	function controlEnt:CustomOnKeyBindPressed(key)
		if key == IN_JUMP then
			local npc = self.VJCE_NPC
			if !npc:IsOnFire() then
				npc:Ignite(99999)
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Igniting!")
			else
				npc:Extinguish()
				self.VJCE_Player:PrintMessage(HUD_PRINTCENTER, "Extinguishing!")
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
	end
	self.BaseClass.OnStateChange(self, oldState, newState)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnMeleeAttack_AfterChecks(hitEnt, isProp)
	if self:IsOnFire() then
		hitEnt:Ignite(math.Rand(3, 5))
	end
end