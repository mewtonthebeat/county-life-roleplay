#define     EmptyGuns::     eg_

stock EmptyGuns::GiveGun(playerid, weaponid, bool:replace = true, pweapon = -1, serial=-1,iswork=-1,ispermit=-1,origin[]="")
{

	new
	    lSlot = ac_GetWeaponSlot(weaponid),
	    lReturn = 1,
		lOld = playerEmptyGuns[playerid][lSlot]
	;
	
	if(pweapon == -1)
	{
	    pweapon 	= playerWeapons[playerid][lSlot][pweapons_WeaponId];
	    serial 		= playerWeapons[playerid][lSlot][pweapons_SerialNumber];
	    iswork 		= !!playerWeapons[playerid][lSlot][pweapons_IsWork];
	    ispermit 	= !!playerWeapons[playerid][lSlot][pweapons_IsPermit];
	    format(origin, 128, "%s", playerWeapons[playerid][lSlot][pweapons_Origin]);
	}
	
	if(lOld > 0 && replace)
	{
	    playerEmptyGuns[playerid][lSlot]	= pweapon;
	    playerEmptyGuns_S[playerid][lSlot] 	= serial;
	    playerEmptyGuns_W[playerid][lSlot] 	= iswork;
	    playerEmptyGuns_P[playerid][lSlot] 	= ispermit;
	    format(playerEmptyGuns_O[playerid][lSlot], 128, "%s", origin);
	
	    lReturn = 2;
	    
	    FormatLog(log_type_player, "%s(%s) got empty weapon ID %d, it was rewrote because there was already a weapon ID %d on this slot!", ReturnName(playerid), ReturnIP(playerid), weaponid, playerEmptyGuns[playerid][lSlot]);
		return 1;
	}
	else if(!replace && lOld <= 0)
	{
		playerEmptyGuns[playerid][lSlot]	= pweapon;
	    playerEmptyGuns_S[playerid][lSlot] 	= serial;
	    playerEmptyGuns_W[playerid][lSlot] 	= iswork;
	    playerEmptyGuns_P[playerid][lSlot] 	= ispermit;
	    format(playerEmptyGuns_O[playerid][lSlot], 128, "%s", origin);
		return 1;
	}
		
	if(replace == false && lOld > 0)
	{
	    // dropni
	    
	    new
	        Float:X, Float:Y, Float:Z,
	        Float:Angle,
	        
	        date[32],
			ex_date[3],
			ex_time[3],
			
			dropfact
		;
		
		if(IsPlayerWorking(playerid))
	    	dropfact = GetPlayerFaction(playerid);
		
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, Angle);
		
		getdate(ex_date[0], ex_date[1], ex_date[2]);
		gettime(ex_time[0], ex_time[1], ex_time[2]);
		format(date, 32, "%d/%d/%d %d:%d:%d", ex_date[2], ex_date[1], ex_date[0], ex_time[0], ex_time[1], ex_time[2]);
	    
	    CreateDynamicDrop(
			1, weaponid, 0,
			X, Y, Z, Angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid),
			ReturnName(playerid), date, dropfact, "Empty weapon", 1,
			.w_serialnum = serial,
			.w_origin = origin,
			.w_iswork = iswork,
			.w_ispermit = ispermit
		);
	    
	    SendSuccess(playerid, "You already had the same weapon type in /myguns, it will be dropped!");
	    FormatLog(log_type_player, "%s(%s) dropped empty weapon ID %d, because he has empty weapon ID %d!", ReturnName(playerid), ReturnIP(playerid), weaponid, playerEmptyGuns[playerid][lSlot]);
	    
	    lReturn = 3;
	}

	return lReturn;
}

stock EmptyGuns::GetGunInSlot(playerid, slot)
{
	return playerEmptyGuns[playerid][slot];
}

stock EmptyGuns::RemoveGun(playerid, weaponid)
{
    playerEmptyGuns[playerid][ac_GetWeaponSlot(weaponid)] = 0;
	return 1;
}

stock EmptyGuns::RemoveGunInSlot(playerid, slot)
{
    playerEmptyGuns[playerid][slot] = 0;
	return 1;
}
