/*--------------------------------------------------
	*** Copyright (c) 2012-2021 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
AddCSLuaFile()

ENT.Base 			= "obj_vj_spawner_base"
ENT.Type 			= "anim"
ENT.PrintName 		= "Random Slow Zombie Spawner"
ENT.Author 			= "DrVrej"
ENT.Contact 		= "http://steamcommunity.com/groups/vrejgaming"
ENT.Purpose 		= "Spawn it and fight with it!"
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "VJ Base Spawners"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if !SERVER then return end

local entsList = {"npc_vj_zss_zombie1","npc_vj_zss_zombie2","npc_vj_zss_zombie3","npc_vj_zss_zombie4","npc_vj_zss_zombie5","npc_vj_zss_zombie6","npc_vj_zss_zombie7","npc_vj_zss_zombie8","npc_vj_zss_zombie9","npc_vj_zss_zombie10","npc_vj_zss_zombie11","npc_vj_zss_zombie12"}
ENT.EntitiesToSpawn = {
	{SpawnPosition = {vForward=50,vRight=0,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=0,vRight=50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=100,vRight=50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=100,vRight=-50,vUp=0},Entities = entsList},
	{SpawnPosition = {vForward=0,vRight=-50,vUp=0},Entities = entsList},
}