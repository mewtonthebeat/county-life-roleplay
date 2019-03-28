////////////////////////////////////////////////////////////////////////////////

/*
	* Weapons::resetWeapons(playerid)
	* Weapons::givePlayerNewWeapon(playerid, weaponid, ammo, bool:isworkweap, bool:ispermitted)
	* Weapons::transferWeapon(playerid, toplayerid, weaponid)
	* Weapons::decreaseAmmo(playerid, weaponid)

	* Weapons::getWeaponSlot(weaponid)
	* Weapons::generateSerialNumber(playerid, bool:ispermitted, bool:isworkweap)
	* Weapons::checkCheated(playerid)
	* Weapons::hasCheatedGun(playerid, weaponid, ammo, type)
*/

#define     Weapons::       		wepsx_

#define     MAX_WEAPON_SLOTS    	13
#define     MAX_SERIAL_NUMBER_STR   24
#define     MAX_ORIGIN_STRING_LEN   128

#define     BIGGEST_WEAPON_ID       46

#define     WEAPON_SERIAL_FORMAT    "MMDDLRRRRR" // mesiac,mesiac,den,den,lfrakcia0,lfrakcia1,ifrakcia0,ifrakcia1,zbrojak,rand,rand,rand,rand,rand,rand
#define     INVALID_SERIAL_NUMBER   0

////////////////////////////////////////////////////////////////////////////////

enum {
    WEAPON_CHEAT_TYPE_NONE      = 0,
    WEAPON_CHEAT_TYPE_WEAPON,
    WEAPON_CHEAT_TYPE_AMMO,
    WEAPON_CHEAT_TYPE_UNL_AMMO,
    WEAPON_CHEAT_TYPE_INVALID_ID,
}

enum pWeaponEnum()
{
	pweapons_WeaponId,      // id of weapon
	pweapons_Ammo,          // what should be the current ammo
	
	pweapons_SerialNumber,  // serial number by format
	pweapons_AmmoGiven,     // what was the ammo when the weapon was given
	
	pweapons_IsWork,
	pweapons_IsPermit,
	
	pweapons_Origin[MAX_ORIGIN_STRING_LEN] // origin of weapon
}

new playerWeapons[MAX_PLAYERS][MAX_WEAPON_SLOTS][pWeaponEnum];
new bool:weaponh_Immunity[MAX_PLAYERS];
new wh_timer[MAX_PLAYERS];

