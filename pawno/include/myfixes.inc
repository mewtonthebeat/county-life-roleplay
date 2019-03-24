/*

NEW FUNCTIONS;

* native GetPlayerArmedWeapon(playerid); // Use instead of GetPlayerWeapon(playerid) !!! Fixes passenger bug returning wrong weapon id.

OVERRIDED FUNCTIONS;

* SetPlayerArmedWeapon(playerid, weaponid);
* GivePlayerWeapon(playerid, weaponid, ammo);
* ClearAnimations(playerid, forcesync = 0, forcekick = 0); // Fixes the kick from the vehicle when ClearAnimations is called, if you wan't to player to be kicked from the vehicle, simply set forcekick to 1.

*/


/*new	myfix_ArmedWeapon[ 1000 char ];

stock FIXES_SetPlayerArmedWeapon(playerid, weaponid)
{

	myfix_ArmedWeapon{ playerid } = weaponid;
	return SetPlayerArmedWeapon(playerid, weaponid);
	
}

#define _ALS_SetPlayerArmedWeapon
#define SetPlayerArmedWeapon( FIXES_SetPlayerArmedWeapon(

stock FIXES_GivePlayerWeapon(playerid, weaponid, ammo)
{

	myfix_ArmedWeapon{ playerid } = weaponid;
	return GivePlayerWeapon(playerid, weaponid, ammo);
	
}

#define _ALS_GivePlayerWeapon
#define GivePlayerWeapon( FIXES_GivePlayerWeapon(

stock GetPlayerArmedWeapon(playerid)
	return myfix_ArmedWeapon{ playerid };
	
public OnPlayerUpdate(playerid)
{

	if(!IsPlayerInAnyVehicle(playerid) && myfix_ArmedWeapon{ playerid } != GetPlayerWeapon(playerid))
		SetPlayerArmedWeapon(playerid, GetPlayerWeapon(playerid));

	#if defined CB_OnPlayerUpdate
		return CB_OnPlayerUpdate(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerUpdate
	#undef OnPlayerUpdate
#else
	#define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate 			CB_OnPlayerUpdate
#if defined CB_OnPlayerUpdate
	forward CB_OnPlayerUpdate(playerid);
#endif*/

stock FIXES_ClearAnimations(playerid, forcesync = 0, forcekick = 0)
{
	if (IsPlayerInAnyVehicle(playerid) && !forcekick)
	{
		return ApplyAnimation(playerid, "PED", "CAR_SIT", 4.0, 0, 0, 0, 0, 1, forcesync);
	}

	new
		ret = ClearAnimations(playerid, forcesync);
		
	ApplyAnimation(playerid, "PED", "IDLE_STANCE", 4.0, 0, 0, 0, 0, 1, forcesync);
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 1, forcesync);
	ApplyAnimation(playerid, "PED", "WALK_PLAYER", 4.0, 0, 0, 0, 0, 1, forcesync);
	return ret;
}

#define _ALS_ClearAnimations
#define ClearAnimations( FIXES_ClearAnimations(

/* ANIMFIXES */

#define LastAnimExecuted    _getLastAnim
#define LastAnimLibExecuted _getLastLib
#define AnimLibExists      _animLibExist

#if !defined isnull
  #define isnull(%1) \
              ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

enum _pAnims
{
    bool:_pAlredyAnimsLoaded,
    _pAnimExecute,
    _pLastAnim[32 char],
    _pLastAnimLib[32 char],

};
new _eAnim[MAX_PLAYERS][_pAnims];

static const _AnimsEnum[][] =
{
    "AIRPORT",      "Attractors",   "BAR",          "BASEBALL",     "BD_FIRE",
    "BEACH",        "benchpress",   "BF_injection", "BIKED",        "BIKEH",
    "BIKELEAP",     "BIKES",        "BIKEV",        "BIKE_DBZ",     "BLOWJOBZ",
    "BMX",          "BOMBER",       "BOX",          "BSKTBALL",     "BUDDY",
    "BUS",          "CAMERA",       "CAR",          "CARRY",        "CAR_CHAT",
    "CASINO",       "CHAINSAW",     "CHOPPA",       "CLOTHES",      "COACH",
    "COLT45",       "COP_AMBIENT",  "COP_DVBYZ",    "CRACK",        "CRIB",
    "DAM_JUMP",     "DANCING",      "DEALER",       "DILDO",        "DODGE",
    "DOZER",        "DRIVEBYS",     "FAT",          "FIGHT_B",      "FIGHT_C",
    "FIGHT_D",      "FIGHT_E",      "FINALE",       "FINALE2",      "FLAME",
    "Flowers",      "FOOD",         "Freeweights",  "GANGS",        "GHANDS",
    "GHETTO_DB",    "goggles",      "GRAFFITI",     "GRAVEYARD",    "GRENADE",
    "GYMNASIUM",    "HAIRCUTS",     "HEIST9",       "INT_HOUSE",    "INT_OFFICE",
    "INT_SHOP",     "JST_BUISNESS", "KART",         "KISSING",      "KNIFE",
    "LAPDAN1",      "LAPDAN2",      "LAPDAN3",      "LOWRIDER",     "MD_CHASE",
    "MD_END",       "MEDIC",        "MISC",         "MTB",          "MUSCULAR",
    "NEVADA",       "ON_LOOKERS",   "OTB",          "PARACHUTE",    "PARK",
    "PAULNMAC",     "ped",          "PLAYER_DVBYS", "PLAYIDLES",    "POLICE",
    "POOL",         "POOR",         "PYTHON",       "QUAD",         "QUAD_DBZ",
    "RAPPING",      "RIFLE",        "RIOT",         "ROB_BANK",     "ROCKET",
    "RUSTLER",      "RYDER",        "SCRATCHING",   "SHAMAL",       "SHOP",
    "SHOTGUN",      "SILENCED",     "SKATE",        "SMOKING",      "SNIPER",
    "SPRAYCAN",     "STRIP",        "SUNBATHE",     "SWAT",         "SWEET",
    "SWIM",         "SWORD",        "TANK",         "TATTOOS",      "TEC",
    "TRAIN",        "TRUCK",        "UZI",          "VAN",          "VENDING",
    "VORTEX",       "WAYFARER",     "WEAPONS",      "WUZI"
};

