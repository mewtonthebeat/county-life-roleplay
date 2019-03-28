/* 
=============================================
|			    CCTV SYSTEM                 |
|				  (core)					|
=============================================
*/

#define MAX_CCTV 50
#define MAX_CCTV_NAME 50

enum E_CCTV_INFO
{
	cctv_ID,

	cctv_Name[MAX_CCTV_NAME],
	Float: cctv_X, 
	Float: cctv_Y,
	Float: cctv_Z,

	Float: cctv_rotX,
	Float: cctv_rotY,
	Float: cctv_rotZ,

	cctv_Particle,
	cctv_Announce,
	cctv_IsBroken,
	cctv_VW,
	cctv_Interior,
	cctv_Faction,

	cctv_Object
};

new 
	CCTVInfo[MAX_CCTV][E_CCTV_INFO],
	Iterator: CCTVIter<MAX_CCTV>,MySQL:MYSQL = MySQL:1;

new
	Float: CCTV_oldX[MAX_PLAYERS],
	Float: CCTV_oldY[MAX_PLAYERS],
	Float: CCTV_oldZ[MAX_PLAYERS],
	Float: CCTV_oldAngle[MAX_PLAYERS],
	CCTV_oldSkin[MAX_PLAYERS],
	CCTV_oldVW[MAX_PLAYERS],
	CCTV_oldInterior[MAX_PLAYERS],
	inCCTV[MAX_PLAYERS],
	CCTV_ID[MAX_PLAYERS],
	CCTV_inEditing[MAX_PLAYERS];

public OnPlayerEditDynamicObject(playerid, objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz)
{
	if(response == EDIT_RESPONSE_CANCEL) 
	{
		if(CCTV_inEditing[playerid]) CancelEditCCTV(playerid, CCTV_ID[playerid]);
	} 
	else if(response == EDIT_RESPONSE_FINAL)
	{
		if(CCTV_inEditing[playerid])
		{
			new id = CCTV_ID[playerid];

			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);

			CCTVInfo[id][cctv_X] = x;
			CCTVInfo[id][cctv_Y] = y;
			CCTVInfo[id][cctv_Z] = z;

			CCTVInfo[id][cctv_rotX] = rx;
			CCTVInfo[id][cctv_rotY] = ry;
			CCTVInfo[id][cctv_rotZ] = rz;
			
			CCTVInfo[id][cctv_IsBroken] = 0;

			SaveCCTV(id);
			CCTV_inEditing[playerid] = 0;
			CCTV_ID[playerid] = -1;
		}
	}
	
    #if defined cctv_OnPlayerEditDynamicObject
        cctv_OnPlayerEditDynamicObject(playerid, objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz);
    #endif
	
    return 1;
}

#if defined _ALS_OnPlayerEditDynamicObject
    #undef OnPlayerEditDynamicObject
#else
    #define _ALS_OnPlayerEditDynamicObject
#endif

#define OnPlayerEditDynamicObject cctv_OnPlayerEditDynamicObject
#if defined cctv_OnPlayerEditDynamicObject
    forward cctv_OnPlayerEditDynamicObject(playerid, objectid, response, Float: x, Float: y, Float: z, Float: rx, Float: ry, Float: rz);
#endif

LoadCCTVs() return mysql_tquery(MYSQL, "SELECT * FROM `cctv` ORDER BY cctv_name", "OnLoadCCTVs", "");