forward disablewhImmunity(playerid);
public disablewhImmunity(playerid)
{
    weaponh_Immunity[playerid] = false;
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

Weapons::enableImmunity(playerid, timems = 3000)
{
	if(weaponh_Immunity[playerid])
	{
	    KillTimer(wh_timer[playerid]);
	}
    weaponh_Immunity[playerid] = true;
	wh_timer[playerid] = SetTimerEx("disablewhImmunity", timems, false, "i", playerid);
	return 1;
}

stock Weapons::getWeaponSlot(weaponid)
{
	new slot;
	switch(weaponid){
		case 0, 1: slot = 0; // No weapon
		case 2 .. 9: slot = 1; // Melee
		case 22 .. 24: slot = 2; // Handguns
		case 25 .. 27: slot = 3; // Shotguns
		case 28, 29, 32: slot = 4; // Sub-Machineguns
		case 30, 31: slot = 5; // Machineguns
		case 33, 34: slot = 6; // Rifles
		case 35 .. 38: slot = 7; // Heavy Weapons
		case 16, 17, 18, 39: slot = 8; // Projectiles
		case 41, 42, 43: slot = 9; // Special 1
		case 10..15: slot = 10; // Gifts
		case 44 .. 46: slot = 11; // Special 2
		case 40: slot = 12; // Detonators
		default: slot = -1; // No slot
	}
	return slot;
}

Weapons::resetWeapons(playerid)
{

    Weapons::enableImmunity(playerid);

	new connected = 0;
	
	if(IsPlayerConnected(playerid))
	{
		ResetPlayerWeapons(playerid);
		connected = 1;
	}
	
	for(new x = 1; x < MAX_WEAPON_SLOTS; x++)
	{
	
	    if(connected)
	    {
	        new S_query[256];
			mysql_format(
				MYSQL, S_query, sizeof S_query,
				"DELETE FROM weapon_db WHERE WeaponId = '%d' AND SerialNumber = '%d'",
				playerWeapons[playerid][x][pweapons_WeaponId],
				playerWeapons[playerid][x][pweapons_SerialNumber]
			);
			mysql_tquery(MYSQL, S_query);
	    }

		playerWeapons[playerid][x][pweapons_WeaponId]       = 0;
		playerWeapons[playerid][x][pweapons_AmmoGiven]      = 0;
		playerWeapons[playerid][x][pweapons_Ammo]           = 0;
		playerWeapons[playerid][x][pweapons_IsWork]   		= 0;
		playerWeapons[playerid][x][pweapons_IsPermit]   	= 0;
		
		playerWeapons[playerid][x][pweapons_SerialNumber]   = 0;
		playerWeapons[playerid][x][pweapons_Origin][0]    	= EOS;

	}
	
	return 1;
}

Weapons::removeWeaponInSlot(playerid, slot, bool:deletedb = true)
{

    Weapons::enableImmunity(playerid);

	if(deletedb)
	{
	    new S_query[256];
		mysql_format(
			MYSQL, S_query, sizeof S_query,
			"DELETE FROM weapon_db WHERE WeaponId = '%d' AND SerialNumber = '%d'",
			playerWeapons[playerid][slot][pweapons_WeaponId],
			playerWeapons[playerid][slot][pweapons_SerialNumber]
		);
		mysql_tquery(MYSQL, S_query);
	}

    playerWeapons[playerid][slot][pweapons_WeaponId]       	= 0;
	playerWeapons[playerid][slot][pweapons_AmmoGiven]      	= 0;
	playerWeapons[playerid][slot][pweapons_Ammo]           	= 0;
	playerWeapons[playerid][slot][pweapons_SerialNumber]   	= 0;
	playerWeapons[playerid][slot][pweapons_IsWork]   		= 0;
	playerWeapons[playerid][slot][pweapons_IsPermit]   		= 0;
	playerWeapons[playerid][slot][pweapons_Origin][0]    	= EOS;

	ResetPlayerWeapons(playerid);

	for(new x = 1; x < MAX_WEAPON_SLOTS; x++)
	{
	    if(playerWeapons[playerid][x][pweapons_WeaponId] < 1 || playerWeapons[playerid][x][pweapons_WeaponId] > BIGGEST_WEAPON_ID) continue;
	    if(playerWeapons[playerid][x][pweapons_Ammo] < 1) continue;
	    GivePlayerWeapon(playerid, playerWeapons[playerid][x][pweapons_WeaponId], playerWeapons[playerid][x][pweapons_Ammo]);
	}
	return 1;
}


Weapons::removeWeapon(playerid, weaponid, bool:deletedb = true)
{

    Weapons::enableImmunity(playerid);

	new slot = Weapons::getWeaponSlot(weaponid);

	if(deletedb)
	{
	    new S_query[256];
		mysql_format(
			MYSQL, S_query, sizeof S_query,
			"DELETE FROM weapon_db WHERE WeaponId = '%d' AND SerialNumber = '%d'",
			playerWeapons[playerid][slot][pweapons_WeaponId],
			playerWeapons[playerid][slot][pweapons_SerialNumber]
		);
		mysql_tquery(MYSQL, S_query);
	}

    playerWeapons[playerid][slot][pweapons_WeaponId]       	= 0;
	playerWeapons[playerid][slot][pweapons_AmmoGiven]      	= 0;
	playerWeapons[playerid][slot][pweapons_Ammo]           	= 0;
	playerWeapons[playerid][slot][pweapons_SerialNumber]   	= 0;
	playerWeapons[playerid][slot][pweapons_IsWork]   		= 0;
	playerWeapons[playerid][slot][pweapons_IsPermit]   		= 0;
	playerWeapons[playerid][slot][pweapons_Origin][0]    	= EOS;

	ResetPlayerWeapons(playerid);

	for(new x = 1; x < MAX_WEAPON_SLOTS; x++)
	{
	    if(playerWeapons[playerid][x][pweapons_WeaponId] < 1 || playerWeapons[playerid][x][pweapons_WeaponId] > BIGGEST_WEAPON_ID) continue;
	    if(playerWeapons[playerid][x][pweapons_Ammo] < 1) continue;
	    GivePlayerWeapon(playerid, playerWeapons[playerid][x][pweapons_WeaponId], playerWeapons[playerid][x][pweapons_Ammo]);
	}
	return 1;
}

Weapons::increaseAmmo(playerid, slot, ammo)
{

    Weapons::enableImmunity(playerid);
    
    playerWeapons[playerid][slot][pweapons_Ammo] += ammo;
    if(playerWeapons[playerid][slot][pweapons_AmmoGiven] < ammo)
        playerWeapons[playerid][slot][pweapons_AmmoGiven] = playerWeapons[playerid][slot][pweapons_Ammo];
        
    SetPlayerAmmo(playerid, GetPlayerWeapon(playerid), playerWeapons[playerid][slot][pweapons_Ammo]);
        
	return 1;
}

Weapons::decreaseAmmo(playerid, weaponid)
{
    new
	    slot = Weapons::getWeaponSlot(weaponid)
	;
	
	playerWeapons[playerid][slot][pweapons_Ammo] --;
	
	return 1;
}

Weapons::GivePlayerNewWeapon(playerid, weaponid, ammo, bool:isworkweap = false, bool:ispermitted = false, origin[] = "", bool:writetodb = false, serialnumber = -1, bool:logging = false)
{

    Weapons::enableImmunity(playerid, 3000);

	new
	    slot = Weapons::getWeaponSlot(weaponid)
	;

	if(!logging) Weapons::removeWeaponInSlot(playerid, slot);

	if(serialnumber <= 0) serialnumber = Weapons::generateSerialNumber(playerid, ispermitted, isworkweap);

	playerWeapons[playerid][slot][pweapons_WeaponId]       	= weaponid;
	playerWeapons[playerid][slot][pweapons_AmmoGiven]      	= ammo;
	playerWeapons[playerid][slot][pweapons_Ammo]           	= ammo;
	playerWeapons[playerid][slot][pweapons_IsWork]         	= !!isworkweap;
	playerWeapons[playerid][slot][pweapons_IsPermit]     	= !!ispermitted;
	playerWeapons[playerid][slot][pweapons_SerialNumber]   	= serialnumber;
	format(playerWeapons[playerid][slot][pweapons_Origin], MAX_ORIGIN_STRING_LEN, "%s", origin);

	GivePlayerWeapon(playerid, weaponid, ammo);

	if(writetodb)
	{
	    new
	        query[1024],
			type = -1
		;

		if(ispermitted && isworkweap) type = 2;
		else if(isworkweap) type = 1;
		else if(ispermitted) type = 0;

		if(type == -1) return 1; // do not write it into database, because it shouldn't be here

		mysql_format(
			MYSQL, query, sizeof query,
			"INSERT INTO weapon_db (WeaponId,Holder,GivenAmmo,SerialNumber,Type,Origin) VALUES ('%d','%e','%d','%d','%d','%e')",
			weaponid,
			ReturnName(playerid),
			ammo,
			playerWeapons[playerid][slot][pweapons_SerialNumber],
			type,
			origin
		);
	}

	////////////////////////////////////////////////////////////////////////////

	switch(weaponid)
	{
	    case 24:
	        Achievement::Reward(playerid, ACHIEVEMENT_WEAPON_TIER_1);

        case 25:
	        Achievement::Reward(playerid, ACHIEVEMENT_WEAPON_TIER_2);

        case 31:
	        Achievement::Reward(playerid, ACHIEVEMENT_WEAPON_TIER_3);

        case 33:
	        Achievement::Reward(playerid, ACHIEVEMENT_WEAPON_TIER_4);
	}

	return 1;
}

Weapons::transferWeapon(playerid, toplayerid, weaponid)
{
    Weapons::enableImmunity(playerid, 3000);
    Weapons::enableImmunity(toplayerid, 3000);

	new
		slot = Weapons::getWeaponSlot(weaponid)
	;
	
    playerWeapons[toplayerid][slot][pweapons_WeaponId]       	= playerWeapons[playerid][slot][pweapons_WeaponId];
	playerWeapons[toplayerid][slot][pweapons_AmmoGiven]      	= playerWeapons[playerid][slot][pweapons_AmmoGiven];
	playerWeapons[toplayerid][slot][pweapons_Ammo]           	= playerWeapons[playerid][slot][pweapons_Ammo];
	playerWeapons[toplayerid][slot][pweapons_IsWork]         	= playerWeapons[playerid][slot][pweapons_IsWork];
	playerWeapons[toplayerid][slot][pweapons_IsPermit]     		= playerWeapons[playerid][slot][pweapons_IsPermit];
	playerWeapons[toplayerid][slot][pweapons_SerialNumber]   	= playerWeapons[playerid][slot][pweapons_SerialNumber];
	format(playerWeapons[toplayerid][slot][pweapons_Origin], MAX_ORIGIN_STRING_LEN, "%s", playerWeapons[playerid][slot][pweapons_Origin]);
	
	////////////////////////////////////////////////////////////////////////////
	
	Weapons::removeWeaponInSlot(playerid, slot, false);
	playerWeapons[playerid][slot][pweapons_WeaponId]       		= 0;
	playerWeapons[playerid][slot][pweapons_AmmoGiven]      		= 0;
	playerWeapons[playerid][slot][pweapons_Ammo]           		= 0;
	playerWeapons[playerid][slot][pweapons_IsWork]         		= 0;
	playerWeapons[playerid][slot][pweapons_IsPermit]     		= 0;
	playerWeapons[playerid][slot][pweapons_SerialNumber]   		= 0;
	
	////////////////////////////////////////////////////////////////////////////
	
	GivePlayerWeapon(toplayerid, playerWeapons[toplayerid][slot][pweapons_WeaponId], playerWeapons[toplayerid][slot][pweapons_Ammo]);

	////////////////////////////////////////////////////////////////////////////
	
	switch(playerWeapons[toplayerid][slot][pweapons_WeaponId])
	{
	    case 24:
	        Achievement::Reward(toplayerid, ACHIEVEMENT_WEAPON_TIER_1);

        case 25:
	        Achievement::Reward(toplayerid, ACHIEVEMENT_WEAPON_TIER_2);

        case 31:
	        Achievement::Reward(toplayerid, ACHIEVEMENT_WEAPON_TIER_3);

        case 33:
	        Achievement::Reward(toplayerid, ACHIEVEMENT_WEAPON_TIER_4);
	}

	return 1;
}

Weapons::generateSerialNumber(playerid, bool:ispermitted = false, bool:isworkweap = false)
{

	if(!IsPlayerConnected(playerid))
	    return INVALID_SERIAL_NUMBER;

	new
	    serialstring[MAX_SERIAL_NUMBER_STR],
	    tempstr[7],
	    serial = INVALID_SERIAL_NUMBER,
	    year, month, day
	;
	
	getdate(year, month, day);
	
	format(tempstr, sizeof tempstr, "%02d", month+10);
	format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("MM", tempstr, WEAPON_SERIAL_FORMAT));
	
	format(tempstr, sizeof tempstr, "%02d", day);
	format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("DD", tempstr, serialstring));
	
	format(tempstr, sizeof tempstr, "%02d", GetPlayerFaction(playerid));
	format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("FF", tempstr, serialstring));
	
	format(tempstr, sizeof tempstr, "%02d", GetPlayerIllegalFaction(playerid));
	format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("II", tempstr, serialstring));
	
	if(ispermitted) 	format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("L", "1", serialstring)); //ak je zo zbrojaku, 1
	else if(isworkweap) format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("L", "2", serialstring)); //ak je to sd zbran, 2
	else 				format(serialstring, MAX_SERIAL_NUMBER_STR, "%s", str_replace("L", "0", serialstring)); //ak ani jedno, je to 0
	
	for(new x, y = sizeof(serialstring); x < y; x++)
	{
	    if(serialstring[x] != 'R') continue;
	    serialstring[x] = (48 + random(10));
	}
	
	serial = strval(serialstring);
	printf("[SERIAL]: %d - %s", serial, serialstring);
	
	return serial;
}

