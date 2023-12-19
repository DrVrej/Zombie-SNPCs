AddCSLuaFile("shared.lua")
include("shared.lua")
/*-----------------------------------------------
	*** Copyright (c) 2012-2024 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/vj_zombies/draggy.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = 200
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.AnimTbl_MeleeAttack = {ACT_MELEE_ATTACK1} -- Melee Attack Animations
ENT.MeleeAttackDistance = 22 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 65 -- How far does the damage go?
ENT.TimeUntilMeleeAttackDamage = 0.2 -- This counted in seconds | This calculates the time until it hits something
ENT.NextAnyAttackTime_Melee = 0.2 -- How much time until it can use any attack again? | Counted in Seconds
ENT.MeleeAttackDamage = 20
ENT.PushProps = false -- True = Pushes props (The ones in the code only!)
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_Idle = {"vj_zombies/special/zmisc_idle1.wav","vj_zombies/special/zmisc_idle2.wav","vj_zombies/special/zmisc_idle3.wav","vj_zombies/special/zmisc_idle4.wav","vj_zombies/special/zmisc_idle5.wav","vj_zombies/special/zmisc_idle6.wav"}
ENT.SoundTbl_Alert = {"vj_zombies/special/zmisc_alert1.wav","vj_zombies/special/zmisc_alert2.wav"}
ENT.SoundTbl_MeleeAttackExtra = {"vj_zombies/special/bite1.wav","vj_zombies/special/bite2.wav","vj_zombies/special/bite3.wav","vj_zombies/special/bite4.wav"}
ENT.SoundTbl_Pain = {"vj_zombies/special/zmisc_pain1.wav","vj_zombies/special/zmisc_pain2.wav","vj_zombies/special/zmisc_pain3.wav","vj_zombies/special/zmisc_pain4.wav","vj_zombies/special/zmisc_pain5.wav","vj_zombies/special/zmisc_pain6.wav"}
ENT.SoundTbl_Death = {"vj_zombies/special/zmisc_die1.wav","vj_zombies/special/zmisc_die2.wav","vj_zombies/special/zmisc_die3.wav"}
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(12, 12, 60), Vector(-12, -12, 0))
	self:SetSkin(math.random(0, 3))
end