OnLoadCCTVs(); public OnLoadCCTVs()
{
	new 
		rows = cache_num_rows(), id, cctvName[MAX_CCTV_NAME];
	if(rows)
	{
		for(new i; i < rows; i++)
		{
			id = Iter_Free(CCTVIter);
			if(id != -1)
			{
				cache_get_value_name_int(i, "ID", CCTVInfo[id][cctv_ID]);
				cache_get_value_name(i, "cctv_name", cctvName);
				strcpy(CCTVInfo[id][cctv_Name], cctvName, MAX_CCTV_NAME);

				cache_get_value_name_float(i, "cctv_x", CCTVInfo[id][cctv_X]);
				cache_get_value_name_float(i, "cctv_y", CCTVInfo[id][cctv_Y]);
				cache_get_value_name_float(i, "cctv_z", CCTVInfo[id][cctv_Z]);

				cache_get_value_name_float(i, "cctv_rot_x", CCTVInfo[id][cctv_rotX]);
				cache_get_value_name_float(i, "cctv_rot_y", CCTVInfo[id][cctv_rotY]);
				cache_get_value_name_float(i, "cctv_rot_z", CCTVInfo[id][cctv_rotZ]);

				cache_get_value_name_int(i, "cctv_vw", CCTVInfo[id][cctv_VW]);
				cache_get_value_name_int(i, "cctv_interior", CCTVInfo[id][cctv_Interior]);
				cache_get_value_name_int(i, "cctv_faction", CCTVInfo[id][cctv_Faction]);

				CCTVInfo[id][cctv_Object] = CreateDynamicObject(1886, CCTVInfo[id][cctv_X], CCTVInfo[id][cctv_Y], CCTVInfo[id][cctv_Z], CCTVInfo[id][cctv_rotX], CCTVInfo[id][cctv_rotY], CCTVInfo[id][cctv_rotZ], CCTVInfo[id][cctv_VW]);

				Iter_Add(CCTVIter, id);
			}
		}
	}
	return 1;
}

OnCCTVCreated(id); public OnCCTVCreated(id)
{
	CCTVInfo[id][cctv_ID] = cache_insert_id();
	return SaveCCTV(id);
}

stock SaveCCTV(id)
{
	new query[512];
	mysql_format(MYSQL, query, sizeof query, "UPDATE `cctv` SET `cctv_name` = '%e', `cctv_faction` = '%d', `cctv_x` = '%f', `cctv_y` = '%f', `cctv_z` = '%f', `cctv_rot_x` = '%f', `cctv_rot_y` = '%f', `cctv_rot_z` = '%f', `cctv_vw` = '%d', `cctv_interior` = '%d' WHERE `ID` = '%d'", 
		CCTVInfo[id][cctv_Name],
		CCTVInfo[id][cctv_Faction],
		CCTVInfo[id][cctv_X],
		CCTVInfo[id][cctv_Y],
		CCTVInfo[id][cctv_Z],
		CCTVInfo[id][cctv_rotX],
		CCTVInfo[id][cctv_rotY],
		CCTVInfo[id][cctv_rotZ],
		CCTVInfo[id][cctv_VW],
		CCTVInfo[id][cctv_Interior],
		CCTVInfo[id][cctv_ID]);
	mysql_query(MYSQL, query);
	return 1;
}

stock CreateCCTV(playerid, name[], factionid)
{
	new id = Iter_Free(CCTVIter);
	if(id != -1)
	{
		new 
			Float: x, Float: y, Float: z;
		GetPlayerPos(playerid, x, y, z);

		CCTVInfo[id][cctv_X] = x;
		CCTVInfo[id][cctv_Y] = y;
		CCTVInfo[id][cctv_Z] = z;

		CCTVInfo[id][cctv_rotX] = 0.0;
		CCTVInfo[id][cctv_rotY] = 0.0;
		CCTVInfo[id][cctv_rotZ] = 0.0;

		CCTVInfo[id][cctv_Faction] = factionid;

		CCTVInfo[id][cctv_VW] = GetPlayerVirtualWorld(playerid);
		CCTVInfo[id][cctv_Interior] = GetPlayerInterior(playerid);
		strcpy(CCTVInfo[id][cctv_Name], name, MAX_CCTV_NAME);

		CCTVInfo[id][cctv_Object] = CreateDynamicObject(1886, CCTVInfo[id][cctv_X], CCTVInfo[id][cctv_Y], CCTVInfo[id][cctv_Z], CCTVInfo[id][cctv_rotX], CCTVInfo[id][cctv_rotY], CCTVInfo[id][cctv_rotZ], CCTVInfo[id][cctv_VW]);

		Iter_Add(CCTVIter, id);
		mysql_tquery(MYSQL, "INSERT INTO `cctv` (`cctv_x`) VALUES (0)", "OnCCTVCreated", "d", id);
	}
	return id;
}