Weapons::checkCheated(playerid)
{

	if(weaponh_Immunity[playerid]) return 0;

	new
	    weaponid,
	    ammo,
		found = 0
	;

	for(new x = 1; x < MAX_WEAPON_SLOTS; x++)
	{

		GetPlayerWeaponData(playerid, x, weaponid, ammo);
		
		if(weaponid == 0 || ammo <= 0)
		    continue; // player has not any weapon in slot
		    
		if(weaponid > BIGGEST_WEAPON_ID)
		    Weapons::hasCheatedGun(playerid, weaponid, ammo, WEAPON_CHEAT_TYPE_WEAPON, 3), found = 1;
		else if(playerWeapons[playerid][x][pweapons_WeaponId] != weaponid && playerWeapons[playerid][x][pweapons_Ammo] > 0)
		    Weapons::hasCheatedGun(playerid, weaponid, ammo, WEAPON_CHEAT_TYPE_WEAPON, 1), found = 1;
		    


		if(playerWeapons[playerid][x][pweapons_SerialNumber] <= 0)
		    Weapons::hasCheatedGun(playerid, weaponid, ammo, WEAPON_CHEAT_TYPE_WEAPON, 2), found = 1;
		else if(playerWeapons[playerid][x][pweapons_Ammo] + 1 < ammo)
		    Weapons::hasCheatedGun(playerid, weaponid, ammo, WEAPON_CHEAT_TYPE_UNL_AMMO), found = 1;
        else if(playerWeapons[playerid][x][pweapons_AmmoGiven] < ammo)
		    Weapons::hasCheatedGun(playerid, weaponid, ammo, WEAPON_CHEAT_TYPE_AMMO), found = 1;
		
	}
	
	if(found==0) weaponWarn[playerid] = 0;
	
	return 1;
}

