/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Random Fast Zombie Spawner"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "VJ Base Spawners"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

local entsList = {"npc_vj_zss_zombfast1","npc_vj_zss_zombfast2","npc_vj_zss_zombfast3","npc_vj_zss_zombfast4","npc_vj_zss_zombfast5","npc_vj_zss_zombfast6","npc_vj_zss_cfastzombie"}
ENT.EntitiesToSpawn = {
	{SpawnPosition = {vForward=50,vRight=0,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=0,vRight=50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=100,vRight=50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=100,vRight=-50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=0,vRight=-50,vUp=0},Entities = entsList},
}