stock _animLibExist(_LoadAnin[])
{
    if(_LoadAnin[0] == '\0')
        return 0;

    for(new i = 0; i < sizeof(_AnimsEnum); i ++)
    {
        if(!strcmp(_LoadAnin, _AnimsEnum[i], true))
        {
            return 1;
        }
    }
    return 0;
}

stock _animPreload(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    if(_eAnim[playerid][_pAlredyAnimsLoaded] == true)
        return 0;

    for(new i = 0; i < sizeof(_AnimsEnum); i ++)
    {
        ApplyAnimation(playerid, _AnimsEnum[i], "null", 4.0, 0, 0, 0, 0, 0, 1);
        _eAnim[playerid][_pAlredyAnimsLoaded] = true;
    }
    return 1;
}

stock _getLastAnim(playerid)
{
    new
        string[33] = "None"
        ;

    if(IsPlayerConnected(playerid))
    {
        if(!isnull(_eAnim[playerid][_pLastAnim]))
        {
            strunpack(string, _eAnim[playerid][_pLastAnim]);
        }
    }
    return string;
}

stock _getLastLib(playerid)
{
    new
        string[33] = "None"
        ;

    if(IsPlayerConnected(playerid))
    {
        if(!isnull(_eAnim[playerid][_pLastAnimLib]))
        {
            strunpack(string, _eAnim[playerid][_pLastAnimLib]);
        }
    }
    return string;
}

stock _resetPlayerAnims(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    _eAnim[playerid][_pAlredyAnimsLoaded] = false;
    _eAnim[playerid][_pAnimExecute] = 0;
    _eAnim[playerid][_pLastAnim][0] = '\0';
    _eAnim[playerid][_pLastAnimLib][0] = '\0';
    return 1;
}

stock _AppliAnimEx(playerid, animlib[], anim[], Float:vel = 4.1, bucle = 0, lockx = 1, locky = 1, freeze = 1, timex = 1, sync = 1)
{
    if(IsPlayerConnected(playerid))
    {
        if(!strcmp(_getLastAnim(playerid), anim, true))
        {
            if(_eAnim[playerid][_pAnimExecute] > gettime())
            {
                return 0;
            }
        }
        new
            bool:_animLibExists = false;

        if(!strcmp(_getLastLib(playerid), animlib, true))
        {
            _animLibExists = true;
        }
        else
        {
            if(_animLibExists != true)
            {
                _animLibExists = ((_animLibExist(animlib)) ? (true) : (false));
            }
        }
        if(_animLibExists != false)
        {
            ApplyAnimation(playerid, animlib, anim, vel, bucle, lockx, locky, freeze, timex, sync);
            _eAnim[playerid][_pAnimExecute] = gettime()+1;
            strunpack(_eAnim[playerid][_pLastAnimLib], animlib);
            strunpack(_eAnim[playerid][_pLastAnim], anim);
            return 1;
        }
    }
    return 0;
}

public OnPlayerSpawn(playerid)
{



    _animPreload(playerid);

    #if defined zHook_OnPlayerSpawn
      return zHook_OnPlayerSpawn(playerid);
    #else
      return 1;
    #endif
}

public OnPlayerConnect(playerid)
{
    _resetPlayerAnims(playerid);

    #if defined zHook_OnPlayerConnect
      return zHook_OnPlayerConnect(playerid);
    #else
      return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
  #define _ALS_OnPlayerConnect
#endif

#if defined _ALS_OnPlayerSpawn
  #undef OnPlayerSpawn
#else
  #define _ALS_OnPlayerSpawn
#endif

#if defined _ALS_ApplyAnimation
  #undef ApplyAnimation
#else
  #define _ALS_ApplyAnimation
#endif

#define ApplyAnimation          _AppliAnimEx
#define OnPlayerSpawn           zHook_OnPlayerSpawn
#define OnPlayerConnect         zHook_OnPlayerConnect

#if defined zHook_OnPlayerSpawn
  forward zHook_OnPlayerSpawn(playerid);
#endif

#if defined zHook_OnPlayerConnect
  forward zHook_OnPlayerConnect(playerid);
#endif