Weapons::hasCheatedGun(playerid, weaponid, ammo, type = WEAPON_CHEAT_TYPE_NONE, extraid = 0)
{
	weaponWarn[playerid] ++;
	
	if(weaponWarn[playerid] >= 3)
	{
	    new
			S_string[144];
	
		switch(type)
		{
		    case WEAPON_CHEAT_TYPE_WEAPON:
		    {
		        if(extraid != 3) format(S_string, 144, "Weapon Hack - %s (%d ammo, err: %d)", GetWeaponNameEx(weaponid), ammo, extraid);
		        else format(S_string, 144, "Weapon Hack - %s (%d ammo, err: %d)", "?", ammo, extraid);
                Weapons::resetWeapons(playerid);
		    }

		    case WEAPON_CHEAT_TYPE_AMMO:
		    {
                format(S_string, 144, "Ammo Hack - %s (%d ammo)", GetWeaponNameEx(weaponid), ammo);
                Weapons::resetWeapons(playerid);
		    }

		    case WEAPON_CHEAT_TYPE_UNL_AMMO:
		    {
		        format(S_string, 144, "Unlimited Ammo Hack - %s (%d ammo)", GetWeaponNameEx(weaponid), ammo);
                Weapons::resetWeapons(playerid);
		    }
		}

		stats_Ban[playerid] ++;
		BanPlayer(playerid, S_string, "System", 2);
	}
	
	return 1;
}

////////////////////////////////////////////////////////////////////////////////
