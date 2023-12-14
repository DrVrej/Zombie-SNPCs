AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/blacktea/zpszombie1.mdl", "models/blacktea/zpszombie2.mdl", "models/blacktea/zpszombie3.mdl", "models/blacktea/zpszombie5.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 120
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {"vjseq_weapon_attack1","vjseq_weapon_attack2"} -- Melee Attack Animations
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 85 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = false -- This counted in seconds | This calculates the time until it hits something
ENT.MeleeAttackDamage = 35
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 0.5 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.7 -- Next foot step sound when it is walking
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"npc/zombie/foot1.wav","npc/zombie/foot2.wav","npc/zombie/foot3.wav"}
ENT.SoundTbl_Idle = {"vj_zombies/slow/zombie_idle1.wav","vj_zombies/slow/zombie_idle2.wav","vj_zombies/slow/zombie_idle3.wav","vj_zombies/slow/zombie_idle4.wav","vj_zombies/slow/zombie_idle5.wav","vj_zombies/slow/zombie_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/slow/zombie_alert1.wav","vj_zombies/slow/zombie_alert2.wav","vj_zombies/slow/zombie_alert3.wav","vj_zombies/slow/zombie_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"vj_zombies/slow/zombie_attack_1.wav","vj_zombies/slow/zombie_attack_2.wav","vj_zombies/slow/zombie_attack_3.wav","vj_zombies/slow/zombie_attack_4.wav","vj_zombies/slow/zombie_attack_5.wav","vj_zombies/slow/zombie_attack_6.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"vj_zombies/slow/miss1.wav","vj_zombies/slow/miss2.wav","vj_zombies/slow/miss3.wav","vj_zombies/slow/miss4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/slow/zombie_pain1.wav","vj_zombies/slow/zombie_pain2.wav","vj_zombies/slow/zombie_pain3.wav","vj_zombies/slow/zombie_pain4.wav","vj_zombies/slow/zombie_pain5.wav","vj_zombies/slow/zombie_pain6.wav","vj_zombies/slow/zombie_pain7.wav","vj_zombies/slow/zombie_pain8.wav"}
ENT.SoundTbl_Death = {"vj_zombies/slow/zombie_die1.wav","vj_zombies/slow/zombie_die2.wav","vj_zombies/slow/zombie_die3.wav","vj_zombies/slow/zombie_die4.wav","vj_zombies/slow/zombie_die5.wav","vj_zombies/slow/zombie_die6.wav"}

ENT.GeneralSoundPitch1 = 60
ENT.GeneralSoundPitch2 = 60
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnAcceptInput(key, activator, caller, data)
	if key == "event_mattack dmg" then
		self:MeleeAttackCode()
	end
end