stock DeleteCCTV(id)
{
	if(!Iter_Contains(CCTVIter, id)) return 0;

	new 
		query[128];
	mysql_format(MYSQL, query, sizeof query, "DELETE FROM `cctv` WHERE `ID` = '%d'", CCTVInfo[id][cctv_ID]);
	mysql_query(MYSQL, query);
	
	CCTVInfo[id][cctv_X] = CCTVInfo[id][cctv_Y] = CCTVInfo[id][cctv_Z] = 
	CCTVInfo[id][cctv_rotX] = CCTVInfo[id][cctv_rotY] = CCTVInfo[id][cctv_rotZ] = 0.0;

	CCTVInfo[id][cctv_VW] = CCTVInfo[id][cctv_Interior] = 
	CCTVInfo[id][cctv_Faction] = CCTVInfo[id][cctv_ID] = -1;
	DestroyDynamicObject(CCTVInfo[id][cctv_Object]);

	Iter_Remove(CCTVIter, id);
	return 1;
}

stock EditCCTV(playerid, id)
{
	if(!Iter_Contains(CCTVIter, id)) return 0;
	if(CCTV_inEditing[playerid]) return -1;
	CCTV_inEditing[playerid] = 1;
	CCTV_ID[playerid] = id;
	EditDynamicObject(playerid, CCTVInfo[id][cctv_Object]);
	return 1;
}

stock CancelEditCCTV(playerid, id)
{
	CCTV_inEditing[playerid] = 0;
	CCTV_ID[playerid] = -1;
	SetDynamicObjectPos(CCTVInfo[id][cctv_Object], CCTVInfo[id][cctv_X], CCTVInfo[id][cctv_Y], CCTVInfo[id][cctv_Z]);
	SetDynamicObjectRot(CCTVInfo[id][cctv_Object], CCTVInfo[id][cctv_rotX], CCTVInfo[id][cctv_rotY], CCTVInfo[id][cctv_rotZ]);
	return 1;
}

stock ChangeCCTVName(playerid, id, name[])
{
	if(!Iter_Contains(CCTVIter, id)) return 0;
	SendClientMessage(playerid, 0xFF6347FF, str);
	return 1;
}

stock ChangeCCTVFaction(playerid, id, factionid)
{
	if(!Iter_Contains(CCTVIter, id)) return 0;
	CCTVInfo[id][cctv_Faction] = factionid;
	return 1;
}

stock MoveCCTV(playerid, id)
{
	if(!Iter_Contains(CCTVIter, id)) return 0;
	new 
		Float: x, Float: y, Float: z, str[128];
	GetPlayerPos(playerid, x, y, z);

	CCTVInfo[id][cctv_X] = x;
	CCTVInfo[id][cctv_Y] = y + 0.5;
	CCTVInfo[id][cctv_Z] = z;

	CCTVInfo[id][cctv_rotX] = 0.0;
	CCTVInfo[id][cctv_rotY] = 0.0;
	CCTVInfo[id][cctv_rotZ] = 0.0;

	CCTVInfo[id][cctv_VW] = GetPlayerVirtualWorld(playerid);
	CCTVInfo[id][cctv_Interior] = GetPlayerInterior(playerid);
	format(str, sizeof str, "AdmCmd: CCTV (#%d) moved to your current location.", id);
	SendClientMessage(playerid, 0xFF6347FF, str);

	SetDynamicObjectPos(CCTVInfo[id][cctv_Object], CCTVInfo[id][cctv_X], CCTVInfo[id][cctv_Y], CCTVInfo[id][cctv_Z]);
	SetDynamicObjectRot(CCTVInfo[id][cctv_Object], CCTVInfo[id][cctv_rotX], CCTVInfo[id][cctv_rotY], CCTVInfo[id][cctv_rotZ]);

	SaveCCTV(id);
	return 1;
}

stock PlayerCancelCCTV(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	SetPlayerPos(playerid, CCTV_oldX[playerid], CCTV_oldY[playerid], CCTV_oldZ[playerid]);
	SetPlayerFacingAngle(playerid, CCTV_oldAngle[playerid]);
	SetPlayerVirtualWorld(playerid, CCTV_oldVW[playerid]);
	SetPlayerInterior(playerid, CCTV_oldInterior[playerid]);
	SetPlayerSkin(playerid, CCTV_oldSkin[playerid]);

	CCTV_oldX[playerid] = CCTV_oldY[playerid] = CCTV_oldZ[playerid] = 0.0;
	CCTV_oldVW[playerid] = CCTV_oldInterior[playerid] = inCCTV[playerid] = 0;
	CCTV_oldSkin[playerid] = -1;
	return 1;
}